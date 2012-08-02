/*
 * Created on 31 déc. 2004
 *
 */
package org.coin.util;

import java.io.*;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.naming.NamingException;

import modula.marche.Marche;
import modula.quark.QuarkTagResumeAnnonce;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.fr.bean.export.Export;
import org.coin.fr.bean.export.PublicationPublissimo;
import org.coin.fr.bean.export.PublicationEmail;

/**
 * @author fkiebel
 *
 * Cette classe contient des méthodes statiques permettant de traiter des fichiers en général
 * (voir des InputStream, OutPutStream, ...)
 */
public class FileUtilitaire {
	/**
	 * Méthode générant le fichier PDF de l'AAPC du marché identifié 
	 * @param iIdMarche - identifiant du marché
	 * @return un File contenant le PDF sinon null
	 * @throws Exception 
	 */
	public static File generatePDFFileFromAAPC(int iIdMarche) throws Exception {

		/* Création du fichier temporaire qui contiendra le PDF */
		File file = File.createTempFile("pdfAAPC" + (new Timestamp(System.currentTimeMillis())).getTime(), ".pdf");
		FileUtil.convertInputStreamInFile(new ByteArrayInputStream(modula.servlet.PDFServletResumeAAPC.generatePDFDocumentBytes(iIdMarche).toByteArray()), file);
		
		return file;
	
	}
	/**
	 * Méthode permettant la génération de l'AATR au format PDF du marché identifié
	 * @param iIdMarche - identifiant du marché
	 * @return un fichier File
	 * @throws Exception 
	 */
	public static File generatePDFFileFromAATR(int iIdMarche) throws Exception {
		/* Création du fichier temporaire qui contiendra le PDF */
		String sFileName ="";
		Marche marche = Marche.getMarche(iIdMarche);
		if(marche.getReferenceExterne().equalsIgnoreCase(null) || marche.getReferenceExterne().equalsIgnoreCase(""))
			sFileName = marche.getReferenceExterne();
		else sFileName = marche.getReference();
		File file = File.createTempFile(sFileName, ".pdf");
		FileUtil.convertInputStreamInFile(new ByteArrayInputStream(modula.servlet.PDFServletResumeAATR.generatePDFDocumentBytes(iIdMarche).toByteArray()), file);
		
		return file;
	}
	
	
	public static File generateQuarkFileFromPublicationPublissimo(
			int iIdPublicationPublissimo, 
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, IOException 
	{
		PublicationPublissimo publicationPublissimo 
			= PublicationPublissimo.getPublicationPublissimo(iIdPublicationPublissimo, conn, false);
		Marche marche = Marche.getMarche(publicationPublissimo.getIdReferenceObjet(), conn, false);
		String sFileName ="";
		//if(marche.getReferenceExterne()!= null || !marche.getReferenceExterne().equalsIgnoreCase(""))
			//sFileName = marche.getReferenceExterne();
		//else
			sFileName = marche.getReference();
		File file = File.createTempFile(sFileName, ".txt");
		Export export = Export.getExport(publicationPublissimo.getIdExport(),conn);
		FileUtil.convertInputStreamInFile(
				QuarkTagResumeAnnonce.makeQuarkTag(
						publicationPublissimo.getTitrePDF(),
						publicationPublissimo.getTetePDF(),
						publicationPublissimo.getCorpsPDF(),
						export.getIdObjetReferenceDestination(),
						conn
						), file); 
		
		return file;
	}
	
	
	public static File generateQuarkFileFromPublicationEmail(
			int iIdPublicationEmail,
			Connection conn) 
	throws CoinDatabaseLoadException, NamingException, SQLException, IOException 
	{
		PublicationEmail publicationEmail = PublicationEmail.getPublicationEmail(iIdPublicationEmail, conn);
		Marche marche = Marche.getMarche(publicationEmail.getIdReferenceObjet(), conn, false);
		String sFileName ="";
		//if(marche.getReferenceExterne()!= null || !marche.getReferenceExterne().equalsIgnoreCase(""))
			//sFileName = marche.getReferenceExterne();
		//else
			sFileName = marche.getReference();
			sFileName = Outils.replaceAll(sFileName,"/","-");
			sFileName = Outils.replaceAll(sFileName,"\\","-");
		File file = File.createTempFile(sFileName, ".quark");
		Export export = Export.getExport(publicationEmail.getIdExport(), conn);
		FileUtil.convertInputStreamInFile(
				QuarkTagResumeAnnonce.makeQuarkTag(publicationEmail.getTitrePDF(),
				publicationEmail.getTetePDF(),
				publicationEmail.getCorpsPDF(),
				export.getIdObjetReferenceDestination(),
				conn), file); 
		
		return file;
	}
	
	
}
