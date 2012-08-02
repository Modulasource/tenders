package org.coin.security;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.security.DigestInputStream;
import java.security.KeyPair;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.Provider;
import java.security.PublicKey;
import java.security.SecureRandom;
import java.security.UnrecoverableKeyException;
import java.security.cert.CRL;
import java.security.cert.CRLException;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509CRL;
import java.security.cert.X509Certificate;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.security.auth.x500.X500Principal;

import org.apache.commons.lang.StringUtils;
import org.bouncycastle.asn1.DERObjectIdentifier;
import org.bouncycastle.asn1.x509.X509Extensions;
import org.bouncycastle.crypto.CryptoException;
import org.bouncycastle.jce.X509Principal;

import org.coin.security.token.BCCryptoUtil;
import org.coin.util.FileUtilBasic;
import org.coin.util.JavaUtil;
import org.coin.util.StringUtilBasic;

import sun.security.tools.KeyStoreUtil;

public class CertificateUtil {

	
	public static final String PROVIDER_NAME_MSCAPI = "SunMSCAPI";
	public static final String PROVIDER_NAME_JCE = "SunJCE";
	public static final String PROVIDER_NAME_BC = "BC";
	
	public static final String BEGIN_CERTIFICATE = "-----BEGIN CERTIFICATE-----";
	public static final String END_CERTIFICATE = "-----END CERTIFICATE-----";
	

	
	private static final char[] HexChars = {
		'0', '1', '2', '3', '4', '5', '6', '7',
		'8', '9', 'a', 'b', 'c', 'd', 'e', 'f'
	};

	/**
	 * Transforme une clé de 16 octets en clé de 24 octets de la maniere suivante:
	 * en entrée 
	 * bytes16bKey = xx xx xx xx  xx xx xx xx  yy yy yy yy  yy yy yy yy
	 * 
	 * en sortie
	 * bytes24bKey = xx xx xx xx  xx xx xx xx  yy yy yy yy  yy yy yy yy  xx xx xx xx  xx xx xx xx  
	 * 
	 * 
	 * @param bytes16bKey
	 * @return bytes24bKey 
	 */
	public static byte[] generate24b3DESKeyFrom16bKey(byte[] bytes16bKey)
	{
		byte[] bytes24bKey =  new byte[24];
		System.arraycopy(bytes16bKey, 0, bytes24bKey, 0, 8);
		System.arraycopy(bytes16bKey, 8, bytes24bKey, 8, 8);
		System.arraycopy(bytes16bKey, 0, bytes24bKey, 16, 8);

		return bytes24bKey ;
	}
	/**
	 * C = A ^ B
	 * 
	 * 
	 * @param bytesA
	 * @param bytesB
	 * @return
	 */
	public static byte[] computeXOr(byte[] bytesA, byte[] bytesB)
	{
		return computeXOr(bytesA, bytesB, 0, 0, bytesA.length);
	}

	/**
	 * 
	 * @param bytesA
	 * @param bytesB
	 * @param iOffsetA
	 * @param iOffsetB
	 * @param iSize
	 * @return
	 */
	public static byte[] computeXOr(byte[] bytesA, byte[] bytesB, int iOffsetA, int iOffsetB, int iSize)
	{
		byte[] bytesC = new byte[iSize];
		for (int i = 0; i < bytesA.length; i++) {
			bytesC[i] = (byte) (bytesA[i + iOffsetA] ^ bytesB[i + iOffsetB]);
		}

		return bytesC ;
	}


	public static String getHexaStringValue(byte[] bytesData)
	{
		StringBuffer sbufData = new StringBuffer("");

		for (int i = 0; i < bytesData.length; i++) 
		{
			byte data = bytesData[i];
			int iDataLow= (((byte) 0x0F & data) & 0x0000000F ); 
			int iDataHigh  = (( data >> 4) & 0x0000000F ); 
			sbufData.append(HexChars[iDataHigh]); 	 
			sbufData.append(HexChars[iDataLow ]); 

			// autre méthode moins rigolote
			//sbufData.append(Crypto.getHexaStringValue(data));
		}

		return sbufData.toString();

	}

	public static byte[] parseHexString(String sBytes)
	{
		int iLength = sBytes.length();
		if ( (iLength & 0x1) != 0 )
		{
			throw new IllegalArgumentException ( "parseHexString requires an even number of hex characters" );
		}
		byte[] b = new byte[iLength / 2];

		for ( int i=0,j=0; i<iLength; i+=2,j++ )
		{
			int high = charToNibble( sBytes.charAt ( i ) );
			int low = charToNibble( sBytes.charAt ( i+1 ) );
			b[j] = (byte)( ( high << 4 ) | low );
		}
		return b;
	}

	private static int charToNibble ( char c )
	{
		if ( '0' <= c && c <= '9' )
		{
			return c - '0';
		}
		else if ( 'a' <= c && c <= 'f' )
		{
			return c - 'a' + 0xa;
		}
		else if ( 'A' <= c && c <= 'F' )
		{
			return c - 'A' + 0xa;
		}
		else
		{
			throw new IllegalArgumentException ( "Invalid hex character: " + c );
		}
	}


	/**
	 * Methode permettant de padder les données pour avoir un nombre sur 128 Octet
	 * 
	 * 
	 * @param dataSHA1
	 * @return
	 */
	public static byte[] padDataTo128Bytes(byte[] bytesData) 
	{

		if(bytesData.length > 128)
		{
			// il n'est pas possible de padder des nombres > 128 octets
			return null;
		}

		byte[] bytesDataPadded = new byte[128] ; 
		int i ;
		for (i = 1; i < 128; i++) {
			bytesDataPadded [i] = (byte) 0xFF;
		}
		bytesDataPadded [0] = (byte) 0x00;
		bytesDataPadded [1] = (byte) 0x01;
		bytesDataPadded [(bytesDataPadded .length - bytesData.length) -1] = (byte) 0x00;

		System.arraycopy(bytesData, 0, bytesDataPadded , bytesDataPadded .length - bytesData.length , bytesData.length);


		return bytesDataPadded ;
	}



	public static byte[] generateAleaBytes(int nAleaSize)
	{
		byte[] bytesAlea =  new byte[nAleaSize];

		// For cryptographic strength random numbers, use the SecureRandom subclass
		SecureRandom generator2 = new SecureRandom();
		// Have the generator generate its own 16-byte seed; takes a *long* time
		generator2.setSeed(generator2.generateSeed(16));  // Extra random 16-byte seed
		// Then use SecureRandom like any other Random object
		generator2.nextBytes(bytesAlea );   // Generate more random bytes

		return bytesAlea ;
	}

	public static byte[] computeHashSha1(byte[] data) throws NoSuchAlgorithmException
	{
		MessageDigest md = MessageDigest.getInstance("SHA");
		return md.digest(data);
	}

	
	public static byte[] computeHashSha1File(String fileName)
	throws IOException, NoSuchAlgorithmException
	{
		return computeHashSha1File(new File(fileName));
	} 

	public static byte[] computeHashSha1File(File file)
	throws IOException, NoSuchAlgorithmException
	{
		return computeHashSha1File(new FileInputStream(file));
	} 

	public static byte[] computeHashSha1File(InputStream fis)
	throws IOException, NoSuchAlgorithmException
	{
		MessageDigest sha = MessageDigest.getInstance("SHA-1");
		DigestInputStream dis = new DigestInputStream (fis,sha);

		// Read the file through the DigestInputStream.
		//int x;
		//while ((x = dis.read ()) != -1)
		while ( dis.read () != -1)
		{

		}
		dis.close ();

		byte[] fileDigest = sha.digest ();
		return fileDigest;
	}
	
	public static X509Certificate getCertificate(String sFilename)
	throws CertificateException, FileNotFoundException, IOException
	{
		return getCertificate(new File (sFilename));
	}

	public static CRL getCRL(File file)
	throws CertificateException, FileNotFoundException, IOException, CRLException
	{
		CertificateFactory certificatefactory = CertificateFactory.getInstance("X.509");
		InputStream inputstream = new FileInputStream(file);
		inputstream = new BufferedInputStream(inputstream);
		CRL crl = (CRL) certificatefactory.generateCRL(inputstream);
		inputstream.close();
		return crl;
	}
	
	public static X509Certificate getCertificate(File file)
	throws CertificateException, FileNotFoundException, IOException
	{
		CertificateFactory certificatefactory = CertificateFactory.getInstance("X.509");
		InputStream inputstream = new FileInputStream(file);
		inputstream = new BufferedInputStream(inputstream);
		X509Certificate x509certificate = (X509Certificate) certificatefactory.generateCertificate(inputstream);
		inputstream.close();
		return x509certificate;
	}

	public static X509Certificate getCertificate(byte[] bytesCertificate)
	throws CertificateException, FileNotFoundException, IOException
	{
		ByteArrayInputStream bis = new ByteArrayInputStream(bytesCertificate);
		CertificateFactory cf = CertificateFactory.getInstance("X.509");
		X509Certificate certificate  = (X509Certificate) cf.generateCertificate(bis);
		bis.close();
		return certificate;
	}
	

	public static String getCertificateFilename(byte[] bytesCertificate)
	throws CertificateException, FileNotFoundException, IOException
	{
		X509Certificate oX509Certificate = getCertificate(bytesCertificate);
		return getCertificateFilename(oX509Certificate);
	}

	public static String getCertificateFilename(X509Certificate oX509Certificate) 
	{
		String sCertificateName = CertificateUtil.getCertificateSubjectInfoCN(oX509Certificate);
		String sNomCertificat = sCertificateName.toLowerCase();
		sNomCertificat = sNomCertificat.replaceFirst(" ",".");
		sNomCertificat = sNomCertificat.trim()+".crt";

		return sNomCertificat;
	}

	
	/**
	 * Récupère l'alias contenu dans le magasin de clés.
	 * 
	 * @param ks
	 * @return
	 * @throws KeyStoreException 
	 */

	@SuppressWarnings("unchecked")
	public static String getAlias(KeyStore ks) throws KeyStoreException
	{
		String sAlias= "";
		//	 RECUPERATION DU COUPLE CLE PRIVEE/PUBLIQUE ET DU CERTIFICAT PUBLIQUE
		Enumeration en = ks.aliases();
		Vector vectaliases = new Vector();

		while (en.hasMoreElements()) vectaliases.add(en.nextElement());

		String[] aliases = (String []) (vectaliases.toArray(new String[0]));

		for (int i = 0; i < aliases.length; i++)
		{
			if (ks.isKeyEntry(aliases[i]))
			{
				sAlias = aliases[i];
				break;
			}
		}

		return sAlias;
	}

	
	/**
	 * Récupère la paire de clés du magazin de clés en fonction de l'alias, 
	 * le mot de passe est obligatoire pour récupérer la clé privée.
	 * 
	 * @param ks
	 * @param sPassword
	 * @param sAlias
	 * @return
	 * @throws KeyStoreException 
	 * @throws NoSuchAlgorithmException 
	 * @throws UnrecoverableKeyException 
	 */
	public static KeyPair getKeyPairFromKeyStore(KeyStore ks, String sPassword, String sAlias)
	throws KeyStoreException, UnrecoverableKeyException, NoSuchAlgorithmException 
	{
		KeyPair kp = null;
		PublicKey publicKey ;
		PrivateKey privateKey;
		char[] charPassword = null;
		if(sPassword != null) charPassword = sPassword.toCharArray();
		privateKey = (PrivateKey)ks.getKey(sAlias, charPassword);
		publicKey = ks.getCertificate(sAlias).getPublicKey();
		kp = new KeyPair (publicKey, privateKey);


		return kp;
	}



	public static void saveCertificateCRT(
			String sPathFilename,
			X509Certificate cert) 
	throws CertificateEncodingException, IOException
	{
		saveCertificateCRT(new File( sPathFilename), cert);
	}
	
	public static void saveCertificateCRT(
			File file,
			X509Certificate cert) 
	throws CertificateEncodingException, IOException
	{
		String base64 = encodeCertificateBase64(cert);
        PrintStream ps = new PrintStream(new FileOutputStream(file));
        ps.println(BEGIN_CERTIFICATE);
        ps.println(base64);
        ps.println(END_CERTIFICATE);
        ps.close();
	}
	
	public static byte[] generateCertificateCRT(X509Certificate cert) throws CertificateEncodingException, IOException
	{
        String base64 = encodeCertificateBase64(cert);
        ByteArrayOutputStream byteCert = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(byteCert);
        ps.println(BEGIN_CERTIFICATE);
        ps.println(base64);
        ps.println(END_CERTIFICATE);
        ps.close();
        return byteCert.toByteArray();
	}
	
	public static String encodeCertificateBase64(X509Certificate cert) throws CertificateEncodingException{
		byte[] encoded = cert.getEncoded();
        sun.misc.BASE64Encoder b64 = new sun.misc.BASE64Encoder();
        String base64 = b64.encode(encoded);
        return base64;
	}
	
	public static String generateCertificateBase64(X509Certificate cert) throws CertificateEncodingException{
		String base64 = encodeCertificateBase64(cert);
        String sCertificate = BEGIN_CERTIFICATE+"\n"+base64+"\n"+END_CERTIFICATE+"\n";
        return sCertificate;
	}
	
	public static X509Certificate loadCertificateBase64WithoutTag(String base64) throws CertificateEncodingException, IOException, CryptoException{
		return loadCertificateBase64(BEGIN_CERTIFICATE+"\n"+base64+"\n"+END_CERTIFICATE+"\n");
	}
	public static X509Certificate loadCertificateBase64(String base64) throws CertificateEncodingException, IOException, CryptoException{
        try {
        	BCCryptoUtil.addProviderBC();
			CertificateFactory cf= CertificateFactory.getInstance("X.509","BC");
			X509Certificate cert = (X509Certificate) cf.generateCertificate(new ByteArrayInputStream(base64.getBytes()));
			return cert;
		} catch (CertificateException e) {
			throw new CryptoException("Impossible de charger le certificat : "+e.getMessage());
		} catch (NoSuchProviderException e) {
			throw new CryptoException("Impossible d'utiliser le provider BC : "+e.getMessage());
		}
	}
	
	public static void saveCertificateCER(String sPath,
			X509Certificate cert) throws CertificateEncodingException, IOException
	{
		FileOutputStream fos = new FileOutputStream(sPath);
		fos.write(cert.getEncoded());
		fos.close();
	}
	
	public static byte[] generateCertificateCER(X509Certificate cert) throws CertificateEncodingException, IOException
	{
		ByteArrayOutputStream byteCert = new ByteArrayOutputStream();
		byteCert.write(cert.getEncoded());
		byteCert.close();
		
		return byteCert.toByteArray();
	}
	
	public static void saveCRL(String sPath,
			X509CRL crl) throws CRLException, IOException
	{
		FileOutputStream fos = new FileOutputStream(sPath);
		fos.write(crl.getEncoded());
		fos.close();
	}
	
	public static byte[] generateCRL(X509CRL crl) throws CRLException, IOException
	{
		ByteArrayOutputStream byteCert = new ByteArrayOutputStream();
		byteCert.write(crl.getEncoded());
		byteCert.close();
		
		return byteCert.toByteArray();
	}
	
	public static X509CRL loadCRL(byte[] bytesCRL) throws CryptoException{
		
		try {
			CertificateFactory cf= CertificateFactory.getInstance("X.509","BC");
			ByteArrayInputStream bais = new ByteArrayInputStream(bytesCRL);
			X509CRL crl = (X509CRL) cf.generateCRL(new ByteArrayInputStream(bytesCRL));
			bais.close();
			return crl;
		} catch (CRLException e) {
			throw new CryptoException("Impossible de charger la CRL : "+e.getMessage());
		} catch (NoSuchProviderException e) {
			throw new CryptoException("Impossible d'utiliser le provider BC : "+e.getMessage());
		} catch (CertificateException e) {
			throw new CryptoException("Impossible de charger la CRL : "+e.getMessage());
		} catch (IOException e) {
			throw new CryptoException("Impossible d'utiliser de fermer le flux : "+e.getMessage());
		}
	}
	
	/**
	 * Charge un certificat existant
	 * @param sPath
	 * @return
	 * @throws CryptoException
	 */
	public static X509Certificate loadX509Certificate(byte[] bytesCert) throws CryptoException{
		
		try {
			CertificateFactory cf= CertificateFactory.getInstance("X.509","BC");
			ByteArrayInputStream bais = new ByteArrayInputStream(bytesCert);
			X509Certificate cert = (X509Certificate) cf.generateCertificate(bais);
			bais.close();
			return cert;
		} catch (CertificateException e) {
			throw new CryptoException("Impossible de charger le certificat : "+e.getMessage());
		} catch (NoSuchProviderException e) {
			throw new CryptoException("Impossible d'utiliser le provider BC : "+e.getMessage());
		} catch (IOException e) {
			throw new CryptoException("Impossible d'utiliser de fermer le flux : "+e.getMessage());
		}
	}
	public static X509Certificate loadX509Certificate(String sPathFilename) 
	throws CryptoException{
		return loadX509Certificate(new File(sPathFilename));
	}
	
	public static X509Certificate loadX509Certificate(File file) 
	throws CryptoException{
		
		try {
			BCCryptoUtil.addProviderBC();
			CertificateFactory cf= CertificateFactory.getInstance("X.509","BC");
			FileInputStream fis = new FileInputStream(file);
			X509Certificate cert = (X509Certificate) cf.generateCertificate(fis);
			fis.close();
			return cert;
		} catch (CertificateException e) {
			throw new CryptoException("Impossible de charger le certificat "+file+" : "+e.getMessage());
		} catch (FileNotFoundException e) {
			throw new CryptoException("Impossible de trouver le certificat "+file+" : "+e.getMessage());
		} catch (NoSuchProviderException e) {
			throw new CryptoException("Impossible d'utiliser le provider BC : "+e.getMessage());
		} catch (IOException e) {
			throw new CryptoException("Impossible d'utiliser de fermer le fichier " + file + " : "+e.getMessage());
		}
	}
	
	public static Certificate getFirstCertificateInKeyStore(KeyStore ks) throws KeyStoreException
	{
		String alias = null;
		
		for(Enumeration<String> e = ks.aliases(); e.hasMoreElements();)
		{
			alias = (String)e.nextElement();
			return ks.getCertificate(alias);
		}
		throw new KeyStoreException("no certificate in key store");
	}
	
	public static ArrayList<HashMap<String, String>> listExtensions() 
	throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, 
	IllegalAccessException{
		ArrayList<HashMap<String, String>> list = new ArrayList<HashMap<String, String>>();
		String[] sExt = JavaUtil.getFieldNames(X509Extensions.class.getName(), DERObjectIdentifier.class, null);
		for(String se : sExt){
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("class", se);
			map.put("name", StringUtils.join(StringUtils.splitByCharacterTypeCamelCase(se), " "));
			list.add(map);
		}

		Collections.sort(list,new Comparator<HashMap<String, String>>(){

			public int compare(HashMap<String, String> o1,
					HashMap<String, String> o2) {
				
				return o1.get("class").compareTo(o2.get("class"));
			}
		} );
		
		return list;
		
	}


	
	/**
	 * Charger un keystore existant
	 * @param keyStorePath
	 * @param keyStorePassword
	 * @return
	 * @throws CryptoException
	 * @throws IOException 
	 */
	public static KeyStore loadKeystorePKCS12(
			String keyStorePath,
			String keyStorePassword)
	throws CryptoException, IOException{
		return loadKeystorePKCS12(
				FileUtilBasic.getBytesFromFile(new File(keyStorePath)), 
				keyStorePassword);
	}
	
	/**
	 * Charger un keystore existant
	 * @param keyStorePath
	 * @param keyStorePassword
	 * @return
	 * @throws CryptoException
	 */
	public static KeyStore loadKeystorePKCS12(
			byte[] bytesKeyStore,
			String keyStorePassword)
	throws CryptoException{
		try {
			BCCryptoUtil.addProviderBC();
			//KeyStore ks = KeyStore.getInstance("PKCS12", "BC");
			KeyStore ks = KeyStore.getInstance("PKCS12");
			InputStream is = new ByteArrayInputStream(bytesKeyStore);
			ks.load(is, keyStorePassword.toCharArray());
			is.close();
			return ks;
		} catch (KeyStoreException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("KeyStoreException : "+ex.getMessage());
		} catch (IOException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("IOException : "+ex.getMessage());
		} catch (NoSuchAlgorithmException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("NoSuchAlgorithmException : "+ex.getMessage());
		} catch (CertificateException ex) {
			Logger.getLogger(KeyStoreUtil.class.getName()).log(Level.SEVERE, null, ex);
			throw new CryptoException("CertificateException : "+ex.getMessage());
		}
	}

	
	
	public static KeyStore getKeyStorePKCS12(String sPathFilename, String sPassword)
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, FileNotFoundException, IOException 
	{
		KeyStore ks = null;
		ks = KeyStore.getInstance("PKCS12");
		InputStream is = new FileInputStream(sPathFilename);
		ks.load(is, sPassword.toCharArray());
		is.close();
		return ks;
	}

	public static KeyStore getKeyStoreTokenUSB(Provider p, String sPassword) 
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException 
	{
		KeyStore ks = KeyStore.getInstance("pkcs11", p);
		ks.load(null,sPassword.toCharArray());

		return ks;
	}

	public static KeyStore getKeyStoreWindowsMY()
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, IOException
	{
		KeyStore ks =  KeyStore.getInstance("Windows-MY");
		ks.load(null, null) ;
		return ks;
	}

	public static String getFirstCertificateAliasInKeyStore(KeyStore ks) throws KeyStoreException
	{
		for(Enumeration<String> e = ks.aliases(); e.hasMoreElements();)
		{
			return (String)e.nextElement();
		}

		return null;
	}

	public static PrivateKey getPrivateKey(
			KeyStore ks,
			String sAlias,
			String sPassword) 
	throws KeyStoreException, UnrecoverableKeyException, NoSuchAlgorithmException
	{
		char[] caPwd = null;
		if(sPassword != null ) caPwd = sPassword.toCharArray();
		return (PrivateKey) ks.getKey(sAlias, caPwd) ;
	}
	


	public static X509Certificate getCertificateInKeyStore(KeyStore ks, String sAlias) throws KeyStoreException
	{
		return (X509Certificate)ks.getCertificate(sAlias);
	}

	
	
	public static Vector<Vector<Object>> getListCertInKeyStore(KeyStore ks) throws KeyStoreException
	{
		Vector <Vector<Object>> vListCerts = new Vector<Vector<Object>>();

		X509Certificate cert = null;
		String alias = null;

		for(Enumeration<String> e = ks.aliases(); e.hasMoreElements();)
		{
			Vector <Object> vCert = new Vector<Object>();
			alias = (String)e.nextElement();
			cert = (X509Certificate)ks.getCertificate(alias);

			vCert.add(alias);
			vCert.add(cert);
			vListCerts.add(vCert);
		}

		return vListCerts;
	}

	public static void displayListCertsInKeystore(KeyStore ks) throws KeyStoreException
	{
		Vector<Vector<Object>> vListCerts = getListCertInKeyStore(ks);
		System.out.println("******** "+vListCerts.size()+" certificats contenu dans le keystore ******");
		for(int i=0;i<vListCerts.size();i++)
		{
			Vector<Object> vCert = (Vector<Object>)vListCerts.get(i);
			if(vCert.size()==2)
			{
				System.out.println("alias: "+(String)vCert.firstElement());
				System.out.println("cert: "+vCert.get(1));
			}

		}
	}

	public static boolean verifyCertificateUser(X509Certificate certificat, String sMailUser)
	{
		boolean bUserValide = false;
		String sMailDestinataireCertificat = getCertificateSubjectInfoEmailAddress(certificat);
		if((StringUtilBasic.stripAccents(sMailDestinataireCertificat).toLowerCase().trim())
				.compareTo(sMailUser) == 0) bUserValide = true;

		return bUserValide;
	}

	

	public static void display(KeyPair kp)//, KeyStore ks, String sAlias) 
	{
		RSAPublicKey publicKey  = (RSAPublicKey ) kp.getPublic();
		RSAPrivateKey privateKey = (RSAPrivateKey) kp.getPrivate();
		//X509Certificate certificat = Crypto.getCertificateFromKeyStore(ks, sAlias);
		//Work work = new Work(kp);

		System.out.println("\n\n******************\npublicKey: PubExp\n" + getHexaStringValue( publicKey.getPublicExponent().toByteArray() ));
		System.out.println("publicKey: Mod \n" + getHexaStringValue( publicKey.getModulus().toByteArray() ));

		System.out.println("privateKey: PriExp\n" + getHexaStringValue( privateKey.getPrivateExponent().toByteArray() ));
		System.out.println("privateKey: Mod \n" + getHexaStringValue( privateKey.getModulus().toByteArray() ));
	}




	
	public static String getCertificateInfo(String sInfos, String sParam) 
	{
		String[] sInfo = sInfos.replaceAll(",",";").split(";");
		for(int i=0;i<sInfo.length;i++)
		{
			if(sInfo[i].trim().startsWith(sParam))
				return  sInfo[i].trim().substring(sParam.length()+1);
		}
		
		return "";
		
	}
	public static String getCertificateIssuerInfoCN(X509Certificate cert)
	{
		String sInfo = cert.getIssuerX500Principal().toString();
		return getCertificateInfo(sInfo, "CN");
	}

	public static String getCertificateSubjectInfoCN(X509Certificate cert)
	{
		String sInfo = cert.getSubjectX500Principal().toString();
		return getCertificateInfo(sInfo, "CN");
	}
	
	public static String getCertificateSubjectInfoEmailAddress(X509Certificate cert)
	{
		String sInfo = cert.getSubjectX500Principal().toString();
		return getCertificateInfo(sInfo, "EMAILADDRESS");
	}
	
	public static boolean checkValidity(X509Certificate cert) 
	{
		boolean bIsValid = false;
		try{
			cert.checkValidity();
			bIsValid = true;
		}catch(Exception e){
			bIsValid = false;
		}
		return bIsValid;
	}
	
    public static void verifyIssuerName(X509Certificate subject, X509Certificate issuer) throws CertificateException 
    {
    	X500Principal issuerX500 = subject.getIssuerX500Principal();
    	X500Principal issuerToCheckX500 = issuer.getSubjectX500Principal();
    	
    	if(issuerX500.getName("CN").equals(  issuerToCheckX500.getName("CN")))
    	{
    		return;
    		
    	}
    	
    	throw new CertificateException ("l'Issuer n'a pas été validé");
    }
    
    public static String getX500PrincipalInfos(X500Principal principal, String sLineDelimiter) throws Exception
    {

    	String sInfos = "";
    	
    	String[] splited = principal.getName().split("\\\\,");
    	
    	for (int i = 0; i < splited.length; i++) {
			String string = splited[i];
			sInfos += string.replaceAll(",", sLineDelimiter) ;
			
			if(i != splited.length)
				sInfos += ",";
		}
    	
    	return sInfos;
    	
    }

	/**
	 * TODO http://spreadsheets.google.com/ccc?key=pyeoS6qqrx5DscNZz2si-XA&hl=fr
	 * 
	 * Création d'un PKCS12 sur le serveur depuis un certificat racine
	 * Création d'une paire de clés
	 * Charger un P12
	 * sauvegarder un P12
	 * Créer une AC avec un certificat ROOT
	 * Créer une AC intermédiare : Modula Demat, Modula Paraph, etc
	 * Signer un certificat avec une chaine de certification
	 * Creer un jeton d'horodatage : normes d'horodatage RFC 3161 Timestamp protocol > XADES ? etc
	   http://www.karlverger.com/developpement/signature-electronique-horodatage-bouncycastle-1-49
	   http://www.karlverger.com/developpement/signature-electronique-horodatage-bouncycastle-2-54
	 * Gérer les listes de révocation : CRL

     * http://forum.java.sun.com/thread.jspa?threadID=716939&messageID=4141387
     * http://fr.wikipedia.org/wiki/PKCS
     * http://www.java2s.com/Open-Source/Java-Document/Security/Bouncy-Castle/org/bouncycastle/x509/X509V2CRLGenerator.java.htm
     * http://www.bouncycastle.org/wiki/display/JA1/X.509+Certificate+Revocation+Lists
     * 
	 * @param args
	 * @throws CryptoException
	 * @throws IOException
	 * @throws CertificateEncodingException 
	 * @throws KeyStoreException 
	 * @throws CRLException 
	 */
	public static void main(String[] args) throws CryptoException, IOException, CertificateEncodingException, KeyStoreException, CRLException {
		BCCryptoUtil.addProviderBC();

		X509Principal rootDN = CertificateGenerator.generateDN("Gratte POIL Root", 
				"Dev Dpt",
				"MT Software",
				"Arradon",
				"France",
				"FRA",
				"root@matamore.com");
		
		X509Principal intermediateDN = CertificateGenerator.generateDN("Gratte POIL Intermediate", 
				"Administratif",
				"Intermediate Software",
				"Paris",
				"France",
				"FRA",
				"intermediate@matamore.com");
		
		X509Principal finalDN = CertificateGenerator.generateDN("Gratte POIL Final", 
				"Atelier",
				"Final Software",
				"Paris",
				"France",
				"FRA",
				"final@matamore.com");
		
		Certificate[] chain = new Certificate[3];

		//1 génération de notre paire de clef privé/public
		KeyPair myKeyPairRoot = CertificateGenerator.generateKeyPair();//KeyPairUtil.RSA_TYPE, 1024
		//CertificateFile.display(myKeyPair);

		//2 création du certificat V1 Root
		X509Certificate myCertV1Root = CertificateGenerator.generateCertV1(rootDN ,
				rootDN,
				1000,
				myKeyPairRoot.getPublic(),
				myKeyPairRoot.getPrivate(),
				"SHA1withRSA");
		chain[2] = myCertV1Root;
		//System.out.println(myCertV1Root.toString());

		//2 création du certificat V1 Intermediate
		KeyPair myKeyPairIntermediate = CertificateGenerator.generateKeyPair();
		X509Certificate myCertV3Intermediate = CertificateGenerator.generateCertV3Intermediate( rootDN,
				intermediateDN,
				1000,
				myKeyPairIntermediate.getPublic(),
				myKeyPairRoot.getPrivate(),
				"SHA1withRSA",
				myCertV1Root);
		chain[1] = myCertV3Intermediate;
		//System.out.println(myCertV1Intermediate.toString());
		
		//2 création du certificat V1 Final
		KeyPair myKeyPairFinal = CertificateGenerator.generateKeyPair();
		X509Certificate myCertV1Final = CertificateGenerator.generateCertV3Final( intermediateDN,
				finalDN,
				1000,
				myKeyPairFinal.getPublic(),
				myKeyPairIntermediate.getPrivate(),
				"SHA1withRSA",
				myKeyPairIntermediate.getPublic());
		chain[0] = myCertV1Final;
		//System.out.println(myCertV1Intermediate.toString());

		//2 création du certificat V3
		/*
		X509Certificate myCertV3 = generateCertV3ForTimeStamping( "Gratte POIL", 
				"Dev Dpt",
				"MT Software",
				"Arradon",
				"France",
				"FRA",
				"julien.renier@matamore.com",
				1000,
				myKeyPair.getPublic(),
				myKeyPair.getPrivate(),
				"SHA1withRSA");
		System.out.println(myCertV3.toString());
		*/
		
        //3 ajout de notre certificat dans le keystore
        KeyStore myKeystoreRoot = CertificateGenerator.createKeyStorePKCS12();
        CertificateGenerator.addCertToKeyStore(myKeystoreRoot, "V1 Root",  "babaV1Root", myKeyPairRoot.getPrivate(), myCertV1Root);
        
        KeyStore myKeystoreIntermediate = CertificateGenerator.createKeyStorePKCS12();
        CertificateGenerator.addCertToKeyStore(myKeystoreIntermediate, "V3 Intermediate",  "babaV3Intermediate", myKeyPairIntermediate.getPrivate(), myCertV3Intermediate);
        
        KeyStore myKeystoreFinal = CertificateGenerator.createKeyStorePKCS12();
        CertificateGenerator.addCertToKeyStore(myKeystoreFinal, "V1 Final",  "babaV1Final", myKeyPairFinal.getPrivate(), myCertV1Final);
       
        //addCertToKeyStore(myKeystore, "V3",  "babaV3", myKeyPair.getPrivate(), myCertV3);
        
        CertificateGenerator.saveKeyStore(myKeystoreRoot, new File("C:\\temp\\myKeystoreRoot.p12"), "bababa".toCharArray());
        CertificateGenerator.saveKeyStore(myKeystoreIntermediate, new File("C:\\temp\\myKeystoreIntermediate.p12"), "bababa".toCharArray());
        CertificateGenerator.saveKeyStore(myKeystoreFinal, new File("C:\\temp\\myKeystoreFinal.p12"), "bababa".toCharArray());
        
        saveCertificateCRT("C:\\temp\\myCertV1Root.crt", myCertV1Root);
        saveCertificateCRT("C:\\temp\\myCertV1Intermediate.crt", myCertV3Intermediate);
        saveCertificateCRT("C:\\temp\\myCertV1Final.crt", myCertV1Final);
        
        KeyStore myKeystoreAll = CertificateGenerator.createKeyStorePKCS12();
        myKeystoreAll.setKeyEntry("All", myKeyPairIntermediate.getPrivate(), null, chain);
        CertificateGenerator.saveKeyStore(myKeystoreAll, new File("C:\\temp\\myKeystoreAll.p12"), "bababa".toCharArray());
        
        X509CRL crl = CertificateGenerator.generateCRL(rootDN, 1000, myKeyPairRoot.getPrivate(), "SHA1withRSA", myCertV1Root);
        saveCRL("C:\\temp\\myCRL.crl", crl);
        crl = CertificateGenerator.revokeCert(myKeyPairRoot.getPrivate(), myCertV1Root, crl, myCertV1Final);
        saveCRL("C:\\temp\\myCRL2.crl", crl);
        System.out.println("myCertV1Final revoked : "+crl.isRevoked(myCertV1Final));
        System.out.println("myCertV3Intermediate revoked : "+crl.isRevoked(myCertV3Intermediate));
        
        KeyStore myKeystoreAllLoaded = loadKeystorePKCS12("C:\\temp\\myKeystoreAll.p12", "bababa");
        System.out.println("***************myKeystoreAllLoaded*******************");
        displayListCertsInKeystore(myKeystoreAllLoaded);
        X509Certificate myCertV1RootLoaded = loadX509Certificate("C:\\temp\\myCertV1Root.crt");
        System.out.println("***************myCertV1RootLoaded*******************");
        System.out.println(myCertV1RootLoaded.toString());
        
        String sB64 = generateCertificateBase64(myCertV1RootLoaded);
        System.out.println("***************myCertV1RootLoaded B64*******************");
        System.out.println(sB64);
        
        X509Certificate myCertV1RootLoadedB64 = loadCertificateBase64(sB64);
        System.out.println("***************myCertV1RootLoadedB64*******************");
        System.out.println(myCertV1RootLoadedB64.toString());
	}
}
