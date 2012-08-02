package org.coin.servlet;

import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.SignatureException;
import java.security.cert.CertificateException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.security.HabilitationException;
import org.coin.util.FileUtil;



public abstract class DownloadZipFileAbstractServlet extends HttpServlet{

	private static final long serialVersionUID = 1L;
	public String sZipFilename = null;
	public boolean bRemoveZipFileAfterDownload = false;
	public boolean bRemoveTempDirAfterDownload = false;
	public String sTempDir = null;
	public void doGet (HttpServletRequest request, HttpServletResponse response)
	{
		doPost(request, response);
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
	{
		File file = null;
		DataInputStream in = null;
		try {
			String sZipFile = null;

			try {
				sZipFile = prepareZip(request, response);
			} catch (Exception e) {
				e.printStackTrace();
				try {
					OutputStream out = response.getOutputStream();
					out.write(e.getMessage().getBytes());
					out.flush();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				if (this.bRemoveTempDirAfterDownload)
				{
					FileUtil.deleteDirectory(this.sTempDir);
				}
				return;
				
			}
			file = new File(sZipFile);

			response.setContentType("application/zip");
			response.setContentLength( (int)file.length() );
			response.setHeader("Content-Disposition", "attachment; filename=" + this.sZipFilename);

			OutputStream out = response.getOutputStream();
			/**
			 * Stream the zip file
			 */
			int length = 0;
			byte[] bbuf = new byte[4096];
			in = new DataInputStream(new FileInputStream(file));

			while ((in != null) && ((length = in.read(bbuf)) != -1))
			{
				out.write(bbuf,0,length);
			}

			in.close();
			out.flush();
			out.close();
			if (this.bRemoveZipFileAfterDownload)
			{
				file.delete();
			}
			if (this.bRemoveTempDirAfterDownload)
			{
				FileUtil.deleteDirectory(this.sTempDir);
			}

		} catch (IOException e) {
			e.printStackTrace();
			try {
				in.close();
				if (this.bRemoveZipFileAfterDownload)
				{
					file.delete();
				}
				if (this.bRemoveTempDirAfterDownload)
				{
					FileUtil.deleteDirectory(this.sTempDir);
				}
			} catch (IOException e1) {
				e1.printStackTrace();
			}
		}

	}

	abstract public String prepareZip(HttpServletRequest request, HttpServletResponse response) 
	throws HabilitationException, NamingException, SQLException, CoinDatabaseLoadException,
	InstantiationException, IllegalAccessException, IOException, InvalidKeyException, 
	CertificateException, SignatureException, NoSuchAlgorithmException, NoSuchProviderException, 
	CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseStoreException ;	
}
