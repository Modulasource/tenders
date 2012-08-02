package org.coin.security;

import java.security.KeyStore;
import java.security.cert.Certificate;
import java.util.Enumeration;


/**
 * 
 * http://java.sun.com/developer/technicalArticles/J2SE/security/
 * 
 * @author david
 *
 */
public class KeyStoreManager {
	public static void main(String[] args) {
		try { 
			/**
			 * KeyStore
	
				Windows-MY
				Windows-ROOT
				
				Provides direct read-write access to MS Window's keystores. The Windows-MY keystore contains the 
				user's private keys and the associated certificate chains. 
				The Windows-ROOT keystore contains all root CA certificates trusted by the machine.
			 * 
			 * 
			 */
			
			//KeyStore ks = KeyStore.getInstance("Windows-ROOT");
			KeyStore ks = KeyStore.getInstance("Windows-MY");
			ks.load(null, null) ;
			Enumeration en = ks.aliases() ;
		 
			while (en.hasMoreElements()) {
				String aliasKey = (String)en.nextElement() ;
				Certificate c = ks.getCertificate(aliasKey) ;
				System.out.println("---> alias : " + aliasKey) ;
				System.out.println("    Certificat : " + c.toString() ) ;
		 

			}
		 
		} catch (Exception ioe) {
			System.err.println(ioe.getMessage());
		}
	}
}
