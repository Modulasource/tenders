<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	long lIdWorkflow;
	String sAction;
	String sTitle ;
	Workflow item;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";



	if(sAction.equals("store"))
	{
		lIdWorkflow = Integer.parseInt( request.getParameter("lIdWorkflow") );
		sTitle = "Modifier un workflow";
		item = Workflow.getWorkflow(lIdWorkflow);
	}
	else
	{
		lIdWorkflow = -1;
		sTitle = "Ajouter un workflow";
		item = new Workflow();
	}

	Vector vWorkflows =  DefinitionWorkflow.getAllStatic();
	Vector vStates = DefinitionState.getAllStatic();

	Vector vObjectTypeGlobal =  ObjectType.getAllObjectType();
	Vector vObjectType =  new Vector<ObjectType>();

	for (int i=0; i < vObjectTypeGlobal.size(); i++)
	{
		ObjectType objtype = (ObjectType) vObjectTypeGlobal.get(i);

		switch ( (int) objtype.getId() )
		{
		case ObjectType.ORGANISATION :
		case ObjectType.PERSONNE_PHYSIQUE :
		case ObjectType.OBJECT_GROUP  :
		case ObjectType.ORGANISATION_SERVICE :
		case ObjectType.WORKFLOW_DOCUMENT :
		case ObjectType.WORKFLOW_FOLDER:
			vObjectType.add(objtype);
			break;
		}
	}



%>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyWorkflow.jsp") %>" method="post" >
	<input type="hidden" name="lIdWorkflow" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<%@ include file="../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Workflow <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Workflow initial :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionWorkflowInitial", 1, vWorkflows, item.getIdDefinitionWorkflowInitial(), "", true, false)

			%>
				</td>
			</tr>

<%
	if(sAction.equals("store"))
	{
%>			<tr>
				<td class="label" >Etat courant :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionStateCurrent", 1, vStates, item.getIdDefinitionStateCurrent(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Workflow courant :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdDefinitionWorkflowCurrent", 1, vWorkflows, item.getIdDefinitionWorkflowCurrent(), "", true, false)

			%>
				</td>
			</tr>
<%
	}
	else
	{
%>
	<input type="hidden" name="lIdDefinitionStateCurrent" value="-1" />
	<input type="hidden" name="lIdDefinitionWorkflowCurrent" value="-1" />

<%
	}
%>
			<tr>
				<td class="label" >Type objet :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdTypeObject", 1, vObjectType, item.getIdTypeObject(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Référence objet :</td>
				<td class="frame"><input type="input" name="lIdReferenceObject" value="<%= item.getIdReferenceObject()%>" size="60" /></td>
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
						"displayAllPathEvent.jsp" )
				%>')" />
		</div>
	</div>
</div>
<%@ include file="../include/footerFiche.jspf" %>
</form>
</body>
</html>