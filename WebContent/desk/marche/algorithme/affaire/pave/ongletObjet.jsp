<%@ page import="java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*" %>
<%@ page import="modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*" %>
<%@ page import="org.coin.util.treeview.*,java.text.*,org.coin.bean.boamp.*" %>
<%@page import="mt.modula.affaire.param.MarcheVolumeType"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%@page import="modula.marche.joue.MarcheJoueInfo"%>
<%
	String sPaveObjetMarcheTitre = "Objet du march&eacute;";
	String sFormPrefix = "";
	
	Marche marche = (Marche) request.getAttribute("marche");
	Organisation org = (Organisation) request.getAttribute("organisation");
	//Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	//long lIdOrganisation = Long.parseLong(request.getParameter("lIdOrganisation"));
	long lIdOrganisation = org.getId();


	MarcheJoueInfo joueInfo 
		= MarcheJoueInfo.getOrNewMarcheJoueInfoFromIdMarche(
				marche.getIdMarche(), true);
	
	
	
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
<%@ include file="paveObjet.jspf" %>
<br />
<%
	String sPaveClassificationProduitsTitre = "Classification des produits (CPF) ";
	String sPaveClassificationGroupProduitsTitre = "Groupes de classification des produits"; 
	CodeCpfSwitcher cpfSwitcher = new CodeCpfSwitcher(ObjectType.AFFAIRE,marche.getId());
	if(cpfSwitcher.isUseCPFGroup()){
%>
<%@ include file="paveClassificationGroupProduits.jspf" %>
<br/>
<%} %>
<%@ include file="paveClassificationProduits.jspf" %>
<br/>
<%@ include file="paveCriteresSociauxForm.jspf" %>
<script type="text/javascript">
Event.observe(window,"load",function(){
    try{
        $$(".criteresSociauxSelectedClass").each(function(item){
            item.disabled=true;
        });
        
    } catch(e){}
});
</script >
<br/>
<%if(bUseBoamp17 && bUseFormMAPA){%>
<%@ include file="paveMotCle.jspf" %>
<br/>
<%} %>
<%
	String sPaveTypeActiviteTitre = "Type d'activité";
	if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
	{
		boolean bIsForm = false;
	%><%@ include file="paveTypeActiviteForm.jspf" %>
	<br /><%
	} 
%>
<br />
<%
	String sPaveTypeMarcheTitre = "Type de march&eacute;";
	sFormPrefix = "";
%>
<%@ include file="paveTypeMarche.jspf" %>
<br />
<%
	
	
	if(bUseFormNS || bUseFormUE)
	{
		String sPaveNomenclatureTitre = "Nomenclature CPV (obligatoire au-delà des seuils européens)";
		sFormPrefix = "";
%>
<%@ include file="paveNomenclature.jspf" %>
<br />
<%
	}

	String sPaveAdresseTitre = "Lieu d'exécution";
	sFormPrefix = "lieu_execution_";
	Adresse adresse = new Adresse();
	try
	{
		adresse = Adresse.getAdresse(marche.getIdLieuExecution());
	}
	catch(Exception e){}
	
	/**
	 * Si on est dans le cas d'un FNS alors le lieu d'execution
	 * est identique au lieu de livraison
	 */
	if(bUseBoamp17 && bUseFormNS)
		sPaveAdresseTitre = "Lieu d'exécution et/ou de livraison";
%>
<table class="pave" >
	<tr onclick="montrer_cacher('adresseExecution')">
		<td colspan="2" class="pave_titre_gauche"><%=sPaveAdresseTitre%></td>
	</tr>
	<tr>
		<td>
			<table id="adresseExecution" >
				<tr><td colspan="2">&nbsp;</td></tr>
				<%@ include file="paveAdresseStatique.jspf" %>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table><br />
<%
	

	if(bUseBoamp17 && !bUseFormNS){
		sPaveAdresseTitre = "Lieu de livraison";
		sFormPrefix = "lieu_livraison_";
		try
		{
			adresse = Adresse.getAdresse(marche.getIdLieuLivraison());
		}
		catch(Exception e){}
	
%>
<table class="pave" >
	<tr onclick="montrer_cacher('adresseLivraison')">
		<td colspan="2" class="pave_titre_gauche"><%=sPaveAdresseTitre%></td>
	</tr>
	<tr>
		<td>
			<table id="adresseLivraison" >
				<tr><td colspan="2">&nbsp;</td></tr>
				<%@ include file="paveAdresseStatique.jspf" %>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>
<%
	}
%>
