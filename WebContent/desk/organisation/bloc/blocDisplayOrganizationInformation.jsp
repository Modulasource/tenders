<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="mt.common.addressbook.habilitation.DisplayOrganizationHabilitation"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="java.sql.Connection"%><%

	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	String sAction = (String) request.getAttribute("sAction");

	DisplayOrganizationHabilitation doh = (DisplayOrganizationHabilitation) request.getAttribute("doh");
	HtmlBeanTableTrPave hbFormulaire = (HtmlBeanTableTrPave)request.getAttribute("hbFormulaire");

	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize)request.getAttribute("locBloc");

	String sBlocNameIdentity = locBloc.getValue(2, "Coordonnées de l'organisme");

	if(sAction.equals("store"))
	{
		%><%@ include file="../pave/paveOrganisationCoordonneesForm.jspf" %><%
	}
	else
	{
		%><%@ include file="../pave/paveOrganisationCoordonnees.jspf" %><%
	}	

%>