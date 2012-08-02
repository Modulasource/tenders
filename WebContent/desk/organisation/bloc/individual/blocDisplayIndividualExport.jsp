<%@page import="org.coin.localization.Localize"%>
<%
	Localize locBloc = (Localize) request.getAttribute("locBloc");
	Localize locAddressBookButton = (Localize) request.getAttribute("locAddressBookButton");
	
	String rootPath = request.getContextPath() +"/";
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
	PersonnePhysique personne = (PersonnePhysique) request.getAttribute("personne");

	String sUrlRedirect = rootPath + "desk/organisation/afficherPersonnePhysique.jsp?iIdOnglet="+iIdOnglet;
%> 
	
<%@page import="org.coin.bean.ObjectType"%>

<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%><div>
	<div style="text-align:right">	
	<button 
		type="button" 
		onclick="javascript:Redirect('<%= response.encodeURL( 
		rootPath + "desk/export/modifierExportForm.jsp?sAction=create"
		+ "&iIdTypeObjetSource=" + ObjectType.PERSONNE_PHYSIQUE
		+ "&iIdObjetReferenceSource=" + personne.getIdPersonnePhysique() 
		+ "&sUrlRedirect=" + sUrlRedirect ) %>')" ><%=locAddressBookButton.getValue(36,"Ajouter un transfert")%></button>
	</div>
	<br />
	<% request.setAttribute("locBloc", locBloc); %>	
	<% request.setAttribute("locAddressBookButton", locAddressBookButton); %>
	<jsp:include page="/desk/export/pave/paveAfficherTousExport.jsp" flush="true" >
			<jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
			<jsp:param name="iIdObjetReferenceSource" value="<%= personne.getIdPersonnePhysique() %>" /> 
			<jsp:param name="iIdTypeObjetSource" value="<%= ObjectType.PERSONNE_PHYSIQUE %>" /> 
	</jsp:include>
</div>
