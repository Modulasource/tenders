<%@page import="org.coin.bean.ObjectType"%>

<%@ page import="org.coin.fr.bean.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%

	String rootPath = request.getContextPath()+"/";

	String sAction = request.getParameter("sAction");
	ObjectGroup ogOrganisationGroupe = null;

	ogOrganisationGroupe = ObjectGroup.getObjectGroup(
			Long.parseLong(request.getParameter("lIdObjectGroup")));

	if(sAction.equals("remove"))
	{
		ObjectGroupItem item = ObjectGroupItem.getObjectItem(
				Long.parseLong(request.getParameter("lIdObjectGroupItem") ));

		item.remove();

	}



	if(sAction.equals("addMembre"))
	{

		ObjectGroupItem item = new ObjectGroupItem();
		item.setIdObjectGroup(ogOrganisationGroupe.getId());
		item.setIdReferenceObject(Long.parseLong(request.getParameter("lIdPersonnePhysiqueMembre")));
		item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
		item.create();

	}


	response.sendRedirect(
			response.encodeRedirectURL("displayOrganisationGroupe.jsp?lIdObjectGroup="
				+ ogOrganisationGroupe.getId()));

%>