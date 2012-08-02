<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.faq.*,java.util.*,modula.graphic.*"%>
<% 
	String sTitle = "Gestion de la FAQ";
	String sPageUseCaseId = "IHM-DESK-FAQ-005";
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath%>include/cacherDivision.js"></script>
<%@include file="pave/faq.jspf" %>
</head>
<body onload="javascript:cacherToutesDivisions();">
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<form name="enAttente" action="validerQuestion.jsp">
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Questions en attente de validation</td>
<%
	Vector vCoupleQR = FAQ.getAllCoupleQR(" WHERE id_statut="+FAQConstant.INVALIDE+" ORDER BY id_type");
	if(vCoupleQR.size() > 1){
%>
		<td class="pave_titre_droite"><%= vCoupleQR.size() %> Questions</td>
<%
	}
	else {
		if(vCoupleQR.size() == 0) {
%>
		<td class="pave_titre_droite">Pas de Question</td>
<%
		}
		else {
%>
		<td class="pave_titre_droite">1 Question</td>
<%
		}
	}
%>
	</tr>	
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<tr>
					<th style="width:33%">Question</th>
					<th width="33%" style="text-align:right">Catégorie de question</th>
					<th style="text-align:right" width="33%">Accepter / Supprimer</th>
				</tr>
							
				<%
				for (int j=0 ; j<vCoupleQR.size() ; j++){
					FAQ oCouple = (FAQ) vCoupleQR.get(j) ;
					oCouple.load();
				%>
				<tr class="liste<%=j%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%2%>'">
					<td><%= oCouple.getQuestion() %></td>
					<td width="33%" style="text-align:right">
					<input type="hidden" value="<%=oCouple.getIdCoupleQR()%>" name="id" />
						<select name="typeQR">
							<option value="0" selected='selected'>Attribuer une catégorie</option>
	<%	Vector vType = FAQType.getAllFAQType();
		for (int i=0;i<vType.size();i++){
			FAQType type = (FAQType)vType.get(i);
			type.load();
	%>
							<option value="<%=type.getId()%>"><%=type.getName()%></option>
	<%
		}
	%>
						</select>
					</td>
					<td width="33%" style="text-align:right"><a href="#" onclick="javascript:return checkCategorie();">Accepter</a> / <a href="<%= response.encodeURL("supprimerQuestion.jsp?id="+oCouple.getIdCoupleQR()) %>" onclick="javascript:return confirm('Etes -vous sûr de vouloir supprimer définitivement cette question ?')">Supprimer</a></td>
				</tr>
				<%
				}
				%>
			</table>
		</td>
	</tr>
</table>
<br />
</form>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Questions validées, mises en ligne</td>
				
<%
	vCoupleQR = FAQ.getAllCoupleQR(" WHERE id_statut="+FAQConstant.VALIDE+" ORDER BY id_type");
	if(vCoupleQR.size() > 1){
%>
		<td class="pave_titre_droite"><%= vCoupleQR.size() %> Questions</td>
<%
	}
	else {
		if(vCoupleQR.size() == 0) {
%>
		<td class="pave_titre_droite">Pas de Question</td>
<%
		}
		else {
%>
		<td class="pave_titre_droite">1 Question</td>
<%
		}
	}
%>
	</tr>	
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<tr>
					<th style="width:33%">Question</th>
					<th width="33%" style="text-align:right">Catégorie de question</th>
					<th style="text-align:right" width="33%">Modifier / Supprimer</th>
				</tr>
				<%
				for (int j=0 ; j<vCoupleQR.size() ; j++){
					FAQ oCouple = (FAQ) vCoupleQR.get(j) ;
					oCouple.load();
					FAQType type = new FAQType(oCouple.getIdTypeQuestion());
					type.load();
				%>
				<tr class="liste<%=j%2%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%2%>'" onclick="javascript:montrer_cacher('div<%= oCouple.getIdCoupleQR()%>')">
					<td style="width:33%"><%= oCouple.getQuestion() %></td>
					<td width="33%" style="text-align:right"><%= type.getName()%></td>
					<td width="33%" style="text-align:right">
						<%if(sessionUserHabilitation.isHabilitate("IHM-DESK-FAQ-007") ) { %>
						<a href="<%= response.encodeURL("modifierQuestionReponseform.jsp?id="+oCouple.getIdCoupleQR())%>">
						<img width="25" src="<%= rootPath %>images/icones/modifier.gif"  title="Modifier" alt="Modifier"/>
						<%}%>
						</a>
						<%if(sessionUserHabilitation.isHabilitate("IHM-DESK-FAQ-008") ) { %>
						<a href="<%= response.encodeURL("supprimerQuestion.jsp?id=" + oCouple.getIdCoupleQR())%>" onclick="javascript:return confirm('Etes -vous sûr de vouloir supprimer définitivement cette question ?')">
				    		<img width="25" src="<%= rootPath + Icone.ICONE_SUPPRIMER %>"  title="Supprimer" alt="Supprimer"/>
						</a>
						<%}%>
					</td>
				</tr>
				<tr id="div<%=oCouple.getIdCoupleQR()%>">
					<td colspan="3">
						<ul>
							<li><%= org.coin.util.Outils.replaceNltoBr(oCouple.getReponseQuestion()) %></li>
						</ul>
					</td>
				</tr>
				<%
				}
				%>
			</table>
		</td>
	</tr>
</table>
<br />
<form action="<%= response.encodeRedirectURL("ajouterQuestionReponse.jsp") %>" method="post" name="formulaire2" onSubmit="javascript:return checkQuestionReponse()">
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Ajout d'une Question - Réponse</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Categorie :</td>
			<td class="pave_cellule_droite">
				<select name="type">
					<option value="0" selected='selected'>Attribuer une catégorie</option>
<%	Vector vType = FAQType.getAllFAQType();
	for (int i=0;i<vType.size();i++){
		FAQType type = (FAQType)vType.get(i);
		type.load();
%>
					<option value="<%=type.getId()%>"><%=type.getName()%></option>
<%
	}
%>
				</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Question :</td>
			<td class="pave_cellule_droite"><input type="text" name="question" maxlength="255" size="50" /></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche" style="vertical-align:top">Réponse :</td>
			<td class="pave_cellule_droite"><textarea name="reponse" cols="70" rows="8"></textarea></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td><input type="submit" value="Ajouter ce couple Question-Réponse" /></td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>
