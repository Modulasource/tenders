package org.coin.servlet;

import java.awt.*;
import java.awt.image.*;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.coin.util.HttpUtil;

public class Fill extends HttpServlet {
    
	private static final long serialVersionUID = 1L;
	
	protected Color getColorFromHexa(String sHexa, int iTransparency){
		Color c = Color.BLACK;
		Pattern p = Pattern.compile("^#?([0-9A-F]{2})([0-9A-F]{2})([0-9A-F]{2})$",
				Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sHexa.trim());
		if (m.find() && m.groupCount()>0){
			c = new Color(
					Integer.parseInt(m.group(1), 16),
					Integer.parseInt(m.group(2), 16),
					Integer.parseInt(m.group(3), 16), (iTransparency*255/100)
					);
		}
		return c;
	}
	
	public void doGet(
			HttpServletRequest request, 
			HttpServletResponse response) 
	throws ServletException, IOException{
		
		try{

			int iWidth = HttpUtil.parseInt("w", request, 5);
			int iHeight = HttpUtil.parseInt("h", request, 5);
			int iTransparency = HttpUtil.parseInt("a", request, 100);
			int iBorderSize = HttpUtil.parseInt("bz", request, 1);
			String sCouleur = HttpUtil.parseString("c", request, "000000").toUpperCase();
			String sBorderColor = HttpUtil.parseString("bc", request, "").toUpperCase();
			String sBorderColorOrientation = HttpUtil.parseString("bco", request, "");
			//iHeight--;
			//iWidth--;
			Color color = getColorFromHexa(sCouleur, iTransparency);
			
	        response.setContentType("image/png");
	        
	        BufferedImage image = new BufferedImage(iWidth, iHeight, BufferedImage.TYPE_INT_ARGB);
	
	        // Get drawing context
	        Graphics2D g2d = image.createGraphics();
	        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
	        g2d.setColor(color);//color
	        g2d.fillRect(0, 0, iWidth, iHeight);
	        
	        if (!sBorderColor.equals("")){
	        	g2d.drawLine(0, 0, iWidth, iHeight);
	        	
				Color colBorderColor = getColorFromHexa(sBorderColor, iTransparency);
				g2d.setColor(colBorderColor);//colBorderColor
				
				BasicStroke wideStroke = new BasicStroke(0.8f*iBorderSize);
		        g2d.setStroke(wideStroke);
		        
				if(sBorderColorOrientation.contains("t"))
		        {
					g2d.drawLine(0, 0, iWidth, 0);
		        }
				if(sBorderColorOrientation.contains("l"))
		        {
					g2d.drawLine(0, 0, 0, iHeight);
		        }
				
				if(sBorderColorOrientation.contains("b"))
		        {
					 g2d.drawLine(0, iHeight, iWidth, iHeight);
		        }
				if(sBorderColorOrientation.contains("r"))
		        {
					g2d.drawLine(iWidth, 0,iWidth, iHeight);
		        }
				
		        //g2d.drawLine(0, iHeight, iWidth, iHeight);
		        //g2d.drawLine(iWidth, 0, iWidth, iHeight);
		        //g2d.drawLine(0, 0, iWidth, iHeight);
			}
	        
	        
	        g2d.dispose();
	
	        ServletOutputStream os = response.getOutputStream();
	        ImageIO.write(image, "png", os);
		} catch (Exception e) {
			e.printStackTrace();
		} catch (Error e) {
			e.printStackTrace();
		}
	}
}