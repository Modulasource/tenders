/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 10 sept. 2004
 *
 * Classe utilitaire pour l'algorithme de hachage SHA1
 */
package org.coin.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.io.*;

/**
 * @author fkiebel
 *
 * v1.1.1.1 - Création de la classe SHA1 et de la méthode getEncodedString(String)
 */
public class SHA1 {

	/**
	 * Méthode hachant une chaine de caractère avec l'algo SHA-1
	 * @param sChaine - chaine à hacher
	 * @return le hachage, sinon null
	 */
	public static String getEncodedString(String sChaine) {
		byte[] uniqueKey = sChaine.getBytes();
		byte[] hash = null;
		try {
			hash = MessageDigest.getInstance("SHA1").digest(uniqueKey);
		} 
		catch (NoSuchAlgorithmException e) {
			throw new Error("no SHA1 support in this VM");
		}
		StringBuffer hashString = new StringBuffer();
		for ( int i = 0; i < hash.length; ++i ) {
			String hex = Integer.toHexString(hash[i]);
			if ( hex.length() == 1 ) {
				hashString.append('0');
				hashString.append(hex.charAt(hex.length()-1));
			} else {
				hashString.append(hex.substring(hex.length()-2));
			}
		}
		return hashString.toString();
	}
	/**
	 * Méthode hachant un fichier avec l'algo SHA-1
	 * @param file - fichier à hacher
	 * @return le hachage sinon null
	 */
	public static String getEncodedFile(InputStream file) {
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(file));
			String line;
			StringBuffer sbFileBuffer = new StringBuffer();
			
			while ((line = in.readLine()) != null) {
				sbFileBuffer.append(line);
			}
			in.close();
			
			return SHA1.getEncodedString(sbFileBuffer.toString());
		}
		catch (IOException e) {
			System.out.println("SHA1.java - Erreur dans la methode getEncodedFile()");
			e.printStackTrace();
			return null;
		}
	}
}
