<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Test Antivirus";
    String sPageUseCaseId = "IHM-PUBLI-3";  
    String sMention = "Cet outil est un anti-virus.<br /><br />";
    sMention += "Il vous permet de tester si vos fichiers contiennent un virus ou non.<br /><br />";
    sMention += "Vous pouvez tester des fichiers binaires, des fichiers zippés, des e-mails entiers ou tout autre fichier que vous souhaitez vérifier.<br /><br />";

    String sClamAVVersion = "";
    try{sClamAVVersion = ClamAV.getVersion();}
    catch(Exception e){}
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<form name="scan" method="post" action="<%=response.encodeURL("scan.jsp")%>" enctype="multipart/form-data" >
<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Assistance / Scan</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
  <table class="fullWidth">
	<tr>
		<td class="pave_titre_gauche"><%= sTitle %></td>
		<td class="pave_titre_droite"><%= sClamAVVersion %></td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td class="mention" colspan="2"><%= sMention %></td></tr>
	<tr><td colspan="2"><input type="file" name="sFilePath" value="" size="50" /></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2"><button type="submit" >Scanner</button></td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
   </table>
</div>
</div>
</form>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>