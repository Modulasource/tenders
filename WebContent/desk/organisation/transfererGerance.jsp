<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%
	String sTitle = "Transférer la gérance de l'organisation ";
	
	String sFormPrefix = "";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	
	int iIdOrganisation = -1;
	Organisation organisation = null;
	PersonnePhysique ppNouveauGerant = null;
	iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	organisation = Organisation.getOrganisation(iIdOrganisation);
	sTitle += organisation.getRaisonSociale();
	
	int iIdPersonnePhysiqueNouveauGerant = -1;
	try
	{
		iIdPersonnePhysiqueNouveauGerant = Integer.parseInt(request.getParameter("choixMembre"));
		ppNouveauGerant = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysiqueNouveauGerant);
	}
	catch(Exception e){iIdPersonnePhysiqueNouveauGerant = -1;}
	
	organisation.setIdCreateur(iIdPersonnePhysiqueNouveauGerant);
	organisation.store();
	
	sMessTitle = "Succès";
	sMess = "La personne physique d&eacute;finie ("+ppNouveauGerant.getCivilitePrenomNom()+
	") devient gérant de l'entreprise "+ organisation.getRaisonSociale();
	sUrlIcone = Icone.ICONE_SUCCES;	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf" %>
<div align="center">
	<button type="button" name="retour" 
	onclick="Redirect('<%=response.encodeRedirectURL(
			rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
					+organisation.getIdOrganisation()) %>')" >Retour à l'organisation</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>


