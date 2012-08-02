<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%
	String sTitle = "Prévenir les candidats de l'annulation du marché";
	Connection conn = ConnectionManager.getConnection();
    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
    Marche marche = Marche.getMarche(iIdAffaire);
    
	int otAffaire = ObjectType.AFFAIRE ;
	marche.setAnnulationAffairePubliee(true);
	marche.store(conn);

	MailCandidature mc = new MailCandidature();
	mc.prevenirCandidatAnnulationAffaire(
			marche.getIdMarche(),
			request.getParameter("objet"),
			"",
			request.getParameter("contenuMail"),
			sessionUser, 
			conn);
	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%
	String sMessTitle = "";
	String sUrlIcone = "";
	if(mc.iErreur == 0)
	{
		sMessTitle = "Succès de l'étape";
		sUrlIcone = Icone.ICONE_SUCCES;
		marche.setCandidatsPrevenusAnnulationAffaire(true);
	}
	if(mc.iErreur > 0)
	{
		sMessTitle = "Echec de l'étape";
		sUrlIcone = Icone.ICONE_ERROR;
	}
	if(mc.iErreur == 0 && mc.vCandidatures.size() == 0)
	{
		sMessTitle = "Etape non effectuée";
		mc.sMess = "Il n'y a aucun candidat à prevenir";
		sUrlIcone = Icone.ICONE_WARNING;
		marche.setCandidatsPrevenusAnnulationAffaire(true);
	}
	marche.store(conn);
	
	ConnectionManager.closeConnection(conn);
	String sMess = mc.sMess;
%>
<%@ include file="/include/message.jspf" %>
<br />
<script type="text/javascript" src="<%= rootPath %>include/redirection.js"></script>

<script type="text/javascript">
function closeModalFrame()
{

    parent.redirectParentTabActive(
    '<%= 
        response.encodeURL(rootPath 
                + "desk/marche/algorithme/annulation/annulerAffaireForm.jsp"
                + "?iIdAffaire="+iIdAffaire)  %>');

   try {new parent.Control.Modal.close();}
   catch(e) { Control.Modal.close();}
}

</script>
<div style="text-align:center">
<button type="button" onclick="closeModalFrame()" >
Retour</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="modula.graphic.Icone"%>
</html>

