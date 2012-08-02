package org.coin.security;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.Outils;

import au.com.objects.examples.AutoReader;

/**
 * 
 * @author julien
 * 
 * specify constant path in configuration table
 * for linux platform : 
   PATH = /usr/local/clamav/bin/
   DB_PATH = /usr/local/clamav/share/clamav/
   CONF_FILE = /etc/clamd.conf
   
 * for win32 platform :
   WIN_PATH = C:\\Program Files\\ClamWin\\bin\\
   WIN_DB_PATH = C:\\temp\\.clamwin\\db\\\\
   WIN_CONF_FILE = C:\\Program Files\\ClamWin\\bin\\ClamWin.conf
   
 */

public class ClamAV implements AutoReader.Listener
{
	public String sReport;
	public String sVirus;
	public boolean bIsExistVirus;
	
	public ClamAV()
	{
		this.sReport = "";
		this.sVirus = "";
		this.bIsExistVirus = false;
	}
	
	public void scanFile(String sFilePath) throws IOException, InterruptedException, ClamAVVirusFoundException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{   
		String args[] = new String[]{Configuration.getConfigurationValueMemory(Configuration.AV_PATH)+"clamscan","-d",Configuration.getConfigurationValueMemory(Configuration.AV_DB_PATH),sFilePath};
        exec(args);

        int iInfectedFiles = 0;
        try{iInfectedFiles = Integer.parseInt(Outils.getTextBetweenOptionalNewLine(this.sReport, "Infected files: "));}
        catch(Exception e){}
        
        if(iInfectedFiles>0){
        	this.sVirus = Outils.getTextBetweenOptionalNewLine(this.sReport,sFilePath+": ");
        	this.sVirus = this.sVirus.split(" ")[0];
        	this.bIsExistVirus = true;
        	throw new ClamAVVirusFoundException(this.sVirus);
        }
        
        /*
        if(!this.sVirus.equalsIgnoreCase("OK"))
        {
        	this.bIsExistVirus = true;
        	this.sVirus = this.sVirus.split(" ")[0];
        	throw new ClamAVVirusFoundException(this.sVirus);
        }
        */

        this.sVirus = "No Virus";
	}
	
	public void update() throws Exception
	{
	    String args[] = new String[]{Configuration.getConfigurationValueMemory(Configuration.AV_PATH)+"freshclam"};
	    exec(args);
	}
	
	public void version() throws Exception
	{
	    String args[] = new String[]{Configuration.getConfigurationValueMemory(Configuration.AV_PATH)+"clamscan","-V"};
	    exec(args);
	}
	
	public static String getVersion() throws Exception
	{
		ClamAV av = new ClamAV();
		av.version();
		
		return av.sReport;
	}
	
	public static String getVirusFromReport(String sReport)
	{
		return Outils.getTextBetweenOptional(sReport,": ","FOUND");
	}
	
	public static void main(String[] args) 
	{
		@SuppressWarnings("unused") String sFilePathVirus = "c:\\temp\\eicar_niveau1.zip";
		@SuppressWarnings("unused") String sFilePath = "c:\\temp\\ouv1.rtf";
		/*
		ClamAV av = new ClamAV();
		try
		{
			av.scanFile(sFilePath);
		}
		catch(Exception eClam)
		{
			eClam.printStackTrace();
		}
		
		System.out.println("report :\n"+av.sReport);
		if(av.bIsExistVirus)
			System.out.println("virus :"+av.sVirus);
		*/
		
		String sReport = "/eicar.com.txt: Eicar-Test-Signature FOUND\n"+
"----------- SCAN SUMMARY -----------\n"+
"Known viruses: 420639\n"+
"Engine version: 0.91.2\n"+
"Scanned directories: 0\n"+
"Scanned files: 1\n"+
"Infected files: 1\n"+
"Data scanned: 0.00 MB\n"+
"Time: 4.838 sec (0 m 4 s)\n"+
"You have new mail in /var/spool/mail/root\n";
		
		int iInfectedFiles = 0;
        try{iInfectedFiles = Integer.parseInt(Outils.getTextBetweenOptionalNewLine(sReport, "Infected files: "));}
        catch(Exception e){}
		
        System.out.println("iInfectedFiles:"+iInfectedFiles);
	}
	
	public void exec(String[] args) throws IOException, InterruptedException
	{
		Process p = Runtime.getRuntime().exec(args);
		AutoReader in = new AutoReader(p.getInputStream());
		in.addListener(this);
		AutoReader err = new AutoReader(p.getErrorStream());
		err.addListener(this);
		new Thread(in).start();
		new Thread(err).start();
		p.waitFor();
	}

	public void lineRead(AutoReader reader, String line) {
		this.sReport += line+"\n";
	}

	public void error(AutoReader reader, IOException ex) {
		ex.printStackTrace();
		
	}

	public void eof(AutoReader reader) {
		
	}
	
	public class ClamAVVirusFoundException extends Exception
	{
		private static final long serialVersionUID = 1L;
		
		public ClamAVVirusFoundException(String sMessage) {
			super(sMessage);
		}
		
		public ClamAVVirusFoundException(String sMessage, Throwable cause) {
			super(sMessage, cause);
		}
	}
}
