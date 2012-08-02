<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>
<%
	PersonnePhysiqueParametre item = new PersonnePhysiqueParametre();
	String sId = HttpUtil.parseStringBlank("sId", request);
	Vector<Object> vParam  = new Vector<Object>();
	vParam.add("system.page.html.news");
	vParam.add(sId);
	
	Vector<PersonnePhysiqueParametre>
		vPPParam = item.getAllWithWhereAndOrderByClause(
				"WHERE name=? "
				+ " AND value=? ",
				"",
				vParam);
%>
<script type="text/javascript" src="<%=rootPath %>dwr/engine.js"></script>
<script type="text/javascript" src="<%=rootPath %>dwr/util.js"></script> 
<script type="text/javascript" src="<%=rootPath %>dwr/interface/PersonnePhysiqueParametre.js?v=<%= PersonnePhysiqueParametre.AJAX_VERSION %>"></script>

<script type="text/javascript">
<!--
mt.config.enableAutoLoading = false;

function displayPerson(lIdPerson)
{
	var sUrl = "<%= response.encodeURL(
		rootPath + "desk/organisation/afficherPersonnePhysique.jsp"
		+ "?iIdPersonnePhysique=" ) %>" + lIdPerson;


	top.addParentTabForced("...",sUrl);
	
}

function removeNews(sIdDiv, lId)
{
	if(confirm("Etes-vous sûr ?"))
	{
		PersonnePhysiqueParametre.removeById(
				lId, 
				function(){
					Element.remove(sIdDiv);
				});
	}
}


//-->
</script>
</head>
<body>

<%
	for(PersonnePhysiqueParametre param : vPPParam)
	{
		try{
			PersonnePhysique pp 
			= PersonnePhysique.getPersonnePhysique(param.getIdPersonnePhysique());

			User user 
			= User.getUserFromIdIndividual(param.getIdPersonnePhysique());

			%>
			<div style="border: #aaa 1px solid; padding: 5px; margin: 5px;"
				id="news_<%= param.getId() %>">
				<table width="100%">
					<tr>
						<td style="width: 30%" >
							<%= pp.getPrenomNom() %> 
						</td>
						<td style="width: 40%" >
							<%= user.getLogin() %> 
						</td>
						<td style="width: 30%" >
								<span style="cursor: pointer;color: #2361AA;" 
									onclick="displayPerson(<%=  pp.getId() %>)" >Voir</span>
								<span style="cursor: pointer;color: #2361AA;"
									onclick="removeNews('news_<%= param.getId() %>', <%= param.getId()%>)" 
									>Supprimer</span>
						</td>
					</tr>
				</table>
			</div>
			<%		
		
		}catch (Exception e) {
			
		}

	}
%>
</body>
</html>
