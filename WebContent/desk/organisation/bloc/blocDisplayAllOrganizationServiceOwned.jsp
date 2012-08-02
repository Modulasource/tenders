<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	OrganisationService service= (OrganisationService) request.getAttribute("service");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

		 
	long lIdObjectTypeOwner = ObjectType.ORGANISATION_SERVICE;
	long lIdObjectReferenceOwner = service.getId();
	request.setAttribute("sBlocTitle", "Appartiennent au service " + service.getName());
				
%>
<jsp:include page="blocDisplayAddressBookOwned.jsp">
<jsp:param value="<%= lIdObjectTypeOwner %>" name="lIdObjectTypeOwner"/>
<jsp:param value="<%= lIdObjectReferenceOwner %>" name="lIdObjectReferenceOwner"/>
</jsp:include>