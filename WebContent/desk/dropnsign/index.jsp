<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@include file="/include/new_style/headerDeskUtf8.jspf" %>
<%
	PersonnePhysique person 
		=PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
		
%>
</head>
<body>
<div>
<img alt="" src="<%= rootPath + "images/dropnsign/64x64/locked.png" %>" /> 
<span style="font-size: 40px">Drop n' Sign</span>
<span style="font-size: 10px;padding-left: 100px;"><%= sessionUser.getLogin() + " (" + person.getNomPrenom() + ")" %></span>
<span style="font-size: 10px;padding-left: 100px;cursor: pointer;" onclick="logout()">logout</span>

</div>
<script type="text/javascript">

function logout()
{
	doUrl("<%= response.encodeURL(rootPath + "desk/logout.jsp" ) %>");
}

function displayRootFolder()
{
	$("mainFrame").src = "<%= response.encodeURL(rootPath + "desk/dropnsign/document/displayRootFolder.jsp" ) %>";
}

function displayAllIndividualLink()
{
	$("mainFrame").src = "<%= response.encodeURL(rootPath + "desk/dropnsign/link/displayAllIndividualLink.jsp" ) %>";
}

function displayAllIndividualTask()
{
	$("mainFrame").src = "<%= response.encodeURL(rootPath + "desk/dropnsign/action/displayAllIndividualAction.jsp" ) %>";
}

</script>

<table width="100%">
	<tr>
		<td width="150px" style="vertical-align: top;" >
		<div style="padding: 5px">
			<div onclick="displayRootFolder()" style="cursor: pointer;padding: 5px;" >Dossiers</div>
			<div onclick="todo()" style="cursor: pointer;padding: 5px;" >Partage</div>
			<div onclick="displayAllIndividualLink()" style="cursor: pointer;padding: 5px;" >Contacts</div>
			<div onclick="displayAllIndividualTask()" style="cursor: pointer;padding: 5px;" >Tâches</div>
			<div onclick="myProfile()" style="cursor: pointer;padding: 5px;" >Compte</div>
		</div>
		</td>
		<td width="90%" >
			<div style="border: 1px #eee solid;height: 700px" >
				<iframe id="mainFrame" width="100%" height="100%" frameborder="0" 
					src="<%= response.encodeURL(rootPath + "desk/dropnsign/document/displayRootFolder.jsp" ) %>" >
				</iframe>
			</div>
		</td>	
	</tr>
</table>


</body>
</html>