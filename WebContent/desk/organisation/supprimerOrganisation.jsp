
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%><%@page import="mt.common.addressbook.AddressBook"%>
<%@ include file="/include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";

	int iIdOrganisation = -1;
	int iIdOrganisationType = -1;
	mt.modula.organisation.OrganisationModula organisation = null;
	try 
	{
		iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
		organisation = mt.modula.organisation.OrganisationModula.getOrganisationModula(iIdOrganisation);
		organisation.setAbstractBeanLocalization(sessionLanguage);
		iIdOrganisationType = organisation.getIdOrganisationType();
	} 
	catch (Exception e) 
	{
		response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=17"));
		return;
	}	

    String sPageUseCaseId = AddressBookHabilitation.getUseCaseForRemoveOrganization(organisation);
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	AddressBook.authorizeOrganizationRemove(organisation);
	
	organisation.removeWithObjectAttached();

	response.sendRedirect(
		response.encodeRedirectURL(
	rootPath + "desk/organisation/afficherToutesOrganisations.jsp?iIdOrganisationType="
			+iIdOrganisationType) );
%>

