<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%

	String rootPath = request.getContextPath() +"/";
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");
	Localize locBloc = (Localize)request.getAttribute("locBloc");
	Organisation organisation = (Organisation) request.getAttribute("organisation");

	int iIdOrganisation = organisation.getIdOrganisation();
	String sLabelNameDepotList = locBloc.getValue(5, "Liste des dépôts");
	Vector<OrganisationDepot> vDepots = OrganisationDepot.getAllFromIdOrganisation(organisation.getIdOrganisation());
	OrganisationDepot depotTmp = new OrganisationDepot();
	depotTmp.setAbstractBeanLocalization(organisation) ;
	organisation.setAbstractBeanLocalization(sessionLanguage);
%>
 		
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.fr.bean.OrganisationDepot"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="org.coin.localization.Localize"%>
<%@page import="org.coin.fr.bean.Organisation"%><div id="search">
 	    <div class="searchTitle">
 	        <div id="infosSearchLeft" style="float:left"><%= sLabelNameDepotList %></div>
 	        <div id="infosSearchRight" style="float:right;text-align:right;"></div>
 	        <div style="clear:both"></div>
 	    </div>
 	    <table class="dataGrid fullWidth" cellspacing="1">
 	        <tbody>
 	            <tr class="header">
 	                <td class="cell"><%= depotTmp.getNameLabel() %></td>
 	                <td class="cell"><%= depotTmp.getPhoneLabel() %></td>
 	                <td class="cell"><%= depotTmp.getIdAdresseLabel() %></td>
 	                <td class="cell"><%= depotTmp.getEmailLabel() %></td>
 	                <td class="cell">&nbsp;</td>
 	            </tr>
 	                        
 	        <%
 	        for (int i = 0; i < vDepots.size(); i++)
 	        {
 	        	OrganisationDepot depot = vDepots.get(i);
 	            Adresse adresseDepot = null;
 	            try {
 	            	adresseDepot = Adresse.getAdresse((int)depot.getIdAdresse());
 	            } catch (CoinDatabaseLoadException e) {
 	            	adresseDepot = new Adresse();
 	            	adresseDepot.setAdresseLigne1("Attention pas d'adresse en bdd !!!");
 	            }
	           	adresseDepot.setAbstractBeanLocalization(organisation);
 	            
 	            int j = i % 2;
 	            %><%@ include file="../depot/paveListItemDepotInOrganisation.jspf" %><%
 	        }
 	        %>
 	        </tbody>
 	    </table>
 	</div>
 	