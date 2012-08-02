<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%		
	String rootPath = request.getContextPath() +"/";
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize)request.getAttribute("locBloc");
	String sBlocLabelCollaboratorList = locBloc.getValue(6,"Personnes associées à l'organisme");
	Organisation organisation = (Organisation) request.getAttribute("organisation");

	Vector<?> vPersonnes = PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation());

	PersonnePhysique personne = new PersonnePhysique();
	personne.setAbstractBeanLocalization(sessionLanguage);
%> 

<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.Adresse"%>

<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<div id="search">
	<div class="searchTitle">
		<div id="infosSearchLeft" style="float:left"><%= sBlocLabelCollaboratorList %></div>
		<div id="infosSearchRight" style="float:right;text-align:right;"></div>
		<div style="clear:both"></div>
	</div>
	<table class="dataGrid fullWidth" cellspacing="1">
		<tbody>
			<tr class="header">
				<td class="cell"><%= personne.getNomLabel()%></td>
				<td class="cell"><%= personne.getFonctionLabel() %></td>
				<td class="cell"><%= personne.getEmailLabel() %></td>
				<td class="cell"><%= personne.getIdAdresseLabel() %></td>
				<td class="cell">&nbsp;</td>
			</tr>
						
<%
	for (int i = 0; i < vPersonnes.size(); i++)
	{
		personne = (PersonnePhysique) vPersonnes.get(i);
		personne.setAbstractBeanLocalization(sessionLanguage);
		Adresse adressePersonne = null;
		
		try{
			adressePersonne = Adresse.getAdresse(personne.getIdAdresse());
		} catch (CoinDatabaseLoadException e) {
			adressePersonne = new Adresse();
			adressePersonne.setAdresseLigne1(e.getMessage());
		}
		adressePersonne.setAbstractBeanLocalization(sessionLanguage);
		int j = i % 2;
		
%>
<%@ include file="../pave/paveListItemPersonnePhysiqueInOrganisation.jspf" %>
<%
	}
%>
		</tbody>
	</table>
</div>
