<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="org.coin.bean.UserType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.util.*"%>
<%
	
	String sTitle = "Display session params";
	
	session.getAttributeNames();
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Session Parameters</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Session ID:</td>
		<td class="pave_cellule_droite" ><%= session.getId() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Creation date  :</td>
		<td class="pave_cellule_droite" ><%= new Timestamp (session.getCreationTime()) %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Last accessed time :</td>
		<td class="pave_cellule_droite" ><%= new Timestamp (session.getLastAccessedTime()) %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Max inactive interval :</td>
		<td class="pave_cellule_droite" ><%= session.getMaxInactiveInterval() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Character encoding :</td>
		<td class="pave_cellule_droite" ><%= request.getCharacterEncoding() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Content type :</td>
		<td class="pave_cellule_droite" ><%= request.getContentType() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Cookies :</td>
		<td class="pave_cellule_droite" ><%= request.getCookies() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche" >Auth type :</td>
		<td class="pave_cellule_droite" ><%= request.getAuthType() %></td>
	</tr>
</table>
	
<br/>

<%
	Enumeration names = session.getAttributeNames();


%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">Session attributes</td>
	</tr>
<%
	while (names.hasMoreElements()) 
	{ 
		String sAttrName = (String) names.nextElement();
%>	<tr>
		<td class="pave_cellule_gauche" ><%= sAttrName %>:</td>
		<td class="pave_cellule_droite" ><%= Outils.getTextToHtml(session.getAttribute(sAttrName).toString() ) %></td>
	</tr>
<%
	}
%>
</table>
	
<br/>
<%
	names = request.getAttributeNames();
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">User Agent attributes</td>
	</tr>
<%
	while (names.hasMoreElements()) 
	{ 
		String sAttrName = (String) names.nextElement();
%>	<tr>
		<td class="pave_cellule_gauche" ><%= sAttrName %>:</td>
		<td class="pave_cellule_droite" ><%= Outils.getTextToHtml(request.getAttribute(sAttrName).toString() ) %></td>
	</tr>
<%
	}
%>
</table>


<br/>
<%
	names = request.getHeaderNames();
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">User Agent header</td>
	</tr>
<%
	while (names.hasMoreElements()) 
	{ 
		String sAttrName = (String) names.nextElement();
%>	<tr>
		<td class="pave_cellule_gauche" ><%= sAttrName %>:</td>
		<td class="pave_cellule_droite" ><%= Outils.getTextToHtml(request.getHeader(sAttrName).toString() ) %></td>
	</tr>
<%
	}
%>
</table>

<br/>
<%
	names = request.getParameterNames();
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">User Agent parameter</td>
	</tr>
<%
	while (names.hasMoreElements()) 
	{ 
		String sAttrName = (String) names.nextElement();
%>	<tr>
		<td class="pave_cellule_gauche" ><%= sAttrName %>:</td>
		<td class="pave_cellule_droite" ><%= Outils.getTextToHtml(request.getParameter(sAttrName).toString() ) %></td>
	</tr>
<%
	}
%>
</table>

<br/>
<%
	names = request.getLocales();
	Locale preferredLocale = request.getLocale();
%>
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche" colspan="2">User Agent localization</td>
	</tr>
<%
	while (names != null && names.hasMoreElements()) 
	{ 
		Locale locale = (Locale) names.nextElement();
%>	<tr>
		<td class="pave_cellule_gauche" >Country <%= locale.getCountry() %>:</td>
		<td class="pave_cellule_droite" ><%= locale.toString() %></td>
	</tr>
<%
	}
%>
	<tr>
		<td class="pave_cellule_gauche" >Preferred locale :</td>
		<td class="pave_cellule_droite" ><%= preferredLocale.toString() %></td>
	</tr>

</table>

</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>

<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.Locale"%>
</html>