<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@page import="modula.faq.*"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "FAQ - Foire Aux Questions";
    String sPageUseCaseId = "IHM-PUBLI-3";  

    String sIdQuestion = "";
    if (request.getParameter("type_question")!=null) sIdQuestion = request.getParameter("type_question");
    String sRequest = " WHERE id_statut="+FAQConstant.VALIDE;
    boolean bIsNum = false;
    String sFiltre = null;
    String sChamp = null;
    if(request.getParameter("filtre")!=null) sFiltre = PreventInjection.preventStore(request.getParameter("filtre"));
    if(request.getParameter("champ")!=null) sChamp = request.getParameter("champ");
    if ((sFiltre!=null)&&(sChamp!=null)) sRequest +=" AND "+sChamp+" LIKE '%"+org.coin.util.Outils.addLikeSlashes(sFiltre)+"%' ";
    if((!sIdQuestion.equals("all"))&&(sIdQuestion!="")) {sRequest += " AND id_type="+sIdQuestion;bIsNum=true;}
    else sRequest +=" ORDER BY id_type";

%>
<%@ include file="/publisher_traitement/public/pagesStatics/assistance/pave/paveFAQ.jspf" %>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body onload="javascript:cacherToutesDivisions();">
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<div class="mention">
	Ce portail de Marchés Publics à votre disposition une liste de questions et de réponses.
</div>

<div style="clear:both"></div>
<form action="<%= response.encodeURL("ajouterQuestion.jsp")%>" method="post" name="formulaire2" onSubmit="javascript:return checkQuestionReponse()">

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Assistance</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >
		<tr onclick="cacherQuestion()">
			<td class="pave_titre_gauche" colspan="2">Pour poser une question, cliquez ici</td>
		</tr>
		<tr id="div_question_1">
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr id="div_question_3">
			<td style="text-align:center" colspan="2"><textarea name="question" cols="90" rows="8"></textarea></td>
		</tr>
		<tr id="div_question_4">
			<td style="text-align:center" colspan="2"><br /><input type="submit" value="Soumettre la question" /></td>
		</tr>
		<tr id="div_question_5">
			<td colspan="2">&nbsp;</td>
		</tr>
    </table>
</div>
</div>
</form>
<br />
<form action="<%= response.encodeURL("faq.jsp")%>" name="faq" method="post">			

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Assistance</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
    <table class="fullWidth" >
		<tr>
			<td class="pave_titre_gauche">Liste des Questions - Réponses</td>
	<%
		Vector vCoupleQR = FAQ.getAllCoupleQR(sRequest);
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
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<strong>Afficher les questions de la catégorie : </strong>
			</td>
			<td class="pave_cellule_droite">
					<%
						Vector vFAQType = FAQType.getAllFAQType();
					%>
								<select name="type_question">
								<option value="all">Toutes les catégories</option>
					<%			for(int i=0;i<vFAQType.size();i++){
					%>
								<option value="<%=((FAQType)vFAQType.get(i)).getId()
								%>"<% 
								if(bIsNum)
								{
									if (Integer.parseInt(sIdQuestion)==((FAQType)vFAQType.get(i)).getId())
									{
										%> selected='selected'<%
									}
								}%> >
								<%=((FAQType)vFAQType.get(i)).getName()%>
								</option>
					<%			
								}
					%>			
								</select>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Dont  :&nbsp;
			<select name="champ">
				<option value="question" >la question</option>
				<option value="reponse">la réponse</option>
			</select>
			</td>
			<td class="pave_cellule_droite">
				<strong>Contient :</strong> 
					<input type="text" name="filtre" value="" /> 
			</td>
		</tr>
		<tr>
			<td colspan="2" style="text-align:center"><input type="submit" value="Voir les résultats" /></td>
		</tr>
		<tr>
			<td colspan="2"></td>
		</tr>
		<tr>
			<td colspan="2">
				<table  >
					<tr>
						<th style="width:70%">Question</th>
						<th style="width:30%;text-align:right">Catégorie de question</th>
					</tr>
					<%
					for (int j=0 ; j<vCoupleQR.size() ; j++){
						FAQ oCouple = (FAQ) vCoupleQR.get(j) ;
						oCouple.load();
						FAQType type = new FAQType(oCouple.getIdTypeQuestion());
						type.load();
					%>
					<tr class="liste0" onmouseover="className='liste_over'" onmouseout="className='liste0'" onclick="javascript:montrer_cacher('div<%= oCouple.getIdCoupleQR()%>')">
						<td style="width:70%">
						<img src="<%=rootPath%>images/icones/puce.gif" style="width:10px;height;10px" alt="puce" />&nbsp;
						<%= oCouple.getQuestion() %> &nbsp;&nbsp;&nbsp;<div class="rouge">(Réponse)</div>
						</td>
						<td width="30%" style="text-align:right"><%= type.getName()%></td>
					</tr>
					<tr id="div<%=oCouple.getIdCoupleQR()%>">
						<td colspan="3">
							<ul>
								<li style="font-weight:normal"><%= org.coin.util.Outils.replaceNltoBr(oCouple.getReponseQuestion()) %></li>
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
</div>
</div>
</form>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>