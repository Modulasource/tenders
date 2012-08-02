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
code="uk.co.mmscomputing.application.imageviewer.MainApp.class"
archive="<%= rootPath + "include/jar/uk.co.mmscomputing.application.imageviewer.jar" %>"
width ="600"
height="450"
>
</applet>


</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
