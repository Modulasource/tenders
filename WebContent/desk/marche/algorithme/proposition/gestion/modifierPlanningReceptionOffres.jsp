<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="java.sql.*" %>
<%@ page import="org.coin.util.*,modula.journal.*,modula.algorithme.*" %>
<%@ page import="java.util.*,modula.marche.*" %>
<%@ page import="mt.modula.bean.mail.*" %>
<%
	Connection conn = ConnectionManager.getConnection();

	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire,conn);
	String sTitle = "Planning validé";
	String sMess = "Succès de l'étape";
	String sMessTitle = "";
	String sUrlIcone = Icone.ICONE_SUCCES;
	int iErreur = 0;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsConstituablesFromMarche(marche,conn);
	Vector<MarcheLot> vLotsTotal = MarcheLot.getAllLotsFromMarche(iIdAffaire,conn);
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sAction = HttpUtil.parseStringBlank( "sAction", request);
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-27");
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request,0);
	boolean bNegociation = HttpUtil.parseBoolean("bNegociation", request,  false);
	boolean bSendMailStage = HttpUtil.parseBoolean("bSendMailStage", request,  false);
	
	MarcheHttpTraitemenent.updatePlanningAndCandidature(marche, request, conn);

	ConnectionManager.closeConnection(conn);

	String sUrl = response.encodeURL(rootPath 
			+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
			+ "?sAction=next"
			+ "&iPreTraitement=" +iIdNextPhaseEtapes
			+ "&iIdAffaire="+iIdAffaire);
	
	if(bSendMailStage)
		sUrl = response.encodeURL(rootPath 
				+ "desk/marche/algorithme/proposition/gestion/envoyerMailInvitationOffreForm.jsp?bNegociation=true&amp;iIdNextPhaseEtapes="
				+ iIdNextPhaseEtapes
				+ "&amp;iIdAffaire=" + iIdAffaire
				+ "&amp;iIdOnglet="+iIdOnglet
				);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>

<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" 
			name="poursuivre"  
			class="disableOnClick"
			onclick="Redirect('<%= sUrl  %>');" >Poursuivre la procédure</button>&nbsp;

</div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.configuration.ModulaConfiguration"%>
<%@page import="org.coin.db.ConnectionManager"%>
</html>