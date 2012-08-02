<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<% 
	String sTitle = "Génération PDF";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">


<br/>
<br/>
<br/>
<br/>

<form action="<%= response.encodeURL(
			rootPath + "") %>" method="post" 
	enctype="multipart/form-data" 
	name="formulaire">

PDF 1 : <input type="file" ><br/>
PDF 2 : <input type="file" ><br/>
<input type="checkbox" /> ajouter premiere page de CR<br/>



<button type="submit">Envoyer</button>

</form>




</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
