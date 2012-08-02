<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.bean.addressbook.IndividualActionState"%>
<%@page import="org.coin.bean.addressbook.IndividualActionType"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%
	Vector<PersonnePhysique> vPersonnePhysique = (Vector<PersonnePhysique>) request.getAttribute("vPersonnePhysique");
	Vector<IndividualAction> vIndividualAction = (Vector<IndividualAction>) request.getAttribute("vIndividualAction");
	PersonnePhysique ppAction = (PersonnePhysique) request.getAttribute("ppAction");
	String rootPath = request.getContextPath() +"/";
%>
<table style="border: thin solid;">
		<tr>
			<th>Date</th>
			<th>Source</th>
			<th>Destination</th>
			<th>Type</th>
			<th>State</th>
			<th>Object type</th>
			<th>Object ref</th>
			<th>Action</th>
		</tr>
<%
for(IndividualAction action : vIndividualAction)
{
    PersonnePhysique ppSource = null;
    PersonnePhysique ppDestination = null;
    IndividualActionType actionType = null;
    IndividualActionState actionState = null;
    ObjectType objectAction = null;
    boolean bActivateAction = false;
    String sActionObjectName = "";
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

    try{
    	objectAction = ObjectType.getObjectTypeMemory(
                action.getIdActionObjectType());
    	
    	
    	if( action.getIdIndividualDestination() == ppAction.getId()
    	&& action.getIdIndividualActionState() == IndividualActionState.STATE_ASSIGNED)
    	{
    		bActivateAction = true;
    	}

   		switch((int)action.getIdActionObjectType())
    	{
    	case ObjectType.GED_DOCUMENT:
    		GedDocument doc = GedDocument.getGedDocument(action.getIdActionObjectReference());
    		sActionObjectName = "<span>" + doc.getDocumentName() + "</span>";
    		if(bActivateAction)
    		{
    			String sUrlReturn = "desk/dropnsign/action/modifyIndividualAction.jsp"
    				+ "?lId=" + action.getId()
    				+ "&sAction=setState"
    				+ "&lIdIndividualActionState=" + IndividualActionState.STATE_DONE;
    			
    			String sUrlReturnCipher = SecureString.getSessionSecureString(sUrlReturn, session);
    			
    			sAction = "<div>" 
    				//+ "<button>Display</button> <br/>"
    				+ "<button onclick='signDocument(" + doc.getId() + ", \"" + sUrlReturnCipher + "\")' >Sign</button> <br/>"
    				+ "<button onclick='refuseAction(" + action.getId() + ")' >Refuse</button> motivation: <input /> <br/>"
    				+ "</div>";
    		}
    		break;
    	}
   		
    	if( action.getIdIndividualActionState() == IndividualActionState.STATE_DONE)
  	    {
    		sAction = "<img src='" + rootPath + "images/dropnsign/16x16/green_check.png" + "' />";
  	    }
    	if( action.getIdIndividualActionState() == IndividualActionState.STATE_REFUSED)
  	    {
    		sAction = "<img src='" + rootPath + "images/dropnsign/16x16/red_cross.png" + "' />";
  	    }

    } catch(Exception e ) {
    	objectAction = new ObjectType();
    }

    
%>
	<tr>
		<td><%= CalendarUtil.getFormatDateHeureStd( action.getDateCreation())  %></td>
		<td><%= ppSource.getNomPrenom() %></td>
		<td><%= ppDestination.getNomPrenom() %></td>
		<td><%= actionType.getName() %></td>
		<td><%= actionState.getName() %></td>
		<td><%= objectAction.getName() %></td>
		<td><%= sActionObjectName %></td>
		<td><%= sAction %></td>
	</tr> 
<%		
}
%>
</table>
