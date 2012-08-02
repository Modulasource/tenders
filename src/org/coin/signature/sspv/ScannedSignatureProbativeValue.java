package org.coin.signature.sspv;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.security.DigestInputStream;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SignatureException;
import java.security.cert.CertStoreException;
import java.security.cert.Certificate;
import java.util.Vector;

import org.coin.signature.sspv.shape.SSPVShape;
import org.coin.util.FileUtilBasic;



public abstract class ScannedSignatureProbativeValue {

	protected Vector<SSPVShape> vShape = new Vector<SSPVShape>();
	//protected ScannedSignatureShape signature;
	//protected ScannedSignatureShape paraph;
	//protected MentionShape mention;

	protected File fileDocumentSource;
	protected byte[] bytesHashDocumentSource ;
	protected byte[] bytesSignatureDocumentSource ;

	protected File fileDocumentDestination;
	protected byte[] bytesHashDocumentDestination;
	protected byte[] bytesSignatureDocumentDestination;

	/**
	 * the Seal = sign(hash(source) + ":" + hash(destination) )
	 */
	protected byte[] bytesHashDocumentSourceDestination;
	protected byte[] bytesSignatureDocumentSourceDestination;


	protected Certificate certificate;
	protected PrivateKey privateKey; 
	protected PublicKey publicKey; 


	protected boolean bAttachFileSource; 
	protected boolean bAttachFileDestination; 

	
	
	public void setFileDocumentDestination(File fileDocumentDestination) {
		this.fileDocumentDestination = fileDocumentDestination;
	}
	
	public void setFileDocumentSource(File fileDocumentSource) {
		this.fileDocumentSource = fileDocumentSource;
	}
	
	public boolean getAttachFileDestination() {
		return bAttachFileDestination ;
	}
	
	public void setAttachFileDestination(boolean attachFileDestination) {
		bAttachFileDestination = attachFileDestination;
	}

	public boolean getAttachFileSource() {
		return bAttachFileSource;
	}

	public void setAttachFileSource(boolean attachFileSource) {
		bAttachFileSource = attachFileSource;
	}

	public void addShape( SSPVShape shape)
	{
		shape.setDocument(getDocument()); 
		this.vShape.add(shape);
	}

	public void transform() throws IOException
	{
		for (SSPVShape shape : this.vShape) {
			System.out.println("draw '" + shape.getName() + "' on page " + shape.getPageNumberList());
			shape.draw();
		}
	}

	public String getXml() throws IOException
	{
		String sXml = "<" + SSPVShape.TAG_NAME_ROOT + ">\n";
		
		if(this.fileDocumentSource != null) sXml += getXmlDocument(this.fileDocumentSource, "source" , this.bAttachFileSource);
		if(this.fileDocumentDestination != null) sXml += getXmlDocument(this.fileDocumentDestination, "destination" , this.bAttachFileDestination);
		
		sXml += getXmlTransform();
		sXml += "</" + SSPVShape.TAG_NAME_ROOT + ">\n";
		return sXml;
	}

	public static String getXmlDocument(
			File file,
			String sType,
			boolean bAttachFile) 
	throws IOException
	{
		String sXml = "<" + SSPVShape.TAG_NAME_DOCUMENT 
			+ " type=\"" + sType +  "\" " 
			+ " format=\"" + "modula/xmldsig/xades" +  "\" " 
			+ " filename=\"" + file.getName() + "\""
			+ " >\n";
		
		if(bAttachFile) {
			sXml += "<body encodingType=\"Base64\" >" 
				+ FileUtilBasic.encodeBase64FromFile(file)
				+ "</body>\n";
		}
		sXml += "<signatures>"
			+ "<signature type=\"PKCS7\" encodingType=\"Base64\" "
				+" name=\"\" >" + "FFFF" + "</signature>"
			+ "</signatures>";
		
		sXml += "</" + SSPVShape.TAG_NAME_DOCUMENT + ">\n";

		return sXml;
	}
	public String getXmlTransform() throws IOException
	{
		String sXml = "<" + SSPVShape.TAG_NAME_TRANSFORMATION + ">\n";
		for (SSPVShape shape : this.vShape) {
			sXml +=  shape.getShapeXml();
		}

		sXml += "</" + SSPVShape.TAG_NAME_TRANSFORMATION + ">\n";

		return sXml;
	}


	abstract public Object getDocument();
	abstract public void   setDocument(Object item);

	abstract public Object getDefaultFont();
	abstract public void   setDefaultFont(Object item);

	
	abstract public File getDefaultFontFile();
	abstract public void setDefaultFontFile(File item);
	
	abstract public int getDocumentPageCount();


	abstract public void sign()
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, SignatureException, CertStoreException, InvalidAlgorithmParameterException, IOException;


	public static byte[] computeHash(InputStream fis, String sMessageDigestAlgorithm)
	throws IOException, NoSuchAlgorithmException
	{
		MessageDigest sha = MessageDigest.getInstance(sMessageDigestAlgorithm);
		DigestInputStream dis = new DigestInputStream (fis,sha);

		while ( dis.read () != -1) { }
		dis.close ();

		byte[] fileDigest = sha.digest ();

		return fileDigest;
	}

}
