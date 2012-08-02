<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.fr.bean.OrganisationType"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.common.addressbook.habilitation.DisplayOrganizationHabilitation"%>
<div>
<%

	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	Pays pays = (Pays) request.getAttribute("pays");
	Adresse adresse = (Adresse)request.getAttribute("adresse");
	
	DisplayOrganizationHabilitation doh = (DisplayOrganizationHabilitation) request.getAttribute("doh");
	HtmlBeanTableTrPave hbFormulaire = (HtmlBeanTableTrPave)request.getAttribute("hbFormulaire");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize)request.getAttribute("locBloc");
	Localize locMessage = (Localize)request.getAttribute("locMessage");
	String sAction = (String) request.getAttribute("sAction");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
	String sFormPrefix = "";
	
	String sBlocNameAddress = locBloc.getValue(3, "Adresse générale");
	String sBlocNameAdministativeData = locBloc.getValue(1, "Données administratives");
	String sLabelNameOrganizationSkill = locBloc.getValue(4, "Compétences");
	String sBlocNameIdentity = locBloc.getValue(2, "Coordonnées de l'organisme");

	
	Vector<BoampCPFItem> vCompetencesOrganisationLibrary = null;
	Vector<BoampCPF> vCompetencesOrganisation = null;
	
	try {
		vCompetencesOrganisationLibrary 
			= BoampCPFItem.getAllFromTypeAndReferenceObjet(
					ObjectType.ORGANISATION, 
					organisation.getIdOrganisation());
		
	}catch (Exception e ) {
		vCompetencesOrganisationLibrary = new Vector<BoampCPFItem> ();
	}
		
	vCompetencesOrganisation = new Vector<BoampCPF>();
	for(BoampCPFItem itemOrg : vCompetencesOrganisationLibrary){
		vCompetencesOrganisation.add(BoampCPF.getBoampCPFMemory(itemOrg.getIdOwnedObject()));
	}

	boolean bIsForm = false;
	String sPaveTypeActiviteTitre = "Type d'activité";
		
		if(sAction.equals("store"))
		{
			%><%@ include file="../pave/paveOrganisationDonneesAdministrativesForm.jspf" %><br/><%

			if (organisation.getIdOrganisationType() == OrganisationType.TYPE_CANDIDAT)
			{
				%><%@ include file="../pave/paveCompetenceForm.jspf" %><%
			}
			if (organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
			{
				bIsForm = true;
				if(doh.bDisplayTypeActivity)
				{
					%>
					<br/>
					<%@ include file="../pave/paveTypeActiviteForm.jspf" %>
					<%
				}
			}
			if(doh.bGroupPersoData){
				String sPaveAdresseTitre = sBlocNameAddress;
                %><%@ include file="../pave/paveOrganisationCoordonneesForm.jspf" %><br/><%
                %><%@ include file="../pave/paveAdresseForm.jspf" %><%
			}
		}
		else
		{
			%>
			<%@ include file="../pave/paveOrganisationDonneesAdministratives.jspf" %>
			<%
			if (organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
			{
				bIsForm = false;
				if(doh.bDisplayTypeActivity)
				{
					%>
					<br/>
					<%@ include file="../pave/paveTypeActiviteForm.jspf" %>
					<%
				}
			}
			
	        if(doh.bGroupPersoData){
	        	String sPaveAdresseTitre = sBlocNameAddress;
	        	%><br/><%@ include file="../pave/paveOrganisationCoordonnees.jspf" %><br/><%
	        	%><%@ include file="../pave/paveAdresse.jspf" %><%
	        }
		}
%>
</div>