
<%@ page import="org.coin.fr.bean.*,org.coin.util.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	int iIdPersonnePhysique = -1;
	PersonnePhysique personne = null;
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request);
	String sAction = HttpUtil.parseString("sAction",request,"");
	
	if(sAction.equals("remove"))
	{
		int iIdPersonnePhysiqueParametre = Integer.parseInt(request.getParameter("lId"));
		PersonnePhysiqueParametre param = PersonnePhysiqueParametre.getPersonnePhysiqueParametre(iIdPersonnePhysiqueParametre);
		personne = PersonnePhysique.getPersonnePhysique(param.getIdPersonnePhysique());
		param.remove();
	}
	
	if(sAction.equals("create"))
	{
		iIdPersonnePhysique = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
		personne = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);
		PersonnePhysiqueParametre param = new PersonnePhysiqueParametre();
		param.setIdPersonnePhysique(iIdPersonnePhysique);
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
        iIdPersonnePhysique = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
        personne = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);

        PersonnePhysiqueParametre param 
            = PersonnePhysiqueParametre.getPersonnePhysiqueParametre(
                    personne.getIdPersonnePhysique(),
                    request.getParameter("sParamName"));

        param.setValue(request.getParameter("sParamValue"));
        param.store();
    }
    
	if(sAction.equals("store"))
	{
		iIdPersonnePhysique = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
		personne = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);

		int iParamSize = Integer.parseInt( request.getParameter("iParamSize") );
		for(int i=0 ;i < iParamSize; i++)
		{
			int iIdParametre = Integer.parseInt( request.getParameter("param_" + i) );
			String sParametreName = request.getParameter("paramName_" + i) ;
			String sParametreValue = request.getParameter("paramValue_" + i) ;
			
			PersonnePhysiqueParametre param = PersonnePhysiqueParametre.getPersonnePhysiqueParametre (iIdParametre);
			param.setName(sParametreName);
			param.setValue(sParametreValue);
			param.store();
		}
	
	}
	



	response.sendRedirect(
		response.encodeRedirectURL("afficherPersonnePhysique.jsp?iIdPersonnePhysique=" 
			+ personne.getIdPersonnePhysique()
			+ "&iIdOnglet=" + iIdOnglet
			+ "&nonce=" + System.currentTimeMillis()));
	
	
%>