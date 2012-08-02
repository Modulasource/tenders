<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.OrganisationParametre"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<div>
<%
	String rootPath = request.getContextPath() +"/";

	Organisation organisation = (Organisation) request.getAttribute("organisation");
	String sAction = (String) request.getAttribute("sAction");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize)request.getAttribute("locBloc");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

	String sTabParameterNameParameterList = locBloc.getValue(7, "Liste des paramètres");
	String sTabParameterNameParameterName =  localizeButton.getValueName();
	String sTabParameterNameParameterValue = localizeButton.getValueValue();

	Vector<OrganisationParametre> vParams
		= OrganisationParametre.getAllFromIdOrganisation(organisation.getIdOrganisation());
		
		
	if(sAction.equals("store"))		
	{
%><%@ include file="../pave/ongletOrganisationParametreForm.jspf" %><%
	}else{ 
%><%@ include file="../pave/ongletOrganisationParametre.jspf" %><%
	}
%>
</div>
		