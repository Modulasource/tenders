<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<% 
	String sTitle = "Articles du CMP"; 
	Vector<ArticleLoi> vArticle = ArticleLoi.getAllStaticMemory();
	
	
	String sPageUseCaseId = "xxx";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
%>
<script type="text/javascript">


function doUrl(url)
{		
	window.location.href = url ;
}


function displayArticle(id) {

	
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/modifyArticleLoiForm.jsp")%>?sAction=store&lId="+id;

	location.href = sUrl;
}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	<div class="right">
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL(rootPath+"desk/parametrage/affaire/modifyArticleLoiForm.jsp?sAction=create") 
		%>');" >Ajouter</button>
	</div><br />
	<div class="dataGridHolder fullWidth">
		<table class="pave" summary="none">
			<tr class="header">
				<th >Id</th>
				<th >Marche passation</th>
				<th >Libellé</th>
				<th >Etat</th>
				<th >Id Marco</th>
			</tr>
<%
	for (int i=0; i < vArticle.size(); i++) {
		ArticleLoi article = vArticle.get(i);
	
		String sMarchePassationName = "";
		try{
			sMarchePassationName = MarchePassation.getMarchePassationNameMemory( 
					article.getIdMarchePassation());
		}catch (Exception e) {}
	
		String sArticleLoiEtat = "";
		try{
			switch((int)article.getIdArticleLoiEtat())
			{
			case 1 : 
				sArticleLoiEtat = "Valide" ;
				break;
			case 2 :
				sArticleLoiEtat = "Obsolète" ;
				break;
			default : 
				sArticleLoiEtat = "?" ;
			break;
			}
		}catch (Exception e) {}
		
	
%>
			<tr class="liste<%=i%2%>" 
				onmouseover="className='liste_over'" 
				onmouseout="className='liste<%=i%2%>'" 
				onclick="javascript:displayArticle('<%= article.getId()  %>');">
		    	<td style="width:5%"><%= article.getIdArticleLoi() %></td>
		    	<td style="width:40%"><%= article.getIdMarchePassation() %> - 
		    	<%= sMarchePassationName%></td>
		    	<td style="width:40%"><%= article.getLibelle() %></td>
		    	<td style="width:10%"><%= sArticleLoiEtat %></td>
		    	<td style="width:5%"><%= article.getIdReferenceMarco() %></td>
		    </tr>
<%
	}
%>
				</table>
	</div>
	</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.ArticleLoi"%>
<%@page import="modula.marche.MarchePassation"%>
</html>
