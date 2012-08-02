<%@page import="org.coin.localization.Localize"%>

<%

	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	PersonnePhysique personne = (PersonnePhysique) request.getAttribute("personne");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize) request.getAttribute("locBloc");


	Vector vMembres = null;
	try{
		CommissionMembre.getAllMembreParIdPersonne(personne.getIdPersonnePhysique());	
	} catch (Exception e) {
		vMembres = new  Vector<CommissionMembre> ();
	}

	if ((organisation.getIdOrganisationType() == OrganisationType.TYPE_ACHETEUR_PUBLIC)
	|| (organisation.getIdOrganisationType() == OrganisationType.TYPE_CONSULTANT))
	{
			if (vMembres == null) vMembres = new Vector();
%>
		
<%@page import="org.coin.fr.bean.OrganisationType"%>

		
<%@page import="java.util.Vector"%>
<%@page import="modula.commission.CommissionMembre"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="modula.commission.Commission"%><table class="pave" >
			<tr>
				<td class="pave_titre_gauche"> <%= locBloc.getValue(18,"Cette personne participe aux commissions") %> </td>
<%
			if(vMembres.size()>1){
%>
			<td class="pave_titre_droite"><%= vMembres.size() %> <%= locBloc.getValue(24,"commissions") %></td>
<%
			}
			else{
				if(vMembres.size()==1){
%>
			<td class="pave_titre_droite">1 <%= locBloc.getValue(21,"Commission") %></td>
<%
			}
			else{
%>
			<td class="pave_titre_droite"><%= locBloc.getValue(19,"Pas de commission") %></td>
<%
				}
			}
%>
			</tr>
			<tr>
				<td colspan="2">
					<table class="liste"  >
						<tr>
							<th><%= locBloc.getValue(20,"Rôle") %></th>
							<th><%= locBloc.getValue(21,"Commission") %></th>
							<th>&nbsp;</th>
						</tr>
<%
			Commission commission = null;
			for (int i = 0; i < vMembres.size(); i++)
			{
				CommissionMembre membre = (CommissionMembre) vMembres.get(i);
				commission = Commission.getCommission(membre.getIdCommission());
				int j = i % 2;
			
				if (commission.getIdCommission() != 0)
				{
				%><%@ include file="../../pave/paveListItemCommissionMembreInPersonnePhysique.jspf" %><%
				}
			}
%>
					</table>
				</td>
			</tr>
		</table>
<%
		} //fin if type d'organisation
%>

