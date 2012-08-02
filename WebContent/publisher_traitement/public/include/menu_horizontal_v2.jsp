<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.ui.Border"%>

<%@page import="mt.modula.site.ModulaDematSiteNational"%>
<table width="100%" style="margin:0 auto;width:750px" >
<tr>
<td >
<div class="header-login"  style="text-align:center">


<%
	Border b2 = new Border("eeeeee", 7,request);
	b2.setStyle("width:auto");
	b2.setColorBorder("aaaaaa");
	
	
	String ua = request.getHeader("User-Agent");
	boolean isIE = (ua != null && ua.indexOf("MSIE") != -1);	
%>

<% if (isIE){ %>
<%=b2.getHTMLTop() %>
<%}else{ %>
<div style="display:inline-block;border-radius:7px;-webkit-border-radius:7px;-moz-border-radius:7px;background-color:#eee;border:1px solid #aaa">
<%} %>

<div class="mainMenu" style="padding:5px 10px 5px 10px;text-align: center; "  >
	    <table class="header-menu" ><tr>
<%
if(Configuration.isTrueMemory("publisher.portail.main.menu.button.home.show",true))
{
%>
	    	<td>
	    		<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath+ "publisher_portail/index.jsp")%>">
					<img class="middle" alt="Accueil" src="<%=rootPath+"images/icons/36x36/gohome.png"  %>"/>
					Accueil
				</a>
			</td>
<%
}


	String sHotLineNumberPaveMenuHorizontal = "08 92 23 02 41";
	try {
		sHotLineNumberPaveMenuHorizontal = Configuration.getConfigurationValueMemory("publisher.portail.hotline.number");
	} catch (Exception e) { }
	
	String sHotLinePriceMenuHorizontal = "0,34&euro; /min";
	try {
		sHotLinePriceMenuHorizontal = Configuration.getConfigurationValueMemory("publisher.portail.hotline.price");
		sHotLinePriceMenuHorizontal = Outils.replaceAll(sHotLinePriceMenuHorizontal, "&amp;" , "&");
	} catch (Exception e) {}


%>
<%
if(!ModulaDematSiteNational.isSite())
{
%>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath+ "publisher_portail/public/annonce/afficherAnnonces.jsp")%>">
					<img class="middle" alt="Afficher les annonces" src="<%=rootPath+"images/icons/36x36/affair_newspapers.png"  %>"/>
		        	Annonces
	        	</a>
			</td>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/displayAssistance.jsp")%>">
					<img style="vertical-align:middle" alt="Assistances" src="<%=rootPath+"images/icons/36x36/help_index.png" %>"/>
					Assistance
				</a>
			</td>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/displayToolbox.jsp")%>">
					<img style="vertical-align:middle" alt="Boîte à outil" src="<%=rootPath+"images/icons/36x36/toolbox.png" %>"/>
					Boîte à outils
				</a>
			</td>
			<td>
				<table>
				<tr>
				<td>
					<a href="<%= response.encodeURL(rootPath + "publisher_portail/public/pagesStatics/assistance/hotline.jsp")%>">
						<img style="vertical-align:middle" alt="Hotline" src="<%=rootPath+"images/icons/36x36/hotline.png" %>"/>
					</a>
				</td>
				<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/pagesStatics/assistance/hotline.jsp")%>">Hotline</a>
				<br/>
				<font><%= sHotLineNumberPaveMenuHorizontal %> (<%= sHotLinePriceMenuHorizontal %>)</font>
				</td>
				</tr>
				</table>
			</td>
		
<%
} else { 
%>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath+ "publisher_portail/public/annonce/afficherAnnonces.jsp")%>">
					<img class="middle" alt="Afficher les annonces" src="<%=rootPath+"images/icons/36x36/affair_newspapers.png"  %>"/>
		        	Annonces
		        </a>
			</td>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/displayAssistance.jsp")%>" style="font-size:12px">
					<img style="vertical-align:middle" alt="Assistances" src="<%=rootPath+"images/icons/36x36/help_index.png" %>"/>
					<br/>
					Assistance-Formations
				</a>
			</td>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/displayPartners.jsp")%>" style="font-size:12px">
					<img style="vertical-align:middle" alt="Boîte à outil" src="<%=rootPath+"images/icons/36x36/toolbox.png" %>"/>
					<br/>
					Partenaires-Références
				</a>
			</td>
			<td>
				<a class="iconeMenuTop" href="<%= response.encodeURL(rootPath + "publisher_portail/public/pagesStatics/assistance/hotline.jsp")%>" style="font-size:12px">
					<img style="vertical-align:middle" alt="Hotline" src="<%=rootPath+"images/icons/36x36/hotline.png" %>"/>
					<br/>
					Contact
				</a>
				<br/>
				<span style="white-space:nowrap;"><%= sHotLineNumberPaveMenuHorizontal %> (<%= sHotLinePriceMenuHorizontal %>)</span>
			</td>
<%
} 
%>
		</tr></table>
	</div>
	

<% if (isIE){ %>
<%=b2.getHTMLBottom() %>
<%}else{ %>
</div>
<%} %>
	

</div>
</td>
</tr>
</table>
