<%@ include file="../../../../include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.db.*,org.coin.bean.html.*,java.util.*" %>
<%@ include file="../../../publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
	if (organisation.getIdCreateur() == candidat.getIdPersonnePhysique())
	{
		String sTitle = "Transférer la gérance de l'organisation";
		String sFormPrefix = "";
		
		  HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
		    hbFormulaire.bIsForm = false;
%>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
</head>
<body>
<%@ include file="../../../publisher_traitement/public/include/header.jspf" %>

<form action="<%=response.encodeRedirectURL(rootPath 
        + "publisher_traitement/private/organisation/transfererGeranceOrganisation.jsp")
        %>" method="post" name="formulaire">

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Gérant actuel</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
    <br/>
    
    <div class="post-footer post-block" style="margin-top:0">
	    <table class="fullWidth">
			<%= hbFormulaire.getHtmlTrInput("Membre :","",candidat.getCivilitePrenomNom()) %>
		</table>
    </div>
	<br />

    <% hbFormulaire.bIsForm = true; %>
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Nouveau gérant</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
    <br/>
    <div class="post-footer post-block" style="margin-top:0">
        <table class="fullWidth">
			<tr>
				<td class="pave_cellule_gauche">Transférer la gérance au membre :</td>
				<td class="pave_cellule_droite">
				<% Vector vPersonnes = PersonnePhysique.getAllFromIdOrganisation(organisation.getIdOrganisation()); %>
				<%= CoinDatabaseAbstractBeanHtmlUtil.getHtmlSelectSecure(
						"choixMembre",
						1,
						(Vector<CoinDatabaseAbstractBean>)vPersonnes,candidat.getId(),
						"",
						session) %>
				</td>
			</tr>
		</table>
	</div>
</div>
<br />
<div style="text-align:center">
	<button type="submit" name="submit" >Transférer la gérance</button>&nbsp;
	<button type="reset" onclick="Redirect('<%=
		response.encodeURL( rootPath + "publisher_portail/private/candidat/indexCandidat.jsp")
		%>')" >Annuler</button>
</div>
</form>
<%@include file="../../../publisher_traitement/public/include/footer.jspf"%>
</body>		
<%
	}
	else
		response.sendRedirect(response.encodeRedirectURL("afficherOrganisation.jsp"));
%>
</html>

