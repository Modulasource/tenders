package org.coin.servlet;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.coin.bean.conf.Configuration;
import org.coin.util.HttpUtil;

public class ProxyServlet extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	
	protected void doPost(
			HttpServletRequest request, 
			HttpServletResponse response) 
	{
		String sUrlRequested =  HttpUtil.parseStringBlank("sUrlRequested", request);
		String sReferer = HttpUtil.parseStringBlank("sReferer", request);
		
		if(sUrlRequested.equals("")) return;
		
		HttpMethod method = getHttpMethodFromUrl(sUrlRequested, sReferer);
		
		String sResponseBody = getResponseBodyAsString(method);
		setHeader(method, response);
		
		String sEncoding = null;
		String sDecoding = null;
		try {
			sEncoding = Configuration.getConfigurationValueMemory("server.proxyservlet.encoding", "UTF-8");
			sDecoding = Configuration.getConfigurationValueMemory("server.proxyservlet.decoding", "ISO-8859-1");
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		
		
		try {
			response.getWriter().write(new String( sResponseBody.getBytes(sDecoding), sEncoding));
			response.getWriter().flush();
			
		} catch (IOException e) {
			e.printStackTrace();
		}
		method.releaseConnection();
	}
	
	protected void doGet(
			HttpServletRequest request, 
			HttpServletResponse response) {
		// Renvoi à la fonction doPost()
		doPost(request, response);
	}
	
	
	
	
	public static void main(String[] args) {
		
		HttpMethod method = getHttpMethodFromUrl("http://www.karzoo.eu/fr/webpartner/moovijob/full", "");
		
		displayInfo(method);
		
		//clean up the connection resources
        method.releaseConnection();
		
	}
	
	
	public static void setHeader(
			HttpMethod method,
			HttpServletResponse response ) {
		Header[] requestHeaders = method.getResponseHeaders();
		for (int i=0; i<requestHeaders.length; i++){
			Header header = requestHeaders[i];
			response.setHeader(header.getName(), header.getValue());
		}
	}
	
	public static String getResponseBodyAsString(String sUrl) {
		HttpMethod method = getHttpMethodFromUrl(sUrl, "");
		return getResponseBodyAsString(method);
	}
	
	public static String getResponseBodyAsString(HttpMethod method) {
		StringBuffer sb = new StringBuffer();
		try {
			//sResponseBody = method.getResponseBodyAsString();
			InputStream is = method.getResponseBodyAsStream();
			BufferedInputStream bis = new BufferedInputStream(is); 
			int ch=0;
			 while((ch = bis.read())> -1){
				 sb.append((char)ch);
            }
		} catch (IOException e) {
		}
		
		return sb.toString();
	}
	
	public static void displayInfo(HttpMethod method) {
		//write out the request headers
		System.out.println("*** Request ***");
		System.out.println("Request Path: " + method.getPath());
		System.out.println("Request Query: " + method.getQueryString());
		Header[] requestHeaders = method.getRequestHeaders();
		for (int i=0; i<requestHeaders.length; i++){
			System.out.print(requestHeaders[i]);
		}

		//write out the response headers
		System.out.println("*** Response ***");
		System.out.println("Status Line: " + method.getStatusLine());
		Header[] responseHeaders = method.getResponseHeaders();
		for (int i=0; i<responseHeaders.length; i++){
			System.out.print(responseHeaders[i]);
		}
		
			
	}
	public static HttpMethod getHttpMethodFromUrl(String url, String sReferer) {
		HttpClient client = new HttpClient();
		
		//establish a connection within 5 seconds
		client.getHttpConnectionManager().
		getParams().setConnectionTimeout(5000);

		HttpMethod method = null;

		Header header2 = new Header ("Referer",sReferer);
		Header header3 = new Header ("USer-Agent","Firefox 2.0.0.7");
		
		method = new GetMethod(url);
		method.setFollowRedirects(true);
		method.setRequestHeader(header2);
		method.setRequestHeader(header3);
		
		try{
			client.executeMethod(method);
		} catch (HttpException he) {
			System.err.println("Http error connecting to '" + url + "'");
			System.err.println(he.getMessage());
		} catch (IOException ioe){
			System.err.println("Unable to connect to '" + url + "'");
		}


		
        return method;
	}
}
