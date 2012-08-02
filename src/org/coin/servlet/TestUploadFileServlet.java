/*
 * Created on 25 nov. 2004
 *
 */
package org.coin.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.fileupload.DefaultFileItemFactory;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.MultipartStream;
import org.apache.commons.fileupload.ParameterParser;
import org.apache.commons.fileupload.MultipartStream.MalformedStreamException;
import org.coin.util.FileUtil;
import org.coin.util.Outils;

import com.oreilly.servlet.multipart.*;

import java.io.*;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * @author jrenier
 *
 */
public class TestUploadFileServlet extends HttpServlet
{
	
	private static final long serialVersionUID = 1L;

	public void doGet (HttpServletRequest req, HttpServletResponse resp)
	throws ServletException , IOException
	{
		doPost(req, resp);
	}

	public void service(HttpServletRequest request, HttpServletResponse response)
	throws IOException
	{
		
		Enumeration e = request.getHeaderNames();
		while (e.hasMoreElements()) {
			String element = (String) e.nextElement();
			System.out.println(element + " :" + request.getHeader(element));
			
		}
		
		//uploadFileUsingMultiPartUL(request,  response);
		//uploadFileUsingCOS(request,  response);
		//uploadFileUsingApacheCommonUL(request,  response);
		
		FileUtil.convertInputStreamInFileWithConsole(
				request.getInputStream(), 
				new File("c:\\" + System.currentTimeMillis() + "inputstream.txt"),
				10*1024*1024);
		
	}
	
	public void uploadFileUsingApacheCommonUL(HttpServletRequest request, HttpServletResponse response)
	throws IOException
	{
		PrintWriter out = new PrintWriter(response.getOutputStream(),true);
		String sFileName ="";
		try {
			
			DefaultFileItemFactory factory = new DefaultFileItemFactory();
			factory.setSizeThreshold(10000);
			factory.setRepository(new File("c:\\temp\\"));
			FileUpload upload = new FileUpload(factory);
			upload.setSizeMax(-1);

			System.out.println("isMultipart = " + FileUpload.isMultipartContent(request));
			List items = null;
			try {
				items = upload.parseRequest(request);
			} catch (Exception e) {
				e.printStackTrace();
			}

			Iterator iter = items.iterator();
			System.out.println("iter");
			while (iter.hasNext()) 
			{
				System.out.println("item.iter : " + iter);
				FileItem item = (FileItem) iter.next();
				System.out.println("item.getFieldName : " + item.getFieldName());
				System.out.println("item.getString : " + item.getString());
				if (item.isFormField())
				{
					if (item.getFieldName().equals("fileName"))
					{
						sFileName = item.getString();
						System.out.println("fileName : " +sFileName );
					}
					if (item.getName().equals("contentType"))
					{
						System.out.println("contentType : " + item.getString());
					}
					if (item.getName().equals("sizeFile"))
					{
						System.out.println("sizeFile : " + Math.round(Float.parseFloat(item.getString())));
					}
				}
				else 
				{
					if (item.getFieldName().equals("file"))
					{
						
						FileUtil.convertInputStreamInFile(
								item.getInputStream(), 
								new File("c:\\" + System.currentTimeMillis() + sFileName));
						
						
					}
				}
			}
			out.println("true");
		}
		catch (Exception e) 
		{
			out.println(e.getMessage());
		}
	}
	
	public void uploadFileUsingMultiPartUL(HttpServletRequest request, HttpServletResponse response)
	throws IOException
	{
		PrintWriter out = new PrintWriter(response.getOutputStream(),true);
		String sFilename = "";
		 byte[] boundary = getBoundary(request.getHeader("Content-Type"));
         
		   try {
		        MultipartStream multipartStream = new MultipartStream(request.getInputStream(),
		                                                              boundary);
		        boolean nextPart = true;
		        //nextPart = multipartStream.skipPreamble();
			
		        int i = 0;
		        while(nextPart) {
		            String header = multipartStream.readHeaders();
		           
		        	if(isParameterFile(header))
		        	{
		        		processParameterFile(multipartStream, header, sFilename);
			        } else {
			        	String sValue = getParameterDataValue(multipartStream, header);
			        	String sName = getParameterDataName(header);
		        		System.out.println("name : " + sName + " = " + sValue);
		        		
		        		if(sName.equals("fileName"))
		        		{
		        			sFilename = sValue;
		        		}
		        	} 
		            
		            nextPart = multipartStream.readBoundary();
		        }
		        
		    } catch(MultipartStream.MalformedStreamException e) {
		          // the stream failed to follow required syntax
		    } catch(IOException e) {
		          // a read or write error occurred
		    }

	}

	public static boolean isParameterFile(String header) 
	throws MalformedStreamException, IOException
	{
		if(header.contains("filename="))
			return true;
		
		return false;
		
	}

	public static String getParameterDataName(String header) 
	throws MalformedStreamException, IOException
	{
		//System.out.println(header);
		header = Outils.replaceAll(header, "\r", "");
		String s = Outils.getTextBetweenOptional(header, "name=\"", "\n");
		// TODO c pourri mais cela m'enerve !!
		return s.substring(0, s.length()-1);
	}

	
	public static String getParameterDataValue(MultipartStream multipartStream, String header) 
	throws MalformedStreamException, IOException
	{
		ByteArrayOutputStream writer = new ByteArrayOutputStream();

		multipartStream.readBodyData((OutputStream)writer);
		writer.close(); 
		
		return writer.toString();
	}
	
	public void processParameterFile(
			MultipartStream multipartStream,
			String header,
			String sFilename) throws MalformedStreamException, IOException
	{
        File textFile = new File("C:\\temp\\" + System.currentTimeMillis() + "_" + System.nanoTime() + sFilename);
        FileOutputStream writer = new FileOutputStream(textFile);
       
        multipartStream.readBodyData((OutputStream)writer);
        writer.close();  
		
	}
	
	
	public void uploadFileUsingCOS(HttpServletRequest request, HttpServletResponse response)
	throws IOException
	{
		PrintWriter out = new PrintWriter(response.getOutputStream(),true);
		String sFileName ="";
		try {
			MultipartParser mp = new MultipartParser(request, Integer.MAX_VALUE, true, true);

			Part part;
			while ((part = mp.readNextPart()) != null)
			{
				System.out.println("part : " +part.getName() );
				if (part.isParam())
				{
					ParamPart param = (ParamPart)part;
					if (param.getName().equals("fileName"))
					{
						sFileName = param.getStringValue();
					}
					if (param.getName().equals("contentType"))
					{
						System.out.println("contentType : " + param.getStringValue());
					}
					if (param.getName().equals("sizeFile"))
					{
						System.out.println("sizeFile : " + Math.round(Float.parseFloat(param.getStringValue())));
					}
				}
				if (part.isFile())
				{
					FilePart file = (FilePart)part;
					if (file.getName().equals("file"))
					{
						
						FileUtil.convertInputStreamInFile(
								file.getInputStream(), 
								new File("c:\\" + System.currentTimeMillis() + sFileName));
						
						
					}
				}
			}
    		//CONFIRMATION RECEPTION DE L'ENVELOPPE
			out.println("true");
		}
		catch (Exception e) 
		{
    		//UPLOAD ERROR
			out.println(e.getMessage());
		}
	}
	
	 protected byte[] getBoundary(String contentType)
	    {
	        ParameterParser parser = new ParameterParser();
	        parser.setLowerCaseNames(true);
	        // Parameter parser can handle null input
	        Map params = parser.parse(contentType, ';');
	        String boundaryStr = (String) params.get("boundary");

	        if (boundaryStr == null) {
	            return null;
	        }
	        byte[] boundary;
	        try {
	            boundary = boundaryStr.getBytes("ISO-8859-1");
	        } catch (UnsupportedEncodingException e) {
	            boundary = boundaryStr.getBytes();
	        }
	        return boundary;
	    } 
	
}
