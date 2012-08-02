<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	String sAction = request.getParameter("sAction");
	OrganisationService orgService = null;
	orgService
		= OrganisationService.getOrganisationService(
			Integer.parseInt(request.getParameter("lIdOrganisationService")));

	if(sAction.equals("remove"))
	{
		ObjectGroupItem item = ObjectGroupItem.getObjectItem(
				Long.parseLong(request.getParameter("lIdObjectGroupItem") ));

		item.remove();

	}

	if(sAction.equals("setMembreResponsable"))
	{
		Vector<ObjectGroup> vServiceMembre
			= ObjectGroup.getAllGroupObjectFromIdGroupTypeAndObjectReference(
					ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE,
					ObjectType.ORGANISATION_SERVICE,
					orgService.getId());

		ObjectGroup og = new ObjectGroup();

		if(	vServiceMembre.size() == 0)
		{
			// il faut créer le groupe avant d'ajouter le membre
			og.setIdGroupType(ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE);
			og.setIdReferenceObject(orgService.getId());
			og.setIdTypeObject(ObjectType.ORGANISATION_SERVICE);
			og.setIdTypeObjectHead(ObjectType.PERSONNE_PHYSIQUE);
			og.setIdReferenceObjectHead(Long.parseLong(request.getParameter("lIdPersonnePhysiqueMembre")));
			og.setNom("Membres du Service "+ orgService.getNom());
			og.create();

		}
		else
		{
			if(	vServiceMembre.size() == 1)
			{
				// le groupe
				og = vServiceMembre.get(0);
				og.setIdReferenceObjectHead(Long.parseLong(request.getParameter("lIdPersonnePhysiqueMembre")));
				og.store();


			}
			else
			{
				throw new Exception("Deux groupes de membres, ce n'est pas permis !");
			}
		}
	}



	if(sAction.equals("addMembre"))
	{
		Vector<ObjectGroup> vServiceMembre
			= ObjectGroup.getAllGroupObjectFromIdGroupTypeAndObjectReference(
					ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE,
					ObjectType.ORGANISATION_SERVICE,
					orgService.getId());

		ObjectGroup og = new ObjectGroup();

		if(	vServiceMembre.size() == 0)
		{
			// il faut créer le groupe avant d'ajouter le membre
			og.setIdGroupType(ObjectGroupType.GROUP_ORGANISATION_SERVICE_MEMBRE);
			og.setIdReferenceObject(orgService.getId());
			og.setIdTypeObject(ObjectType.ORGANISATION_SERVICE);
			og.setIdTypeObjectHead(ObjectType.PERSONNE_PHYSIQUE);
			og.setNom("Membres du Service "+ orgService.getNom());
			og.create();

			ObjectGroupItem item = new ObjectGroupItem();
			item.setIdObjectGroup(og.getId());
			item.setIdReferenceObject(Long.parseLong(request.getParameter("lIdPersonnePhysiqueMembre")));
			item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
			item.create();
		}
		else
		{
			if(	vServiceMembre.size() == 1)
			{
				// le groupe
				og = vServiceMembre.get(0);

				ObjectGroupItem item = new ObjectGroupItem();
				item.setIdObjectGroup(og.getId());
				item.setIdReferenceObject(Long.parseLong(request.getParameter("lIdPersonnePhysiqueMembre")));
				item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
				item.create();

			}
			else
			{
				throw new Exception("Deux groupes de membres, ce n'est pas permis !");
			}
		}
	}


	response.sendRedirect(
			response.encodeRedirectURL("displayOrganisationService.jsp?lIdOrganisationService="
				+ orgService.getId()));

%>