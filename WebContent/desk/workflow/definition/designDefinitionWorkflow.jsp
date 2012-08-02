<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="java.util.Vector"%>
<%@ page import="org.coin.db.CoinDatabaseWhereClause"%>
<%
	long lIdDefinitionWorkflow ;
	String sIdUser ;
	String sSelected ;


	lIdDefinitionWorkflow = Integer.parseInt( request.getParameter("lIdDefinitionWorkflow") );
	DefinitionWorkflow item = DefinitionWorkflow.getDefinitionWorkflow(lIdDefinitionWorkflow );
	String sTitle = "Afficher une définition de workflow";
	String sPageUseCaseId = "xxx";


	Vector vStates = DefinitionState.getAllFromIdDefinitionWorkflow(item.getId());
	Vector vTransitions = DefinitionTransition.getAllFromIdDefinitionWorkflow(item.getId());


	int iDndCellSizeX = 80;
	int iDndCellSizeY = 40;

%>

<link rel="stylesheet" type="text/css" href="dnd.css" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/js/dnd.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/wz_jsgraphics.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/js/drawingtoolkit.js"></script>
<style type="text/css" >
	div.dndCell {
		width: <%= iDndCellSizeX %>px;
		height: <%= iDndCellSizeY %>px;
		background: #eee none;
		border: 1px solid #bbb;
		font-size: 0.9em;
		cursor: move;
		position: absolute;
		vertical-align:middle;
		text-align:center;
		}

	div.dndCellTransition {
		width: <%= iDndCellSizeX %>px;
		height: <%= iDndCellSizeY + 10 %>px;
		background: #cce none;
		border: 1px solid #99b;
		font-size: 0.9em;
		cursor: move;
		position: absolute;
		}

</style>

</script>
<script type="text/javascript">
<!--



// to draw directly into the document
var jg_doc ;
var g_box_width = <%= iDndCellSizeY %>;
var g_box_height = <%= iDndCellSizeX %>;

function my_endDrag(){
	//endDrag();

	jg_doc.clear();

// Recadre les points

<%
	for (int i=0; i < vStates.size(); i++)
	{
		DefinitionState state = (DefinitionState ) vStates.get(i);
		%>
		normDivPositionFromCanevas('state_<%= state.getId() %>', 10);
		<%
	}

	for (int i=0; i < vTransitions.size(); i++)
	{
		DefinitionTransition trans = (DefinitionTransition) vTransitions.get(i);
		%>
		normDivPositionFromCanevas('transition_<%= trans.getId() %>', 10);
		<%
	}
%>



	// Ajout des transistions
	<%
	for (int i=0; i < vTransitions.size(); i++)
	{
		DefinitionTransition trans = (DefinitionTransition) vTransitions.get(i);
		String sColorLine = "maroon";

		switch ( (int) trans.getIdDefinitionTransitionType() )
		{
		case DefinitionTransitionType.TYPE_NORMAL :
			sColorLine = "green";
			break;
		case DefinitionTransitionType.TYPE_WARNING :
			sColorLine = "orange";
			break;
		case DefinitionTransitionType.TYPE_ERROR :
			sColorLine = "red";
			break;
		}
		%>
	    jg_doc.setColor("<%= sColorLine %>");
		my_drawLine('state_<%=
			trans.getIdDefinitionStateInitial() %>', 'transition_<%=
			trans.getId() %>');
		my_drawLine('transition_<%=
			trans.getId() %>', 'state_<%=
			trans.getIdDefinitionStateFinal() %>');

		<%
	}
	%>
	jg_doc.paint();

}
function my_drawLine(a, b)
{
	mt_drawVectorWithArrowInMiddle(a, b, 10, 15)
}


function storePosition()
{
	<%
	for (int i=0; i < vStates.size(); i++)
	{
		DefinitionState state = (DefinitionState ) vStates.get(i);
		%>
		var point = getVectorFromDivTopLeftCorner('state_<%= state.getId() %>');
		var posX = document.getElementById('state_<%= state.getId() %>_posX');
		posX.value = point.x;
		var posY = document.getElementById('state_<%= state.getId() %>_posY');
		posY.value = point.y;

		<%
	}
	%>


	<%
	for (int i=0; i < vTransitions.size(); i++)
	{
		DefinitionTransition transition = (DefinitionTransition) vTransitions.get(i);
		%>
		var point = getVectorFromDivTopLeftCorner('transition_<%= transition.getId() %>');
		var posX = document.getElementById('transition_<%= transition.getId() %>_posX');
		posX.value = point.x;
		var posY = document.getElementById('transition_<%= transition.getId() %>_posY');
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
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">


	<form id="nodePositions"
		name="nodePositions"
		action="<%=
			response.encodeURL(
					"modifyDefinitionWorkflowCoordinate.jsp?sAction=store") %>"
		method="post" >

	<div id="fiche">

	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Définition de workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame"><%= item.getName()%></td>
			</tr>
			<tr>
				<td class="label" >Description :</td>
				<td class="frame"><%= item.getDescription()%></td>
			</tr>
		</table>
	</div>
	<br />


	<div id="drawingDiv"
		style="width : 10px; height:10px " >
	</div>


		<input type="hidden" name="lIdDefinitionWorkflow"  value="<%= item.getId() %>"  />

	<%
	for (int i=0; i < vStates.size(); i++)
	{
		DefinitionState state = (DefinitionState ) vStates.get(i);
		%>
		<div id="state_<%= state.getId()  %>"
			class="dndCell" onmouseup="my_endDrag();"  >

 <div class="rounded_t">
 <div class="rounded_b">
 <div class="rounded_l">
 <div class="rounded_r">
 <div class="rounded_bl">
 <div class="rounded_br">
 <div class="rounded_tl">
 <div class="rounded_tr">
<%= state.getName() %>
</div></div></div></div></div></div></div></div>

		</div>

		<input type="hidden" id="state_<%= state.getId() %>_posX" name="state_<%= state.getId() %>_posX" value="<%= state.getPosX()  %>" />
		<input type="hidden" id="state_<%= state.getId() %>_posY" name="state_<%= state.getId() %>_posY" value="<%= state.getPosY()  %>" />

		<%
	}
	%>

	<%
	for (int i=0; i < vTransitions.size(); i++)
	{
		DefinitionTransition transition = (DefinitionTransition) vTransitions.get(i);
		%>
		<div id="transition_<%= transition.getId()  %>"
			class="dndCellTransition"
			onmouseup="my_endDrag();"  >
			<b><%= transition.getName() %><br/></b>
		<%
			Vector vTransitionCondition
				= DefinitionTransitionCondition.getAllFromIdDefinitionTransition(transition.getId());

			for (int j=0; j < vTransitionCondition.size(); j++)
			{
				DefinitionTransitionCondition condition
					= (DefinitionTransitionCondition) vTransitionCondition.get(j);
				%><%= condition.getName() %><br/><%
			}
		%>
		</div>

		<input type="hidden" id="transition_<%= transition.getId() %>_posX" name="transition_<%= transition.getId() %>_posX" value="<%= transition.getPosX()  %>" />
		<input type="hidden" id="transition_<%= transition.getId() %>_posY" name="transition_<%= transition.getId() %>_posY" value="<%= transition.getPosY()  %>" />

		<%
	}
	%>




<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>
<br/>

	<!-- Boutons -->
	<div id="fiche_footer">
		<button type="button" onclick="javascript:Redirect('<%=
			response.encodeRedirectURL("displayDefinitionWorkflow.jsp?lIdDefinitionWorkflow="
			+ item.getId()) %>')" >Retour</button>
		<button type="button" onclick="javascript:storePosition()" >Enregistrer Position</button>
	</div>

</div> <!-- end fiche -->

</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

	<script type="text/javascript">
   // <![CDATA[
     //positionnement des divs
		positionne('drawingDiv', '5px', '100px');
		var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
<%
for (int i=0; i < vStates.size(); i++)
{
	DefinitionState state = (DefinitionState ) vStates.get(i);
	%>
		 new Draggable('state_<%= state.getId()  %>',
		 	{
		      onStart:function(){ this.style.backgroundColor = "#900"; },
		      onDrag:function(){ $('state_<%= state.getId()  %>').setStyle( {backgroundColor:'#bfb'});  },
      		  onEnd:function(){ /* ... */ },
		 	  revert:false
		 	});
		 	
		/*Event.observe(window, 'load', function(){
		menuBorder.render($('state_<%= state.getId() %>'));
		});
		 */
		 	
		positionne('state_<%= state.getId() %>', '<%= state.getPosX() %>px', '<%= state.getPosY() %>px');
		
	<%
}
%>

<%
for (int i=0; i < vTransitions.size(); i++)
{
	DefinitionTransition transition = (DefinitionTransition) vTransitions.get(i);
	%>
		positionne('transition_<%= transition.getId() %>', '<%= transition.getPosX() %>px', '<%= transition.getPosY() %>px');

		 new Draggable('transition_<%= transition.getId()  %>',
		 	{
		 	  revert:false
		 	});
	<%
}
%>



		//isDragging = false;

		jg_doc = new jsGraphics("drawingDiv");

		my_endDrag();
   // ]]>
 	</script>
</form>


</body>
</html>
