package org.coin.security;

import java.security.KeyPair;
import java.security.cert.X509Certificate;


import org.coin.security.token.SessionKey;


public class CipherModulaKey {
	
	protected KeyPair kp;
	protected String sDataPKCS1;
	//private PassThruCardService ptcs;
	protected SessionKey oSessionKey;
	protected boolean bLocalCHVAuth;
	protected X509Certificate oX509Certificate;
	protected byte[][] bytesX509CertificateInfos;
	protected byte[] bytesCardSerialNumber ;

	
	public static byte[] getKey() {
		return new byte[] { 
				(byte) 0xE5, (byte) 0x57, (byte) 0x21, (byte) 0xFF,
				(byte) 0xE9, (byte) 0xF7, (byte) 0x36, (byte) 0xE6,
				(byte) 0xE5, (byte) 0x57, (byte) 0x21, (byte) 0xFF,
				(byte) 0xE5, (byte) 0x57, (byte) 0x21, (byte) 0xFF };
	}
	
	
	public static byte[] getKDC() {

		byte[]  bytesKDC = getKey();
		bytesKDC = CertificateUtil.generate24b3DESKeyFrom16bKey(bytesKDC);
		return bytesKDC;
	}

}
