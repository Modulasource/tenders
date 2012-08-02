package org.coin.security;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Security;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpSession;

import org.bouncycastle.jce.provider.BouncyCastleProvider;
import org.coin.bean.conf.Configuration;

public class SecureString {

	private static String sPassPhrase ;
	private static final String sSymetricKeyDefault = "moovi2_5love" ;

	public static String getCipherSymetricKey() 
	{
		String sSymetricKey;
		try {
			sSymetricKey = Configuration.getConfigurationValueMemory("security.instance.passphrase", sSymetricKeyDefault);
		} catch (Exception e) {
			sSymetricKey = sSymetricKeyDefault;
		}
		return sSymetricKey;
	}

	/**
	 * 
	 * @param sPlainString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws InvalidAlgorithmParameterException
	 */
	public static String getSecureString(String sPlainString) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, 
	NoSuchPaddingException, IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		Security.addProvider(new BouncyCastleProvider());
    	byte[] bytesCipherMessage = Blowfish.cipher(getCipherSymetricKey() , sPlainString.getBytes());
    	return CertificateUtil.getHexaStringValue(bytesCipherMessage);
	}
	
	/**
	 * 
	 * @param sSecureString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public static String getPlainString(String sSecureString) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, 
	NoSuchPaddingException, InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException 
	{
		Security.addProvider(new BouncyCastleProvider());
    	byte[] bytesCipherMessage =  CertificateUtil.parseHexString(sSecureString);
		byte[] bytesDecipherMessage = Blowfish.unCipher(getCipherSymetricKey() , bytesCipherMessage);
		return new String(bytesDecipherMessage);
	}
	
	
	/**
	 * 
	 */
	private static void genStaticPassPhrase() {
		genStaticPassPhrase(false);
	}

	
	/**
	 * 
	 */
	private static String getSessionPassPhrase(HttpSession session) {
		String sPassPhrase = (String)session.getAttribute("SecureStringSessionPassPhrase");
		if(sPassPhrase == null) 
		{
			sPassPhrase = genPassPhrase();
			session.setAttribute("SecureStringSessionPassPhrase", sPassPhrase);
		}
		return sPassPhrase;
	}

	

	/**
	 * 
	 * @param bForceGeneration
	 */
	private static void genStaticPassPhrase(boolean bForceGeneration) 
	{
		if(bForceGeneration || sPassPhrase == null) {
			sPassPhrase = genPassPhrase();
		}
	}
	
	/**
	 * 
	 * @return
	 */
	private static String genPassPhrase() {
		return Password.calcPassword(12,Password.CHARSET_TINY + Password.CHARSET_NUM);
	}
	
	/**
	 * 
	 * @param sPlainString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws InvalidAlgorithmParameterException
	 */
	public static String getInstanceSecureString(String sPlainString) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException,
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException  
	{
		Security.addProvider(new BouncyCastleProvider());
		genStaticPassPhrase();
    	byte[] bytesCipherMessage = Blowfish.cipher(sPassPhrase, sPlainString.getBytes());
    	return CertificateUtil.getHexaStringValue(bytesCipherMessage);
	}
	
	/**
	 * 
	 * @param sSecureString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public static String getInstancePlainString(String sSecureString) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException  
	{
		Security.addProvider(new BouncyCastleProvider());
		genStaticPassPhrase();
    	byte[] bytesCipherMessage =  CertificateUtil.parseHexString(sSecureString);
		byte[] bytesDecipherMessage = Blowfish.unCipher(sPassPhrase, bytesCipherMessage);
		return new String(bytesDecipherMessage);
	}
	
	/**
	 * cipher message
	 * 
	 * @param session
	 * @param sPlainString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 * @throws InvalidAlgorithmParameterException
	 */
	public static String getSessionSecureString(String sPlainString, HttpSession session) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		Security.addProvider(new BouncyCastleProvider());
		byte[] bytesCipherMessage = Blowfish.cipher(getSessionPassPhrase(session), sPlainString.getBytes());
    	return CertificateUtil.getHexaStringValue(bytesCipherMessage);
	}
	
	/**
	 * decipher message
	 * 
	 * @param session
	 * @param sSecureString
	 * @return
	 * @throws InvalidKeyException
	 * @throws NoSuchAlgorithmException
	 * @throws NoSuchProviderException
	 * @throws NoSuchPaddingException
	 * @throws InvalidAlgorithmParameterException
	 * @throws IllegalBlockSizeException
	 * @throws BadPaddingException
	 */
	public static String getSessionPlainString(String sSecureString, HttpSession session)
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException, 
	InvalidAlgorithmParameterException, IllegalBlockSizeException, BadPaddingException
	{
		Security.addProvider(new BouncyCastleProvider());
		byte[] bytesCipherMessage =  CertificateUtil.parseHexString(sSecureString);
		byte[] bytesDecipherMessage = Blowfish.unCipher(getSessionPassPhrase(session), bytesCipherMessage);
		return new String(bytesDecipherMessage);
	}
	
}
