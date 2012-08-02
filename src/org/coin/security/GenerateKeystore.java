package org.coin.security;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.security.Key;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.util.Enumeration;

import org.coin.util.ProcessStreamReader;

/**
 * @author julien
 * @required the package org.mortbay.jetty.jar in JAVA_HOME\jre\lib\ext directory
 * @required OpenSSL - defined the path in your ENVIRONEMENT VAR
 * @required file prod.modula-demat.com.crt 
 * @required file prod.modula-demat.com.key
 * @required file ComodoSecurityServicesCA.cer
 * @required file GTECyberTrustRootCA.cer
 */
public class GenerateKeystore 
{
	public static void generatePKCS12(
			String sPathFileNameOut, 
			String sPathFileNameCRT, 
			String sPathFileNameKEY, 
			String sPassword) 
	throws Exception  
	{
		Process p;
		String sPath = "C:\\OpenSSL-Win64\\bin\\";
		String sCommandLine 
		= sPath + "openssl pkcs12 -export -inkey \"" + sPathFileNameKEY + "\""
		+ " -in \"" + sPathFileNameCRT + "\""
		+ " -out \"" + sPathFileNameOut + "\"";

		try 
		{
			System.out.println(sCommandLine );
			/**
			 * TODO : open CMD.exe as Administrator and copy/paste the command line
			 */

			p = Runtime.getRuntime().exec(sCommandLine );
		} 
		catch (Exception e) 
		{
			throw new Exception("generatePKCS12 error >> " + e.toString());
		}

		ProcessStreamReader psr_stdout = new ProcessStreamReader(p.getInputStream());
		ProcessStreamReader psr_stderr = new ProcessStreamReader(p.getErrorStream());

		psr_stdout.start();
		psr_stderr.start();

		BufferedWriter out = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
		try 
		{
			out.write(sPassword);
			out.close();
		} 
		catch (Exception e) 
		{
			throw new Exception("generatePKCS12 error >> " + e.toString());
		}

		try 
		{
			p.waitFor();
			psr_stdout.join();
			psr_stderr.join();
		} 
		catch (Exception e) 
		{
			throw new Exception("generatePKCS12 error >> " + e.toString());
		}

		System.out.println("gpg output : " + psr_stdout.getString());
		System.out.println("gpg output : " + psr_stderr.getString());

	}

	public static void addPrivateKey(
			String sFilePKCS12, 
			String sFilePKCS12Password, 
			String sAlias,
			String sJavaKeyStoreJKS,
			String sJavaKeyStoreJKSPassword)
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, FileNotFoundException, 
	IOException, UnrecoverableKeyException 
	{
		KeyStore kspkcs12=KeyStore.getInstance("PKCS12");
		kspkcs12.load(new FileInputStream(sFilePKCS12),sFilePKCS12Password.toCharArray());
		KeyStore ksjks=KeyStore.getInstance("JKS");
		ksjks.load(new FileInputStream(sJavaKeyStoreJKS),sJavaKeyStoreJKSPassword.toCharArray());

		Certificate c[]=kspkcs12.getCertificateChain(sAlias);
		Key key=kspkcs12.getKey(sAlias,sFilePKCS12Password.toCharArray());

		ksjks.setKeyEntry(sAlias,key,sFilePKCS12Password.toCharArray(),c);
		ksjks.store(new FileOutputStream(sJavaKeyStoreJKS),sJavaKeyStoreJKSPassword.toCharArray());

	}


	/**
	 * @see http://www.java2s.com/Code/Java/Security/Importakeycertificatepairfromapkcs12fileintoaregularJKSformatkeystore.htm
	 * 
	 * @param fileP12
	 * @param fileKeyStore
	 * @throws KeyStoreException 
	 * @throws IOException 
	 * @throws FileNotFoundException 
	 * @throws CertificateException 
	 * @throws NoSuchAlgorithmException 
	 * @throws UnrecoverableKeyException 
	 */
	public static void addP12(
			File fileP12,
			String sPassphraseP12,
			File fileKeyStore,
			String sPassphraseKeyStore,
			String sForceAliasForKeyStore)
	throws KeyStoreException, NoSuchAlgorithmException, CertificateException, FileNotFoundException, 
	IOException, UnrecoverableKeyException 
	{

		KeyStore kspkcs12 = KeyStore.getInstance("pkcs12");
		KeyStore ksjks = KeyStore.getInstance("jks");

		kspkcs12.load(new FileInputStream(fileP12), sPassphraseP12.toCharArray());

		ksjks.load(
				(fileKeyStore.exists())
				? new FileInputStream(fileKeyStore) : null, sPassphraseKeyStore.toCharArray());

		Enumeration eAliases = kspkcs12.aliases();
		int n = 0;
		while (eAliases.hasMoreElements()) {
			String sAlias = (String)eAliases.nextElement();
			System.err.println("Alias " + n++ + ": " + sAlias );

			if (kspkcs12.isKeyEntry(sAlias )) {
				System.err.println("Adding key for alias " + sAlias );
				Key key = kspkcs12.getKey(sAlias , sPassphraseP12.toCharArray());

				Certificate[] chain = kspkcs12.getCertificateChain(sAlias );
				String sAliasForKeyStore = sAlias ;
				if(sForceAliasForKeyStore != null) {
					sAliasForKeyStore = sForceAliasForKeyStore; 
				}
				ksjks.setKeyEntry(sAliasForKeyStore, key, sPassphraseKeyStore.toCharArray(), chain);
			}
		}

		OutputStream out = new FileOutputStream(fileKeyStore);
		ksjks.store(out, sPassphraseKeyStore.toCharArray());
		out.close();
	}

	public static void main(String[] args) 
	{
		try 
		{
			String sPassword = "modula";
			String sPath = "D:\\source\\eclipse_3.5\\"
				+ "modula_core\\config\\jar\\certificate\\";
			String sPathYear = sPath + "2010\\";

			/*
			generatePKCS12(
					sPathYear + "prod.modula-demat.com.p12", 
					sPathYear + "prod.modula-demat.com.crt", 
					sPathYear + "prod.modula-demat.com.key", 
					sPassword);
			 */


			File fileP12 = new File(sPathYear + "prod.modula-demat.com.p12");
			File fileKeyStore = null;

			if(fileKeyStore == null)
			{
				fileKeyStore = new File(sPathYear + "code_signing.jks");
			}

			addP12(fileP12, sPassword, fileKeyStore, sPassword, "prod.modula-demat.com.2010");

			/*
			addPrivateKey(
					sPathYear + "prod.modula-demat.com.p12", 
					"modula" , 
					"prod.modula-demat.com.2010", 
					sPath + "code_signing.keystore", 
					"modula");
			 */
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		}

	}
}
