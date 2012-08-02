<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%

	String sAction = HttpUtil.parseStringBlank("sAction",request);
	long lIdOrganisationGroup = HttpUtil.parseInt("lIdOrganisationGroup",request, 0);
	long lIdOrganisationGroupItem = HttpUtil.parseInt("lIdOrganisationGroupItem",request, 0);

	OrganisationGroupItem item = null;
	
	
	if(sAction.equals("create"))
	{
		item = new OrganisationGroupItem();
		item.setFromForm(request,"");
		item.create();
	} 
	
    if(sAction.equals("createFromCountry"))
    {
        OrganisationGroupItem.createFromCountryAndType(lIdOrganisationGroup,OrganisationType.TYPE_BUSINESS_UNIT);
    } 
	
	if(sAction.equals("remove"))
	{
		item = OrganisationGroupItem.getOrganisationGroupItem(lIdOrganisationGroupItem);
		lIdOrganisationGroup = item.getIdOrganisationGroup();
		item.remove();
	} 

	response.sendRedirect(
		response.encodeRedirectURL("modifyOrganisationGroupForm.jsp?lIdOrganisationGroup=" + lIdOrganisationGroup));

%>
