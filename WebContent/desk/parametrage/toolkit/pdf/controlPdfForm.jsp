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

<input type="file" ><br/>

<input type="checkbox" /> Contrôler présence mots clés : <input type="text" /><br/>
<input type="checkbox" /> Contrôler la signature, P12 : <input type="file" /><br/>



<button type="submit">Envoyer</button>

</form>




</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
