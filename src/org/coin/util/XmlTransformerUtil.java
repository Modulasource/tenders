package org.coin.util;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.Writer;

import javax.servlet.jsp.JspWriter;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.fop.apps.MimeConstants;
import org.w3c.dom.Document;

public abstract class XmlTransformerUtil  {
	
	public static final int FICHIER_TYPE_TEXTE = 1;
	public static final int FICHIER_TYPE_PDF = 2;
	public static final int FICHIER_TYPE_RTF = 3;
	
	public static String xmlToString(Document xmlDoc, String sXsl) throws TransformerException  {

		Writer result = new StringWriter();
	    Source source = new DOMSource(xmlDoc);
	    Result resultat = new StreamResult(result);
	    transform(sXsl,source,resultat);
	 //  	return Outils.getHtmlToText(result.toString().trim());
	   return result.toString();
	}
	

	public static File xmlToFile(
			Document xmlDoc, 
			String sXsl, 
			String sFileName, 
			int iFileType) 
	throws TransformerException, IOException 
	{
		File file = new File(sFileName);
		return xmlToFile(xmlDoc, sXsl, file, iFileType);
	}
	
	public static File xmlToFile(
			Document xmlDoc, 
			Source sourceXsl, 
			String sFileName, 
			int iFileType)
	throws IOException, TransformerException
	{
		File file = new File(sFileName);
		return xmlToFile(xmlDoc, sourceXsl, file, iFileType);
	}
	
	
	
	
	
	
	



	public static File xmlToFile(
			Document xmlDoc, 
			File fileXsl, 
			File fileXml, 
			int iFileType)
	throws IOException, TransformerException
	{
		StreamSource stylesource = new StreamSource(
				FileUtil.convertFileInInputStream(fileXsl));

		return xmlToFile(xmlDoc, stylesource, fileXml, iFileType);
	}
	

	
	
	
	public static File xmlToFile(
			Document xmlDoc, 
			String sXsl, 
			File fileXml, 
			int iFileType) 
	throws TransformerException, IOException 
	{
		StreamSource stylesource = new StreamSource(sXsl);
		return xmlToFile(xmlDoc, stylesource, fileXml, iFileType);
	}
	
	
	


	
	public static File xmlToFile(
			Document xmlDoc, 
			Source sourceXsl, 
			File file, 
			int iFileType)
	throws IOException, TransformerException
	{
		if (file.exists()) file.delete();
		OutputStream out = new java.io.FileOutputStream(file);
	    Source source = new DOMSource(xmlDoc);
	    Result resultat = new StreamResult(out);
	    
	    switch(iFileType)
	    {
	    case FICHIER_TYPE_TEXTE :
	    	transform(sourceXsl,source,resultat);
	    	break;
	    
	    case FICHIER_TYPE_PDF:
	    	transformToPDF(sourceXsl,source,out); 
	    	break;

	    case FICHIER_TYPE_RTF:
	    	transform(sourceXsl,source,out, MimeConstants.MIME_RTF); 
	    	break;
	    	

	    default:
	    	throw new IOException("Le type de fichier que vous souhaitez générer est inconnu.");
	    }
	    
	    out.close();
	    return file;
	}
	

	
	public static void transform(
			Source sourceXsl,
			Source source, 
			OutputStream out,
			String sMimeType) 
	throws IOException {
		FopFactory fopFactory = FopFactory.newInstance(); 
		try {
			Fop fop = fopFactory.newFop(sMimeType, out);
			TransformerFactory factory = TransformerFactory.newInstance();
		    Transformer transformer = factory.newTransformer(sourceXsl);
			Result res = new SAXResult(fop.getDefaultHandler());
			transformer.transform(source, res);
		}catch(Exception e){
			e.printStackTrace();
		} finally {
			out.close();
		}	
	}	
	
	private static void transform(
			String sXsl,
			Source source,
			Result resultat) 
	throws TransformerException{
		StreamSource stylesource = new StreamSource(sXsl);
		transform(stylesource, stylesource, resultat);
		
	}

	private static void transform(
			Source sourceXsl,
			Source source,
			Result resultat) 
	throws TransformerException{
	    TransformerFactory fabriqueT = TransformerFactory.newInstance();
	    Transformer transformer = fabriqueT.newTransformer(sourceXsl);
	    transform(transformer, source, resultat);
	}


	private static void transform(
			Transformer transformer,
			Source source,
			Result resultat) 
	throws TransformerException {
	    transformer.setOutputProperty(OutputKeys.METHOD, "text");
	    transformer.setOutputProperty(OutputKeys.INDENT, "no");
	    transformer.transform(source, resultat);
	}	
	
	
	
	public static void transformToPDF(String sXsl,Source source, OutputStream out)throws IOException {
		StreamSource stylesource = new StreamSource(sXsl);
		transform(stylesource, source, out, MimeConstants.MIME_PDF);
	}	

	public static void transformToPDF(
			Source sourceXsl,
			Source source, 
			OutputStream out) 
	throws IOException {
		transform(sourceXsl, source, out, MimeConstants.MIME_PDF);
	}
	
	


	
	
	
	
	
	
	
	

	/* GENERATION DE XHTML
	 * 
	 */ 
		public static void buildHTML(String xmlPath, String xslPath, OutputStream sortie) throws TransformerException{
		    StreamSource source = new StreamSource(xmlPath);
		    StreamSource stylesource = new StreamSource(xslPath);
		    buildHTML(source,stylesource,sortie);
		}	 
		public static void buildHTML(Document docXml, String xslPath, OutputStream sortie) throws TransformerException{
		    Source source = new DOMSource(docXml);
		    StreamSource stylesource = new StreamSource(xslPath);
		    buildHTML(source,stylesource,sortie);
		}	 
		
		public static void buildHTML(Document docXml, String xslPath, JspWriter sortie) throws TransformerException{
		    Source source = new DOMSource(docXml);
		    StreamSource stylesource = new StreamSource(xslPath);
		    Result resultat = new StreamResult(sortie); 
		    TransformerFactory fabriqueT = TransformerFactory.newInstance();
		    Transformer transformer = fabriqueT.newTransformer(stylesource);
		    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		    transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		    transformer.transform(source, resultat);
		}	 
		
		public static String buildXmlDoc(Document docXml, String xslPath) throws TransformerException{
		    Source source = new DOMSource(docXml);
		    StreamSource stylesource = new StreamSource(xslPath);
			Writer sortie = new StringWriter();
		    Result resultat = new StreamResult(sortie); 
		    TransformerFactory fabriqueT = TransformerFactory.newInstance();
		    Transformer transformer = fabriqueT.newTransformer(stylesource);
		    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		   // transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		    transformer.transform(source, resultat);
		    return sortie.toString();
		}	 
		
		public static void buildXmlDoc(Document docXml, String xslPath, OutputStream out) throws TransformerException{
		    Source source = new DOMSource(docXml);
		    StreamSource stylesource = new StreamSource(xslPath);
			//Writer sortie = new StringWriter();
		    Result resultat = new StreamResult(out); 
		    TransformerFactory fabriqueT = TransformerFactory.newInstance();
		    Transformer transformer = fabriqueT.newTransformer(stylesource);
		    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		   // transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		    transformer.transform(source, resultat);
		 
		}	 
		

		
		public static void buildXmlDoc(
				Document docXml, 
				StreamSource stylesource, 
				OutputStream out) 
		throws TransformerException 
		{
			try {
				Source source = new DOMSource(docXml);
				//Writer sortie = new StringWriter();
				Result resultat = new StreamResult(out); 
				TransformerFactory fabriqueT = TransformerFactory.newInstance();
				Transformer transformer = fabriqueT.newTransformer(stylesource);
				transformer.setOutputProperty(OutputKeys.METHOD, "xml");
				// transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
				transformer.setOutputProperty(OutputKeys.INDENT, "yes");
				transformer.transform(source, resultat);
			} catch (TransformerException e) {
				e.printStackTrace();
				String sErrorMessage = "docXml="+ docXml + e.getMessage();
				throw new TransformerException (sErrorMessage);
			}

		}	
		


		public static void buildHTML(File xmlFile, File xslFile, OutputStream sortie) throws TransformerException{
		    StreamSource source = new StreamSource(xmlFile);
		    StreamSource stylesource = new StreamSource(xslFile);
		    buildHTML(source,stylesource,sortie);
		}	 
		
		public static void buildHTML(Source sourceXml, Source sourceXsl, OutputStream sortie) throws TransformerException{
		    Result resultat = new StreamResult(sortie); 
		    TransformerFactory fabriqueT = TransformerFactory.newInstance();
		    Transformer transformer = fabriqueT.newTransformer(sourceXsl);
		    transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		    transformer.setOutputProperty(OutputKeys.ENCODING, "ISO-8859-1");
		    transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		    transformer.transform(sourceXml, resultat);
		}	 
		

		
	 /* /GENERATION DE XHTML
	 */
 	
}
