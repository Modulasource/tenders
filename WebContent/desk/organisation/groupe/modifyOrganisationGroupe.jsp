<%@page import="modula.graphic.Onglet"%>

<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	String sAction = request.getParameter("sAction");
	ObjectGroup ogOrganisationGroupe = null;

	if(sAction.equals("store"))
	{
		ogOrganisationGroupe = ObjectGroup.getObjectGroup(
				Long.parseLong(request.getParameter("lIdObjectGroup")));

		ogOrganisationGroupe.setFromFormUTF8(request, "");
		ogOrganisationGroupe.store();

	}

	if(sAction.equals("remove"))
	{
		ogOrganisationGroupe = ObjectGroup.getObjectGroup(
		Long.parseLong(request.getParameter("lIdObjectGroup")));

		ObjectGroupItem ogi = new ObjectGroupItem();
		ogi.remove(" WHERE id_object_group = " + ogOrganisationGroupe.getId() );
		ogi = null;

		ogOrganisationGroupe.remove();
	}

	if(sAction.equals("create"))
	{
		ogOrganisationGroupe = new ObjectGroup();
		ogOrganisationGroupe.setFromFormUTF8(request, "");

		ogOrganisationGroupe.create();
	}


	response.sendRedirect(
			response.encodeRedirectURL("../afficherOrganisation.jsp?iIdOrganisation="
				+ ogOrganisationGroupe.getIdReferenceObject()
				+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_GROUP));

%>


