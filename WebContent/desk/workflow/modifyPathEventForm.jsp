<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	long lIdPathEvent;
	String sAction;
	String sTitle ;
	PathEvent item;

	sAction = request.getParameter("sAction") ;
	String rootPath = request.getContextPath()+"/";



	if(sAction.equals("store"))
	{
		lIdPathEvent = Integer.parseInt( request.getParameter("lIdPathEvent") );
		sTitle = "Modifier un evt";
		item = PathEvent.getPathEvent(lIdPathEvent);
	}
	else
	{
		lIdPathEvent = -1;
		sTitle = "Ajouter un evt";
		item = new PathEvent();
	}

	Vector vObjectTypeGlobal =  ObjectType.getAllObjectType();
	Vector vObjectType =  new Vector<ObjectType>();

	for (int i=0; i < vObjectTypeGlobal.size(); i++)
	{
		ObjectType objtype = (ObjectType) vObjectTypeGlobal.get(i);

		switch ( (int) objtype.getId() )
		{
		case ObjectType.WORKFLOWDEFINITION_STATE :
		case ObjectType.WORKFLOWDEFINITION_TRANSITION :
		case ObjectType.WORKFLOWDEFINITION_TRANSITION_CONDITION :
			vObjectType.add(objtype);
			break;
		}
	}



%>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
</head>
<body>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyPathEvent.jsp") %>" method="post" >
	<input type="hidden" name="lIdPathEvent" value="<%=item.getId() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />

	<%@ include file="../include/headerFiche.jspf" %>
	<div id="fiche">

	<div class="sectionTitle"><div>Définition de evt <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Workflow :</td>
				<td class="frame"><input type="input" name="lIdWorkflow" value="<%= item.getIdWorkflow()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Event précédent :</td>
				<td class="frame"><input type="input" name="lIdPathEventPrevious" value="<%= item.getIdPathEventPrevious()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Type objet :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdTypeObjectEvent", 1, vObjectType, item.getIdTypeObjectEvent(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Référence objet :</td>
				<td class="frame"><input type="input" name="lIdReferenceObjectEvent" value="<%= item.getIdReferenceObjectEvent()%>" size="60" /></td>
			</tr>
			<tr>
				<td class="label" >Type objet cible :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdTypeObjectTarget", 1, vObjectTypeGlobal, item.getIdTypeObjectTarget(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Référence objet cible :</td>
				<td class="frame"><input type="input" name="lIdReferenceObjectTarget" value="<%= item.getIdReferenceObjectTarget()%>" size="60" /></td>
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