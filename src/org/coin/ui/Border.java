package org.coin.ui;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import org.coin.http.util.Browser;
import org.coin.util.Outils;

public class Border {
	
	protected String sColor;
	protected String sColorBorder;
	protected int iBorderSize = 1;
	protected int iRadius;
	protected int iTransparency = 100;
	protected boolean isIE = false;
	protected boolean bUseBorderUnrounded = false;
	protected String sStyles = "width:100%";
    protected Vector<String> vClass;
    protected String sBackgroundColor;
    protected String sId;
    /**
     * tblr : tout les angles sont arrondis
     * blr : bottom left right
     * tbl : top bottom left
     * tbr : top bottom right
     */
    protected String sOrientation = "tblr";
    
    public static String rootPath = "";
      
    public Border(String sColor, int iRadius, int iTransparency,String sOrientation,HttpServletRequest req) {
    	init(sColor, iRadius, iTransparency,sOrientation,req);
    }
    
    public Border(String sColor, int iRadius, int iTransparency, HttpServletRequest req) {
    	init(sColor, iRadius, iTransparency,req);
    }
    
    public Border(String sColor, int iRadius,HttpServletRequest req) {
    	init(sColor, iRadius,req);
    }
    
    public void init(String sColor, int iRadius, int iTransparency,String sOrientation,HttpServletRequest req){
    	this.sOrientation = sOrientation;
    	init(sColor, iRadius,iTransparency,req);
    }
    
    public void init(String sColor, int iRadius, int iTransparency,HttpServletRequest req){
    	this.iTransparency = iTransparency;
    	init(sColor, iRadius,req);
    }
    
    public void init(String sColor, int iRadius,HttpServletRequest req){
    	this.sColor = sColor;
    	this.sColorBorder = "";
    	this.iRadius = iRadius;
    	this.sId = "";
    	rootPath = req.getContextPath()+"/";
    	
    	if(req != null){
	    	String s = req.getHeader("user-agent");
	    	if (s.indexOf("MSIE") > -1) {
		    	Browser b = new Browser(req);
		    	Float version = Float.parseFloat(b.getVersion());
		    	if (version<7){
		    		isIE = true;
		    	}
	    	}
    	}
    }
    
	public void addClass(String s) {
		vClass.add(s);
	}
	
	public void setStyle(String s) {
		sStyles = s;
	}
	
	public void setId(String s) {
		sId = s;
	}
	
	public void setColor(String s) {
		sColor = s;
	}
	public void setColorBorder(String s) {
		sColorBorder = s;
	}
	public void setBackgroundColor(String s) {
		this.sBackgroundColor = s;
	}
	public void setOrientation(String s) {
		this.sOrientation = s;
	}
	public void setRadius(int i) {
		iRadius = i;
	}
	
	public int getBorderSize() {
		return iBorderSize;
	}

	public void setBorderSize(int iBorderSize) {
		this.iBorderSize = iBorderSize;
	}
	
	public boolean isUseBorderUnrounded() {
		return this.bUseBorderUnrounded;
	}

	public void setUseBorderUnrounded(boolean bUseBorderUnrounded) {
		this.bUseBorderUnrounded = bUseBorderUnrounded;
	}
	
	public String getHTMLTop() {
		String sStyle = (this.sStyles.equals(""))?"":" style='"+this.sStyles+"'";
		String sId = (this.sId.equals(""))?"":" id='"+this.sId+"'";
		String sBColor = (this.sColorBorder.equals(""))?"":("&bc=" + this.sColorBorder);
		String sBColorFillTop = (this.sColorBorder.equals(""))?"":("border-top:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");
		String sBColorFillLeft = (this.sColorBorder.equals(""))?"":("border-left:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");
		String sBColorFillRight = (this.sColorBorder.equals(""))?"":("border-right:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");

		String sTop = "<table "+sId+"class='rc'"+sStyle+"><tr>";

		/**
		 * soit on cree l'angle top left
		 * soit on met des bordures gauche et haut sans angle
		 */
		if(this.sOrientation.contains("t")&&this.sOrientation.contains("l")){
			sTop += getRoundedTD(sBColor, "tl");
		}else{
			String sBorder = "";String sOrientation = "";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("t")))
				sBorder += sBColorFillTop;
			if(this.bUseBorderUnrounded&&(this.sOrientation.contains("t")))
				sOrientation += "t";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("l")))
				sBorder += sBColorFillLeft;
			sTop += getFillTD(sBColor,sBorder , sOrientation);
		}
		
		/**
		 * on ajoute une bordure top
		 */
		String sBorderMiddle = "";
		String sOrientationMiddle = "";
		if(this.sOrientation.contains("t")){
			sOrientationMiddle = "t";
		}else if(this.bUseBorderUnrounded){
			sBorderMiddle += sBColorFillTop;
			sOrientationMiddle += "t";
		}
		sTop += getFillTD(sBColor, sBorderMiddle, sOrientationMiddle);
		
		/**
		 * soit on cree l'angle top right
		 * soit on met des bordures droite et haut sans angle
		 */
		if(this.sOrientation.contains("t")&&this.sOrientation.contains("r")){
			sTop += getRoundedTD(sBColor, "tr");
		}else{
			String sBorder = "";String sOrientation = "";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("t")))
				sBorder += sBColorFillTop;
			if(this.bUseBorderUnrounded&&(this.sOrientation.contains("t")))
				sOrientation += "t";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("r")))
				sBorder += sBColorFillRight;
			sTop += getFillTD(sBColor,sBorder , sOrientation);
		}
		
		sTop += "</tr><tr>";
		
		/**
		 * on ajoute une bordure left
		 */
		String sBorder = "";
		String sOrientation = "l";
		if(this.bUseBorderUnrounded&&!this.sOrientation.contains("l")){
			sBorder += sBColorFillLeft;
			sOrientation = null;
		}
		sTop += getFillTD(sBColor, sBorder, sOrientation);

		sTop += getFillTDOpen();
		
		return sTop;
	}
	public String getHTMLBottom() {
		String sBColor = (this.sColorBorder.equals(""))?"":("&bc=" + this.sColorBorder);
		String sBColorFillBottom = (this.sColorBorder.equals(""))?"":("border-bottom:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");
		String sBColorFillRight = (this.sColorBorder.equals(""))?"":("border-right:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");
		String sBColorFillLeft = (this.sColorBorder.equals(""))?"":("border-left:"+this.iBorderSize+"px solid #"+ this.sColorBorder+";");
		
		String sBottom = "</td>"
		+ (this.sOrientation.contains("r")||this.bUseBorderUnrounded?getFillTD(sBColor, sBColorFillRight, "r"):getFillTD())
		+ "</tr><tr>";
	
		/**
		 * soit on cree l'angle bottom left
		 * soit on met des bordures gauche et bas sans angle
		 */
		if(this.sOrientation.contains("b")&&this.sOrientation.contains("l")){
			sBottom += getRoundedTD(sBColor, "bl");
		}else{
			String sBorder = "";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("b")))
				sBorder += sBColorFillBottom;
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("l")))
				sBorder += sBColorFillLeft;
			sBottom += getFillTD(sBColor,sBorder , null);
		}
		
		sBottom += getFillTD(sBColor, (this.sOrientation.contains("b")||this.bUseBorderUnrounded?sBColorFillBottom:null), "b");
		
		if(this.sOrientation.contains("b")&&this.sOrientation.contains("r")){
			sBottom += getRoundedTD(sBColor, "br");
		}else{
			String sBorder = "";
			if(this.bUseBorderUnrounded&&(!this.sOrientation.contains("b") || !this.sOrientation.contains("r")))
				sBorder += sBColorFillBottom+sBColorFillRight;
			sBottom += getFillTD(sBColor,sBorder , "br");
		}
		
		sBottom += "</tr></table>";
		return sBottom;
	}
	
	private String getFillTD(){
		return getFillTD(null, null, null);
	}
	private String getFillTDOpen(){
		return getFillTD(null, null, null,false);
	}
	private String getFillTD(String sBColor, String sBColorFill, String sOrientation){
		return getFillTD(sBColor, sBColorFill, sOrientation,true);
	}
	private String getFillTD(String sBColor, String sBColorFill, String sOrientation, boolean bCloseTD){
		return "<td style='background:url("+rootPath+"Fill?"
		+ "w="+this.iRadius
		+ "&h="+this.iRadius
		+ "&c="+this.sColor
		+ (Outils.isNullOrBlank(sBColor)?"":sBColor) 
		+ (Outils.isNullOrBlank(sOrientation)?"":"&bco="+sOrientation) 
		+ "&bz="+this.iBorderSize
		+ "&a="+this.iTransparency+");" 
		+ (Outils.isNullOrBlank(sBColorFill)?"":sBColorFill) 
		+ "'>"
		+ ((bCloseTD)?"</td>":"");
	}
	
	// TODO : on dirait que la bordure de droite et d'en bas n'applique pas la transparence, et le fond est "strié" bizarrement
	private String getRoundedTD(String sBColor, String sOrientation){
		return "<td class='lh0' style='width:"+(this.iRadius)+"px;height:"+(this.iRadius)
		+ "px;background:url("+rootPath+"RoundedCorner?"
		+ "w="+this.iRadius
		+ "&h="+this.iRadius
		+ "&o="+sOrientation
		+ "&c="+this.sColor
		+ sBColor 
		+ "&bz="+this.iBorderSize
		+ "&a="+this.iTransparency
		+ (this.isIE?"&bgc="+this.sBackgroundColor:"") +")'></td>";
	}
}	