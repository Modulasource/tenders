<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,modula.marche.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String sTitle = "Archiver le marché";
	String sMess = "";
	int iErreur = 0;
	int iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%
	String sHeadTitre = "Archiver le marché"; 
	boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
	// Il faut un test sur l'état initial du marché !!!!
	// voir avec l'algo modula pour faire un automate !
	try
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	}
	catch(Exception e)
	{
		System.out.println("Exception > archiverMarche.jsp: "+e.getMessage());
	}
	marche.setAffaireArchivee(true);
	try
	{
		marche.store();
	}
	catch(Exception e)
	{iErreur++;}
	if (iErreur == 0)
	{
		Evenement.addEvenement(marche.getIdMarche(),"IHM-DESK-AFF-20",sessionUser.getIdUser(),"Archivage du marché");
		String sMessTitle = "Succès de l'étape";
		sMess += InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_ARCHIVAGE_MARCHE,false);
		String sUrlIcone = Icone.ICONE_SUCCES;

		String sTargetURL = "afficherAffaire.jsp";
		try
		{
			if(marche.isAffaireAATR()) sTargetURL = "afficherAttribution.jsp";
		}
		catch(Exception e)
		{}
%>
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/"+ 
				sTargetURL +"?iIdOnglet=0&amp;iIdAffaire="+iIdAffaire) 
				%>')" >Retour à l'affaire</button>
</div>
<%
	}
	else
	{
		String sMessTitle = "Echec de l'étape";
		sMess += InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_ERROR_ARCHIVAGE_MARCHE);
		String sUrlIcone = Icone.ICONE_ERROR;
%>
<%@ include file="/include/message.jspf" %>
<%
	}
%>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>