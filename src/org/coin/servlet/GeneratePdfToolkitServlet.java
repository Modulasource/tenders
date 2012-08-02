package org.coin.servlet;


import java.io.File;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.SQLException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.coin.bean.ObjectType;
import org.coin.bean.User;
import org.coin.db.ConnectionManager;
import org.coin.db.InputStreamDownloader;
import org.coin.fr.bean.Multimedia;
import org.coin.fr.bean.MultimediaType;
import org.coin.signature.sspv.impl.pdf.pdfbox.shape.SSPVPdfBoxImageShape;
import org.coin.util.HttpUtil;
import org.coin.util.pdf.PdfTransformation;


public class GeneratePdfToolkitServlet extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	public void doGet (HttpServletRequest request, HttpServletResponse response)
	{
		doPost(request, response);
	}

	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		HttpServletRequest hsrRequest = (HttpServletRequest)request;
		HttpSession hsSession = hsrRequest.getSession();
		Connection conn = null;
		String sDisposition = HttpUtil.parseString("sContentDisposition", request, "attachement" ) + ";";
		User uUserSession = (User) hsSession.getAttribute("sessionUser");
		
		try 
		{
			conn = ConnectionManager.getConnection();

			PdfTransformation transformation = new PdfTransformation();
			transformation.updateEncoding(conn);
			
			
			String sContentType = "application/pdf";
			response.setContentType(sContentType);
			String sFilenameOut = "generate_" + System.currentTimeMillis() + ".pdf";
			response.setHeader("Content-Disposition", sDisposition+" filename=\"" + sFilenameOut+"\"");
			
			// TODO response.addHeader("length-file",sContentLength);
			
			transformation.prepare(request);
			
			InputStreamDownloader isdImageSignature =null;
			if(uUserSession != null && uUserSession.getId() > 0)
			{
				Multimedia multimedia 
					= Multimedia.getMultimediaFirstOccurence(
						MultimediaType.TYPE_SCANNED_SIGNATURE, 
						uUserSession.getIdIndividual(), 
						ObjectType.PERSONNE_PHYSIQUE, conn);
				
				/*
				isdImageSignature = multimedia.getInputStreamDownloaderMultimediaFile(conn);
				transformation.isImage = isdImageSignature.is;
				transformation.sImageFilename = new File(multimedia.getFileName()).getName();
				*/
				
	    		/**
	    		 * add the scanned signature
	    		 */
	    		SSPVPdfBoxImageShape scannedSignature = new SSPVPdfBoxImageShape();
	    		scannedSignature.setName("scanned signature " );
	    		scannedSignature.fileImage = new File(multimedia.getFileName());
	    		scannedSignature.setPageNumberList(0 );
	    		scannedSignature.loadFileImage(multimedia.getInputStreamDownloaderMultimediaFile(conn).is);
	    		scannedSignature.dImageRatio = transformation.fRatioImageSignature;
	    		
	    		transformation.vSSPVImageShape.add(scannedSignature);
	    		transformation.bSetScanSign = true;
				
			} else {
				
			}	

			
			OutputStream out = response.getOutputStream();
			
			transformation.transform();
			
			transformation.document.save(out);
			transformation.document.close();
				
				
			out.flush();
			out.close();
			
			if(isdImageSignature != null) isdImageSignature.close();
		
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		try {
			ConnectionManager.closeConnection(conn);
		} catch (SQLException e) { }
		
	}

}
