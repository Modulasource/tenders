
<%@ page import="modula.marche.*" %>
<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdMarche = -1;
	Marche marche = null;
	
	String sAction = request.getParameter("sAction");
	
	if(sAction.equals("remove"))
	{
		int iIdMarcheParametre = Integer.parseInt(request.getParameter("iIdMarcheParametre"));
		MarcheParametre param = MarcheParametre.getMarcheParametre(iIdMarcheParametre);
		iIdMarche = param.getIdMarche();
		param.remove();
	}
	
	if(sAction.equals("create"))
	{
		iIdMarche = Integer.parseInt(request.getParameter("iIdAffaire"));
		MarcheParametre param = new MarcheParametre ();
		param.setIdMarche(iIdMarche);
		param.create();

		param.setName("Paramètre " + param.getIdMarcheParametre());
		param.setValue("Valeur " + param.getIdMarcheParametre());
		param.store();
		
	}

	if(sAction.equals("store"))
	{
		iIdMarche = Integer.parseInt(request.getParameter("iIdAffaire"));
		int iParamSize = Integer.parseInt( request.getParameter("iParamSize") );
		for(int i=0 ;i < iParamSize; i++)
		{
			int iIdParametre = Integer.parseInt( request.getParameter("param_" + i) );
			String sParametreName = request.getParameter("paramName_" + i) ;
			String sParametreValue = request.getParameter("paramValue_" + i) ;
			
			MarcheParametre param = MarcheParametre.getMarcheParametre(iIdParametre);
			param.setName(sParametreName);
			param.setValue(sParametreValue);
			param.store();
		}
	
	}
	response.sendRedirect(
		response.encodeRedirectURL("afficherAffaire.jsp?" 
			+ "iIdAffaire=" + iIdMarche
			+ "&iIdOnglet=" + modula.graphic.Onglet.ONGLET_AFFAIRE_PARAMETRES
			+ "&nonce=" + System.currentTimeMillis()));
	
	
%>