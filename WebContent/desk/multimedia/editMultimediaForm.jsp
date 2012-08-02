<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.bean.*,org.coin.fr.bean.*,modula.*,java.io.*,modula.graphic.*" %>
<%
	String sTitle = "Edit Multimedia File";
	long lIdMultimedia = HttpUtil.parseLong("lId",request,0);
	Multimedia multi = null;
	try{
		multi = Multimedia.getMultimedia((int)lIdMultimedia, false);
	}catch(Exception e){
		multi = new Multimedia();
	}
	
	
	/**
	 * defined for Affiches de Grenoble
	 */
	String sEncoding = "ISO-8859-1";
	InputStream is = multi.getInputStreamMultimediaFile();
	String sText = FileUtil.convertInputStreamInString(
			is,
			sEncoding );
		
	is.close();

%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%=response.encodeURL("editMultimedia.jsp") %>">
<input type="hidden" name="lId" value="<%= multi.getId() %>" />
<table class="pave">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%=multi.getFileName() %></td>
	</tr>
	<tr>
		<td class="pave_cellule_droite" colspan="2">
			<textarea style="width:100%;height:400px;" name="content"><%= sText %></textarea> 
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="text-align:center">
			<button type="submit"><%= localizeButton.getValueModify() %></button>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>

<%@page import="org.coin.util.FileUtil"%></html>