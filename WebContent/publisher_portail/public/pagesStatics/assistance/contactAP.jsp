<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ page import="modula.candidature.*,modula.*,java.util.*,org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<% String sTitle = "Contacts"; %>
<% 
	String sMessage = "";
	try{
		sMessage = (!request.getParameter("sMessage").equalsIgnoreCase("null")?request.getParameter("sMessage"):"");
		sMessage = PreventInjection.preventForJavascript(sMessage);
	}catch(Exception e){} 
%>
<script type="text/javascript" src="<%= rootPath %>include/popup.js" ></script>
<script type="text/javascript" src="checkContactForm.js" ></script>
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
                Contact
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
     
    




&nbsp;&nbsp;&nbsp;<span class="firstLetter">C</span>ontactez notre service commercial.
<br /><br />
Vous souhaitez être contacté pour connaître nos tarifs et bénéficier d'une présentation 
complète de notre solution ? 
<br /><br />
Utilisez le formulaire suivant :
<br /><br />
<form action="<%=response.encodeURL("contact.jsp")
	%>" name="formulaire" onsubmit="javascript:return checkForm()">
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
			<td class="pave_cellule_gauche">
				<input type="checkbox" name="contact" id="contact" value="1" />&nbsp;
			</td>
			<td class="pave_cellule_droite">
				Je souhaite être contacté pour connaître les conditions tarifaires
				 d'accès au portail et bénéficier d'une présentation fonctionnelle complète.
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<input type="checkbox" name="offreEssai" id="offreEssai" value="1" />&nbsp;
			</td>
			<td class="pave_cellule_droite">
				Je suis intéressé par une offre à l'essai.
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		
		<tr>
			<td colspan="2" style="text-align:center">
				<input type="submit" value="Envoyer" />
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