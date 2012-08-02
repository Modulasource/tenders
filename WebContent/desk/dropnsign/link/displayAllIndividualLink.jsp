<%@page import="org.coin.bean.addressbook.IndividualLinkDom"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.addressbook.IndividualLinkState"%>
<%@page import="org.coin.bean.addressbook.IndividualLinkType"%>
<%@page import="org.coin.bean.addressbook.IndividualLink"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%

	IndividualLinkDom dom = new IndividualLinkDom(sessionUser.getIdIndividual());
	dom.computeList();

%>
<script type="text/javascript">
function acceptIndividualLink(lId)
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/link/modifyIndividualLink.jsp" 
			+ "?sAction=accept") %>"
		+ "&lId=" + lId);
}
function refuseIndividualLink(lId)
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/link/modifyIndividualLink.jsp" 
			+ "?sAction=refuse") %>"
		+ "&lId=" + lId);
}
function removeIndividualLink(lId)
{
	doUrl("<%= response.encodeURL(rootPath 
			+ "desk/dropnsign/link/modifyIndividualLink.jsp" 
			+ "?sAction=remove") %>"
		+ "&lId=" + lId);
}
</script>

</head>
<body>
<div>
<form action="<%= response.encodeURL(
		rootPath + "desk/dropnsign/link/modifyIndividualLink.jsp"
		+ "?sAction=create"
		+ "&mode=login") %>" method="post">
Login : <input name="sLogin"  />
<button onclick="">Ajouter contact</button>
</form>
</div>
<div style="margin-top: 30px;">Contact</div>
<%	
	for(IndividualLink link : dom.vItemAccepted)
	{
		long lIdLinked = 0;
		if(link.getIdIndividualDestination() == sessionUser.getIdIndividual())
		{
			lIdLinked = link.getIdIndividualSource();
		} else {
			lIdLinked = link.getIdIndividualDestination();
		}
		
		PersonnePhysique p = PersonnePhysique.getPersonnePhysique(lIdLinked);
%>
<div style="float: left;padding: 15px;" >
<img
	style="cursor: pointer;"
	onclick="todo(<%= p.getId() %>);" 
	src="<%= rootPath + "images/dropnsign/64x64/individual.png" %>" /><br/>
<div style="text-align: center;">
<%= p.getPrenomNom() %> <br/>
<%= p.getEmail() %>
</div>
<div>
	<button onclick="removeIndividualLink(<%= link.getId() %>);" >Supprimer</button>
</div>
</div>

<%		
	}
%>
<div style="clear: both;"></div>


<div style="margin-top: 30px;">Contact à confirmer</div>
<%	
	for(IndividualLink link : dom.vItemToConfirm)
	{
		PersonnePhysique p = PersonnePhysique.getPersonnePhysique(link.getIdIndividualSource());
%>
<div style="float: left;padding: 15px;" >
<img
	style="cursor: pointer;"
	onclick="todo(<%= p.getId() %>);" 
	src="<%= rootPath + "images/dropnsign/64x64/individual.png" %>" /><br/>
<div style="text-align: center;">
<%= p.getPrenomNom() %> <br/>
<%= p.getEmail() %>
</div>
<div>
	<button onclick="acceptIndividualLink(<%= link.getId() %>);" >Accepter</button>
	<button onclick="refuseIndividualLink(<%= link.getId() %>);" >Refuser</button>
</div>
</div>
<%		
	}
%>
<div style="clear: both;"></div>


<div style="margin-top: 30px;">Demande en attente</div>
<%	
	for(IndividualLink link : dom.vItemPending)
	{
		PersonnePhysique p = PersonnePhysique.getPersonnePhysique(link.getIdIndividualDestination());
%>
<div style="float: left;padding: 15px;" >
<img
	style="cursor: pointer;"
	onclick="todo(<%= p.getId() %>);" 
	src="<%= rootPath + "images/dropnsign/64x64/individual.png" %>" /><br/>
<div style="text-align: center;">
<%= p.getPrenomNom() %> <br/>
<%= p.getEmail() %>
</div>
</div>
<%		
	}
%>
<div style="clear: both;"></div>

</body>
</html>