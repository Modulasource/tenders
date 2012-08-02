<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.algorithme.*,org.coin.autoform.component.*,java.util.*"%>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%

	String sSelected ;
	String sUrlCancel = "afficherToutesAffaires.jsp";
	String sFormPrefix = "";
	String sTitle = "Ajouter une affaire";
	int iIdCommision = -1;
	String sAction = "create";
	int iIdCommission = -1;
	String sPageUseCaseId = "IHM-DESK-AFF-1";
	Marche marche = new Marche();
	String sIdAffaireMarco = "";
	
	
	Vector<ArticleLoi> vArticleLoiMarche = null;
	if ( (request.getParameter("iIdAffaire" ) != null) )
	{
		sIdAffaireMarco = request.getParameter("iIdAffaire");
		session.setAttribute("iIdAffaireMarco", "" + sIdAffaireMarco);
		int iIdAffaireMarco = -1;
		try {
			iIdAffaireMarco = Integer.parseInt(sIdAffaireMarco);
			HashMap<String, Object> map = marche.setFromFormMarcoImport(iIdAffaireMarco);
			vArticleLoiMarche = (Vector<ArticleLoi>)map.get("vArticleLoi");
		} catch (Exception e) {
			System.out.println("ERROR : sIdAffaireMarco = " + sIdAffaireMarco);
			return;
		}
	}
	
	PersonnePhysique ppUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	
	if(!sessionUserHabilitation.isHabilitate(sPageUseCaseId))
	{
		// on teste par rapport à son organisation
		sPageUseCaseId = "IHM-DESK-AFF-55";
	}
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);


	/**
	 * MarcheVolumeType
	 */ 
    MarcheVolumeType marcheVolumeType = null;
	boolean bMarcheVolumeTypeUseUndefinedValue = Configuration.isTrueMemory("modula.marche.volume.type.use.undefined.value", true) ;
    try{
        MarcheVolume marcheVolume = MarcheVolume.getMarcheVolumeFromIdMarche(marche.getId());
        marcheVolumeType = MarcheVolumeType.getMarcheVolumeTypeMemory(marcheVolume.getIdMarcheVolumeType());
    } catch (CoinDatabaseLoadException e){
        marcheVolumeType = new MarcheVolumeType();
    }
  

	   //ONGLET CRITERES
    AutoFormCptDoubleMultiSelect afIdArticleSelection = null;
    AutoFormCptSelect afIdMarchePassation = null;
    AutoFormCptSelect afIdProcedure = null;
    AutoFormCptBlock afBlockTypeAvis = null;
    AutoFormCptBlock afBlockProcedure = null;
    AutoFormCptBlock afBlockPub = null;
    AutoFormCptInputRadioSet afTypePublication = null;
    MarcheProcedure marProc = new MarcheProcedure();
    AutoFormCptSelect afProcedureSimpleEnveloppe = null;
    
    boolean bUseFormNS = true;
    boolean bUseFormUE = true;
    
    
    
    if(vArticleLoiMarche == null){
        try{vArticleLoiMarche = ArticleLoi.getArticleLoiPourIdMarche(marche.getIdMarche());}
        catch(Exception e){}
    }
 
    
    %><%@ include file="pave/blocAutoformAffaire.jspf" %><%
    
	
	JSONArray jTypeForm = BoampFormulaireType.getJSONArray();
	JSONArray jPass = MarchePassation.getJSONArray(false);
	JSONArray jNiveau = AffaireProcedureType.getJSONArray(false);
	JSONArray jLois = ArticleLoi.getJSONArrayEtatValide(false);
	JSONArray jProc = AffaireProcedure.getJSONArray(sessionUserHabilitation);
		
	
%>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<%@ include file="pave/ajouterAffaireFormBoamp.jspf" %>


<style type="text/css">
<!--
#lIdMarcheVolumeType{

	background-color:#FFE3E3;/*FFEAA9*/
	border: 1px solid #CC0000/*FFD75F*/;
/**
  @see class on desk.css : <%= CSS.DESIGN_CSS_MANDATORY_CLASS %> ;
  */
}
-->
</style>
</head>
<body>


<%@ include file="/include/new_style/headerFiche.jspf" %>


<div style="padding:15px">
<form name="formulaire" action="<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/modifierAffaire.jsp" ) %>" method='post' onSubmit="return checkForm();" >
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="iIdAffaireMarco" value="<%= sIdAffaireMarco %>" />
		<table class="pave">
			<tr>
				<td class="pave_titre_gauche" colspan="2" >Renseignements sur l'organisation et la commission</td>
			</tr>
			<tr>
				<td colspan="2" >&nbsp;</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Organisme passant le marché *</td>
				<td class="pave_cellule_droite">
					<button type="button" id="AJCL_but_iIdOrganisation" 
					class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" >Cliquer ici pour sélectionner l'organisme</button>
					<input type="hidden" id="iIdOrganisation" name="iIdOrganisation" />
               	 </td>
 			</tr>
 			<tr>
				<td class="pave_cellule_gauche">Commission *</td>
				<td class="pave_cellule_droite">
					<select name="iIdCommission" id="iIdCommission" style="width:450px" class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>">
						<option selected="selected" value="">Sélectionnez la commission</option>
					</select>
 				</td>
 			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<br />
		<%
		// Affichage des pavés les uns après les autres
		%>
		
				
        <table id="block_rens_affaire" class="pave" >
			<tr>
			    <td class="pave_titre_gauche" colspan="2">Renseignements sur l'affaire</td>
			</tr>
			<tr id="pave_sReference" >
			    <td class='pave_cellule_gauche' ><label class=" " for="sReference" >Numéro de référence de l'affaire *</label></td>
			    <td class='pave_cellule_droite' >
			     <input name="sReference" 
			         id="sReference" 
			         class="obligatory obligatory" 
			         type="text" 
			         size="50" 
			         maxlength="45"
			         value="<%= marche.getReference() %>" />
			    </td>
			</tr>
			<tr id="pave_sObjet" >
			    <td class='pave_cellule_gauche' ><label class=" " for="sObjet" >Objet de l'affaire *</label></td>
			    <td class='pave_cellule_droite' >
			     <input name="sObjet" 
			         id="sObjet" 
			         class="obligatory obligatory" 
			         type="text" 
			         size="100" 
			         maxlength="200" 
			         value="<%= marche.getObjet() %>" />
			    </td>
			</tr>
            <tr >
                <td class='pave_cellule_gauche' >Volume du marché (montant estimatif) *</td>
                <td class='pave_cellule_droite' >
                    <%= marcheVolumeType.getAllInHtmlSelect(
                    		"lIdMarcheVolumeType", 
                    		bMarcheVolumeTypeUseUndefinedValue
                    		) %>
                    		
                </td>
            </tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
					
 		<br />
		<%=afBlockTypeAvis.getHTML() %>
		<br />
		<%=afBlockProcedure.getHTML() %>
		<br />
		
	    <jsp:include page='<%= Theme.getDeskTemplateFilePath("/desk/marche/algorithme/affaire/pave/paveChoixPublicationOfficielleForm.jsp",request)%>' flush="false">
	    
	     
	    <jsp:param name="lIdMarche" value="<%= marche.getId() %>" />
	    </jsp:include>
        
        <div  id="tablePublicationOfficielle"  ></div>


		<br />
<!-- 		<span style="font-weight:bold;float:right;color:#2361AA">(1) Les publications papier et internet seront séléctionnées pendant la procédure de dématérialisation</span>

 -->		<br />
		<br />
	<br />
	<div class="center">
	<button type="submit"><%=sTitle %></button>
	<button type="button" onclick="javascript:Redirect('<%=response.encodeRedirectURL(sUrlCancel) %>')">Annuler</button>
	</div>
	<br/>
	<span style="font-weight:bold;float:right">* Champs obligatoires</span>
</form>
</div>

<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.marche.ArticleLoi"%>
<%@page import="org.json.JSONArray"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>

<%@page import="org.coin.bean.ObjectType"%><%@page import="org.coin.util.FileUtil"%>

<%@page import="modula.marche.MarcheProcedure"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="org.coin.util.HttpUtil"%></html>
