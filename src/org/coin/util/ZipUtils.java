package org.coin.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

public class ZipUtils {

	public static int BUFFER_SIZE = 1024 * 64;
	

	@SuppressWarnings("unchecked")
	public static void unzipArchive(File archive, File outputDir) {
		try {
			ZipFile zipfile = new ZipFile(archive);
			for (Enumeration  e = zipfile.entries(); e.hasMoreElements(); ) {
				ZipEntry entry = (ZipEntry) e.nextElement();
				unzipEntry(zipfile, entry, outputDir);
			}
		} catch (Exception e) {
			System.out.println("Error while extracting file " + archive  + " "+ e.getMessage());
		}
	}

	private static void unzipEntry(
			ZipFile zipfile, 
			ZipEntry entry, 
			File outputDir) 
	throws IOException 
	{

		//System.out.println("entry : " +  entry.getName());
		
		if (entry.isDirectory()) {
			createDir(new File(outputDir, entry.getName()));
			return;
		}

		File outputFile = new File(outputDir, entry.getName());
		if (!outputFile.getParentFile().exists()){
			createDir(outputFile.getParentFile());
		}

		BufferedInputStream inputStream = new BufferedInputStream(zipfile.getInputStream(entry));
		BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(outputFile));

		try {
			copy(inputStream, outputStream);
		} finally {
			outputStream.close();
			inputStream.close();
		}
	}

	private static void createDir(File dir) {
		if(!dir.mkdirs()){
			if(!dir.exists()){
				throw new RuntimeException("Can not create dir '" + dir + "'");
			}
		}
	}

	private static void copy(InputStream in, OutputStream out)
	throws IOException
	{
		if (in == null)
			throw new NullPointerException("InputStream is null!");
		if (out == null)
			throw new NullPointerException("OutputStream is null");

		// Transfer bytes from in to out
		byte[] buf = new byte[BUFFER_SIZE];
		int len;
		while ((len = in.read(buf)) > 0)
		{
			out.write(buf, 0, len);
		}
		in.close();
		out.close();
	}
}
