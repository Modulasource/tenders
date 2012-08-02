<%@page import="org.coin.bean.addressbook.IndividualActionState"%>
<%@page import="org.coin.bean.addressbook.IndividualActionType"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() + "/";
	GedDocument doc = (GedDocument) request.getAttribute("doc");
	Vector<IndividualAction> vIndividualActionAssigned = (Vector<IndividualAction> )request.getAttribute("vIndividualActionAssigned");


%>
<div id="actionList_<%= doc.getId() %>" style="display: none;text-align: left;" class="overlay_action" >
	<table style="border: thin solid;">
		<tr>
			<th>Date</th>
			<th>Source</th>
			<th>Destination</th>
			<th>Type</th>
			<th>State</th>
			<th></th>
		</tr>
<%
	Vector<PersonnePhysique > vPersonnePhysique = new Vector<PersonnePhysique >();

	for(IndividualAction action : vIndividualActionAssigned )
	{
        PersonnePhysique ppSource = null;
        PersonnePhysique ppDestination = null;
        IndividualActionType actionType = null;
        IndividualActionState actionState = null;
        String sAction = "";
        
        try{
            ppSource = PersonnePhysique.getOrLoadPersonnePhysique(
                    action.getIdIndividualSource(), 
                    vPersonnePhysique);
        } catch(Exception e ) {
            ppSource = new PersonnePhysique();
        }

        try{
            ppDestination = PersonnePhysique.getOrLoadPersonnePhysique(
                    action.getIdIndividualDestination(), 
                    vPersonnePhysique);
        } catch(Exception e ) {
            ppDestination = new PersonnePhysique();
        }


        try{
        	actionType = IndividualActionType.getIndividualActionTypeMemory(
                    action.getIdIndividualActionType());
        } catch(Exception e ) {
        	actionType = new IndividualActionType();
        }

        try{
        	actionState = IndividualActionState.getIndividualActionStateMemory(
                    action.getIdIndividualActionState());
        } catch(Exception e ) {
        	actionState = new IndividualActionState();
        }
        
    	if( action.getIdIndividualActionState() == IndividualActionState.STATE_DONE)
  	    {
    		sAction = "<img src='" + rootPath + "images/dropnsign/16x16/green_check.png" + "' />";
  	    }
    	if( action.getIdIndividualActionState() == IndividualActionState.STATE_REFUSED)
  	    {
    		sAction = "<img src='" + rootPath + "images/dropnsign/16x16/red_cross.png" + "' />";
  	    }



%>
		<tr>
			<td><%= CalendarUtil.getFormatDateHeureStd( action.getDateCreation())  %></td>
			<td><%= ppSource.getNomPrenom() %></td>
			<td><%= ppDestination.getNomPrenom() %></td>
			<td><%= actionType.getName() %></td>
			<td><%= actionState.getName() %></td>
			<td><%= sAction %></td>
		</tr>
<%		
	
	}
%>
	</table>
</div>
	