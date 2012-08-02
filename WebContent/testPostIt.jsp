<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="java.util.Vector"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.organigram.*"%>
<%
	long lIdOrganigram ;
	String sIdUser ;
	String sSelected ;

	String sTitle = "Afficher des post'it";
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "xxx";

	int iDndCellSizeX = 80;
	int iDndCellSizeY = 80;

%>
<%@ include file="desk/include/checkHabilitationPage.jspf" %>
<%@ include file="desk/include/headerDesk.jspf" %>

<link rel="stylesheet" type="text/css" href="dnd.css" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/js/scriptaculous/scriptaculous.js"></script>
<script type="text/javascript" src="<%=rootPath%>include/dnd.js"></script>
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

//-->
</script>

</head>
<body>
	<!-- Titre -->
	<%@ include file="desk/include/headerFiche.jspf" %>
	<div id="fiche">

	<!-- Pavé groupe -->
	<div class="sectionTitle"><div>Définition de workflow</div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Nom :</td>
				<td class="frame">Test</td>
			</tr>
		</table>
	</div>
	<br />


	<div id="drawingDiv"
		style="width : 10px; height:10px " >
		bloc de dessins
	</div>
		<div id="node_1"
			class="dndCell"
			 >
			bla bla bla bla bla 
		</div>
	</form>


	<script type="text/javascript">
   // <![CDATA[
   
		positionne('drawingDiv', '0px', '100px');
		positionne('node_1', '100px', '100px');
		new Draggable('node_1', { revert:false });

   // ]]>
 	</script>


</div> <!-- end fiche -->
<%@ include file="desk/include/footerFiche.jspf" %>
</body>
</html>
