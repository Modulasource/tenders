<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.document.*" %>
<%
    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
    Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Générateur de documents officiels";
	String sPageUseCaseId = "IHM-DESK-GED-004";
	
	Vector<Document> vDocumentsOfficiels = Document.getAllDocumentOfficielsFromOrganisation(marche.getIdOrganisationFromMarche());
	Vector<Document> vDocumentsGeneres = Document.getAllDocumentGeneresFromAffaire(iIdAffaire);	
	
	String sHeadTitre = sTitle; 
	boolean bAfficherPoursuivreProcedure = false;
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body onload="cacher('divMessageGeneration');">
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br/>
<div id="divMessageGeneration" class="mention" style="text-align:center">
Veuillez patentier, génération du document en cours...
</div>
<br />
<%@ include file="pave/paveDocumentsOfficiels.jspf" %>
<br />
<%@ include file="pave/paveDocumentsGeneres.jspf" %>
<br />
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="modula.marche.Marche"%>
</html>
