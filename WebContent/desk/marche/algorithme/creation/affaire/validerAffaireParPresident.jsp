<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,org.coin.util.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Authentification de l'intégrité de l'affaire";
	String sPageUseCaseId = "IHM-DESK-AFF-CRE-6"; 
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	int iIdNextPhaseEtapes = -1;
	if(request.getParameter("iIdNextPhaseEtapes") != null)
		iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
	
	boolean bIsContainsAAPCPublicity = AffaireProcedure.isContainsAAPCPublicity(marche.getIdAlgoAffaireProcedure());
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	String sDivValidationStyle = "";
	String sPoursuivreProcedureBtn = "";
	String sAction = "";
%>
<script type="text/javascript">
<!--

	function afficherBoutonPoursuivre(id, btn)
	{
		$(btn).disabled = (id.checked) ? false : true;
	}
	
//-->
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% 
	String sHeadTitre = "Validation de l'affaire";
	boolean bAfficherPoursuivreProcedure = false;
%>
<%
	if (iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_PETITE_ANNONCE ){
%>
<%@ include file="/desk/include/headerPetiteAnnonce.jspf" %>
<%
	}
	else{
%><%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %><%
	}

	marche.setLectureSeule(true);
	marche.setAffaireValidee(true);
	int iIdPhaseEtapesCourante = marche.getIdAlgoPhaseEtapes();
	try
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	marche.setDateModification(new Timestamp(System.currentTimeMillis()));
	try
	{
		marche.store();
		sMessTitle = "Succ&egrave;s de l'&eacute;tape";
		sMess = InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_VALIDATION_PRESIDENT);
		sUrlIcone = Icone.ICONE_SUCCES;
		modula.journal.Evenement.addEvenement(
				marche.getIdMarche(), 
				"IHM-DESK-AFF-CRE-6", 
				sessionUser.getIdUser(),
				"Validation du marche ref."+marche.getReference());
		
		//evenement comptable
		modula.journal.Evenement.addEvenement(
				marche.getIdOrganisationFromMarche(), 
				"IHM-DESK-PROC-004", 
				sessionUser.getIdUser(),
				"Validation de l'AAPC : "
				+ UseCase.getUseCaseNameMemory(
						AffaireProcedure.getAffaireProcedureMemory(
								marche.getIdAlgoAffaireProcedure()).getIdUseCase()));

		/*
		if (iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_NEGOCIE){
			
			Vector<Candidature> vCandidature = Candidature.getAllCandidatureFromMarche(iIdAffaire);
			Vector<Candidature> vCandidaturePapier = new Vector<Candidature> ();
			for(int i=0;i<vCandidature.size();i++)
			{	
				Candidature candidature = vCandidature.get(i);
				if(candidature.isCandidaturePapier(false))
				{
					vCandidaturePapier.add(candidature);
				}
				
			}
			
				sMess += "<br/><br/><br/><img src=" + 
				rootPath +
				Icone.ICONE_WARNING 
				+ " />Attention, après cette étape vous ne pourrez plus créer de candidatures papiers.<br/>";
				
			if(vCandidature.size() == 0)
			{
				sMess += "<input type='checkbox' onclick='afficherBoutonPoursuivre(this,\"divPoursuivreProcedure\");' /> "
				+ "poursuivre sans candidature papier.";
			
				sPoursuivreProcedureBtn= "disabled=\"disabled\"";
				
			}
			
			
		}
		*/

	}
	catch(Exception e)
	{
		sMessTitle = "Echec de l'&eacute;tape";
		sMess = InfosBulles.getInfosBullesContenuMemory(MarcheConstant.MSG_ERROR_VALIDATION_PRESIDENT);
		sUrlIcone = modula.graphic.Icone.ICONE_ERROR;
		marche.setLectureSeule(false);
		marche.setAffaireValidee(false);
		try
		{
			marche.setIdAlgoPhaseEtapes(iIdPhaseEtapesCourante);
		}
		catch(Exception e1)
		{
			e1.printStackTrace();
		}
	}
	
	
	
%>
<div align="center">
<table summary="none" width="100%">
	<tr>
    	<td style="vertical-align:top">
<%@ include file="/include/message.jspf" %>
<div style="text-align:center;<%= sDivValidationStyle  %>" >
<%
	String sButton = "Poursuivre la procédure";
	if(bIsContainsAAPCPublicity)
		sButton = "Publier l'affaire";
%>
	<button id="divPoursuivreProcedure" <%= sPoursuivreProcedureBtn %> 
		onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
				+ "?sAction=next"
				+ "&iTesterConditions=0"
				+ "&iIdAffaire=" + marche.getId()) 
		%>')"><%= sButton %></button>&nbsp;&nbsp;
</div>
</div>
		</td>
	</tr>
</table>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.candidature.Candidature"%>
<%@page import="org.coin.bean.UseCase"%>
<%@page import="java.sql.Timestamp"%>
</html>