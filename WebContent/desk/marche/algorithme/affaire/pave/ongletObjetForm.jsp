<%@ page import="modula.graphic.*,java.sql.*,org.coin.bean.boamp.*,org.coin.fr.bean.*,modula.candidature.*" %>
<%@ page import="org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*" %>
<%@ page import="modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ page import="org.coin.autoform.component.*"%>
<%@page import="org.coin.bean.question.QuestionAnswer"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveObjetMarcheTitre = "Objet du march&eacute;";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	Organisation org = (Organisation) request.getAttribute("organisation");
	//Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	long lIdOrganisation = org.getId();
	
	String rootPath = request.getContextPath()+"/";
	String sSelected;
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;

	/**
     * MarcheVolumeType
     */ 
    MarcheVolumeType marcheVolumeType = null;
    try{
        MarcheVolume marcheVolume = MarcheVolume.getMarcheVolumeFromIdMarche(marche.getId());
        marcheVolumeType = MarcheVolumeType.getMarcheVolumeTypeMemory(marcheVolume.getIdMarcheVolumeType());
    } catch (CoinDatabaseLoadException e){
        marcheVolumeType = new MarcheVolumeType();
    }
	
%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveObjetForm.jspf" %> 

<%@page import="modula.marche.joue.MarcheJoueInfo"%><br />
<%
	String sPaveClassificationProduitsTitre = "Classification des produits (CPF) *"; 
	String sPaveClassificationGroupProduitsTitre = "Groupes de classification des produits*"; 
	try
	{
		if(marche.isAffaireAATR()){
			sPaveClassificationProduitsTitre = "Classification des produits (CPF) "; 
			sPaveClassificationGroupProduitsTitre = "Groupes de classification des produits"; 
		}
			
	}
	catch(Exception e){}
	
	/**
	 * ADDED FOR BOAMP17
	 */
	AutoFormCptBlock afBlockTypeActivite = new AutoFormCptBlock("Type d'activités", "block_type_activite");
	
	// Pave Type d'activité
	AutoFormCptLabel afLabelPrincipaleActivitePouvoirAdjudicateur 
		= new AutoFormCptLabel("", "Principale(s) activités du pouvoir adjudicateur");
	afBlockTypeActivite.addComponent(afLabelPrincipaleActivitePouvoirAdjudicateur );

	
	AutoFormCptLabel afLabelPrincipaleActiviteEntiteAdjudicatrice 
		= new AutoFormCptLabel("", "Principale(s) activités de l'entité adjudicatrice");
	afBlockTypeActivite.addComponent(afLabelPrincipaleActiviteEntiteAdjudicatrice );
	
	MarcheJoueInfo joueInfo = MarcheJoueInfo.getOrNewMarcheJoueInfoFromIdMarche(marche
			.getIdMarche(), true);
	
	CodeCpfSwitcher cpfSwitcher = new CodeCpfSwitcher(ObjectType.AFFAIRE,marche.getId());
	if(cpfSwitcher.isUseCPFGroup()){
%>
<br />
<%@ include file="paveClassificationGroupProduitsForm.jspf" %>
<%} %>
<br/>
<%@ include file="paveClassificationProduitsForm.jspf" %>
<br/>
<%@ include file="paveCriteresSociauxForm.jspf" %>
<br/>
<%if(bUseBoamp17 && bUseFormMAPA){%>
<%@ include file="paveMotCleForm.jspf" %>
<br/>
<%} %>
<%
	String sPaveTypeActiviteTitre = "Type d'activité";
	if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
	{
		boolean bIsForm = true;
	%><%@ include file="paveTypeActiviteForm.jspf" %>
	<br /><%
	} 

	String sPaveTypeMarcheTitre = "Type de march&eacute;";
	sFormPrefix = "";
%>
<%@ include file="paveTypeMarcheForm.jspf" %>
<br />
<%

	if(bUseFormNS || bUseFormUE)
	{
		String sPaveNomenclatureTitre = "Nomenclature européenne (obligatoire au-delà des seuils européens)";
		sFormPrefix = "";
%>
<%@ include file="paveNomenclatureForm.jspf" %>
<br />
<%
	}

	boolean bReadOnly = false;
	String sPaveAdresseTitre = "Lieu d'exécution";
	sFormPrefix = "lieu_execution_";
	boolean bFieldsRequired = false;
	Adresse adresse = null;
	Pays pays = new Pays();
	try{
		System.out.print("marche.getIdLieuExecution() : " + marche.getIdLieuExecution());
		if(marche.getIdLieuExecution()!=0){
			adresse = Adresse.getAdresse(marche.getIdLieuExecution());
			pays = Pays.getPays( adresse.getIdPays() );
		} else {
			/**
			 * cf bug 2368 
			 */
			adresse = new Adresse();
			adresse.create();
			marche.setIdLieuExecution(adresse.getIdAdresse());
			marche.store();
		}
	}
	catch(Exception e){
		e.printStackTrace();
	}
	if(bUseBoamp17 && bUseFormNS)
		sPaveAdresseTitre = "Lieu d'exécution et/ou de livraison" ;
			
	
	adresse.iAbstractBeanIdLanguage=Language.LANG_FRENCH;
	pays.iAbstractBeanIdLanguage=Language.LANG_FRENCH;
%>  
<%@ include file="/desk/organisation/pave/paveAdresseForm.jspf" %>
<br />
<%
if(bUseBoamp17 && !bUseFormNS){
	sPaveAdresseTitre = "Lieu de livraison";
	sFormPrefix = "lieu_livraison_";
	try{		
		if(marche.getIdLieuLivraison()!=0){
			adresse = Adresse.getAdresse(marche.getIdLieuLivraison());
			pays = Pays.getPays( adresse.getIdPays() );

		}
	} catch(Exception e){} 
	
	adresse.iAbstractBeanIdLanguage=Language.LANG_FRENCH;
	pays.iAbstractBeanIdLanguage=Language.LANG_FRENCH;
%>
<%@ include file="/desk/organisation/pave/paveAdresseForm.jspf" %>
<%
}
%>