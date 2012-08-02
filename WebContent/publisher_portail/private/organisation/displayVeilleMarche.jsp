<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.db.*"%>
<%@page import="mt.modula.html.HtmlSearchEngine"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf"%>  
<%
	//boolean bLaunchSearch = HttpUtil.parseBoolean("bLaunchSearch", request,false);
	String sAction = HttpUtil.parseStringBlank("sAction", request);	
	
	VeilleMarcheAbonnes veilleMarcheAbonnes = null;
	boolean bVeilleMarche = false;
	try{
		veilleMarcheAbonnes 
			= VeilleMarcheAbonnes.getVeilleMarcheAbonnesFromPersonnePhysique(
					candidat.getIdPersonnePhysique());
		bVeilleMarche = true;
	}catch(CoinDatabaseLoadException e){
		veilleMarcheAbonnes = new VeilleMarcheAbonnes();
		veilleMarcheAbonnes.setIdPersonnePhysique(candidat.getIdPersonnePhysique());
	}
	
	CodeCpfSwitcher cpfSwitcher = new CodeCpfSwitcher(
			ObjectType.PERSONNE_PHYSIQUE,
			candidat.getIdPersonnePhysique());
	
	Vector<Departement> vDept = Departement.getAllStaticMemory(false);
	Vector<PersonnePhysiqueParametre> vParams = PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(candidat.getId());
	String sTypeKeyword = veilleMarcheAbonnes.getTypeKeyWord(vParams);
	ArrayList<String> sMailList = veilleMarcheAbonnes.getAllMail(vParams,candidat, false);
	long lNumberMailAuthorize = veilleMarcheAbonnes.getCounMailAuthorize(vParams);
	
	Vector<Departement> vDeptSelected = VeilleMarcheAbonnes.getAllDepartement(candidat.getId(), vParams,vDept);
%>
<script type="text/javascript" src="<%= rootPath %>include/produitCartesien.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/CodeCpfSwitcher.js" ></script>
<script type="text/javascript">
<!--

onPageLoad = function() {
    try{ showLoginBox(); } catch (e) {}

    <%if(sAction.equals("store")){%>
    $("formulaire").onValidSubmit = function(){
        Visualise(document.formulaire.iIdCompetenceSelection,document.formulaire.iIdCompetenceSelectionListe);
        if(document.formulaire.iIdGroupCompetenceSelection)
    		Visualise(document.formulaire.iIdGroupCompetenceSelection,document.formulaire.iIdGroupCompetenceSelectionListe);

        
        Visualise(document.formulaire.iIdDepartementSelection,document.formulaire.iIdDepartementSelectionListe);
        return true;
    }
    <%}%>
}
//-->
</script>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<%if(sAction.equals("store")){%>
<form action="<%= response.encodeURL(rootPath + "publisher_traitement/private/organisation/modifyVeilleMarche.jsp")
    %>" method="post" name="formulaire" id="formulaire" class="validate-fields">

       
<%@ include file="/publisher_traitement/private/organisation/pave/paveVeilleDeMarcheForm.jspf" %>
<div style="text-align:center">
<button type="submit" >Valider</button>
</div>
</form>       
       <%
   }
   else
   {
%>
       <%@ include file="/publisher_traitement/private/organisation/pave/paveVeilleDeMarche.jspf" %>
<div style="text-align:center">

<%
	/**
	 *TODO_AG
	 */
	if(sessionUserHabilitation.isSuperUser() 
	|| !Configuration.isEnabledMemory("publisher.portail.annonce.searchengine.habilitation", false))
	{
	
%>
<button 
    type="button" 
    onclick="<%= response.encodeURL(
        "Redirect('displayVeilleMarche.jsp?"
        + "sAction=store" ) %>');" >Modifier</button>

<%
	}
%>
</div>
<%
   }
%>

<%@ include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>
