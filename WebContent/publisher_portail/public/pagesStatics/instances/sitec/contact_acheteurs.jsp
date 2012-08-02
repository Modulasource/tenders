<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ page import="modula.candidature.*,modula.*,java.util.*,org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<% String sTitle = "Contact"; %>
<% 
	String sMessage = "";
	try{
		sMessage = (!request.getParameter("sMessage").equalsIgnoreCase("null")?request.getParameter("sMessage"):"");
		sMessage = PreventInjection.preventForJavascript(sMessage);
	}catch(Exception e){} 
%>
<script type="text/javascript" src="<%= rootPath %>include/popup.js" ></script>
<script type="text/javascript" src="../../assistance/checkContactForm.js" ></script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body style="text-align:justify">
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<br />


<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td class="post-title-alt">
                L'accompagnement et la formation
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
    <%
	if(sMessage != ""){
%>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2" style="color:red;text-align:center;font-weight:bold"><%= sMessage %></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
<%
	} else {
    
%>
       <tr>
            <td>
     
    

	<style>
	.redac {
	   font-size:12px;
	}
	.redac p,ul{
	    padding:5px;
	}
	</style>
	
	<div class="redac">
		<p>
		Acheteurs publics, nos forfaits de publication incluent au choix :
		<ul>
		<li>une aide par télé-assistance au démarrage </li>
		<li>un programme de formation pour la prise en main du logiciel </li>
		<li>des prestations de télé accompagnement adaptées à vos besoins</li>
		<li>une prestation de service clé en main</li>
		</ul>
				</p>
		<p>pour assurer le bon déroulement de vos procédures dématérialisées. </p>
		<p>
		<u>Le service clé en main :</u>
		</p>
		<p>A partir de vos documents électroniques et dans un délai de 24 heures, nous réalisons pour vous :
		<ul>
		<li>La publication des avis d'appels public à concurrence sur votre profil acheteur et sur les supports Presse Régionale, BOAMP, JOUE</li>
		<li>La publication des Dossiers de Consultation des Entreprises</li>
		<li>La gestion du registre des retraits</li>
		<li>L'assistance dédiée lors du décachetage en CAO</li>
		<li>L'attribution et archivage du marché</li>
		</ul>
		</p>
		<p>
		<u>La formation d'une journée aborde les points suivants :</u>
		<ul>
		<li>Les obligations légales des acheteurs publics dans le cadre de la dématérialisation des marchés publics.</li>
		<li>Présentation des interfaces du logiciel et du principe de fonctionnement général. </li>
		<li>Le déroulement d'une procédure</li>
		</ul>
		</p>
		<p>
		<u>Le télé accompagnement :</u>
		</p>
		<p>Les prestations de télé accompagnement consistent en l'intervention planifiée de notre service d'assistance lors de toutes les étapes critiques de la passation d'un marché. 
		Un télé accompagnateur dédié à votre marché planifie les dates de ses interventions pour vous assister lors des phases suivantes :
		<ul>
		<li>Rédaction et publication des avis, </li>
		<li>Préparation de la Commission des Appels d'Offre, </li>
		<li>Décachetage des plis lors de la réunion de la commission, </li>
		<li>Aide à la rédaction de l'avis d'attribution. </li>
		</ul>
		</p>
		<p>Pour connaître le détail de ces prestations n'hésitez pas à contacter notre service commercial, en utilisant le formulaire suivant :</p>
	</div>

	<form action="<%=response.encodeURL("contact.jsp")%>" name="formulaire" onsubmit="javascript:return checkForm()" style="padding:20px;">
		<table style="width:60%">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td class="pave_cellule_gauche">Raison Sociale* :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="raison_sociale" id="raison_sociale" value=""/>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Qualité* :</td>
				<td class="pave_cellule_droite">
					<select name="civilite">
						<option value="Mademoiselle">Mademoiselle</option>
						<option value="Madame">Madame</option>
						<option value="Monsieur">Monsieur</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Nom* :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="nom" id="nom" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Prénom* :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="prenom" id="prenom" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Téléphone* :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="tel" id="tel" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Email* :</td>
				<td class="pave_cellule_droite">
					<input type="text" name="email" id="email" value="" />
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td class="pave_cellule_gauche" style="text-align:right;vertical-align:top">
					<input type="checkbox" checked="checked" name="contact" id="contact" value="2" />&nbsp;
				</td>
				<td class="pave_cellule_droite">
					Je souhaite obtenir des informations sur les conditions tarifaires d'accès au portail et bénéficier d'une présentation fonctionnelle complète.
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
			
			<tr>
				<td colspan="2" style="text-align:center">
					<input type="submit" value="Envoyer" style="padding:2px 6px 2px 6px"/>
				</td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	</form>

</td>
</tr>
<%
		} // else sMessage != ""
%>

    </table>
    </div>
</div>


</body>
</html>