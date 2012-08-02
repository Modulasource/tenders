<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Annuler définitivement le marché";
	boolean bAffaireValidee2 = marche.isAffaireValidee(false);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
	String sMess = "";
	String sMessTitle = "Succès";
	String sUrlIcone = Icone.ICONE_SUCCES;

	if(bAffaireValidee2){
		marche.setAffaireAnnulee(true);
		marche.setCandidaturesCloses(true);
		marche.setOffresCloses(true);
		marche.setAffaireArchivee(true);
		String sError = "";
		try{
			Vector<Validite> vValiditeAffaire = Validite.getAllValiditeAAPCFromAffaire(marche.getIdMarche());
			Validite validiteAffaire = vValiditeAffaire.firstElement();
			validiteAffaire.setDateFin(new Timestamp(System.currentTimeMillis()+(15*24*60*60*1000)));
			validiteAffaire.store();
		} catch (Exception e) {
			sError = "<br/>\n" + e.getMessage();
		}
		marche.store();
		sMess = "Votre affaire a été déclarée sans suite." + sError;
		
	}
	else
	{
		marche.removeWithObjectAttached();
		sMess = "Votre affaire a été intégralement supprimée.";
	}
%>
<%@ include file="/include/message.jspf" %>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.sql.Timestamp"%>
</html>
