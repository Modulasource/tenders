<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.organigram.*"%>
<%@page import="modula.graphic.Onglet"%>
<%
	long lIdOrganigram ;
	String sIdUser ;
	String sSelected ;

	String sTitle = "Afficher un organigramme";
	String sPageUseCaseId = "xxx";


	lIdOrganigram = Long.parseLong( request.getParameter("lIdOrganigram") );
	Organigram item = Organigram.getOrganigram(lIdOrganigram );
	Vector vNode = OrganigramNode.getAllFromIdOrganigram( item.getId());

	int iDndCellSizeX = 80;
	int iDndCellSizeY = 80;

%>

<link rel="stylesheet" type="text/css" href="dnd.css" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/js/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/dnd.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/wz_jsgraphics.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/drawingtoolkit.js"></script>
<style type="text/css" >
	div.dndCell {
		width: <%= iDndCellSizeX %>px;
		height: <%= iDndCellSizeY %>px;
		background: #eee none;
		border: 1px solid #ddd;
		font-size: 0.9em;
		cursor: move;
		position: absolute
		}
</style>

<script type="text/javascript">
<!--



// to draw directly into the document
var jg_doc ;
var g_box_width = <%= iDndCellSizeX %>;
var g_box_height = <%= iDndCellSizeY %>;

function my_drag(e){

	if(isDragging == true){
		var newPosX;
		var newPosY;
		getPositionCurseur(e);
		newPosX = curX - ecartX;
		newPosY = curY - ecartY;

		drag(e);
	}
}

function my_beginDrag(p_obj,e){
	beginDrag(p_obj,e);
}

function my_endDrag(){
	//endDrag();

	jg_doc.clear();
    jg_doc.setColor("maroon");


	<%
	for (int i=0; i < vNode.size(); i++)
	{
		OrganigramNode node = (OrganigramNode) vNode.get(i);

		if(node.getIdOrganigramNodeParent() != node.getId() )
		{
		%>

		normDivPositionFromCanevas('node_<%= node.getId() %>', 10);

		my_drawLine('node_<%=
				node.getIdOrganigramNodeParent() %>', 'node_<%=
	 			node.getId() %>');
		<%
		}
	}
	%>

	jg_doc.paint();

}
function my_drawLine(a, b)
{
	mt_drawVectorWithCorner(a, b);
}

function storePosition()
{
	<%
	for (int i=0; i < vNode.size(); i++)
	{
		OrganigramNode node = (OrganigramNode) vNode.get(i);
		%>
		var point = getVectorFromDivTopLeftCorner('node_<%= node.getId() %>');
		var posX = document.getElementById('node_<%= node.getId() %>_posX');
		posX.value = point.x;
		var posY = document.getElementById('node_<%= node.getId() %>_posY');
		posY.value = point.y;

		<%
	}
	%>

	var nodePositions = document.getElementById('nodePositions');
	nodePositions.submit();
	return true;
}


//-->
</script>

</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

	<div id="fiche">

	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Définition de workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><%= item.getName()%></td>
			</tr>
		</table>
	</div>
	<br />


	<div id="drawingDiv"
		style="width : 10px; height:10px " >
		bloc de dessins
	</div>
	<form id="nodePositions"
		name="nodePositions"
		action="<%=
			response.encodeURL(
					"modifyOrganisationOrganigramNodeCoordinate.jsp?sAction=store") %>"
		method="post" >
		<input type="hidden" name="lIdOrganigram"  value="<%= item.getId() %>"  />

<%

	Vector vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int) item.getIdReferenceObject());

	for (int i=0; i < vNode.size(); i++)
	{
		OrganigramNode node = (OrganigramNode) vNode.get(i);

		PersonnePhysique personne = (PersonnePhysique)
			PersonnePhysique
				.getCoinDatabaseAbstractBeanFromId(
					node.getIdReferenceObject(), vPersonne);

		%>
		<div id="node_<%= node.getId()  %>"
			class="dndCell"
			onmouseup="my_endDrag();"  >
			<%= node.getName() %><br/>
			<%= personne.getPrenomNom() %>
		</div>

		<input type="hidden" id="node_<%= node.getId() %>_posX" name="node_<%= node.getId() %>_posX" value="<%= node.getPosX()  %>" />
		<input type="hidden" id="node_<%= node.getId() %>_posY" name="node_<%= node.getId() %>_posY" value="<%= node.getPosY()  %>" />

		<%
	}
%>



	</form>


	<script type="text/javascript">
   // <![CDATA[
     //positionnement des divs
		positionne('drawingDiv', '0px', '100px');

<%
	for (int i=0; i < vNode.size(); i++)
	{
		OrganigramNode node = (OrganigramNode) vNode.get(i);
	%>
		positionne('node_<%= node.getId() %>', '<%= node.getPosX() %>px', '<%= node.getPosY() %>px');
		 new Draggable('node_<%= node.getId()  %>', { revert:false });
	<%
	}
%>


		isDragging = false;

		jg_doc = new jsGraphics("drawingDiv");

		my_endDrag();
   // ]]>
 	</script>

	<div id="fiche_footer">
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL(
				rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
			+ item.getIdReferenceObject()
			+ "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_ORGANIGRAM
			+ "&nonce=" + System.currentTimeMillis()
			) %>')" >Retour</button>
		<button type="button" onclick="javascript:storePosition()" >Enregistrer Position</button>
	</div>


</div> <!-- end fiche -->
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>


</body>
</html>
