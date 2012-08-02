package org.coin.security;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class Blowfish {

	public static byte[] cipher(
			String sSymetricKey, 
			byte[] data) 
	throws NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidKeyException, InvalidAlgorithmParameterException 
	{
		// CHoix de l'iv
		byte[] iv = { (byte) 0xc9, (byte) 0x36, (byte) 0x78, (byte) 0x99,
					  (byte) 0x52, (byte) 0x3e, (byte) 0xea, (byte) 0xf2 };

		IvParameterSpec salt = new IvParameterSpec(iv);
		// Secret key choosen
		byte[] raw = sSymetricKey.getBytes();
		SecretKey skeySpec = new SecretKeySpec(raw, "Blowfish");
		
		// Chiffrement du fichier
		Cipher c = Cipher.getInstance("Blowfish/CBC/PKCS5Padding", "BC");    
	    c.init(Cipher.ENCRYPT_MODE, skeySpec, salt);
		return c.doFinal(data);
	}	

	public static byte[] unCipher(
			String sSymetricKey, 
			byte[] data) 
	throws NoSuchAlgorithmException, NoSuchProviderException,
			NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException
	
	{
		// CHoix de l'iv
		byte[] iv = { (byte) 0xc9, (byte) 0x36, (byte) 0x78, (byte) 0x99,
					  (byte) 0x52, (byte) 0x3e, (byte) 0xea, (byte) 0xf2 };

		IvParameterSpec salt = new IvParameterSpec(iv);
		//Secret key choosen
		byte[] raw = sSymetricKey.getBytes();
		SecretKey skeySpec = new SecretKeySpec(raw, "Blowfish");
		
		// Chiffrement du fichier
		Cipher c = Cipher.getInstance("Blowfish/CBC/PKCS5Padding", "BC");    
	    c.init(Cipher.DECRYPT_MODE, skeySpec, salt);
		return c.doFinal(data);
	}	
	
}
