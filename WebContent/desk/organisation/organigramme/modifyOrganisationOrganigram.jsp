
<%@ page import="org.coin.bean.ObjectType"%>
<%@ page import="org.coin.bean.organigram.Organigram"%>
<%@ page import="org.coin.fr.bean.*" %>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.bean.organigram.OrganigramNode"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	int iIdOrganisation = -1;
	Organisation organisation = null;

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");

	if(sAction.equals("remove"))
	{
		int iIdOrganigram = Integer.parseInt(request.getParameter("lIdOrganigram"));
		Organigram organigram = Organigram.getOrganigram(iIdOrganigram);
		Vector vNode = OrganigramNode.getAllFromIdOrganigram( organigram.getId() );
		for(int i = 0; i < vNode.size(); i++ )
		{
			OrganigramNode node = (OrganigramNode) vNode.get(i);
			node.remove();
		}
		organigram.remove();
	}

	if(sAction.equals("create"))
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = Organisation.getOrganisation(iIdOrganisation);
		Organigram organigram = new Organigram();
		organigram.setIdTypeObject(Integer.parseInt(request.getParameter("lIdTypeObject")));
		organigram.setIdTypeObjectNode(Integer.parseInt(request.getParameter("lIdTypeObjectNode") ));
		organigram.setIdReferenceObject(organisation.getId());
		organigram.setName("Organigramme de " + organisation.getRaisonSociale() + " IdTypeObjectNode " + organigram.getIdTypeObjectNode() );
		organigram.setDescription("Organigramme de " + organisation.getRaisonSociale() + " IdTypeObjectNode " + organigram.getIdTypeObjectNode() )  ;
		organigram.create();
	}

	if(sAction.equals("store"))
	{
		// TODO : ........

	}




	response.sendRedirect(
		response.encodeRedirectURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
				+ organisation.getIdOrganisation()
				+ "&iIdOnglet=" + Integer.parseInt(request.getParameter("iIdOnglet"))
				+ "&nonce=" + System.currentTimeMillis() ) );
%>