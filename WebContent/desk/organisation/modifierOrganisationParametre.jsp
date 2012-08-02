<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="org.coin.fr.bean.*,modula.*,org.coin.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sTitle = "";
	String rootPath = request.getContextPath()+"/";
	int iIdOrganisation = -1;
	Organisation organisation = null;
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request);
	String sAction = HttpUtil.parseString("sAction",request,"");
	
	if(sAction.equals("remove"))
	{
		int iIdOrganisationParametre = Integer.parseInt(request.getParameter("iIdOrganisationParametre"));
		OrganisationParametre param = OrganisationParametre.getOrganisationParametre(iIdOrganisationParametre);
		organisation = Organisation.getOrganisation(param.getIdOrganisation());
		param.remove();
	}
	
	if(sAction.equals("create"))
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation);
		OrganisationParametre param = new OrganisationParametre();
		param.setIdOrganisation(iIdOrganisation);
		param.create();

       if(request.getParameter("sName") == null){
            param.setName("Paramètre " + param.getId());
            param.setValue("Valeur " + param.getId());
        } else {
            param.setFromForm(request, "");
        }

		param.store();
	}

    if(sAction.equals("storeOneParam"))
    {
        iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
        organisation = Organisation.getOrganisation(iIdOrganisation);

        OrganisationParametre param 
	        = OrganisationParametre.getOrganisationParametre(
	        		organisation.getIdOrganisation(),
	        		StringEscapeUtils.unescapeHtml (request.getParameter("sParamName")));

        param.setValue(StringEscapeUtils.unescapeHtml (request.getParameter("sParamValue")));
        param.store();
    }
   
	if(sAction.equals("store"))
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation);

		int iParamSize = Integer.parseInt( request.getParameter("iParamSize") );
		for(int i=0 ;i < iParamSize; i++)
		{
			int iIdParametre = Integer.parseInt( request.getParameter("param_" + i) );
			String sParametreName = StringEscapeUtils.unescapeHtml(request.getParameter("paramName_" + i)) ;
			String sParametreValue = StringEscapeUtils.unescapeHtml(request.getParameter("paramValue_" + i)) ;
			
			OrganisationParametre param = OrganisationParametre.getOrganisationParametre (iIdParametre);
			param.setName(sParametreName);
			param.setValue(sParametreValue);
			param.store();
		}
	
	}
	



	response.sendRedirect(
		response.encodeRedirectURL("afficherOrganisation.jsp?iIdOrganisation=" 
			+ organisation.getIdOrganisation()
			+ "&iIdOnglet=" + iIdOnglet
			+ "&nonce=" + System.currentTimeMillis()));
	
	
%>