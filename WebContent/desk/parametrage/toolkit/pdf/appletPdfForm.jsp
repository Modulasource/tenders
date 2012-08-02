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

ICI Mettre l'applet,trouver comment lancer cutePdf en ligne de commande

<input type="checkbox" /> Signer avec P12<br/>
<input type="checkbox" /> Signer avec Navigation<br/>
<input type="checkbox" /> Signer avec token USB<br/>
<input type="checkbox" /> Chiffrer PDF<br/>


<button type="submit">Envoyer</button>

</form>




</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
