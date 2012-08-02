<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<% 
	String sTitle = "Toolkit PDF";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">


<br/>
<br/>
<br/>
<br/>
<button onclick="doUrl('<%= response.encodeURL("generatePdfForm.jsp") %>')">Génération PDF</button> <br/><br/>
<button onclick="doUrl('<%= response.encodeURL("appletPdfForm.jsp") %>')">Applet PDF</button> <br/><br/>
<button onclick="doUrl('<%= response.encodeURL("controlPdfForm.jsp") %>')">Contrôle PDF</button> <br/><br/>
<button onclick="doUrl('<%= response.encodeURL("fusionPdfForm.jsp") %>')">Fusion PDF</button> <br/><br/>

</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
