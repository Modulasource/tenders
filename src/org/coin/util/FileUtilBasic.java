/*
 * Created on 31 déc. 2004
 *
 */
package org.coin.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.Authenticator;
import java.net.ConnectException;
import java.net.HttpURLConnection;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLConnection;
import java.security.AccessController;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;


import sun.misc.BASE64Decoder;
import sun.misc.BASE64Encoder;
import sun.security.action.GetPropertyAction;

/**
 * basic class without using additionnal lib (mandatory for applet like JavaLibInstallationApplet.java
 */
public class FileUtilBasic {

	final static int BUFFER_SIZE = 2048;

	public static String cleanFileName(String sFileName){
		String s = StringUtilBasic.stripAccents(sFileName.toLowerCase().replaceAll(" ","_"), true);
		/**
		 * due to encoding pb you can have filename un GED like	"Lettre demande facture d?mat?rialis?e.pdf"
		 */
		return StringUtilBasic.replaceAll(s, "?", "_");
	}
	

	public static String cleanUpFileName(String sFileName) {
		
		String s = StringUtilBasic.replaceAll(sFileName, "\\", "_");
		s = StringUtilBasic.replaceAll(s, "/", "_");
		s = StringUtilBasic.replaceAll(s, ":", "_");
		s = StringUtilBasic.replaceAll(s, "*", "_");
		s = StringUtilBasic.replaceAll(s, "?", "_");
		s = StringUtilBasic.replaceAll(s, "\"", "_");
		s = StringUtilBasic.replaceAll(s, "<", "_");
		s = StringUtilBasic.replaceAll(s, ">", "_");
		s = StringUtilBasic.replaceAll(s, "|", "_");

		return s;
	}
	
	/**
     * IE doesn't follow the RFC and sends file names as complete paths.
     * This method trims it back to the file name (as it is supposed to be).
     */
    public static String getBasename(String name) {
        // We look for the last '\\' or '/'
        name = name.replace('\\', '/');
        int index = name.lastIndexOf('/');
        if (index >= 0) {
            return name.substring(index+1);
        }
        return name;
    }

	
	/**
	 * 
	 * if we have "bcmail-jdk16-[140].jar;" 
	 * then we are looking for version >= 140
	 * 
	 * @param sFilename
	 * @param sPath
	 * @return
	 */
	public static boolean isLibExists(
			String sFilename,
			String sPath)
	{ 
		if(sFilename.contains("["))
		{
			boolean bLibFound = false;
			int iSearchRange = 100;
			int iVersionStart = Integer.parseInt(StringUtilBasic.getTextBetweenOptional(sFilename, "[", "]"));
			for (int i = iVersionStart; i < iVersionStart + iSearchRange; i++) 
			{
				File file = new File(
						sPath
						+ StringUtilBasic.replaceAll(
								sFilename, 
								"[" + iVersionStart + "]", 
								"" + i) );
				
				System.out.println("check if exists : " + file);
				if(file.exists()) 
				{
					bLibFound = true;
					break;
				}
			}
			if(!bLibFound)
			{
				System.out.println("Error lib required : " + sFilename + sFilename);
				return false;
			}
		} else {
			File file = new File(sPath + sFilename);
			if(! file .exists()) {
				System.out.println("Error lib required : " + file.getAbsolutePath());
				return false;
			}
		}
		return true;
	}	


	
	static public final Vector<File> unzip(
			File file, 
			String destinationPath,
            boolean force) 
	throws IOException 
	{
		System.out.println("destinationPath: " + destinationPath);
		
		Vector<File> vFile = new Vector<File>();
        ZipFile zipfile = new ZipFile(file);
        byte[] buf = new byte[BUFFER_SIZE];
        FileInputStream fis = new FileInputStream(zipfile.getName());
        BufferedInputStream bis = new BufferedInputStream(fis);
        ZipInputStream zis = new ZipInputStream(bis);
        ZipEntry entry = null;
        try {
            while ((entry = zis.getNextEntry()) != null) {
                File f = new File(destinationPath + File.separatorChar
                        + entry.getName());
                
                if (entry.isDirectory()) {
                    System.out.println(entry.getName());
                    File parent = new File(entry.getName()).getParentFile();
                    if(parent != null) parent.mkdir();
                    continue;
                }
                
                if (f.exists()) {
                    if (force) {
                        f.delete();
                    } else {
                        continue;
                    }
                }


                 // create the destination path, if needed  
                String parent = f.getParent();  
                if (parent!=null)  
                {  
                	System.out.println("parent: " + parent);
                	File parentFile = new File(parent);  
	                if (!parentFile.exists())  
	                {  
	                	System.out.println("parentFile: " + parentFile);
	                	// create the chain of subdirs to the file  
	                	parentFile.mkdirs();  
	                }  
                }  
                
                System.out.println("f : " + f);
                f.createNewFile();
                FileOutputStream fos = new FileOutputStream(f);
                BufferedOutputStream bos = new BufferedOutputStream(fos,
                        BUFFER_SIZE);
                int nbRead;
                try {
                    while ((nbRead = zis.read(buf)) > 0) {
                        bos.write(buf, 0, nbRead);
                    }
                } finally {
                    bos.flush();
                    bos.close();
                    fos.close();
                }
                vFile.add(f);
            }
        } finally {
            zis.close();
            bis.close();
            fis.close();
        }
        
        return vFile;
    }
	

	public static void write(InputStream in, OutputStream out)
	throws FileNotFoundException, IOException {
		InputStream bin = null;
		try {
			bin = new BufferedInputStream(in);
			byte[  ] buf = new byte[4 * 1024 * 1024];  // 4M buffer
			int bytesRead;
			while ((bytesRead = bin.read(buf)) != -1) {
				out.write(buf, 0, bytesRead);
			}
		}
		finally {
			if (in != null) in.close(  );
		}
	}
	
	
	/**
	 * 
	 * 
	 * 
	 *  System.out.println("Match number "+count);
	    System.out.println("start(): "+m.start());
	    System.out.println("end(): "+m.end());
	    System.out.println("str : "+s.substring(m.start(), m.end()) );

	 * 
	 * @param sFileIn
	 * @param sFileOut
	 * @throws IOException
	 */
	public static void rewriteXML(
			String sFileIn,
			String sFileOut)
	throws IOException 
	{
		rewriteXML(new File(sFileIn), new File(sFileOut));
	}
	
	public static void rewriteXML(
			File fileIn,
			File fileOut)
	throws IOException 
	{
		
		/**
		 * Load XML
		 */
		FileReader rd = new FileReader(fileIn);
		char[] buf = new char[(int)fileIn.length()];
		rd.read(buf);
		rd.close();
		String s = new String(buf);
		
		// can read 2Gb text file
		//   21340887
		// 2147483647
		System.out.println("s : " + s.length());
		System.out.println("max : " + Integer.MAX_VALUE);
		

		
		StringBuilder sbFilter = new StringBuilder(s);
		for (int i = 0; i < sbFilter.length(); i++) {
			char c = sbFilter.charAt(i);
			if ((byte)c == (byte)0x4) {
				/**
				 * SYSTEM CODE to remove , like 0x4 END LINE
				 */
				sbFilter.setCharAt(i, ' ');
			}
		}
		

		
		/**
		 * Parse XML end tag </xxx>
		 * and add a LINE FEED
		 */
		Pattern pattern = Pattern.compile("<\\/[^>]+>");
		Matcher m = pattern.matcher(sbFilter.toString());
		StringBuilder sb = new StringBuilder();
		int iLastReadIn = 0;
		
		//int count = 0;
		while(m.find()) {
	        sb.append(sbFilter.substring(iLastReadIn , m.end() ));
	        sb.append("\n");
	        iLastReadIn = m.end();
	        
	        //if(count > 100) break;
		}		

		/**
		 * Write the output XML
		 */
		FileWriter fw = new FileWriter(fileOut);
		fw.write(sb.toString());
		fw.close();
	}

	
	public static String getTempDir() 
	{
		String tmpdir;
	    GetPropertyAction a = new GetPropertyAction("java.io.tmpdir");
	    tmpdir = ((String) AccessController.doPrivileged(a));
        return tmpdir;
    }
	
	public static File getTempDirFile() 
	{
		return new File(getTempDir());
    }

	public static File getTempDirFile(
			String sSubDir) 
	{
		File f = new File(getTempDir() + File.separatorChar + sSubDir);
		f.mkdirs();
		return f;
    }
	
	public static File getTempFile(
			String sFilename, 
			String sSubDir) 
	throws IOException 
	{
		String sFileSeparator = System.getProperty("file.separator");
		String sTempDir = getTempDir();
		if(sTempDir.endsWith("/") || sTempDir.endsWith("\\") )
		{
			sTempDir.substring(0, sTempDir.length() - 1);
		}
		File fileTempDir = new File(sTempDir + sFileSeparator + sSubDir  );
		fileTempDir.mkdirs();
		
		
		/* System.out.println("sFilename : " + sFilename); */
		
		if(sFilename == null || sFilename.equals("")){
			//sFilename = "warning_no_name_" + System.currentTimeMillis();
			throw new IOException("Filename is empty");
		}
		File f = new File( fileTempDir.getAbsolutePath() + sFileSeparator + sFilename);
		
		/* System.out.println("f temp : " + f.getAbsolutePath() + " subdir : " + sSubDir); */
		
		return f;
		
    }
	
	
	public static double getOccupationPercent(
			File file) 
	{

		double dCurrentOccupation = 0;
		if(file.getTotalSpace() > 0){
			dCurrentOccupation = (file.getFreeSpace() * 100) / file.getTotalSpace();
		}
		
		return dCurrentOccupation;
	}
	
	public static String getDiskSpaceString(
			String sPartition) 
	{
		String sMessage = "";

		String[] sarrPartition = sPartition.split(";");
		for (int i = 0; i < sarrPartition.length; i++) {
			String part = sarrPartition[i];
			File file = new File(part);
			
			
			sMessage += "part " + file.getAbsolutePath() 
			+ "\ttotal: " +  file.getTotalSpace()  
			+ "\tfree: "  +  file.getFreeSpace() 
			+ "\t% occupation : "  + getOccupationPercent(file) + "\n"
			;
		}

		return sMessage;
	}

	public static String getPartitions() 
	{
		File[] roots = File.listRoots();

		if(roots[0].getAbsolutePath().equals("/"))
		{
			// unix system
			File ff = new File("/dev");
			roots = ff.listFiles();
			roots = new File[]{ new File("/"), new File("/boot") , new File("/dev/shm"), new File("/usr/local")};
		}

		String sPartition = "";
		for(int i = 0; i< roots.length -1 ; i++)
		{
			sPartition += roots[i].getAbsolutePath() + ";"; 
		}
		sPartition += roots[roots.length -1].getAbsolutePath();
		
		return sPartition;
	}
	
	/**
	 * on a aussi  
	 * 
	 * df -H 
	 * fdisk -l | grep Disk 
	 * fdisk -l | grep Disque 
	 * 
	 * @param iOccupationMaximum
	 * @param sPartition
	 * @return
	 * @throws IOException 
	 */
	public static void  controlPartitions(
			int iOccupationMaximum,
			String sPartition) 
	throws IOException 
	{
		
		String[] sarrPartition = sPartition.split(";");
		for (int i = 0; i < sarrPartition.length; i++) {
			String part = sarrPartition[i];
			File file = new File(part);
			try{
				controlPartition(iOccupationMaximum, file);
			} catch (IOException e) {
				throw new IOException(e.getMessage() 
						+ "\ndisk info :\n" 
						+ getDiskSpaceString(sPartition));
			}
		}
		
	}
	
	public static void  controlPartition(
			int iOccupationMaximum,
			File partition) 
	throws IOException 
	{
		
		double dCurrentOccupation = getOccupationPercent(partition);
		if(dCurrentOccupation > iOccupationMaximum){
			throw new IOException (
					"Warning occupation quota exceed : " 
					+ dCurrentOccupation + "% > " + iOccupationMaximum + " % "
					+ " on partition " + partition.getAbsolutePath() + "\n" );
		}
	}
	

	public static boolean testProxyURLConnection(
			String url, 
			String sMessage)
	{
		return testProxyURLConnection(url, sMessage, true);
	}

	public static void setProxyParam(
			Proxy proxy,
			String sUsername,
			String sPassword)
	{
		InetSocketAddress addr = (InetSocketAddress) proxy.address();

		if(addr == null) {
			return;
		} 

		Properties sysProps = System.getProperties();
		sysProps.put( "proxySet", "true" );
		sysProps.put( "proxyHost", addr.getHostName());
		sysProps.put( "proxyPort", addr.getPort());

		if(sUsername != null && sPassword != null)
		{
			Authenticator authenticator = new CoinAuthenticator(sUsername, sPassword);
			Authenticator.setDefault(authenticator);	
		}
		
	}

	public static boolean testProxyURLConnection(
			String url, 
			String sMessage,
			boolean bDefaultAllowUserInteraction)
	{
		return testProxyURLConnection(url, sMessage, bDefaultAllowUserInteraction, null, null, null);
	}
	
	public static boolean testProxyURLConnection(
			String url, 
			String sMessage,
			boolean bDefaultAllowUserInteraction,
			Proxy proxy,
			String sProxyUsername,
			String sProxyPassword)
	{
		URLConnection.setDefaultAllowUserInteraction(bDefaultAllowUserInteraction);
		
		HttpURLConnection urlCon = null;
		try
		{
			
			
			URL destinationWithParam = new URL(url);
			if(proxy != null){
				urlCon = (HttpURLConnection)destinationWithParam.openConnection(proxy);
				setProxyParam(proxy, sProxyUsername, sProxyPassword);
			} else {
				urlCon = (HttpURLConnection)destinationWithParam.openConnection();
			}
			urlCon.setRequestMethod("POST");
			urlCon.setDoInput(true);
			urlCon.setDoOutput(true);
			urlCon.setUseCaches(false);
			urlCon.setRequestProperty("Content-Type", "application/zip");
			urlCon.connect();
			OutputStream outServer = urlCon.getOutputStream();
			InputStream inClient = new ByteArrayInputStream(sMessage.getBytes());
			byte buffer[] = new byte[1024];
			int nb;
			while((nb = inClient.read(buffer)) != -1) 
				outServer.write(buffer, 0, nb);
			inClient.close();
			outServer.close();
			InputStream inServer = urlCon.getInputStream();
			StringBuffer sb = new StringBuffer(sMessage.length());
			while((nb = inServer.read(buffer)) != -1) 
				sb.append(new String(buffer, 0, nb));
			inServer.close();
			urlCon.getResponseCode();
			urlCon.disconnect();

			// ADDED by DK 
			System.out.println("chaineEnvoyee : " + sMessage);
			System.out.println("chaine recue : " + sb.toString());


			if(sb.toString().equals(sMessage))
				return true;
			System.out.println("ERROR : " + sb.toString());
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return false;
		}
		return false;
	}

	public static Proxy getDefaultProxy(
			String sTargetURL) 
	{
		
		
		/*
		* network.proxy.type:
		*    null  Direct connection (no proxy)
		*    1     Manual proxy configuration
		*    2     Automatic proxy configuration
		*/

		System.out.println("network.proxy.type : " + System.getProperty("network.proxy.type")); 
		System.setProperty("java.net.useSystemProxies","true");
		
		Proxy proxy = null;
		
		List<Proxy> l = null;
		try {
			l = ProxySelector.getDefault().select( new URI(sTargetURL));

			System.out.println("List proxies");
			for (Iterator<Proxy> iter = l.iterator(); iter.hasNext(); ) {
				proxy = (Proxy) iter.next();
				System.out.println("proxy type : " + proxy.type());
				InetSocketAddress addr = (InetSocketAddress) proxy.address();

				if(addr == null) {
					System.out.println("No Proxy");
				} else {
					System.out.println("proxy hostname : " + addr.getHostName());
					System.out.println("proxy port : " + addr.getPort());
					System.out.println("End List proxies");
					return proxy;
				}
			}

		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		
		System.out.println("End List proxies");
		return proxy;
		
	}
	

	/*
	 * ne pas utiliser pour le moment
	public static String getMimeType(File file)
	throws IOException, MagicParseException, MagicMatchNotFoundException {


		
		return new MimetypesFileTypeMap().getContentType(file) ;
		//return Magic.getMagicMatch(file,true).getMimeType();
	}*/	

	

	public static boolean isVistaVirtualFile(
			File file)
	throws IOException
	{
		File vista = getVistaVirtualFile(file);
		return vista.exists();
	}

	public static File getVistaVirtualFile(
			File file)
	throws IOException
	{
		String sUserHome = System.getProperty("user.home");
		String sVistaVirtualFile = sUserHome 
		+ "\\AppData\\Local\\VirtualStore\\"
		+  file.getAbsolutePath().substring(3)  // pour supprimer le "C:\\"
		;

		return new File(sVistaVirtualFile);
	}


	public static File decodeBase64TempFile(
			String docBase64EncodedFile,
			String sExtention)
	throws IOException
	{
		File file = File.createTempFile("pdf_", sExtention);
		return  decodeBase64File(file, docBase64EncodedFile);
	}

	public static File decodeBase64TempFile(
			String docBase64EncodedFile)
	throws IOException
	{
		File file = File.createTempFile("pdf_", ".tmp");
		return  decodeBase64File(file, docBase64EncodedFile);
	}

	public static File decodeBase64File(
			String sFileName,
			String docBase64EncodedFile) 
	throws IOException
	{
		File file = new File (sFileName);
		return decodeBase64File(file, docBase64EncodedFile);
	}

	public static File decodeBase64File(
			File file ,
			String docBase64EncodedFile) 
	throws IOException
	{
		FileOutputStream fos = new FileOutputStream(file);
		BASE64Decoder decoder = new BASE64Decoder();
		fos.write( decoder.decodeBuffer(docBase64EncodedFile)) ;

		fos.flush();
		fos.close();

		return file;
	}
	
//	public static File decodeBase64File(
//			File file ,
//			byte[] docBase64EncodedFile) 
//	throws IOException
//	{
//		FileOutputStream fos = new FileOutputStream(file);
//		//BASE64Decoder decoder = new BASE64Decoder();
//		fos.write(Base64.decode(docBase64EncodedFile));
//		//fos.write( decoder.decodeBuffer(docBase64EncodedFile)) ;
//
//		fos.flush();
//		fos.close();
//
//		return file;
//	}
	
	
	public static String encodeBase64FromFile(
			String sFilename) throws IOException
	{
		return  encodeBase64FromFile( new File(sFilename) );
	}

	public static String encodeBase64FromFile(
			File file) throws IOException
	{
		BASE64Encoder encoder = new BASE64Encoder();
		return  encoder.encode(getBytesFromFile(file) );
	}

	static public boolean deleteDirectory(String sPath) {
		return  deleteDirectory(new File (sPath) );
	}


	static public boolean deleteDirectory(File path) {
		if( path.exists() ) {
			File[] files = path.listFiles();
			for(int i=0; i<files.length; i++) {
				if(files[i].isDirectory()) {
					deleteDirectory(files[i]);
				}
				else {
					files[i].delete();
				}
			}
		}
		return( path.delete() );
	}

	
	static public String getContentFromUrl(
			String sUrl)
	throws IOException
	{
		URL fileURL = new URL(sUrl); 
		URLConnection urlConnection = fileURL.openConnection();     
		InputStream is = urlConnection.getInputStream();  
		String  s = FileUtilBasic.convertInputStreamInString(is);
		is.close();
		
		return s;
	}

	/**
	 * Méthode permettant de convertir un flux InputStream en File
	 * @param in - flux InputStream
	 * @param file - fichier de sortie
	 * @throws IOException 
	 */
	public static void convertInputStreamInFile(InputStream in, File file) throws IOException {
		convertInputStreamInFile(in, 
				file,
				2*1024*1024);
	}

	public static void convertInputStreamInFile(
			InputStream in, 
			File file,
			int iBufferSize) 
	throws IOException {
		OutputStream fos = new BufferedOutputStream( new FileOutputStream(file));
		byte[] buffer = new byte[iBufferSize]; 
		int read = 0;

		while((read = in.read(buffer)) > 0) {
			fos.write(buffer, 0, read);
		}
		fos.close();
	}

	public static String convertInputStreamInString(
			InputStream in,
			String sCharsetName)
	throws IOException {
		return convertInputStreamInString(
				in, 
				20*1024,
				sCharsetName);
	}

	public static String convertInputStreamInString(InputStream in)
	throws IOException {
		return convertInputStreamInString(in, 
				20*1024);
	}

	public static String convertInputStreamInString(
			InputStream in, 
			int iBufferSize) 
	throws IOException {
		return convertInputStreamInString(in, iBufferSize, null);
	}

	public static String convertInputStreamInString(
			InputStream in, 
			int iBufferSize,
			String sCharsetName) 
	throws IOException {
		StringBuffer sbText = new StringBuffer();
		byte[] buffer = new byte[iBufferSize]; 

		int read = 0;
		while((read = in.read(buffer)) > 0) {
			if(sCharsetName == null) sbText.append(new String (buffer,0,read));
			else sbText.append(new String (buffer,0,read, sCharsetName));
		}
		return sbText.toString();
	}


	public static void convertInputStreamInFileWithConsole(
			InputStream in, 
			File file,
			int iBufferSize) throws IOException {
		/* Création d'un flux de sortie dirigé vers le fichier indiqué */
		FileOutputStream fos = new FileOutputStream(file);
		byte[] buffer = new byte[iBufferSize]; 
		int read = 0;
		long lReaded = 0;
		/* Lecture/Ecriture du fichier tant que EOF n'est pas trouvé */
		while((read = in.read(buffer)) > 0) {
			fos.write(buffer, 0, read);
			lReaded += iBufferSize / 1024;
			System.out.println("readed : " + lReaded);
		}
		/* Fermeture du flux de sortie */
		fos.close();
	}

	public static InputStream convertFileInInputStream(File file) throws IOException {
		InputStream fis = new FileInputStream(file);
		return fis;
	}

	/**
	 * Méthode permettant de supprimer le fichier indiqué
	 * @param file - fichier à supprimer
	 * @return true si réussi sinon false
	 */
	public static boolean deleteFileFromSystem(File file) {
		return file.delete();

	}
	
	public static boolean deleteFileWithoutException(String sAbsoluteFilename) {
		try{
			File file = new File(sAbsoluteFilename);
			return file.delete();
		} catch (Exception e) {
		}
		return false;
	}
	
	public static boolean deleteFileWithoutException(File fileIn, String sSuffix) {
		try{
			File file = new File(fileIn.getAbsolutePath() + sSuffix);
			return file.delete();
		} catch (Exception e) {
		}
		return false;
	}


	public static String changeExtension(String originalName, String newExtension) {
		int lastDot = originalName.lastIndexOf(".");
		if (lastDot != -1) {
			return originalName.substring(0, lastDot) + newExtension;
		} else {
			return originalName + newExtension;
		}
	}

	public static String appendTextBeforeFileExtension(String originalName, String sText) {
		return changeExtension(originalName , "")
		+ sText + "." + FileUtilBasic.getExtension(originalName);
	}

	public static String getExtension(File file) {
		return getExtension(file.getName());
	}
	
	public static String getExtension(String sFilename) 
	{

		String sExtension = "";
		int i = sFilename.length();
		String sCaractere = "";
		while( (i>0) && (!sCaractere.equalsIgnoreCase(".")) ) {
			i--;
			sCaractere = ""+sFilename.charAt(i);
		}
		sExtension = sFilename.substring(i+1);
		return sExtension;
	}

	public static void listeRepertoire ( File repertoire ) {
		if ( repertoire.isDirectory ( ) ) {
			File[] list = repertoire.listFiles();
			for ( int i = 0; i < list.length; i++) {
				// Appel récursif sur les sous-répertoires
				listeRepertoire( list[i]);
			} 
		} 
	}

	/** copie le fichier source dans le fichier resultat
	 * retourne vrai si cela réussit
	 * @throws FileNotFoundException 
	 */
	public static boolean copier( File source, File destination ) 
	throws IOException
	{
		boolean resultat = false;
		FileInputStream sourceFile=null;
		FileOutputStream destinationFile=null;
		try {
			destination.createNewFile();
			sourceFile = new FileInputStream(source);
			destinationFile = new FileOutputStream(destination);
			byte buffer[]=new byte[512*1024];
			int nbLecture;
			while( (nbLecture = sourceFile.read(buffer)) != -1 ) {
				destinationFile.write(buffer, 0, nbLecture);
			} 
			resultat = true;
		}  finally {
			try {
				sourceFile.close();
			} catch(Exception e) { }
			try {
				destinationFile.close();
			} catch(Exception e) { }
		} 
		return  resultat ;
	}

	public static boolean deplacer(File source,File destination)
	throws IOException {
		if( !destination.exists() ) {
			// On essaye avec renameTo
			boolean result = source.renameTo(destination);
			if( !result ) {
				// On essaye de copier
				result = true;
				result &= copier(source,destination);
				result &= source.delete();
			} return(result);
		} else {
			// Si le fichier destination existe, on annule ...
			return false;
		} 
	}
	

	public static File getPathFromWildcard(
			File file)
	throws IOException {
		String[] sWildcard = file.getAbsolutePath().split("\\*");
		return new File(sWildcard[0]);
		
	}

	public static String getFilterFromWildcard(
			File file)
	throws IOException {
		String[] sWildcard = file.getAbsolutePath().split("\\*");
		String sFilter = "";
		for (int i = 1; i < sWildcard.length; i++) {
			sFilter += "*" + sWildcard[i];
		}
		
		if(file.getAbsolutePath().endsWith("*"))
		{
			sFilter += "*";
		}
		
		return sFilter;
	}

	

	public static byte[] getBytesFromFile(String sFilename) throws IOException {
		return getBytesFromFile(new File(sFilename));
	}




	public static byte[] getBytesFromFile(File file) throws IOException {
		InputStream is = new BufferedInputStream(new FileInputStream(file));

		long length = file.length();
		if (length > Integer.MAX_VALUE) {
			throw new IOException("File is too large " + file); 
		}

		byte[] bytes = new byte[(int)length];

		// Read in the bytes
		int offset = 0;
		int numRead = 0;
		while (offset < bytes.length
				&& (numRead=is.read(bytes, offset, bytes.length-offset)) >= 0) {
			offset += numRead;
		}

		if (offset < bytes.length) {
			throw new IOException("Could not completely read file "+file.getName());
		}

		is.close();
		return bytes;
	}

	public static void writeFileWithData(
			String sFileCompletePath,
			byte[] bytesData) 
	throws IOException 
	{
		File file = new File( sFileCompletePath);
		writeFileWithData(file, bytesData);
	}	


	public static void writeFileWithData(
			String sFileCompletePath,
			String sData) 
	throws IOException 
	{
		File file = new File(sFileCompletePath);
		writeFileWithData(file, sData);
	}	

	public static void writeFileWithData(
			File file,
			byte[] bytesData) 
	throws IOException 
	{
		OutputStream fos = new BufferedOutputStream( new FileOutputStream( file));
		fos.write(bytesData);
		fos.flush();
		fos.close();
	}	

	public static void writeFileWithData(
			File file,
			char[] bytesData) 
	throws IOException 
	{
		OutputStream fos = new BufferedOutputStream( new FileOutputStream( file));
		fos.write(bytesData.toString().getBytes());
		fos.flush();
		fos.close();
	}	

	
	
	public static void writeFileWithData(
			File file,
			String sData) 
	throws IOException 
	{
		FileWriter fw = new FileWriter(file);
		fw.write(sData);
		fw.close();
	}	

	public static String getXmlContentFromFile(String fileCompletePath) throws IOException,FileNotFoundException
	{
		return getStringContentFromFile(fileCompletePath);
	}


	public static String getStringContentFromFile(String fileCompletePath) 
	throws IOException,FileNotFoundException
	{
		File fileToRead = new File(fileCompletePath);
		return getStringContentFromFile(fileToRead);
	}
	/**
	 * Get the String content of a file
	 * 
	 * @param fileCompletePath
	 * @return
	 * @throws IOException
	 * @throws FileNotFoundException
	 */
	public static String getStringContentFromFile(File file) 
	throws IOException
	{
		return getStringFromFile(file);

		/*
		BufferedReader oBuffRead = null;
		StringBuffer sbXmlData = new StringBuffer(50000);

		String line;
		FileReader fr = new FileReader(file);

		oBuffRead = new BufferedReader(fr);
		long lFileSize = file.length();
		long lFileSizeReaded = 0l;

		try {

			while ((line = oBuffRead.readLine()) != null) 
			{
				sbXmlData.append(line); 
				sbXmlData.append("\n"); 
				lFileSizeReaded += line.length();
				if(lFileSizeReaded >= lFileSize  )
				{
					throw new IOException("Impossible to read file : " +  file);
				}

			}
		}
		catch (FileNotFoundException fNFE) 
		{
			sbXmlData = null;
			throw fNFE;
		}
		catch (IOException iOE) 
		{
			iOE.printStackTrace();
			sbXmlData = null;
			throw iOE;
		}
		finally{
			try{
				oBuffRead.close();
			}
			catch (IOException e)
			{
				e.printStackTrace();
				sbXmlData = null;
				throw e;
			}
		}
		return sbXmlData.toString();
		 */
	}

	public static String getStringFromFile(File f)
	throws IOException {
		FileReader rd = new FileReader(f);
		char[] buf = new char[(int)f.length()];
		rd.read(buf);
		rd.close();
		return new String(buf);
	}



	public static void downloadFileFromUrl(String sUrl, String localFileName)
	throws IOException {
		downloadFileFromUrl(new URL( sUrl), new File(localFileName));
	}

	public static void downloadFileFromUrl(URL url , File fileLocalFileName) 
	throws IOException {
		OutputStream out = null;
		URLConnection conn = null;
		InputStream  in = null;
		FileOutputStream fos = new FileOutputStream(fileLocalFileName);
		try {
			out = new BufferedOutputStream(
					fos);
			conn = url.openConnection();
			in = conn.getInputStream();
			byte[] buffer = new byte[1024];
			int numRead;
			long numWritten = 0;
			while ((numRead = in.read(buffer)) != -1) {
				out.write(buffer, 0, numRead);
				numWritten += numRead;
			}
		} catch (ConnectException e) {
			fos.close();
			fileLocalFileName.delete();
			throw e;
		} finally {
			try {
				if (in != null) {
					in.close();
				}
				if (out != null) {
					out.close();
				}
			} catch (IOException ioe) {
			}
		}
	}

	public static void downloadFileFromUrlToSpecificPath(
			String sUrl,
			String localPath) 
	throws IOException {
		int lastSlashIndex = sUrl.lastIndexOf('/');
		if (lastSlashIndex >= 0 &&
				lastSlashIndex < sUrl.length() - 1) {
			downloadFileFromUrl(sUrl, localPath + sUrl.substring(lastSlashIndex + 1));
		} else {
			System.err.println("Could not figure out local file name for " +
					sUrl);
		}
	}
	public static String readTextFile(File file) throws IOException{
		BufferedReader buffReader = null;
		String sText = "";
		String sLine = "";

		try {buffReader = new BufferedReader(new FileReader(file));
		} catch (FileNotFoundException exc) {return "";}
		while ((sLine=buffReader.readLine())!= null) {
			sText += sLine+"\n";
		}
		buffReader.close();
		return sText;
	}
	
	public static void copyFileIntoOutputStream (File file, OutputStream outputStream)
	throws IOException
	{
		byte [] buffer = new byte [1024 * 10];
		FileInputStream fis = new FileInputStream (file);
		try {
			int count;
			while ((count = fis.read (buffer)) != -1)
				outputStream.write(buffer, 0, count);
		} finally {
			fis.close();
		}
	}
}
