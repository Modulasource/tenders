package org.coin.servlet;

import javax.servlet.http.*;

import java.util.*;
import java.io.*;

/**
 * @author julien
 *
 */
public class AppletServletCommunication extends HttpServlet
{
	private static final long serialVersionUID = 3257844372597651248L;
	
	public static void sendVectorResponse(HttpServletResponse resp, Vector v)
	{
	     ObjectOutputStream sortie;
	     
	     try
	     {
    		sortie = new ObjectOutputStream(resp.getOutputStream());
    		sortie.writeObject(v);
    		sortie.close();
	     }
	     catch (IOException e)
	     {
	       e.printStackTrace(); 
	     }
	}

}
