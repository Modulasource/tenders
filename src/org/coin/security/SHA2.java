/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */

package org.coin.security;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA2 {

	public static String getEncodedString256(String key) {
		byte[] uniqueKey = key.getBytes();
		byte[] hash = null;
		try {
			hash = MessageDigest.getInstance("SHA-256").digest(uniqueKey);
		}
		catch (NoSuchAlgorithmException e) {
			throw new Error("no SHA-256 support in this VM");
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


	public static String getEncodedString512(String key) {
		byte[] uniqueKey = key.getBytes();
		byte[] hash = null;
		try {
			hash = MessageDigest.getInstance("SHA-512").digest(uniqueKey);
		}
		catch (NoSuchAlgorithmException e) {
			throw new Error("no SHA-512 support in this VM");
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

	public static void main(String[] args) {
		System.out.println("getEncodedString="  + getEncodedString256("toto") );
	}
}
