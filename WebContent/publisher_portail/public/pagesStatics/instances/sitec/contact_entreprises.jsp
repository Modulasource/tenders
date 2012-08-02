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
		<p>Nous vous proposons un panel de formations complètes, pratiques et adaptées à votre structure qui vous permettrons d'acquérir toutes les compétences pour :
		<ul>
		<li>utiliser vos certificats électroniques en toute sérénité, et dans de bonnes conditions de sécurité,</li>
		<li>envoyer vos candidatures et offres sur les principales plateformes de dématérialisation de marchés, </li>
		<li>effectuer toutes les télé-déclarations aux différents organismes sociaux (TéléTVA, DUCS, etc) </li>
		</ul>
				</p>
		<p>
		Nos stages sont organisés en inter ou en intra entreprise en fonction de vos souhaits. Si vous en faites la demande, nous pouvons élaborer ensemble un programme de formation adapté à vos besoins particuliers.<br/>
		Nos formations peuvent être financées par l'OPCA de votre branche d'activité.
		</p>
		<p>Informations, programmes et tarifs vous seront fournis par notre service commercial au 0810 618 868 (prix d'un appel local) ou en remplissant le formulaire ci-dessous :
		</p>
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
					<input type="checkbox" checked="checked" name="contact" id="contact" value="1" />&nbsp;
				</td>
				<td class="pave_cellule_droite">
					Je souhaite être contacté pour avoir des informations sur les programmes de formation et d'accompagnement aux entreprises
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