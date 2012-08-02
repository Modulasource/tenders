<%@ include file="../../../include/headerXML.jspf" %>
<%@ page import="java.util.*,modula.configuration.*,org.coin.fr.bean.*" %>

<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sTitle = "Paramètrage de vos \"Coups de Coeur\"";
	String rootPath = request.getContextPath()+"/";
	Vector<CoupCoeur> vCoupsDeCoeur = CoupCoeur.getAllCoupCoeur();
	Vector<Organisation> vAcheteursPublics = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_ACHETEUR_PUBLIC);
%>
<%@ include file="../../include/headerDesk.jspf" %> 
</head>
<body>
	<div class="titre_page"> <%=sTitle%> </div>
	<div class="mention">Sélectionnez les Acheteurs Publics dont les logos seront présents dans le moteur de recherche</div><br />
<%
	if(request.getParameter("sMessage")!=null){
%>
<div class="rouge"><%=request.getParameter("sMessage") %></div><br />
<%
	}
%>
	<form action="<%=response.encodeURL("modifierCoupsDeCoeur.jsp")%>" >

		<table class="pave" summary="none">
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
<%
	String sChecked="checked=\"checked\"";
	for(int i=0;i<vAcheteursPublics.size();i++){
		Organisation organisation = vAcheteursPublics.get(i);
%>
			<tr>
				<td class="pave_cellule_gauche">
					<input type="checkbox" name="vIdOrganisation" 
						value="<%= organisation.getIdOrganisation()%>"
					<%=organisation.isCoupDeCoeur()?sChecked:"" %>
					 />
				</td>
				<td class="pave_cellule_droite">
					<strong>
					<%= organisation.getRaisonSociale()%>
					</strong>
				</td>
			</tr>
<% 
	}
%>
			<tr>
				<td colspan="2" style="text-align:center;">
					<input type="submit" value="Enregister les coups de coeur" />
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
	</form>



<%@ include file="../../include/footerDesk.jspf" %> 
</body>
</html>
