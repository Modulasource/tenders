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
		<li>une aide par t�l�-assistance au d�marrage </li>
		<li>un programme de formation pour la prise en main du logiciel </li>
		<li>des prestations de t�l� accompagnement adapt�es � vos besoins</li>
		<li>une prestation de service cl� en main</li>
		</ul>
				</p>
		<p>pour assurer le bon d�roulement de vos proc�dures d�mat�rialis�es. </p>
		<p>
		<u>Le service cl� en main :</u>
		</p>
		<p>A partir de vos documents �lectroniques et dans un d�lai de 24 heures, nous r�alisons pour vous :
		<ul>
		<li>La publication des avis d'appels public � concurrence sur votre profil acheteur et sur les supports Presse R�gionale, BOAMP, JOUE</li>
		<li>La publication des Dossiers de Consultation des Entreprises</li>
		<li>La gestion du registre des retraits</li>
		<li>L'assistance d�di�e lors du d�cachetage en CAO</li>
		<li>L'attribution et archivage du march�</li>
		</ul>
		</p>
		<p>
		<u>La formation d'une journ�e aborde les points suivants :</u>
		<ul>
		<li>Les obligations l�gales des acheteurs publics dans le cadre de la d�mat�rialisation des march�s publics.</li>
		<li>Pr�sentation des interfaces du logiciel et du principe de fonctionnement g�n�ral. </li>
		<li>Le d�roulement d'une proc�dure</li>
		</ul>
		</p>
		<p>
		<u>Le t�l� accompagnement :</u>
		</p>
		<p>Les prestations de t�l� accompagnement consistent en l'intervention planifi�e de notre service d'assistance lors de toutes les �tapes critiques de la passation d'un march�. 
		Un t�l� accompagnateur d�di� � votre march� planifie les dates de ses interventions pour vous assister lors des phases suivantes :
		<ul>
		<li>R�daction et publication des avis, </li>
		<li>Pr�paration de la Commission des Appels d'Offre, </li>
		<li>D�cachetage des plis lors de la r�union de la commission, </li>
		<li>Aide � la r�daction de l'avis d'attribution. </li>
		</ul>
		</p>
		<p>Pour conna�tre le d�tail de ces prestations n'h�sitez pas � contacter notre service commercial, en utilisant le formulaire suivant :</p>
	</div>

	<form action="<%=response.encodeURL("contact.jsp")%>" name="formulaire" onsubmit="javascript:return checkForm()" style="padding:20px;">
		<table style="width:60%">
			<tr><td colspan="2">&nbsp;</td></tr>
			<tr>
				<td class="pave_cellule_gauche">Raison Sociale*�:</td>
				<td class="pave_cellule_droite">
					<input type="text" name="raison_sociale" id="raison_sociale" value=""/>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Qualit�*�:</td>
				<td class="pave_cellule_droite">
					<select name="civilite">
						<option value="Mademoiselle">Mademoiselle</option>
						<option value="Madame">Madame</option>
						<option value="Monsieur">Monsieur</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Nom*�:</td>
				<td class="pave_cellule_droite">
					<input type="text" name="nom" id="nom" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Pr�nom*�:</td>
				<td class="pave_cellule_droite">
					<input type="text" name="prenom" id="prenom" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">T�l�phone*�:</td>
				<td class="pave_cellule_droite">
					<input type="text" name="tel" id="tel" value="" />
				</td>
			</tr>
			<tr>
				<td class="pave_cellule_gauche">Email*�:</td>
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
					Je souhaite obtenir des informations sur les conditions tarifaires d'acc�s au portail et b�n�ficier d'une pr�sentation fonctionnelle compl�te.
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