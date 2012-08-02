<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*,java.util.*" %>
<%
	String sTitle = "Article du CMP: ";
	ArticleLoi article = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if (sAction.equals("create")) {
		article = new ArticleLoi();

	}
	if (sAction.equals("store")) {
		long lId = Long.parseLong(request.getParameter("lId"));
		article = ArticleLoi.getArticleLoi((int)lId);
		sTitle += "<span class=\"altColor\">"
		+ article.getIdArticleLoi() + " "
		+ article.getLibelle() + "</span>";

	}

	MarchePassation marchePassation = null;
	try{
		marchePassation = MarchePassation.getMarchePassation(article.getIdMarchePassation());
	} catch (CoinDatabaseLoadException e) {
		marchePassation = new MarchePassation();
	}

	ArticleLoiEtat articleLoiEtat = null;
	try{
		articleLoiEtat = ArticleLoiEtat.getArticleLoiEtat(article.getIdArticleLoiEtat());
	} catch (CoinDatabaseLoadException e) {
		articleLoiEtat = new ArticleLoiEtat();
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave( );
	pave.bIsForm = true;
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/ArticleLoi.js"></script>
<script type="text/javascript">
function displayAllArticleLoi() {
	location.href = "<%=
		response.encodeURL(rootPath+"desk/parametrage/affaire/displayAllArticleLoi.jsp")
		%>";
}

function removeItem()
{
    if(confirm("Voulez vous vraiment effacer cet article ?")){
    	ArticleLoi.removeFromId(<%=article.getId()%>,function() { 
            location.href = '<%=response
									.encodeURL("displayAllArticleLoi.jsp")%>';
           });
     }
}
</script>

</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyArticleLoi.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<input type="hidden" name="lId" value="<%=  article
			.getIdArticleLoi() %>" />
		<table class="formLayout" cellspacing="3">
		<%=pave.getHtmlTrInput("Libelle :", "sLibelle", article
							.getLibelle(), "size=\"100\"")%>
		<%=pave.getHtmlTrSelect("Marche passation :",
							"iIdMarchePassation", marchePassation)%>
		<%=pave.getHtmlTrInput("Id Marco :", "iIdReferenceMarco",
							article.getIdReferenceMarco(), "size=\"100\"")%>
		<%=pave.getHtmlTrSelect("Etat :",
							"lIdArticleLoiEtat", articleLoiEtat)%>
		
		</table>
</div>


<div id="fiche_footer">
	<button type="submit">Valider</button>
<%
if(sAction.equals("store"))
{

%>
	<button type="button" onclick="removeItem()">Supprimer</button>
<%
}
%>
	<button type="button" onclick="javascript:displayAllArticleLoi();">Annuler</button>

</div>
</form>

<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.ArticleLoi"%>
<%@page import="modula.marche.MarchePassation"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="modula.marche.ArticleLoiEtat"%>
</html>
