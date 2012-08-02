package org.coin.servlet;

import java.io.BufferedInputStream;
import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class EchoServlet extends HttpServlet  {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(
			HttpServletRequest request, 
			HttpServletResponse response) 
	{
		try {
			ServletOutputStream out = response.getOutputStream () ; 
			BufferedInputStream in = new BufferedInputStream (request.getInputStream ()) ; 
			//out.println(request.getHeader ("content-type")) ; 
			int c = -1; 
			while  ((c=in.read ()) >= 0) {
				out.write (c) ;
				//System.out.println(c);
			}
			out.close () ; 
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 

	}
}
