package org.coin.ws;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.URL;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import sun.net.www.protocol.http.HttpURLConnection;

public class WebServiceUtil {

	public static HttpsURLConnection sendSoapMessageHttps(
			String sEnvelope, 
			String sUrl)
	throws IOException {
		URL url = new URL(sUrl);
		return sendSoapMessageHttps(sEnvelope, url);
	}	
	
	public static HttpsURLConnection sendSoapMessageHttps(
			String sEnvelope, 
			URL url)
	throws IOException {
		HttpsURLConnection  httpConn = null;
		
		
		httpConn = (HttpsURLConnection)url.openConnection();
		httpConn.setDoOutput(true);
		httpConn.setDoInput(true);
		httpConn.setUseCaches (false);
		httpConn.setDefaultUseCaches (false);
		//httpConn.setRequestMethod( "GET" );
		httpConn.setRequestMethod( "POST" );
		httpConn.setHostnameVerifier(new HostnameVerifier()        
		{                  
		   public boolean verify(String arg0, SSLSession arg1) {
			   System.out.println("arg0 : " + arg0);
		      return true;
		   }
		});
		
		httpConn.setRequestProperty("Content-Type", "text/xml");
		httpConn.setRequestProperty("soapAction", "notUsedButMandatory");
		
   		DataOutputStream dstream = new DataOutputStream(httpConn.getOutputStream());
   		dstream.writeBytes(sEnvelope);
   		dstream.flush();
   		dstream.close();
   		
   		return httpConn;
	}
	
	public static HttpURLConnection sendSoapMessage(
			String sEnvelope, 
			String sUrl)
	throws IOException
	{
		URL url = new URL(sUrl);
		return sendSoapMessage(sEnvelope, url);
	}	
	
	public static HttpURLConnection sendSoapMessage(
			String sEnvelope, 
			URL url)
	throws IOException
	{
		HttpURLConnection  httpConn = null;
		
		httpConn = (HttpURLConnection)url.openConnection();
		httpConn.setDoOutput(true);
		httpConn.setDoInput(true);
		httpConn.setUseCaches (false);
		httpConn.setDefaultUseCaches (false);
		//httpConn.setRequestMethod( "GET" );
		httpConn.setRequestMethod( "POST" );

		httpConn.setRequestProperty("Content-Type", "text/xml");
		httpConn.setRequestProperty("soapAction", "notUsedButMandatory");
		
   		DataOutputStream dstream = new DataOutputStream(httpConn.getOutputStream());
   		dstream.writeBytes(sEnvelope);
   		dstream.flush();
   		dstream.close();
   		
   		return httpConn;
	}
	
	public static String getResponse(HttpsURLConnection  httpConn) 
	throws IOException
	{
		BufferedReader in;
		in = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		String sLigneAR = "";
		String sReturn = "";
		sLigneAR = in.readLine();
		while (sLigneAR != null) {
			sReturn += sLigneAR + "\n";
		    sLigneAR = in.readLine() ;
		}
		in.close();
		return sReturn;
	}

	
	public static String getResponse(HttpURLConnection  httpConn) 
	throws IOException
	{
		BufferedReader in;
		in = new BufferedReader(new InputStreamReader(httpConn.getInputStream()));
		String sLigneAR = "";
		String sReturn = "";
		sLigneAR = in.readLine();
		while (sLigneAR != null) {
			sReturn += sLigneAR + "\n";
		    sLigneAR = in.readLine() ;
		}
		in.close();
		return sReturn;
	}
	public static String sendAndGetResponse(
			String sEnvelope, 
			String sUrl) 
	throws IOException
	{
		URL url = new URL(sUrl);
		
		return sendAndGetResponse(sEnvelope, url);
	}
	
	public static String sendAndGetResponse(
			String sEnvelope, 
			URL url) 
	throws IOException
	{
		String sReturn  = null;
		
		/**
		 * 
		 * 3. Send SOAP XML Message
		 * 
		 */
		if(url.getProtocol().toLowerCase().equals("https")){
			System.out.println("HTTPS");
			HttpsURLConnection httpsConn = sendSoapMessageHttps(sEnvelope, url);
			sReturn = getResponse(httpsConn);
			
		} else {
			System.out.println("HTTP");
			HttpURLConnection httpConn = sendSoapMessage(sEnvelope, url);
			/**
			 * 
			 * 4. Get SOAP XML Response returned 
			 * 
			 */
	   		sReturn = getResponse(httpConn);
			
		}
		
		return sReturn;
	}
}
