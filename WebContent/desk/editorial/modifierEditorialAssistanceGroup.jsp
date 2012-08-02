
<%@ page import="org.coin.bean.*,org.coin.bean.editorial.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-AR-018";
	String sFormPrefix = "";
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e)	{}
	
	EditorialAssistanceGroup group = null;
	if(sAction.equals("create"))
	{
		group = new EditorialAssistanceGroup();
		group.setFromForm(request,sFormPrefix);
		group.create();
		
		int iIdReferenceObjet = 0;
		try{iIdReferenceObjet = Integer.parseInt(request.getParameter(sFormPrefix + "iIdReferenceObjet"));}
		catch(Exception e){}
		
		int iIdTypeObjet = ObjectType.SYSTEME;
		try{iIdTypeObjet = Integer.parseInt(request.getParameter(sFormPrefix + "iIdTypeObjet"));}
		catch(Exception e){}
		
		String sVisibilite = "public";
		if(request.getParameter(sFormPrefix + "sVisibilite")!=null)
			sVisibilite = request.getParameter(sFormPrefix + "sVisibilite");
		
		EditorialAssistanceGroupLibrary lib = new EditorialAssistanceGroupLibrary();
		lib.setIdEditorialAssistanceGroup((int)group.getId());
		if(sVisibilite.equalsIgnoreCase("public"))
		{
			iIdReferenceObjet = 0;
			iIdTypeObjet = ObjectType.SYSTEME;
		}
		lib.setIdReferenceObjet(iIdReferenceObjet);
		lib.setIdTypeObjet(iIdTypeObjet);
		lib.create();
		
		if(iIdTypeObjet != ObjectType.PERSONNE_PHYSIQUE 
		|| (iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE && iIdReferenceObjet != group.getIdPersonnePhysiqueAuteur())
		)
		{
			EditorialAssistanceGroupLibrary libAuteur = new EditorialAssistanceGroupLibrary();
			libAuteur.setIdEditorialAssistanceGroup((int)group.getId());
			libAuteur.setIdReferenceObjet(group.getIdPersonnePhysiqueAuteur());
			libAuteur.setIdTypeObjet(ObjectType.PERSONNE_PHYSIQUE);
			libAuteur.create();
		}
	}
	
	if(sAction.equals("store"))
	{
		int iIdEditorialAssistanceGroup = -1;
		try{iIdEditorialAssistanceGroup = Integer.parseInt(request.getParameter("iIdEditorialAssistanceGroup"));}
		catch (Exception e)	{}
		
		group = EditorialAssistanceGroup.getEditorialAssistanceGroup(iIdEditorialAssistanceGroup);
		group.setFromForm(request,"");	
		group.store();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherEditorialAssistanceGroup.jsp?iIdEditorialAssistanceGroup=" + group.getId() 
					+ "&iIdOnglet=" + iIdOnglet
					+ "&nonce=" + System.currentTimeMillis() ));
%>
