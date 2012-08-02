<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.algorithme.condition.*" %>
<% String sTitle = "Afficher toutes les conditions"; 
	Vector vConditions = ConditionBean.getAllConditionBean();
	String sUseCaseIdBoutonAjouterCondition = "IHM-DESK";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" summary="menu">
	<tr>
<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterCondition ))
	{
%>
		<th style="text-align:left">
			<object type="application/x-shockwave-flash" data="<%= rootPath %>images/icones/condition.swf?targetURL=<%= response.encodeURL("modifierConditionForm.jsp?sAction=create")%>" style="text-align:left;width:40px;height:45px" >
			  <param name="movie" value="<%= rootPath %>images/icones/condition.swf?targetURL=<%= response.encodeURL("modifierConditionForm.jsp?sAction=create")%>">
			  <param name="quality" value="high">
			  <param name="wmode" value="transparent">
			</object>
		</th>
<%
	}
%>
		<td>&nbsp;</td>
	</tr>
</table>
<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche">Liste des conditions</td>
<%
	if(vConditions.size() > 1){
%>
			<td class="pave_titre_droite"><%= vConditions.size() %> conditions</td>
<%
	}
	else {
		if(vConditions.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de condition</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 condition</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>Référence</th>
						<th>Libellé</th>
						<th>Certifié</th>
						<th>&nbsp;</th>
					</tr>
<%

for (int i=0; i < vConditions.size(); i++)
{
	ConditionBean condition = (ConditionBean) vConditions.get(i);
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste<%=i%2%>'" 
				  		onclick="Redirect('<%=response.encodeRedirectURL("afficherCondition.jsp?iIdCondition="+condition.getId())  %>')">
				    	<td style="width:15%"><%=condition.getId()  %>&nbsp;</td>
				    	<td style="width:70%"><%=condition.getName()  %></td>
				    	<td style="width:10%">&nbsp;</td>
				    	<td style="width:5%;text-align:right">
				    	<a href="<%=response.encodeURL("afficherCondition.jsp?iIdCondition="+condition.getId())  %>" >
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
				    	</a>
				    	</td>
				  	</tr>
<%
}
%>
				</table>
			</td>
		</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
