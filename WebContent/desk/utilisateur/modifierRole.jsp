<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.util.*,org.coin.bean.*,java.util.*" %>
<%

	int iIdRole;
	String sAction;
	String sRoleName;
	String sIdUseCasesListe;
	sAction = request.getParameter("sAction") ;
	Role role = null;
	if(sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-PARAM-HAB-12";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

		role = new Role();
		sRoleName = request.getParameter("sName") ;
		role.setName(sRoleName);
		role.create();
		response.sendRedirect(response.encodeRedirectURL("modifierRoleForm.jsp?iIdRole=" + role.getId()  ));
		return ;
	}
	
	iIdRole = Integer.parseInt( request.getParameter("iIdRole") );
	role = Role.getRole(iIdRole);

	// partie Group
	if(sAction.equals("remove"))
	{
		role.remove();
		response.sendRedirect(response.encodeRedirectURL("afficherTousRole.jsp"));
		return;
	}

	Vector vStringList;
	int iIdOnglet = Integer.parseInt( request.getParameter("iIdOnglet") );

	if (iIdOnglet == 0)
	{
		sRoleName = request.getParameter("sName") ;
		role.setName(sRoleName);
		role.setIdTreeview(Long.parseLong(request.getParameter("lIdTreeview") ));
		role.store();
		
		Habilitation.updateManageable(role.getId(),request);
	
	}
	// partie UseCases
	//Habilitation.removeAllByIdRole(role.getId());
	if (iIdOnglet == 1)
	{
		
		sIdUseCasesListe = request.getParameter("IHM_DESK_ORG_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-ORG-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	
		sIdUseCasesListe = request.getParameter("IHM_DESK_PERS_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PERS-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}

	if (iIdOnglet == 2)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_COM_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-COM-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	
		sIdUseCasesListe = request.getParameter("IHM_DESK_AFF_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-AFF-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	if (iIdOnglet == 3)
	{
	
		sIdUseCasesListe = request.getParameter("IHM_DESK_PA_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PA-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	if (iIdOnglet == 4)
	{
	
		sIdUseCasesListe = request.getParameter("IHM_PUBLI_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-PUBLI-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	
	if (iIdOnglet == 5)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_PARAM_TV_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PARAM-TV-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	
		sIdUseCasesListe = request.getParameter("IHM_DESK_PARAM_HAB_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PARAM-HAB-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	
	if (iIdOnglet == 6)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_PARAM_ORG_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PARAM-ORG-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	
		sIdUseCasesListe = request.getParameter("IHM_DESK_PARAM_AFF_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PARAM-AFF-");
		Habilitation.createByStringList((int)role.getId(),vStringList);

		sIdUseCasesListe = request.getParameter("IHM_DESK_PARAM_MAIL_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PARAM-MAIL-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	

	if (iIdOnglet == 7)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_JOU_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-JOU-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}


	if (iIdOnglet == 8)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_FAQ_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-FAQ-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	if (iIdOnglet == 9)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_GED_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-GED-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	
	if (iIdOnglet == 10)
	{
		sIdUseCasesListe = request.getParameter("IHM_DESK_AR_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-AR-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}


	if (iIdOnglet == 11)
	{
		// Vehicle
		sIdUseCasesListe = request.getParameter("IHM_DESK_VEHICLE_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-VEHICLE-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}
	

	if (iIdOnglet == 12)
	{
		// Contract
		sIdUseCasesListe = request.getParameter("IHM_DESK_CONTRACT_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-CONTRACT-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}


	if (iIdOnglet == 13)
	{
		// Plannif
		sIdUseCasesListe = request.getParameter("IHM_DESK_PLANIFICATION_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeAllByUseCasePrefix(iIdRole, "IHM-DESK-PLANIFICATION-");
		Habilitation.createByStringList((int)role.getId(),vStringList);
	}

	if (iIdOnglet == 14)
	{
		// c'est le pendant de l'autre liste
		sIdUseCasesListe = request.getParameter("_OTHER_UNSELECTED_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeByStringList((int)role.getId(),vStringList);

		sIdUseCasesListe = request.getParameter("_OTHER_iIdUseCaseSelectionListe");
		vStringList = Outils.parseStringList(sIdUseCasesListe , "|");
		Habilitation.removeByStringList((int)role.getId(),vStringList);
		Habilitation.createByStringList((int)role.getId(),vStringList);

	}
	response.sendRedirect(
			response.encodeRedirectURL(
					"modifierRoleForm.jsp?iIdRole=" + role.getId() 
					+ "&iIdOnglet=" + iIdOnglet 
					+ "&nonce=" + System.currentTimeMillis() ));
%>
