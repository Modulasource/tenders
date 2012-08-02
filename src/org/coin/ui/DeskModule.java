package org.coin.ui;

public class DeskModule {
	
	protected String sTitle;
	protected Border border = new Border("C3D9FF", 5,null);
	
    public DeskModule(String sTitle) {
    	this.sTitle = sTitle;
    }
	
	public String getHTMLTop() {
		String sHTML = "<div style='padding:6px'>"+border.getHTMLTop();
		sHTML += "<div style='background-color:#F1F4FA;border:1px solid #BBB'>"
			  + "<div style='border:1px solid #FFF'>"
			  + "<div style='font-size:12px;font-weight:bold;padding:3px 6px 3px 6px;background-color:lightyellow'>"	
			  + this.sTitle
			  + "</div>";
		return sHTML;
	}
	
	public String getHTMLBottom() {
		return "</div></div>"+ border.getHTMLBottom()+"</div>";
	}
	
}	