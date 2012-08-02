<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	PersonnePhysique personne = (PersonnePhysique ) request.getAttribute("personne");
	Connection conn = (Connection ) request.getAttribute("conn");
	
	Vector<ParaphFolder> vParaphFolder 
	 		= ParaphFolder.getAllParaphFolderTemplate(
					ObjectType.PERSONNE_PHYSIQUE,
					personne.getId(), 
					false, 
					conn);
 		
	/** Just for localization **/
	ParaphFolder paraphFolderLoc = new ParaphFolder ();
	paraphFolderLoc.setAbstractBeanLocalization(sessionLanguage);
 
	Localize locTitle = (Localize) request.getAttribute ("locTitle");
	
	String sMyCircuits = locTitle.getValue(47, "Mes circuits");
	String sServiceCircuits = locTitle.getValue(48, "Circuits du service");
 
	Vector<OrganisationService> vOrganisationService 
	= OrganisationService.getAllFromIdOrganisation(personne.getIdOrganisation(), false, conn);

	Vector<Organigram> vOrganigramOrganisationService 
    =  OrganisationService.getAllOrganigramStatic(vOrganisationService, false, conn);

    Vector<OrganigramNode> vOrganigramNodeAll 
    	= OrganisationService.getAllOrganigramNode(
    		vOrganisationService,
    		vOrganigramOrganisationService,
    		false,
    		conn);

    
	Vector<OrganigramNode> vOrganigramNode = new Vector<OrganigramNode>();
	try{
		vOrganigramNode = OrganisationService.getAllOrganigramNodeFromIndividual(
				personne.getIdOrganisation(), 
				personne.getId(), 
				conn);
	}catch(Exception e){}

    
%>
 

<%@page import="java.util.Vector"%>
<%@page import="mt.paraph.folder.ParaphFolder"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="mt.paraph.folder.ParaphFolderState"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeType"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.localization.Localize" %>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%><div> 
<%= sMyCircuits %> :  
</div>
<table class="dataGrid fullWidth">
	<tr class="header">
		<th><%=paraphFolderLoc.getNameLabel() %></th>
		<th><%=paraphFolderLoc.getIdParaphFolderTypeLabel() %></th>
		<th><%=paraphFolderLoc.getDateCreationLabel() %></th>
		<th>&nbsp;</th>
	</tr>
<%		
 		for(ParaphFolder pf : vParaphFolder)
 		{
 			ParaphFolderType pfType = ParaphFolderType.getParaphFolderTypeMemory(pf.getIdParaphFolderType());
 			ParaphFolderState pfState = ParaphFolderState.getParaphFolderStateMemory(pf.getIdParaphFolderState());
%>
	<tr class="liste0">
		<td><%= pf.getName() %></td>
		<td><%= pfType.getName() %></td>
		<td><%= CalendarUtil.getDateCourte(pf.getDateCreation() ) %></td>
		<td>
			<img src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
				style="cursor: pointer;"
				onclick="parent.addParentTabForced('...','<%=
					response.encodeURL(
						rootPath + "desk/paraph/folder/prepareParaphFolder.jsp"
						+ "?lId=" + pf.getId() )%>');"/>
		</td>
	</tr>
<%			
 		}
%>
</table>



<% 

	if(PersonnePhysiqueParametre.isEnabled(
		personne.getId(), 
		"use.habilitation.manage.paraph.folder.template", 
		false, 
		conn))
	{
		for(OrganigramNode on : vOrganigramNode)
		{
			OrganigramNodeType ont = null;
			OrganisationService osTemp = null;
			try{
				ont = OrganigramNodeType.getOrganigramNodeType(on.getIdOrganigramNodeType()); 
			} catch (CoinDatabaseLoadException e){
				ont = new OrganigramNodeType();
			}
		
			try{
				osTemp 
					= OrganisationService.getOrganisationServiceFromIdOrganigramNode(
						on.getId(),
						vOrganisationService, 
						vOrganigramOrganisationService, 
						vOrganigramNodeAll);
			
			} catch (CoinDatabaseLoadException e){
				osTemp = new OrganisationService();
				osTemp.setName(e.getMessage());
			}
		
			request.setAttribute("service", osTemp);
%>
<div style="background-color: #FFF; border: #AAA 1px solid;margin-top: 20px;padding: 5px;">
<div> 
<%= sServiceCircuits %> <%= osTemp.getName() %>:
</div>
	<jsp:include page="/desk/organisation/groupe/bloc/blocOrganisationServiceParaphFolderTemplate.jsp" />
</div>
<%		
		}
	}

%>