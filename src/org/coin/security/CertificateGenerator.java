package org.coin.security;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.math.BigInteger;
import java.security.GeneralSecurityException;
import java.security.InvalidParameterException;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Hashtable;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.bouncycastle.asn1.DERObjectIdentifier;
import org.bouncycastle.asn1.x509.BasicConstraints;
import org.bouncycastle.asn1.x509.CRLNumber;
import org.bouncycastle.asn1.x509.CRLReason;
import org.bouncycastle.asn1.x509.ExtendedKeyUsage;
import org.bouncycastle.asn1.x509.KeyPurposeId;
import org.bouncycastle.asn1.x509.X509Extensions;
import org.bouncycastle.crypto.CryptoException;
import org.bouncycastle.jce.X509Principal;
import org.bouncycastle.x509.X509V1CertificateGenerator;
import org.bouncycastle.x509.X509V2CRLGenerator;
import org.bouncycastle.x509.X509V3CertificateGenerator;
import org.bouncycastle.x509.extension.AuthorityKeyIdentifierStructure;
import org.bouncycastle.x509.extension.SubjectKeyIdentifierStructure;

import sun.security.tools.KeyStoreUtil;

public class CertificateGenerator {
	/**
	 * Création de la paire de clefs
	 * @return
	 * @throws CryptoException
	 */
	public static KeyPair generateKeyPair() throws CryptoException
	{
		try {
			KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
			SecureRandom rand = SecureRandom.getInstance("SHA1PRNG");
			keyPairGen.initialize(2048, rand);

			KeyPair keyPair = keyPairGen.generateKeyPair();

			return keyPair;
		}
		catch (NoSuchAlgorithmException ex) {
			throw new CryptoException("Probleme lors de la création de la pair de clef : "+ex.getMessage());
		}
		catch (InvalidParameterException ex) {
			throw new CryptoException("Probleme lors de la création de la pair de clef : "+ex.getMessage());
		}
	}
	
	/**
	 * Generate Issuer or Subject DN
	 * 
	 * @param sCommonName
	 * @param sOrganisationUnit
	 * @param sOrganisation
	 * @param sLocality
	 * @param sState
	 * @param sCountryCode
	 * @param sEmailAddress
	 * @return
	 */
	public static X509Principal generateDN(String sCommonName,
			String sOrganisationUnit,
			String sOrganisation,
			String sLocality,
			String sState,
			String sCountryCode,
			String sEmailAddress){
		Hashtable<DERObjectIdentifier, String> attrs = new Hashtable<DERObjectIdentifier, String>();
		Vector<DERObjectIdentifier> vOrder = new Vector<DERObjectIdentifier>();

		if (sCommonName != null) {
			attrs.put(X509Principal.CN, sCommonName);
			vOrder.add(0, X509Principal.CN);
		}

		if (sOrganisationUnit != null) {
			attrs.put(X509Principal.OU, sOrganisationUnit);
			vOrder.add(0, X509Principal.OU);
		}

		if (sOrganisation != null) {
			attrs.put(X509Principal.O, sOrganisation);
			vOrder.add(0, X509Principal.O);
		}

		if (sLocality != null) {
			attrs.put(X509Principal.L, sLocality);
			vOrder.add(0, X509Principal.L);
		}

		if (sState != null) {
			attrs.put(X509Principal.ST, sState);
			vOrder.add(0, X509Principal.ST);
		}

		if (sCountryCode != null) {
			attrs.put(X509Principal.C, sCountryCode);
			vOrder.add(0, X509Principal.C);
		}

		if (sEmailAddress != null) {
			attrs.put(X509Principal.E, sEmailAddress);
			vOrder.add(0, X509Principal.E);
		}
		
		return new X509Principal(vOrder, attrs);
	}

	/**
	 * Creation du certificat de type X509 V1
	 * 
	 * @param issuerDN
	 * @param subjectDN
	 * @param daysValidity
	 * @param publicKey
	 * @param privateKey
	 * @param signatureType
	 * @return
	 * @throws CryptoException
	 */
	public static X509Certificate generateCertV1( X509Principal issuerDN,
			X509Principal subjectDN,
			int daysValidity,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType)
	throws CryptoException {
		
		return generateCertV1(issuerDN, subjectDN, 
				new Timestamp(System.currentTimeMillis()), 
				new Timestamp(System.currentTimeMillis() + ((long) daysValidity * 24 * 60 * 60 * 1000)), 
				publicKey, privateKey, signatureType,
				generateX509SerialNumber().toString());
	}
	public static X509Certificate generateCertV1( X509Principal issuerDN,
			X509Principal subjectDN,
			Timestamp tsDateStart,
			Timestamp tsDateEnd,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType,
			String sSerialNumber)
	throws CryptoException {
		
		X509V1CertificateGenerator certGen = new X509V1CertificateGenerator();
		certGen.setIssuerDN(issuerDN);
		certGen.setNotBefore(new Date(tsDateStart.getTime()));
		certGen.setNotAfter(new Date(tsDateEnd.getTime()));
		certGen.setSubjectDN(subjectDN);
		certGen.setPublicKey(publicKey);
		certGen.setSignatureAlgorithm(signatureType.toString());
		certGen.setSerialNumber(new BigInteger(sSerialNumber));

		try {
			X509Certificate cert = certGen.generate(privateKey, "BC");
			return cert;
		}
		catch (GeneralSecurityException ex) {
			ex.printStackTrace();
			throw new CryptoException("Une erreur est survenu lors de la création du certificat");
		}
	}
	
	public static X509CRL generateCRL( X509Principal issuerDN,
			int daysValidity,
			PrivateKey privateKey,
			String signatureType,
			X509Certificate rootCRT)
	throws CryptoException {
		
		return generateCRL(issuerDN, 
				new Timestamp(System.currentTimeMillis()), 
				new Timestamp(System.currentTimeMillis() + ((long) daysValidity * 24 * 60 * 60 * 1000)), 
				privateKey, signatureType,
				rootCRT,
				generateX509SerialNumber().toString());
	}
	
	public static X509CRL generateCRL( X509Principal issuerDN,
			Timestamp tsDateStart,
			Timestamp tsDateEnd,
			PrivateKey privateKey,
			String signatureType,
			X509Certificate rootCRT,
			String sSerialNumber) throws CryptoException{
		
		X509V2CRLGenerator crlGen = new X509V2CRLGenerator();
		crlGen.setIssuerDN(issuerDN);
		crlGen.setThisUpdate(tsDateStart);
		crlGen.setNextUpdate(tsDateEnd);
		crlGen.setSignatureAlgorithm(signatureType);

		try {
			crlGen.addExtension(X509Extensions.AuthorityKeyIdentifier, 
					false, new AuthorityKeyIdentifierStructure(rootCRT));
			crlGen.addExtension(X509Extensions.CRLNumber, 
					false, new CRLNumber(new BigInteger(sSerialNumber)));

			X509CRL crl = crlGen.generate(privateKey, "BC");
			return crl;
		}
		catch (GeneralSecurityException ex) {
			ex.printStackTrace();
			throw new CryptoException("Une erreur est survenu lors de la création de la liste de revocation");
		}
	}
	
	public static X509CRL revokeCert(
			PrivateKey privateKey,
			X509Certificate rootCRT,
			X509CRL crl,
			X509Certificate revokeCert
			) throws CryptoException{
		
		
		X509V2CRLGenerator crlGen = new X509V2CRLGenerator();
		crlGen.setIssuerDN(crl.getIssuerX500Principal());
		crlGen.setThisUpdate(new Date(System.currentTimeMillis()));
		crlGen.setNextUpdate(crl.getNextUpdate());
		crlGen.setSignatureAlgorithm(crl.getSigAlgName());
		
		try {
			crlGen.addCRL(crl);
			crlGen.addCRLEntry(revokeCert.getSerialNumber(), new Date(System.currentTimeMillis()), CRLReason.keyCompromise);

			crlGen.addExtension(X509Extensions.AuthorityKeyIdentifier, 
					false, new AuthorityKeyIdentifierStructure(rootCRT));
			crlGen.addExtension(X509Extensions.CRLNumber, 
					false, new CRLNumber(generateX509SerialNumber()));

			X509CRL crlUpdate = crlGen.generate(privateKey, "BC");
			return crlUpdate;
		}
		catch (GeneralSecurityException ex) {
			ex.printStackTrace();
			throw new CryptoException("Une erreur est survenu lors de la maj de la liste de revocation");
		}
	}

	/**
	 * generate X509 SerialNumber
	 * @return SerialNumber
	 */
	public static BigInteger generateX509SerialNumber() {
		return new BigInteger(Long.toString(System.currentTimeMillis() / 1000));
	}

	/**
	 * ajout du certificat et de ses clefs au keystore, le tout identifié par un alias et protégé par un password
	 * @param keystore
	 * @param alias
	 * @param passAlias
	 * @param pkey
	 * @param cert
	 */
	public static void addCertToKeyStore(KeyStore keystore, String alias, String passAlias,PrivateKey pkey,Certificate cert) {
		Certificate[] chain = {cert};
		addCertToKeyStore(keystore, alias, passAlias, pkey, chain);
	}
	
	/**
	 * Ajout de toute la chaine de certification dans un keystore
	 * @param keystore
	 * @param alias
	 * @param passAlias
	 * @param pkey
	 * @param chain
	 */
	public static void addCertToKeyStore(KeyStore keystore, String alias, String passAlias,PrivateKey pkey,Certificate[] chain) {
		try {
			keystore.setKeyEntry(alias, pkey, passAlias.toCharArray(),chain);
		} catch (KeyStoreException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
		}
	}
	
	public static X509Certificate generateCertV3Intermediate( X509Principal issuerDN,
			X509Principal subjectDN,
			int daysValidity,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType,
			X509Certificate rootCRT)
	throws CryptoException {
		
		return generateCertV3Intermediate(issuerDN, subjectDN, 
				new Timestamp(System.currentTimeMillis()), 
				new Timestamp(System.currentTimeMillis() + ((long) daysValidity * 24 * 60 * 60 * 1000)),
				publicKey, privateKey, signatureType, rootCRT,
				generateX509SerialNumber().toString());
	}
	public static X509Certificate generateCertV3Intermediate( X509Principal issuerDN,
			X509Principal subjectDN,
			Timestamp tsDateStart,
			Timestamp tsDateEnd,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType,
			X509Certificate rootCRT,
			String sSerialNumber)
	throws CryptoException {
		
		X509V3CertificateGenerator certGen = new X509V3CertificateGenerator();
		certGen.setIssuerDN(issuerDN);
		certGen.setNotBefore(new Date(tsDateStart.getTime()));
		certGen.setNotAfter(new Date(tsDateEnd.getTime()));
		certGen.setSubjectDN(subjectDN);
		certGen.setPublicKey(publicKey);
		certGen.setSignatureAlgorithm(signatureType.toString());
		certGen.setSerialNumber(new BigInteger(sSerialNumber));

		try {
			certGen.addExtension(
					X509Extensions.SubjectKeyIdentifier,
					false,
					new SubjectKeyIdentifierStructure(publicKey));

			certGen.addExtension(
					X509Extensions.AuthorityKeyIdentifier,
					false,
					new AuthorityKeyIdentifierStructure(rootCRT));

			certGen.addExtension(
					X509Extensions.BasicConstraints,
					true,
					new BasicConstraints(0));


			X509Certificate cert = certGen.generate(privateKey, "BC");
			return cert;
		}
		catch (GeneralSecurityException ex) {
			throw new CryptoException("Une erreur est survenu lors de la création du certificat");
		}
	}
	
	public static X509Certificate generateCertV3Final( X509Principal issuerDN,
			X509Principal subjectDN,
			int daysValidity,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType,
			PublicKey publicIntermediateKey)
	throws CryptoException {
		
		return generateCertV3Final(issuerDN, subjectDN, 
				new Timestamp(System.currentTimeMillis()), 
				new Timestamp(System.currentTimeMillis() + ((long) daysValidity * 24 * 60 * 60 * 1000)),
				publicKey, privateKey, signatureType, publicIntermediateKey,
				generateX509SerialNumber().toString());
	}
	public static X509Certificate generateCertV3Final( X509Principal issuerDN,
			X509Principal subjectDN,
			Timestamp tsDateStart,
			Timestamp tsDateEnd,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType,
			PublicKey publicIntermediateKey,
			String sSerialNumber)
	throws CryptoException {
		

		X509V3CertificateGenerator certGen = new X509V3CertificateGenerator();
		certGen.setIssuerDN(issuerDN);
		certGen.setNotBefore(new Date(tsDateStart.getTime()));
		certGen.setNotAfter(new Date(tsDateEnd.getTime()));
		certGen.setSubjectDN(subjectDN);
		certGen.setPublicKey(publicKey);
		certGen.setSignatureAlgorithm(signatureType.toString());
		certGen.setSerialNumber(new BigInteger(sSerialNumber));

		try {
			certGen.addExtension(
					X509Extensions.SubjectKeyIdentifier,
					false,
					new SubjectKeyIdentifierStructure(publicKey));

			certGen.addExtension(
					X509Extensions.AuthorityKeyIdentifier,
					false,
					new AuthorityKeyIdentifierStructure(publicIntermediateKey));

			X509Certificate cert = certGen.generate(privateKey, "BC");
			return cert;
		}
		catch (GeneralSecurityException ex) {
			throw new CryptoException("Une erreur est survenu lors de la création du certificat");
		}
	}
	
	
	
	/**
	 * création d’un certificat X509 V3 à utiliser pour la création des jeton d’horodatage (TimeStampToken)
	 * @param sCommonName
	 * @param sOrganisationUnit
	 * @param sOrganisation
	 * @param sLocality
	 * @param sState
	 * @param sCountryCode
	 * @param sEmailAddress
	 * @param daysValidity
	 * @param publicKey
	 * @param privateKey
	 * @param signatureType
	 * @return
	 * @throws CryptoException
	 */
	public static X509Certificate generateCertV3ForTimeStamping( X509Principal issuerDN,
			X509Principal subjectDN,
			int daysValidity,
			PublicKey publicKey,
			PrivateKey privateKey,
			String signatureType)
	throws CryptoException {
		

		X509V3CertificateGenerator certGen = new X509V3CertificateGenerator();
		certGen.setIssuerDN(issuerDN);
		certGen.setNotBefore(new Date(System.currentTimeMillis()));
		certGen.setNotAfter(new Date(System.currentTimeMillis() + ((long) daysValidity * 24 * 60 * 60 * 1000)));
		certGen.setSubjectDN(subjectDN);
		certGen.setPublicKey(publicKey);
		certGen.setSignatureAlgorithm(signatureType.toString());
		certGen.setSerialNumber(generateX509SerialNumber());

		try {
			certGen.addExtension(X509Extensions.ExtendedKeyUsage, true, new ExtendedKeyUsage(KeyPurposeId.id_kp_timeStamping));

			X509Certificate cert = certGen.generate(privateKey, "BC");
			return cert;
		}
		catch (GeneralSecurityException ex) {
			throw new CryptoException("Une erreur est survenu lors de la création du certificat");
		}
	}

	/**
	 * Créer un keystore de manière programmatique
	 * @return
	 * @throws CryptoException
	 */
	public static KeyStore createKeyStorePKCS12() throws CryptoException{
		try {
			KeyStore keyStore = null;
			//keyStore = KeyStore.getInstance("PKCS12", "BC");
			keyStore = KeyStore.getInstance("PKCS12");
			keyStore.load(null, null);
			return keyStore;
		} catch (IOException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("Problème IO : "+ex.getMessage());
		} catch (NoSuchAlgorithmException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("Problème d'algo : "+ex.getMessage());
		} catch (CertificateException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("Problème de certificat : "+ex.getMessage());
		} catch (KeyStoreException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("Problème sur le keystore : "+ex.getMessage());
		}
	}

	/**
	 * Sauvegarder le keystore protéger par un mot de pass dans un fichier 
	 * @param keyStore
	 * @param fKeyStoreFile
	 * @param cPassword
	 * @return
	 * @throws CryptoException
	 * @throws IOException
	 */
	public static KeyStore saveKeyStore(KeyStore keyStore, File fKeyStoreFile,char[] cPassword)throws CryptoException, IOException
	{
		FileOutputStream fos = new FileOutputStream(fKeyStoreFile);
		try {
			keyStore.store(fos, cPassword);
		}
		catch (IOException ex) {
			throw new CryptoException("Impossible de sauvegarder le keystore "+ex.getMessage());
		}
		catch (GeneralSecurityException ex) {
			throw new CryptoException("Impossible de sauvegarder le keystore "+ex.getMessage());
		}
		finally {
			fos.close();
		}
		return keyStore;
	}
	public static byte[] generateKeyStore(KeyStore keyStore, char[] cPassword)throws CryptoException, IOException
	{
		ByteArrayOutputStream byteKs = new ByteArrayOutputStream();
		try {
			keyStore.store(byteKs, cPassword);
		}
		catch (IOException ex) {
			throw new CryptoException("Impossible de sauvegarder le keystore "+ex.getMessage());
		}
		catch (GeneralSecurityException ex) {
			throw new CryptoException("Impossible de sauvegarder le keystore "+ex.getMessage());
		}
		finally {
			byteKs.close();
		}
		return byteKs.toByteArray();
	}

}
