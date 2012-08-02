<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,org.coin.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Authentification de l'intégrité de l'avis d'attribution";
	String sPageUseCaseId = "IHM-DESK-AATR-1"; 
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	int iIdNextPhaseEtapes = -1;
	if(request.getParameter("iIdNextPhaseEtapes") != null)
		iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
	
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% 
String sHeadTitre = "Validation de l'Avis d'Attribution";
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<%
	AvisAttribution avisAttribution = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	avisAttribution.setValide(true);
	avisAttribution.setLectureSeule(true);
	
	int iIdPhaseEtapesCourante = marche.getIdAlgoPhaseEtapes();
	try
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	}
	catch(Exception e)
	{
		System.out.println("Exception > validerAATRParPresident.jsp: "+e.getMessage());
	}
	marche.setDateModification(new Timestamp(System.currentTimeMillis()));
	
	try
	{
		marche.store();
		avisAttribution.store();
		sMessTitle = "Succ&egrave;s de l'&eacute;tape";
		sMess = InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_VALIDATION_PRESIDENT);
		sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
		modula.journal.Evenement.addEvenement(avisAttribution.getIdAvisAttribution(), "IHM-DESK-AATR-1", sessionUser.getIdUser(),"Validation de l'avis d'attribution du marché ref."+marche.getReference());
		
		//evenement comptable
		modula.journal.Evenement.addEvenement(marche.getIdOrganisationFromMarche(), "IHM-DESK-PROC-004", sessionUser.getIdUser(),"Validation de l'AATR : "+org.coin.bean.UseCase.getUseCaseNameMemory(AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdUseCase()));
	}
	catch(Exception e)
	{
		sMessTitle = "Echec de l'&eacute;tape";
		sMess = InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_ERROR_VALIDATION_PRESIDENT);
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		avisAttribution.setValide(false);
		try
		{
			marche.setIdAlgoPhaseEtapes(iIdPhaseEtapesCourante);
		}
		catch(Exception e1)
		{
			System.out.println("Exception > validerAATRParPresident.jsp: "+e1.getMessage());
		}
	}
%>

<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button"
		onclick="Redirect('<%= response.encodeURL(
				rootPath 
				+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
				+ "?sAction=next"
				+ "&iTesterConditions=0"
				+ "&iIdAffaire=" + marche.getId()) 
				%>')" >Publier l'Avis d'Attribution</button>&nbsp;&nbsp;
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.sql.Timestamp"%>
</html>