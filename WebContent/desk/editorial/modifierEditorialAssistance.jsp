
<%@ page import="org.coin.bean.*,org.coin.bean.editorial.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-AR-001";
	String sFormPrefix = "";
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	int iIdOnglet = 0;
	try{iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch (Exception e)	{}
	
	EditorialAssistance edit = null;
	if(sAction.equals("create"))
	{
		edit = new EditorialAssistance();
		edit.setFromForm(request,sFormPrefix);
		edit.create();
		
		int iIdReferenceObjet = 0;
		try{iIdReferenceObjet = Integer.parseInt(request.getParameter(sFormPrefix + "iIdReferenceObjet"));}
		catch(Exception e){}
		
		int iIdTypeObjet = ObjectType.SYSTEME;
		try{iIdTypeObjet = Integer.parseInt(request.getParameter(sFormPrefix + "iIdTypeObjet"));}
		catch(Exception e){}
		
		String sVisibilite = "public";
		if(request.getParameter(sFormPrefix + "sVisibilite")!=null)
			sVisibilite = request.getParameter(sFormPrefix + "sVisibilite");
		
		EditorialAssistanceLibrary lib = new EditorialAssistanceLibrary();
		lib.setIdEditorialAssistance((int)edit.getId());
		if(sVisibilite.equalsIgnoreCase("public"))
		{
			iIdReferenceObjet = 0;
			iIdTypeObjet = ObjectType.SYSTEME;
		}
		lib.setIdReferenceObjet(iIdReferenceObjet);
		lib.setIdTypeObjet(iIdTypeObjet);
		lib.create();
		
		if(iIdTypeObjet != ObjectType.PERSONNE_PHYSIQUE 
		|| (iIdTypeObjet == ObjectType.PERSONNE_PHYSIQUE && iIdReferenceObjet != edit.getIdPersonnePhysiqueAuteur())
		)
		{
			EditorialAssistanceLibrary libAuteur = new EditorialAssistanceLibrary();
			libAuteur.setIdEditorialAssistance((int)edit.getId());
			libAuteur.setIdReferenceObjet(edit.getIdPersonnePhysiqueAuteur());
			libAuteur.setIdTypeObjet(ObjectType.PERSONNE_PHYSIQUE);
			libAuteur.create();
		}
	}
	
	if(sAction.equals("store"))
	{
		int iIdEditorialAssistance = -1;
		try{iIdEditorialAssistance = Integer.parseInt(request.getParameter("iIdEditorialAssistance"));}
		catch (Exception e)	{}
		
		edit = EditorialAssistance.getEditorialAssistance(iIdEditorialAssistance);
		edit.setFromForm(request,"");	
		edit.store();
	}
	
	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherEditorialAssistance.jsp?iIdEditorialAssistance=" + edit.getId() 
					+ "&iIdOnglet=" + iIdOnglet
					+ "&nonce=" + System.currentTimeMillis() ));
%>
