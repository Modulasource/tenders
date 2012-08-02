package org.coin.servlet;

import java.awt.*;
import java.awt.geom.Arc2D;
import java.awt.image.*;
import java.io.IOException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.imageio.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.coin.util.HttpUtil;
import org.coin.util.Outils;

public class RoundedCorner extends HttpServlet {
    
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
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		int iX = 0;
		int iY = 0;
		int iWidth = HttpUtil.parseInt("w", request, 5);
		int iHeight = HttpUtil.parseInt("h", request, 5);
		int iBorderSize = HttpUtil.parseInt("bz", request, 1);
		int iTransparency = HttpUtil.parseInt("a", request, 100);
		String sOrientation = HttpUtil.parseString("o", request, "tl").toLowerCase();
		boolean bEnableAntiAlias = HttpUtil.parseBoolean("aa", request, true);
		
		String sCouleur = HttpUtil.parseString("c", request, "000000").toUpperCase();
		Color color = getColorFromHexa(sCouleur, iTransparency);
		
		String sBackground = HttpUtil.parseString("bgc", request, "").toUpperCase();
		
		String sBorderColor = HttpUtil.parseString("bc", request, "").toUpperCase();

		int iOrientation = 0;
		if (sOrientation.equals("tl") || sOrientation.equals("lt")){
			iOrientation = 90;
			iX = 0;
			iY = 0;
		}else if (sOrientation.equals("tr") || sOrientation.equals("rt")){
			iOrientation = 0;
			iX = -iWidth;
			iY = 0;
		}else if (sOrientation.equals("bl") || sOrientation.equals("lb")){
			iOrientation = 180;
			iX = 0;
			iY = -iHeight;
		}else{ // br
			iOrientation = 270;
			iX = -iWidth;
			iY = -iHeight;
		}
        response.setContentType("image/png");

        // Create image
        // Pour une image transparente : BufferedImage.TYPE_INT_ARGB sinon TYPE_INT_RGB
        BufferedImage image = null;
        if(Outils.isNullOrBlank(sBackground))
        	image = new BufferedImage(iWidth, iHeight, BufferedImage.TYPE_INT_ARGB);
        else
        	image = new BufferedImage(iWidth, iHeight, BufferedImage.TYPE_INT_RGB);

        // Get drawing context
        Graphics2D g2d = image.createGraphics();
        //g2d.setRenderingHint(RenderingHints.KEY_RENDERING, RenderingHints.VALUE_RENDER_QUALITY);
        //g2d.setRenderingHint(RenderingHints.KEY_ALPHA_INTERPOLATION, RenderingHints.VALUE_ALPHA_INTERPOLATION_QUALITY);
        if(bEnableAntiAlias)
        	g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        else
        	g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_OFF);
                
        if(!Outils.isNullOrBlank(sBackground)){
        	Color bgColor = getColorFromHexa(sBackground, iTransparency);
        	g2d.setColor(bgColor);
        	g2d.fillRect(iX, iY, iWidth*2, iHeight*2);
        }
        
        g2d.setColor(color);
        g2d.fillArc(iX, iY, iWidth*2, iHeight*2, iOrientation, 90);

		if (!sBorderColor.equals("")){
			Color colBorderColor = getColorFromHexa(sBorderColor, iTransparency);
			//g2d.setColor(Color.RED);
	        g2d.setColor(colBorderColor);
	        //g2d.drawArc(iX, iY, iWidth*2 -1, iHeight*2 -1, iOrientation, 90);
	        //g2d.setColor(Color.GRAY);
	        //g2d.drawRect(0, 0, iWidth, iHeight);
	        //Arc2D arc = new Arc2D.Double(-1.0, -1.0, 2.0, 2.0, 0.0, 90.0, Arc2D.PIE);
	        BasicStroke wideStroke = new BasicStroke(0.8f*iBorderSize);
	        g2d.setStroke(wideStroke);
	        Arc2D arc2 = new Arc2D.Double(iX, iY, iWidth*2 -1, iHeight*2 -1, iOrientation, 90, Arc2D.OPEN);
	        g2d.draw(arc2);
	        
		}
		
        // Dispose context
        g2d.dispose();
        // Write image to the output stream
        ServletOutputStream os = response.getOutputStream();        
        ImageIO.write(image, "png", os);
    }
}