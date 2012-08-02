<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>

<%@page import="org.coin.bean.ObjectType"%><div>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	OrganisationService service = (OrganisationService) request.getAttribute("service");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");

	String sAction =  HttpUtil.parseStringBlank("sAction", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request , 0);


	String sUrlRedirect 
		= rootPath + "desk/organisation/groupe/displayOrganisationService.jsp?iIdOnglet="+iIdOnglet
				+ "&lIdOrganisationService=" + service.getId();
%>
	<br />
	<jsp:include page="/desk/multimedia/pave/paveAfficherTousMultimedia.jsp" flush="true" >
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdReferenceObjet" value="<%=service.getId() %>" /> 
			<jsp:param name="iIdTypeObjet" value="<%= ObjectType.ORGANISATION_SERVICE %>" /> 
	</jsp:include>
</div>
