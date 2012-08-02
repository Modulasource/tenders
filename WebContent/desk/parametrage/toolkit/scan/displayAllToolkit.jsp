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
<button onclick="doUrl('<%= response.encodeURL("acquireTwain.jsp") %>')">Acquerir en Twain</button> <br/><br/>
<button onclick="doUrl('<%= response.encodeURL("transformImage.jsp") %>')">Manipuler image</button> <br/><br/>

</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
