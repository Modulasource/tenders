<%@ include file="../../../../include/new_style/headerPublisher.jspf" %>
<%@ page import="modula.graphic.*,org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
if (organisation.getIdCreateur() == candidat.getIdPersonnePhysique())
{
	String sFormPrefix = "";
	
	PersonnePhysique personne = new PersonnePhysique ();
	Adresse adresse = new Adresse();
	Pays pays = new Pays();
	try
	{
		adresse = Adresse.getAdresse(organisation.getIdAdresse());
		pays = Pays.getPays(adresse.getIdPays() );
	}
	catch(Exception e){}
	
	String sTitle ="Ajout d'une personne à l'organisation "+organisation.getRaisonSociale();
%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script type="text/javascript">
<%@ include file="../../../publisher_traitement/private/organisation/ajouterPersonnePhysique.jspf" %>
</script>
</head>
<body>
<%@ include file="../../../publisher_traitement/public/include/header.jspf" %>
<div class="titre_page"><%= sTitle %></div>
<div style="clear:both"></div>
<br />
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<form action="<%= response.encodeURL(rootPath+"publisher_traitement/private/organisation/ajouterPersonnePhysique.jsp")
    %>" method="post" enctype="application/x-www-form-urlencoded" 
    name="formulaire" onsubmit="return checkForm()">
<div class="mention">
La personne que vous allez inscrire va recevoir son identifiant et son mot de passe par email.
Elle pourra répondre à des offres au nom de votre entreprise.
<br /><br />
Les champs marqués d'un * sont obligatoires
</div>
<br />
<a name="ancreError"></a>
<div class="rouge" style="text-align:left" id="divError"></div>
<%@ include file="../../../publisher_traitement/private/organisation/pave/pavePersonnePhysiqueInfosForm.jspf" %>
<br />
<% String sPaveAdresseTitre = "Adresse"; %>
<%@ include file="../../../publisher_traitement/private/organisation/pave/paveAdresseForm.jspf" %>
<br />
<div style="text-align:center">
	<button type="submit" >Valider</button>&nbsp;
	<button type="reset" onclick="Redirect('<%=
		response.encodeURL("afficherOrganisation.jsp?iIdOnglet="+Onglet.ONGLET_ORGANISATION_PERSONNES) 
		%>')" >Annuler</button>
</div>
</form>
<%@include file="../../../publisher_traitement/public/include/footer.jspf"%>
</body>		
<%
}
else
	response.sendRedirect(response.encodeRedirectURL("afficherOrganisation.jsp"));
%>

<%@page import="mt.modula.JavascriptVersionModula"%></html>