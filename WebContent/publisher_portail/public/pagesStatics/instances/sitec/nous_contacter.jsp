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
		<p>Contactez notre service commercial. </p>
		<p>Vous souhaitez �tre contact� pour conna�tre nos tarifs et b�n�ficier d'une pr�sentation compl�te de la solution ? </p>
		<p>Utilisez le formulaire suivant : </p>
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