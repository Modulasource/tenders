<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<% 
	String sTitle = "Toolkit Scan";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">


<br/>
<br/>
<br/>
<br/> 

<applet
code="mt.modula.applet.AppletSynchroExcel.class"
archive="<%= rootPath + "include/jar/SExcelApplet.jar" %>"
width ="800"
height="550"
>
</applet>


</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
