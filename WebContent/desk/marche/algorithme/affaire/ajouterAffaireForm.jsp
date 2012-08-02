<%@ include file="../../../../include/headerXML.jspf" %>
<%@ page import="modula.algorithme.*,org.w3c.dom.*,org.coin.util.*,modula.ws.marco.*"%>

<%@ include file="../../../include/beanSessionUser.jspf" %>
<%@ include file="../../../include/useBoamp17.jspf" %>
<%
	if(bUseBoamp17){
		response.sendRedirect(response.encodeRedirectURL("ajouterAffaireFormBoamp.jsp"));
		return;
	}
	String sSelected ;
	String sUrlCancel = "";
	String sFormPrefix = "";
	String sTitle = null;
	int iIdAffaire = -1;
	int iIdCommision = -1;
	String sAction = null;
	String rootPath = request.getContextPath()+"/";
	int iIdCommission = -1;
	String sPageUseCaseId = "IHM-DESK-AFF-1";

	if(!sessionUserHabilitation.isHabilitate(sPageUseCaseId))
	{
		// on test par rapport à son organisation
		sPageUseCaseId = "IHM-DESK-AFF-55";
	}
%>
<%@ include file="../../../include/checkHabilitationPage.jspf" %>
<% 
	sAction = "create";
	
	iIdAffaire = -1;
	
	sTitle = "Ajouter une affaire"; 
	String sIdAffaireMarco = null;
	MarcoAffaire aff = null;
	sUrlCancel = "afficherToutesAffaires.jsp" ;
	String sLibelle = "";
	String sNumeroAffaire = "";
	
	if ( (request.getParameter("iIdAffaire" ) != null) )
	{
		sIdAffaireMarco = request.getParameter("iIdAffaire");
		session.setAttribute("iIdAffaireMarco", "" + sIdAffaireMarco);
	
		Document doc;
		Node nodeData;
		int iIdAffaireMarco = -1;
		
		try {
			iIdAffaireMarco = Integer.parseInt(sIdAffaireMarco);
		} catch (Exception e) {
			System.out.println("ERROR : sIdAffaireMarco = " + sIdAffaireMarco);
			return;
		}
		
		ExportMarco export = new ExportMarco(iIdAffaireMarco ); 
		export.load();
	
		doc = BasicDom.parseXmlStream(export.getExport() , false); 
		if (doc != null)
		{
			nodeData =  BasicDom.getFirstChildElementNode(doc);
			MarcoAffaire.sLineFeedToUse = "\n";
			aff = new MarcoAffaire(BasicDom.getFirstChildElementNode(nodeData));
			sNumeroAffaire = aff.sNumeroAffaire;
			if (sNumeroAffaire == null) 
			{
				sNumeroAffaire = "";
			}
			else
			{
				// FLON : à déflonner
				sNumeroAffaire = org.coin.util.Outils.replaceAll(sNumeroAffaire, "\"", " ");
			}
		
			sLibelle = aff.sLibelle;
			if (sLibelle == null) 
			{
				sLibelle = "";
			}
			else
			{
				// FLON : à déflonner
				sLibelle = org.coin.util.Outils.replaceAll(sLibelle, "\"", " ");
			}

		}
	}

%>
<%@ include file="../../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<%@ include file="pave/ajouterAffaireForm.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<form name="formulaire" action="<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/modifierAffaire.jsp" ) %>" method='post' onSubmit="return checkForm();" >
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="iIdAffaireMarco" value="<%= sIdAffaireMarco %>" />
		<table class="pave" summary="none">
			<tr>
				<td class="pave_titre_gauche" colspan="2" >Renseignements sur l'organisation et la commission</td>
			</tr>
			<tr>
				<td colspan="2" >&nbsp;</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Organisme passant le marché* :</td>
				<td class="pave_cellule_droite">
					<input type="button" id="AJCL_but_iIdOrganisation" value="Cliquer ici pour sélectionner l'organisme" />
					<input type="hidden" id="iIdOrganisation" name="iIdOrganisation" />
               	 </td>
 			</tr>
 			<tr>
				<td class="pave_cellule_gauche">Commission* :</td>
				<td class="pave_cellule_droite">
					<select name="iIdCommission" id="iIdCommission" style="width:450px">
						<option selected="selected" value="">Sélectionnez la commission</option>
					</select>
 				</td>
 			</tr>
 			<tr>
 				<td class="pave_cellule_gauche" colspan="2">
 				* Champs obligatoires
 				</td>
 			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<br />
		<table class="pave" summary="none">
			<tr>
				<td class="pave_titre_gauche" colspan="2" >Renseignements sur l'affaire</td>
			</tr>
			<tr><td>&nbsp;</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">&nbsp;</td>
				<td class="pave_cellule_droite">Attention : la référence de l'affaire doit être unique</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Référence de l'affaire : </td>
				<td class="pave_cellule_droite"><input value="<%= sNumeroAffaire %>" name="sReference" size="100" /></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Objet de l'affaire : </td>
				<td class="pave_cellule_droite"><input value="<%= sLibelle %>" name="sObjet" size="100" /></td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Phase de démarrage : </td>
				<td class="pave_cellule_droite">
					<select name="iIdPhase" id="iIdPhase" style="min-width:60px;width:60px">
						<option selected="selected" value="<%= Phase.PHASE_CREATION %>">AAPC</option>
						<option value="<%= Phase.PHASE_CREATION_AATR %>">AATR</option>
					</select>
				</td>
			</tr>
			<tr><td>&nbsp;</td>
			</tr>
	</table>
	<br />
	<input type="submit" value="<%=sTitle %>" />
	<input type="button" value="Annuler" onclick="javascript:Redirect('<%=response.encodeRedirectURL(sUrlCancel) %>')" />
<%@ include file="../../../include/footerDesk.jspf"%>
</form>
</body>
</html>
