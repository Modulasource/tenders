<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*, modula.algorithme.*" %>
<%
	String sTitle = "Afficher toutes les etapes"; 
	Vector vEtapes = Etape.getAllStaticMemory();
	String sUseCaseIdBoutonAjouterEtape = "IHM-DESK-ALGO-001";
%>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<table class="menu" cellspacing="2" summary="menu">
	<tr>

<%

	if( sessionUserHabilitation.isHabilitate(sUseCaseIdBoutonAjouterEtape ))
	{
%>
		<th>
			<object type="application/x-shockwave-flash" data="<%= response.encodeURL(rootPath + "images/icones/etape.swf?targetURL=" + response.encodeURL("modifierEtapeForm.jsp?sAction=create"))%>" style="text-align:left;width:40px;height:45px" >
			  <param name="movie" value="<%= response.encodeURL(rootPath + "images/icones/etape.swf?targetURL=" + response.encodeURL("modifierEtapeForm.jsp?sAction=create"))%>">
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
			<td class="pave_titre_gauche"> Liste des étapes</td>
<%
	if(vEtapes.size() > 1){
%>
			<td class="pave_titre_droite"><%= vEtapes.size() %> Etapes</td>
<%
	}
	else {
		if(vEtapes.size() == 0) {
%>
			<td class="pave_titre_droite">Pas d'étape</td>
<%
		}
		else {
%>
			<td class="pave_titre_droite">1 etape</td>
<%
		}
	}
%>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" summary="none">
					<tr>
						<th>Libellé</th>
						<th>Phase</th>
						<th>Cas d'utilisation</th>
						<th>Commentaire</th>
						<th>&nbsp;</th>
					</tr>
<%

for (int i=0; i < vEtapes.size(); i++)
{
	Etape etape = (Etape) vEtapes.get(i);
%>
				  	<tr class="liste<%=i%2%>" onmouseover="className='liste_over'" 
				  		onmouseout="className='liste<%=i%2%>'" 
				  		onclick="Redirect('<%=response.encodeRedirectURL("afficherEtape.jsp?iIdEtape="+etape.getId())  %>')">
				    	<td style="width:20%"><%=etape.getLibelle()  %></td>
				    	<td style="width:20%"><%=Phase.getPhaseName( etape.getIdAlgoPhase() )  %></td>
				    	<td style="width:10%"><%=etape.getIdUseCase()  %></td>
				    	<td style="width:45%"><%=etape.getCommentaire()  %></td>
				    	<td style="width:5%;text-align:right">
							<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
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
