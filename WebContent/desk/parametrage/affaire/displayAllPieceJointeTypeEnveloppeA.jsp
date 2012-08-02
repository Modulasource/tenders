<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*" %>
<%@page import="java.util.Vector"%>
<%@page import="modula.candidature.EnveloppeAPieceJointeType"%>
<% 
	String sTitle = "Pi�ces jointes types - enveloppe a";
	String sEnvelop="";
	String sPageUseCaseId = "xxx";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	Vector<EnveloppeAPieceJointeType> vPieceType =EnveloppeAPieceJointeType.getAllEnveloppeAPieceJointeType();
	%>
<script type="text/javascript">


function doUrl(url)
{		
	window.location.href = url ;
}


function displayPieceJointeType(id) {

	
	var sUrl = "<%=
		response.encodeURL(
				rootPath
				+"desk/parametrage/affaire/modifyPieceJointeTypeEnveloppeAForm.jsp")%>?sAction=store&lId="+id;

	location.href = sUrl;
}

</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div id="fiche">
	<div class="right">
	<button type="button" onclick="javascript:doUrl('<%=
		response.encodeURL(rootPath+"desk/parametrage/affaire/modifyPieceJointeTypeEnveloppeAForm.jsp?sAction=create") 
		%>');" >Ajouter</button>
	</div><br />
	<div class="dataGridHolder fullWidth">
		<table class="pave" summary="none">
			<tr class="header">
				<th >Id</th>
				<th >Libell�</th>
			</tr>
<%
	for (int i=0; i < vPieceType.size(); i++) {
		EnveloppeAPieceJointeType piece = vPieceType.get(i);
%>
			<tr class="liste<%=i%2%>" 
				onmouseover="className='liste_over'" 
				onmouseout="className='liste<%=i%2%>'" 
				onclick="javascript:displayPieceJointeType('<%= piece.getId()  %>');">
		    	<td style="width:5%"><%= piece.getId() %></td>
		    	<td style="width:95%"><%= piece.getName() %></td>
		    </tr>
<%
	}
%>
				</table>
	</div>
	</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.candidature.EnveloppeAPieceJointeType"%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.If"%></html>
