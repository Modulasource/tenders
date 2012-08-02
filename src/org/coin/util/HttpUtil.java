package org.coin.util;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Timestamp;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.servlet.ServletRequest;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.coin.bean.conf.Configuration;
import org.coin.security.PreventInjection;
import org.json.JSONException;
import org.json.JSONObject;

public class HttpUtil {
	
	public ServletRequest request;
	public HashMap<String, Object> mapContext;
	
	public HttpUtil(ServletRequest request) {
		this.request = request;
		this.mapContext = new HashMap<String, Object>();
	}

	@SuppressWarnings("unchecked")
	public String replaceAllTagParameters(
			String sText)
	{
		Enumeration<String> en = request.getParameterNames();
		for ( ; en.hasMoreElements() ;) {
			String sParameterName = en.nextElement();
	        sText = replaceAllTag(sText , sParameterName);
	     }

		return sText;
	}

	
	public String replaceAllTag(
			String sText,
			String sParameterName)
	{
		return replaceAllTag(this.request, sText , sParameterName);
	}
	
	public static String replaceAllTag(
			ServletRequest request,
			String sText,
			String sParameterName)
	{
		return  Outils.replaceAll(sText, "[" + sParameterName + "]", request.getParameter(sParameterName));
	}	
	public static void returnFile(InputStream in, OutputStream out)
	throws FileNotFoundException, IOException {
		FileUtilBasic.write(in, out);
	}
	
	public static void write(InputStream in, OutputStream out)
	throws FileNotFoundException, IOException {
		FileUtilBasic.write(in, out);
	}
	
	public static String encodeAllUrl(
			String sHtmlText,
			String sDelimiterStart,
			String sDelimiterEnd,
			HttpServletResponse response) 
	throws MalformedURLException
	{
		return encodeAllUrl(sHtmlText, sDelimiterStart, sDelimiterEnd, "", response);
	}	
	
	public static String encodeAllUrl(
			String sHtmlText,
			String sDelimiterStart,
			String sDelimiterEnd,
			String sUrlParams,
			HttpServletResponse response) 
	throws MalformedURLException
	{
		Vector<String> vUrlToEncode = Outils.getAllTextBetweenOptional(sHtmlText, sDelimiterStart, sDelimiterEnd);
		
		
		for (int i = 0; i < vUrlToEncode.size(); i++) {
			String sUrlToEncode = vUrlToEncode.get(i);
			sUrlToEncode = sUrlToEncode.substring(
					sDelimiterStart.length(), 
					sUrlToEncode.length() - sDelimiterEnd.length());
			String sDelimiter = "";
			if(!sUrlToEncode.endsWith("?"))
			{
				sDelimiter = "&" ;
			}
			sHtmlText = Outils.replaceAll(
					sHtmlText, 
					sDelimiterStart + sUrlToEncode + sDelimiterEnd, 
					response.encodeURL(sUrlToEncode + sDelimiter + sUrlParams));
		}
		
		return sHtmlText;
	}

	public static String getUrlWithProtocolAndPortToExternalFormWithJSESSIONID(
			String sUrl,
			HttpServletRequest request,
			HttpServletResponse response) 
	throws MalformedURLException
	{
		String sUrlSession 
			= getUrlWithProtocolAndPort(
				sUrl,
				request).toExternalForm();
		
		
		
		/**
		 * force the JSESSION in the URL rather than by cookie
		 * its important to do that for applets.
		 */
		boolean bUseSessionCookie = false;

		Cookie[] cookies = request.getCookies();
		if(cookies != null) {
			for (Cookie c : cookies)
			{
				if("jsessionid".equals(c.getName().toLowerCase())) {
					bUseSessionCookie = true;
					break;
				}
			}
		}
		
		if(bUseSessionCookie)
		{
			int index = sUrlSession.indexOf("?");
			int indexSession = sUrlSession.indexOf(";jsessionid");
			String sSID = ";jsessionid=" + request.getSession().getId();
			if(index >= 0 && indexSession < 0) 
			{
				sUrlSession 
					= StringUtil.insertStringAfterFirstOccurrence(
						sUrlSession, 
						index, 
						sSID);
				
			} else {
				sUrlSession += sSID;	
			}
		}


		return response.encodeURL(sUrlSession);
		
	}

	
	public static String getUrlWithProtocolAndPortToExternalForm(
			String sUrl,
			ServletRequest request) 
	throws MalformedURLException
	{
		return getUrlWithProtocolAndPort(
				sUrl,
				request).toExternalForm();
		
	}
	
	public static URL getUrlWithProtocolAndPort(
			String sUrl,
			ServletRequest request) 
	throws MalformedURLException
	{
		String sHost = request.getServerName();
		int iPort = request.getServerPort();
		String[] sProtocol = request.getProtocol().split("/");
		String sProtocolPort = "";
		if(iPort == 443) sProtocolPort = "s";

		return new URL(sProtocol[0]+sProtocolPort,
						sHost,
						iPort,
						sUrl);
	}
	
	public static int[] splitToIntArray(String sValueName, String sDelimiter, HttpServletRequest request)
	throws NumberFormatException
	{
		String[] arr =  request.getParameter(sValueName).split(sDelimiter);
		int[] arrInt = new int[arr.length];
		for (int i = 0; i < arr.length; i++) {
			arrInt[i] = Integer.parseInt( arr[i]);
		}
		
		return arrInt;
	}
	
	public static final boolean parseBooleanCheckbox(
			String sValueName, 
			HttpServletRequest request, 
			boolean bDefaultValue)
	{
		String sValue = request.getParameter(sValueName) ;
		return parseBooleanCheckbox(sValue, bDefaultValue);
	}

	public static final boolean parseBooleanCheckbox(
			String sValue, 
			boolean bDefaultValue)
	{
		if (sValue != null)
		{
			boolean b = sValue .equals("on");
			if(b) return b;
			return sValue .equals("true");
		}
		return bDefaultValue; 
	}

	
	public static final boolean parseBoolean(
			String sValueName, 
			HttpServletRequest request, 
			boolean bDefaultValue)
	{
		if (request.getParameter(sValueName) != null)
		{
			return Boolean.parseBoolean(request.getParameter(sValueName));
		}
		return bDefaultValue; 
	}

	public static final int parseInt(String sValueName, HttpServletRequest request, int iDefaultValue)
	{
		return parseInt(request.getParameter(sValueName), iDefaultValue);
	}
	public static final int parseInt(String sValue, int iDefaultValue)
	{
		try{return Integer.parseInt(Outils.removeAllSpaces(sValue));}
		catch(Exception e){}
		return iDefaultValue;
	}

	public static int parseInt(String sValueName, HttpServletRequest request)
	throws NumberFormatException
	{
		return Integer.parseInt(request.getParameter(sValueName));
	}
	
	public static final long[] parseArrayLong(
			String sValueName, 
			boolean bUseBraket,
			HttpServletRequest request)
	{
		return Outils.toArray(request.getParameter(sValueName), bUseBraket);
	}

	public static final float[] parseArrayFloat(
			String sValueName, 
			boolean bUseBraket,
			HttpServletRequest request)
	{
		return Outils.toArrayFloat(request.getParameter(sValueName), bUseBraket);
	}

	public static final String[] parseArrayString(
			String sValueName,
			HttpServletRequest request)
	{
		return Outils.toArrayString(request.getParameter(sValueName));
	}
	
	public static final long parseLong(String sValueName, HttpServletRequest request, long lDefaultValue)
	{
		try{return Long.parseLong(request.getParameter(sValueName));}
		catch(Exception e){}
		return lDefaultValue;
	}

	public static final long parseLong(
			String sValueName, 
			HashMap<String, String> hashMap, 
			long lDefaultValue)
	{
		try{return Long.parseLong(hashMap.get(sValueName));}
		catch(Exception e){}
		return lDefaultValue;
	}

	public static final long parseLong(String sValueName, HttpServletRequest request)
	{
		return Long.parseLong(request.getParameter(sValueName));
	}

	public static final double parseDouble(String sValueName, HttpServletRequest request, double dDefaultValue)
	{
		try{return Double.parseDouble(request.getParameter(sValueName));}
		catch(Exception e){}
		return dDefaultValue;
	}

	public static final float parseFloat(String sValueName, HttpServletRequest request, float fDefaultValue)
	{
		try{return Float.parseFloat(request.getParameter(sValueName));}
		catch(Exception e){}
		return fDefaultValue;
	}
	
	public static final float parseFloat(String sValueName, HttpServletRequest request)
	{
		return Float.parseFloat(request.getParameter(sValueName));
	}
	
	public static final Timestamp parseTimestamp(
			String sValueName, 
			HttpServletRequest request,
			Timestamp tsDefaultValue)
	{
		if(request.getParameter(sValueName) == null)
			return tsDefaultValue;

		return CalendarUtil.getConversionTimestamp( request.getParameter(sValueName), "dd/MM/yyyy");
	}

	public static final void putJSON(
			String sPrefix, 
			String sValueName, 
			JSONObject obj,
			HttpServletRequest request) 
	throws JSONException
	{
		obj.put(sValueName, parseString(sPrefix + sValueName, request, null));
		
	}

	
	public static final String parseStringBlank(
			String sValueName, 
			HttpServletRequest request)
	{
		return parseString(sValueName, request, "");
	}
	
	public static final String parseStringBlankTrim(
			String sValueName, 
			HttpServletRequest request)
	{
		return parseString(sValueName, request, "").trim();
	}
	
	public static final String parseStringBlank(
			String sValueName, 
			boolean bUseHttpPrevent,
			HttpServletRequest request)
	{
		return parseString(sValueName, request, bUseHttpPrevent, "");
	}

	public static final String parseString(
			String sValueName, 
			HttpServletRequest request, 
			String sDefaultValue)
	{
		return parseString(sValueName,
			request, 
			false,
			sDefaultValue);
	}

	public static final String parseString(
			String sValueName,
			HttpServletRequest request, 
			boolean bUseHttpPrevent,
			String sDefaultValue)
	{
		if(Outils.isNull(request.getParameter(sValueName)))
			return sDefaultValue;

		if(bUseHttpPrevent)
			return PreventInjection.preventStore(request.getParameter(sValueName));
		return request.getParameter(sValueName);
	}
	
	@SuppressWarnings("unchecked")
	public static Vector<Long> getAllCheckedId(
			HttpServletRequest request,
			String sPrefix) 
	{
		Vector<Long> vParamId = new Vector<Long>();
		for ( Enumeration<String> e = request.getParameterNames();
		e.hasMoreElements() ; ) 
		{
			String param = (String)e.nextElement();
			if(param.startsWith(sPrefix) && request.getParameter( param ).equals("on")){
				param = param.substring(sPrefix.length());
				long lId = Long.parseLong(param );
				vParamId.add(lId);
			}
		}
		return vParamId;
	}
	
	@SuppressWarnings("unchecked")
	public static Vector<HashMap<String, String>> getAllParameterWithIdAndValue(
			HttpServletRequest request,
			String sPrefix,
			String[] sOptionalParams) 
	{
		Vector<HashMap<String, String>> vParamId = new Vector<HashMap<String, String>>();
		for ( Enumeration<String> e = request.getParameterNames();
		e.hasMoreElements() ; ) 
		{
			String param = (String)e.nextElement();
			if(param.startsWith(sPrefix)){
				HashMap<String, String> map = new HashMap<String, String>();
				String sValue = parseStringBlank(param, request);
				map.put("sValue", sValue);
				param = param.substring(sPrefix.length());
				String sId = param;
				map.put("sId", sId);
				
				if(sOptionalParams != null){
					for(String sOptionalParam : sOptionalParams){
						if(!Outils.isNullOrBlank(sOptionalParam)){
							String sOtionalParamValue = parseStringBlank(sOptionalParam+"_"+sId, request);
							map.put(sOptionalParam, sOtionalParamValue);
						}
					}
				}
				
				vParamId.add(map);
			}
		}
		return vParamId;
	}

	@SuppressWarnings("unchecked")
	public static void displayOnConsoleRequestParameters(
			HttpServletRequest request	) 
	{
		for ( Enumeration<String> e = request.getParameterNames();
		e.hasMoreElements() ; ) 
		{
			String param = (String)e.nextElement();
			System.out.println( param + "='" + 
					request.getParameter( param ) + "'" );

		}
	}
	public static String getRequestParametersXml(
			HttpServletRequest request	) 
	{
		return getRequestParametersXml(null, request);
	}
	
	@SuppressWarnings("unchecked")
	public static String getRequestParametersXml(
			String sFilterPrefix,
			HttpServletRequest request	) 
	{
		StringBuilder sbXml = new StringBuilder("<parameters>\n");
		for ( Enumeration<String> e = request.getParameterNames();
		e.hasMoreElements() ; ) 
		{
			String param = (String)e.nextElement();
			if(sFilterPrefix != null && param.startsWith(sFilterPrefix))
			{
				continue;
			}
			
			sbXml.append("<parameter name=\"" + param  + "\" "
						+ " id=\"" + param + "\" "
						+ " >" );
			
			sbXml.append(request.getParameter( param ) );
			sbXml.append("</parameter>\n" );

		}
		sbXml.append("</parameters>\n" );
		return sbXml.toString();
	}

	
	@SuppressWarnings("unchecked")
	public static HashMap<String, String>  getRequestParametersHashMap(
			HttpServletRequest request	) 
	{
		HashMap<String, String> hashMap = new HashMap<String, String>();
		for ( Enumeration<String> e = request.getParameterNames();
		e.hasMoreElements() ; ) 
		{
			String param = (String)e.nextElement();
			hashMap.put(param, (String)request.getParameter( param )) ;
		}
		
		return hashMap;
	}	
	
	public static FileItem getFirstFileItem(
			HttpServletRequest request ) throws FileUploadException
	{
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
	
		if(isMultipart)
		{
			Iterator<?> iter = getItemList(request);
			while (iter.hasNext()) {
			    FileItem item = (FileItem) iter.next();
		    	if (item.isFormField()) {
			       // processFormField(item);
			    } else {
			    	return item;
			    }
			}
		}
		return null;	
	}
	
	public FileItem getFileItemWithProcess(
			HttpServletRequest request ) throws FileUploadException
	{
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		FileItem file = null;
		if(isMultipart)
		{
			Iterator<?> iter = getItemList(request);
			while (iter.hasNext()) {
			    FileItem item = (FileItem) iter.next();
		    	if (item.isFormField()) {
			       processFormField(item);
			    } else {
			    	file = item;
			    }
			}
		}
		return file;	
	}
	
	public void processFormField(FileItem item){

	}

	public static Iterator<?> getItemList(
			HttpServletRequest request ) 
	throws FileUploadException
	{
		String sHeaderEncoding = null;
		try {
			sHeaderEncoding = Configuration.getConfigurationValueMemory("org.coin.util.HttpUtil.header.encoding", (String) null);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return getItemList(request, sHeaderEncoding);
	}
	
	public static Iterator<?> getItemList(
			HttpServletRequest request,
			String sHeaderEncoding) 
	throws FileUploadException
	{
		boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		
		if(isMultipart)
		{
			DiskFileItemFactory factory = new DiskFileItemFactory();
			factory.setSizeThreshold(10*1024*1024); /* 10MB */
			ServletFileUpload upload = new ServletFileUpload(factory);
			if(sHeaderEncoding != null) upload.setHeaderEncoding(sHeaderEncoding);
			List<?> items = upload.parseRequest(request);
			return items.iterator();
		}
		return null;
	}
	
	public static boolean isFileExist(
			String sFileURL,
			HttpServletRequest request) 
	throws MalformedURLException
	{
		//String sHost = request.getServerName();
		int iPort = request.getServerPort();
		String[] sProtocol = request.getProtocol().split("/");
		String sProtocolPort = "";
		if(iPort == 443) sProtocolPort = "s";
		
		String sContextPath = request.getContextPath();
		
		// using localhost instead of request.getServerName()
		// was making the connection timeout when getServerName is an IP Address (caused by using a virtual IP, my guess)
		URL url = new URL(sProtocol[0]+sProtocolPort,
						"localhost",
						iPort,
						sContextPath+sFileURL+";jsessionid="+request.getSession().getId());
		
		boolean bExist = false;
		try {
			
			URLConnection conn = url.openConnection();
			
			int length = conn.getContentLength();
			
			if(length > 0) {
				bExist = true;
			}
			
			if( ((HttpURLConnection)conn).getResponseCode()==200){
				bExist = true;
			}else if( ((HttpURLConnection)conn).getResponseCode()==404){
				bExist = false;
			}

		} catch (IOException e) {
			e.printStackTrace();
			bExist = false;
		}

		return bExist;
	}

}
