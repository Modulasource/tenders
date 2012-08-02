package org.coin.signature.sspv;

import java.io.IOException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SignatureException;
import java.security.cert.CertStoreException;


public abstract class BCScannedSignatureProbativeValue extends ScannedSignatureProbativeValue {
	public static final String SIGN_METHOD = "SHA1withRSA";

	public void sign() 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, SignatureException,
	CertStoreException, InvalidAlgorithmParameterException, IOException
	{
		try {
			//sign(this.fileDocumentSource, this., this.privateKey, null);
			//sign(this.fileDocumentDestination, this. , this.privateKey, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}







}
