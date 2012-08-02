<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.fr.bean.PersonnePhysique"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sAction;
	String sTitle ;
	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";
	DocumentReferent item = null;
	long lIdWorkflowDocument = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdWorkflowDocument" , -1);
	long lIdWorkflowDocumentReferentType = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdWorkflowDocumentReferentType" , -1);
	long lIdWorkflowDocumentReferent = CoinDatabaseAbstractBean.getLongFromHtmlForm(request, "lIdWorkflowDocumentReferent" , -1);

	if(sAction.equals("store"))
	{
		item = DocumentReferent.getDocumentReferent(lIdWorkflowDocumentReferent);

		sTitle = "Modifier";
	}
	else
	{

		item = new DocumentReferent();
		item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
		item.setIdWorkflowDocument(lIdWorkflowDocument);
		item.setIdWorkflowDocumentReferentType(lIdWorkflowDocumentReferentType);

		sTitle = "Créer";
	}

	Vector vDocumentReferentType = DocumentReferentType.getAllStatic();
	Vector vPersonne = PersonnePhysique.getAllStatic();



%>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDocumentReferent.jsp") %>" method="post" >
	<input type="hidden" name="lIdDocumentReferent" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="lIdWorkflowDocument" value="<%=item.getIdWorkflowDocument() %>" />
	<input type="hidden" name="lIdTypeObject" value="<%=item.getIdTypeObject() %>" />

	<%@ include file="../../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Référent du document</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Type :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdWorkflowDocumentReferentType", 1, vDocumentReferentType, item.getIdWorkflowDocumentReferentType())
			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Personne :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdRefenceObject", 1, vPersonne, item.getIdRefenceObject() )
			%>
				</td>
			</tr>
		</table>
	</div>
	<br />

	<div class="sectionFrame">

		<!-- Les boutons -->
		<div id="fiche_footer">
			<input type="submit" value="<%=sTitle %>"  />
			<input type="button" value="Annuler" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayDocument.jsp?lIdWorkflowDocument=" + item.getIdWorkflowDocument() )
				%>')" />
		</div>
	</div>
</div>
<%@ include file="../../include/footerFiche.jspf" %>
</form>
</body>
</html>