package org.coin.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import javax.activation.MimetypesFileTypeMap;

import net.sf.jmimemagic.Magic;
import net.sf.jmimemagic.MagicException;
import net.sf.jmimemagic.MagicMatchNotFoundException;
import net.sf.jmimemagic.MagicParseException;

import org.apache.commons.io.filefilter.WildcardFileFilter;


public class FileUtil extends FileUtilHttpClientBasic {
	

	
	/**
	 * @see http://www.therightstuff.de/2006/12/16/Office+2007+File+Icons+For+Windows+SharePoint+Services+20+And+SharePoint+Portal+Server+2003.aspx
	 * @see http://www.webmaster-toolkit.com/mime-types.shtml
	 * 
	 * @param sFilename
	 * @return
	 * @throws IOException
	 * @throws MagicParseException
	 * @throws MagicMatchNotFoundException
	 */
	public static String getMimeType(String sFilename)
	throws IOException {

		String fileTypeName = null;

		String sFileExtention = FileUtilBasic.getExtension(sFilename);
		if(sFileExtention.equalsIgnoreCase("doc")) fileTypeName="application/msword";
		else if(sFileExtention.equalsIgnoreCase("docm")) fileTypeName="application/vnd.ms-word.document.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("docx")) fileTypeName="application/vnd.openxmlformats-officedocument.wordprocessingml.document";
		else if(sFileExtention.equalsIgnoreCase("dotm")) fileTypeName="application/vnd.ms-word.template.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("dotx")) fileTypeName="application/vnd.openxmlformats-officedocument.wordprocessingml.template";
		else if(sFileExtention.equalsIgnoreCase("potm")) fileTypeName="application/vnd.ms-powerpoint.template.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("potx")) fileTypeName="application/vnd.openxmlformats-officedocument.presentationml.template";
		else if(sFileExtention.equalsIgnoreCase("ppam")) fileTypeName="application/vnd.ms-powerpoint.addin.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("ppsm")) fileTypeName="application/vnd.ms-powerpoint.slideshow.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("ppsx")) fileTypeName="application/vnd.openxmlformats-officedocument.presentationml.slideshow";
		else if(sFileExtention.equalsIgnoreCase("pptm")) fileTypeName="application/vnd.ms-powerpoint.presentation.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("pptx")) fileTypeName="application/vnd.openxmlformats-officedocument.presentationml.presentation";
		else if(sFileExtention.equalsIgnoreCase("xlam")) fileTypeName="application/vnd.ms-excel.addin.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("xlsb")) fileTypeName="application/vnd.ms-excel.sheet.binary.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("xlsm")) fileTypeName="application/vnd.ms-excel.sheet.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("xlsx")) fileTypeName="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
		else if(sFileExtention.equalsIgnoreCase("xltm")) fileTypeName="application/vnd.ms-excel.template.macroEnabled.12";
		else if(sFileExtention.equalsIgnoreCase("xltx")) fileTypeName="application/vnd.openxmlformats-officedocument.spreadsheetml.template";


		else if(sFileExtention.equalsIgnoreCase("xml")) fileTypeName="text/xml";
		else if(sFileExtention.equalsIgnoreCase("txt")) fileTypeName="text/plain";
		else if(sFileExtention.equalsIgnoreCase("html")) fileTypeName="text/html";
		else if(sFileExtention.equalsIgnoreCase("p12")) fileTypeName="application/x-pkcs12";
		else if(sFileExtention.equalsIgnoreCase("crt")) fileTypeName="application/pkix-cert";

		else if(sFileExtention.equalsIgnoreCase("png")) fileTypeName="image/png ";
		else if(sFileExtention.equalsIgnoreCase("bmp")) fileTypeName="image/bmp ";
		
		else if(sFileExtention.equalsIgnoreCase("pdf")) fileTypeName="application/pdf";

		if(fileTypeName != null) return fileTypeName;
		
		return new MimetypesFileTypeMap().getContentType(sFilename) ;
	}	

	public static String getMimeType(BufferedInputStream bis)
	throws IOException, MagicParseException, MagicMatchNotFoundException, MagicException {
		bis.mark(Integer.MAX_VALUE);
		byte[]header = new byte[7];
		bis.read(header, 0, 7);
		bis.reset();
		return Magic.getMagicMatch(header).getMimeType();
	}

	

	public static void copyDirectory(
			File sourceLocation , 
			File targetLocation,
			boolean bRecursive)
	throws IOException
	{

		System.out.println("copyDirectory " + sourceLocation + " > " + targetLocation);
		if (sourceLocation.isDirectory()) {
			/**
			 * Directory case
			 */
			if ( targetLocation.isDirectory()
				&& !targetLocation.exists() )
			{
				targetLocation.mkdirs();
			}

			String[] children = sourceLocation.list();
			for (int i=0; i<children.length; i++) {
				File fileSourceChild = new File(sourceLocation, children[i]);
				File fileTargetChild = new File(targetLocation, children[i]);
				if(fileSourceChild.isDirectory())
				{
					System.out.println("bRecursive : " + bRecursive);
					if(!bRecursive) continue;

					fileTargetChild.mkdirs();
				}
				copyDirectory(
						new File(sourceLocation, children[i]),
						new File(targetLocation, children[i]),
						bRecursive);
			}
		} else {
			/**
			 * File or wildcard case
			 */

			File filePath = getPathFromWildcard(sourceLocation);
			String sFilter = getFilterFromWildcard(sourceLocation);
			FileFilter  wcf = new WildcardFileFilter(sFilter);
			File[] files = filePath.listFiles(wcf);
			File fileSubTargetLocation = getPathFromWildcard(targetLocation);
			
			/**
			 * if it's file to file copy
			 */
			if(files == null || sourceLocation.isFile()){

				files = new File[1];
				files[0] = sourceLocation;
			} 

			for (File file : files) {
				
				
				System.out.println("file : " + file);
				if (file.isDirectory()) {
					if(!bRecursive) continue;

					if(!file.equals(targetLocation))
					{
						File fileSubPath = new File(fileSubTargetLocation.getAbsolutePath() +  "/" + file.getName());
						fileSubPath.mkdirs();
						copyDirectory(file, fileSubPath , bRecursive);
					}
				} else {
					
					File fileOut = null;

					/**
					 * prepare destination path 
					 */
					if(sourceLocation.isFile()
					&& sourceLocation.getName().equals(targetLocation.getName()))
					{
						/**
						 * file to file copy
						 */
						fileOut = targetLocation;
					} else {
						fileOut = new File(
								fileSubTargetLocation.getAbsolutePath()
								+ "/" + file.getName());
					}
					
					if(!fileSubTargetLocation.exists()
					&& !fileSubTargetLocation.getName().equals(sourceLocation.getName()))
					{
						fileSubTargetLocation.mkdirs();
					}
					
					
					/**
					 * Copy the bits from instream to outstream
					 */
					InputStream in = new BufferedInputStream( new FileInputStream(file));
					OutputStream out 
						=  new BufferedOutputStream(
								new FileOutputStream(fileOut) );

					byte[] buf = new byte[1024 * 64];
					int len;
					while ((len = in.read(buf)) > 0) {
						out.write(buf, 0, len);
					}
					in.close();
					out.close();
				}
			
			}
		}
	}

	public static void copyDirectory(
			String sSourceLocation , 
			String sTargetLocation)
	throws IOException {
		copyDirectory(
				new File(sSourceLocation), 
				new File(sTargetLocation),
				false);
	}

	public static void copyDirectory(
			String sSourceLocation , 
			String sTargetLocation,
			boolean bRecursive)
	throws IOException {
		copyDirectory(
				new File(sSourceLocation), 
				new File(sTargetLocation),
				bRecursive);
	}

}
