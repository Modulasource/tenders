<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%@page import="java.util.Vector"%>

<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>

<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.localization.LocalizeButton"%>

<div>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
	String sAction = (String) request.getAttribute("sAction");


	String sUrlRedirect = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOnglet="+iIdOnglet;
	if(sAction.equals("store"))
	{
%><%@ include file="../pave/ongletOrganisationCharteGraphiqueForm.jspf" %><%
	}else{ 
%><%@ include file="../pave/ongletOrganisationCharteGraphique.jspf" %><%
	}
%>
	<br />
	<jsp:include page="/desk/multimedia/pave/paveAfficherTousMultimedia.jsp" flush="true" >
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdReferenceObjet" value="<%= 	organisation.getIdOrganisation() %>" /> 
			<jsp:param name="iIdTypeObjet" value="<%= ObjectType.ORGANISATION %>" /> 
	</jsp:include>
</div>
