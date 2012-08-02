<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%

	String sAction = HttpUtil.parseStringBlank("sAction",request);
	long lIdOrganisationGroup = HttpUtil.parseInt("lIdOrganisationGroup",request, 0);
	long lIdOrganisationGroupPersonnePhysique = HttpUtil.parseInt("lIdOrganisationGroupPersonnePhysique",request, 0);

	OrganisationGroupPersonnePhysique item = null;
	
	
	if(sAction.equals("create"))
	{
		item = new OrganisationGroupPersonnePhysique();
		item.setFromForm(request,"");
		item.create();
	} 
	
	if(sAction.equals("remove"))
	{
		item = OrganisationGroupPersonnePhysique.getOrganisationGroupPersonnePhysique(lIdOrganisationGroupPersonnePhysique);
		lIdOrganisationGroup = item.getIdOrganisationGroup();
		item.remove();
	} 

	response.sendRedirect(
		response.encodeRedirectURL("modifyOrganisationGroupForm.jsp?lIdOrganisationGroup=" + lIdOrganisationGroup));

%>
