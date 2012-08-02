<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.algorithme.*" %>
<% String sTitle = "Afficher toutes les phases"; 
	Vector vPhases = Phase.getAllStaticMemory();
	String sUseCaseIdBoutonAjouterPhase = "IHM-DESK";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%
	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterPhase ))
	{
%>
		<th>
			<object type="application/x-shockwave-flash" data="<%= response.encodeURL(rootPath + "images/icones/phase.swf?targetURL=" + response.encodeURL("modifierPhaseForm.jsp?sAction=create"))%>" style="text-align:left;width:38px;height:41px" >
  			<param name="movie" value="<%= response.encodeURL(rootPath + "images/icones/phase.swf?targetURL=" + response.encodeURL("modifierPhaseForm.jsp?sAction=create"))%>">
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
			<td class="pave_titre_gauche"> Liste des phases</td>
<%
	if(vPhases.size() > 1){
%>
			<td class="pave_titre_droite"><%= vPhases.size() %> Phases</td>
<%
	}
	else {
		if(vPhases.size() == 0) {
%>
			<td class="pave_titre_droite">Pas de phase</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 phase</td>
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
						<th>&nbsp;</th>
					</tr>
				<!-- Affichage des étapes -->
<%

for (int i=0; i < vPhases.size(); i++)
{
	Phase phase = (Phase) vPhases.get(i);
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste<%=i%2%>'" 
				  		onclick="Redirect('<%=response.encodeRedirectURL("afficherPhase.jsp?iIdPhase="+phase.getId())  %>')">
				    	<td style="width:25%"><%=phase.getId()  %></td>
				    	<td style="width:70%"><%=phase.getName()  %></td>
				    	<td style="width:5%;text-align:right">
				    	<a href="<%=response.encodeURL("afficherPhase.jsp?iIdPhase="+phase.getId())  %>" >
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
