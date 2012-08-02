<%@ include file="/mobile/include/header.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mt.mobile.db.SearchEngine"%>
<%
long idOrganisation = 2860;

SearchEngine engine = new SearchEngine();
engine.setMainTable("organigram_node", "onode", "id_organigram_node");
String select =
	"onode.id_organigram_node,"+
	"onode.id_organigram,"+
	"onode.id_type_object,"+
	"onode.id_organigram_node_parent,"+
	"onode.id_organigram_node_type,"+
	"onode.id_reference_object,"+
	"concat(pp.prenom,' ',pp.nom) as people,"+
	"os.nom as service,"+
	"orga.id_type_object as type_object_organigram,"+
	"orga.id_reference_object as reference_object_organigram,"+
	"org.id_organisation";
engine.setSelect(select);

ArrayList<Object> values = new ArrayList<Object>();
values.add(ObjectType.PERSONNE_PHYSIQUE);
engine.addTableWithLeftJoin("personne_physique pp on (pp.id_personne_physique=onode.id_reference_object and onode.id_type_object=?)", values);

values = new ArrayList<Object>();
values.add(ObjectType.ORGANISATION_SERVICE);
engine.addTableWithLeftJoin("organisation_service os on (os.id_organisation_service=onode.id_reference_object and onode.id_type_object=?)", values);

engine.addTableWithLeftJoin("organigram orga on (orga.id_organigram=onode.id_organigram)");

values = new ArrayList<Object>();
values.add(idOrganisation);
values.add(ObjectType.ORGANISATION);
values.add(idOrganisation);

engine.addWhereClause("(org.id_organisation=?) or (orga.id_type_object=? and orga.id_reference_object=?)", values);

engine.addTableWithLeftJoin("organisation org on (org.id_organisation=pp.id_organisation)");

engine.setGroupByClause("onode.id_organigram_node");
engine.run();
%>
<jsp:include page="/desk/mobile/include/headerHTML.jsp" flush="true" />
<script>

function Organigram(domId, width, height){
	var self = this;
	
	this.nodes = {};
	this.lines = [];
	this.hLines = [];
	this.previewMode = false;
	this.viewPeople = true;
	this.graphDimensions = {width:10000, height:10000};
	this.fontSize = 100;
	this.verticalMode = true;

	this.setDataset = function(dataset){
		this.dataset = dataset;
	}

	this.setDisplayMode = function(b){
		this.verticalMode = b;
		this.updateDisplay();
	}
	
	this.displayNode = function(id_node, elm, topElement){
		mt.dom.disableSelection(elm);
		var item = this.nodes[id_node];

		var divMain = document.createElement("div");
		
		var divBox = document.createElement("div");
		
		var divTitle = document.createElement("div");
		divBox.appendChild(divTitle);

		var divPeople = document.createElement("div");
		divPeople.style.backgroundColor = "#EEE";
		divBox.appendChild(divPeople);
		
		divMain.appendChild(divBox);

		var divSubs = document.createElement("div");
		
		if (item.id_type_object==<%=ObjectType.ORGANISATION_SERVICE%>) {			
			
			divTitle.style.fontSize = "0.7em";
			
			elm.style.position = "relative";
			
			if (this.verticalMode) {
				elm.style.cssFloat = "left";
				
				divBox.style.display = "table";
				divBox.style.borderCollapse = "collapse";
				divBox.style.margin = "0 auto";

				var divVerticalLineTop = document.createElement("div");
				divVerticalLineTop.style.height = "2em";
				divVerticalLineTop.style.width = "2px";
				divVerticalLineTop.style.backgroundColor = "#333";
				divVerticalLineTop.style.margin = "0 auto";
				if (!topElement) elm.appendChild(divVerticalLineTop);
				this.hLines.push(divVerticalLineTop);

				elm.style.margin = "0 0.5em 0 0.5em";
			} else {
				elm.style.display = "table";
				elm.style.borderCollapse = "collapse";
				elm.style.marginBottom = ".5em";

				divMain.style.display = "table-cell";
				divMain.style.verticalAlign = "middle";
				
				divBox.style.width = (this.previewMode) ? "auto" : "10em";
				
				divSubs.style.display = "table-cell";
				divSubs.style.verticalAlign = "middle";

				var divLineLeft = document.createElement("div");
				divLineLeft.className = "divLineLeft";
				divLineLeft.style.display = "table-cell";
				divLineLeft.style.verticalAlign = "middle";				
				var HLineLeft = document.createElement("div");
				HLineLeft.style.height = "2px";
				HLineLeft.style.width = "2em";
				HLineLeft.style.backgroundColor = "#333";
				divLineLeft.appendChild(HLineLeft);				
				if (!topElement) elm.appendChild(divLineLeft);
				
			}

			divTitle.style.textAlign = "center";
			
			divBox.style.border = "1px solid #888";
			divBox.style.borderRight = "2px solid #888";
			divBox.style.borderBottom = "2px solid #888";
			divBox.style.backgroundColor = "#FFF";
			
			divTitle.style.fontWeight = "bold";
			divTitle.style.color = "#2f4361";
			divTitle.innerHTML = (this.previewMode) ? "" : item.service;
			
			divTitle.style.padding = (this.previewMode) ? "0.9em" : "0.2em";
			
		} else if (item.id_type_object==<%=ObjectType.PERSONNE_PHYSIQUE%>) { // if people
			divSubs.style.paddingLeft = "1em";
			divTitle.style.fontSize = "0.5em";
			divTitle.innerHTML = item.people;
		}
		
		var serviceCount = 0;
		var serviceNodes = [];

		elm.appendChild(divMain);
		
		this.dataset.each(function(node){

			if (!self.previewMode && self.viewPeople){
				if (node.type_object_organigram=<%=ObjectType.ORGANISATION_SERVICE%> && node.reference_object_organigram==item.id_reference_object && (node.id_organigram_node==node.id_organigram_node_parent)){
					var elmNode = document.createElement("div");
					self.displayNode(node.id_organigram_node, elmNode);
					divPeople.appendChild(elmNode);
				}
			}
			
			if (node.id_organigram_node_parent==item.id_organigram_node && node.id_organigram_node_parent!=node.id_organigram_node){
				var elmNode = document.createElement("div");				
				self.displayNode(node.id_organigram_node, elmNode);
				divSubs.appendChild(elmNode);
				serviceCount++;
				serviceNodes.push(elmNode);
			}
			
		});		
		
		if (item.id_type_object==<%=ObjectType.ORGANISATION_SERVICE%> && serviceCount>1) {

			if (this.verticalMode){
				var divVerticalLineBottom = document.createElement("div");
				divVerticalLineBottom.style.height = "2em";
				divVerticalLineBottom.style.width = "2px";
				divVerticalLineBottom.style.backgroundColor = "#333";
				divVerticalLineBottom.style.margin = "0 auto";
				elm.appendChild(divVerticalLineBottom);
				this.hLines.push(divVerticalLineBottom);

				var divHorizontalLineBottom = document.createElement("div");
				divHorizontalLineBottom.style.height = "2px";
				divHorizontalLineBottom.style.width = (150*serviceCount)+"px";
				divHorizontalLineBottom.style.backgroundColor = "#333";
				divHorizontalLineBottom.style.position = "absolute";
				elm.appendChild(divHorizontalLineBottom);

				this.lines.push({line:divHorizontalLineBottom, node1:serviceNodes[0].firstChild, node2:serviceNodes[serviceCount-1].firstChild});
				
			} else {
				var divLineRight = document.createElement("div");
				divLineRight.style.display = "table-cell";
				divLineRight.style.verticalAlign = "middle";				
				var HLineRight = document.createElement("div");
				HLineRight.style.height = "2px";
				HLineRight.style.width = "2em";
				HLineRight.style.backgroundColor = "#333";
				divLineRight.appendChild(HLineRight);		
				elm.appendChild(divLineRight);


				var divLineV = document.createElement("div");
				divLineV.style.width = "2px";
				divLineV.style.position = "relative";
				
				var VLineRight = document.createElement("div");		
				VLineRight.style.width = "2px";
				VLineRight.style.position = "absolute";
				VLineRight.style.backgroundColor = "#333";
				divLineV.appendChild(VLineRight);
				elm.appendChild(divLineV);

				this.lines.push({line:VLineRight, node1:serviceNodes[0], node2:serviceNodes[serviceCount-1]});
			}
			
		}
		
		elm.appendChild(divSubs);

	}
	
	this.render = function(rootNode){

		this.rootNode = rootNode;
		
		var rootElm = $(domId);		
		mt.dom.disableSelection(rootElm);
		
		rootElm.style.border = "2px solid #36C";

		var divGraph = document.createElement("div");
		divGraph.style.width = width+"px";
		divGraph.style.height = height+"px";
		divGraph.style.overflow = "hidden";
		divGraph.style.cursor = "move";
		
		var graphPosition = {};
		var positionStart = {};

		function onMove(e){
			var deltaX = Event.pointerX(e)-positionStart.x;
			var deltaY = Event.pointerY(e)-positionStart.y;			
			
			self.graph.style.left = (graphPosition.x+deltaX)+"px"; 
			self.graph.style.top = (graphPosition.y+deltaY)+"px";
		}
		
		Element.observe(divGraph, 'mousedown', function(e){
			var l = Element.getStyle(self.graph, 'left');
			var t = Element.getStyle(self.graph, 'top');
			graphPosition.x = parseInt(l.substring(0, l.length-2));
			graphPosition.y = parseInt(t.substring(0, t.length-2));
			
			positionStart.x = Event.pointerX(e);
			positionStart.y = Event.pointerY(e);

			Element.observe(window, 'mousemove', onMove);
						
			Element.observe(window, 'mouseup', function(){
				Element.stopObserving(window, 'mousemove', onMove);
			});
			
		});
		
		this.graph = document.createElement("div");
		this.graph.style.fontSize = this.fontSize+"%";
		this.graph.style.width = this.graphDimensions.width+"px";
		this.graph.style.height = this.graphDimensions.height+"px";
		this.graph.style.position = "relative";
		this.initGraphPosition();

		var divOptions = document.createElement("div");
		divOptions.style.background = "#EFF5FF";
		divOptions.style.borderBottom = "1px solid #888";
		divOptions.style.padding = "4px";
		divOptions.style.fontSize = "11px";

		var label1 = document.createElement("label");
		var checkbox1 = document.createElement("input");
		checkbox1.type = "checkbox";
		checkbox1.onchange = function(){
			self.setDisplayPreview(this.checked);
		}
		label1.appendChild(checkbox1);
		label1.appendChild(document.createTextNode("Afficher la preview"));
		divOptions.appendChild(label1);

		var label2 = document.createElement("label");
		var checkbox2 = document.createElement("input");
		checkbox2.type = "checkbox";
		checkbox2.checked = true;
		checkbox2.onchange = function(){
			self.setDisplayPeople(this.checked);
		}
		label2.appendChild(checkbox2);
		label2.appendChild(document.createTextNode("Voir toutes les personnes"));
		divOptions.appendChild(label2);

		var label3 = document.createElement("label");
		var checkbox3 = document.createElement("input");
		checkbox3.type = "checkbox";
		checkbox3.onchange = function(){
			self.setDisplayMode(!this.checked);
		}
		label3.appendChild(checkbox3);
		label3.appendChild(document.createTextNode("Display mode"));
		divOptions.appendChild(label3);
		
		
		function updateFontSize(v){
			var value = Element.getStyle(self.graph, 'font-size');
			value = parseInt(value.substring(0, value.length-1));
			value = value+v;
			if (value>=10 && value<=160){
				self.fontSize = value;
				self.graph.style.fontSize = self.fontSize+"%";
				self.updateLines();
			}
		}
		
		var upSize = document.createElement("input");
		upSize.type = "button";
		upSize.value = "+";
		upSize.onmousedown = function(){
			this.idInterval = setInterval(function(){updateFontSize(3);}, 1);
		}
		upSize.onmouseup = function(){
			clearInterval(this.idInterval);
		}
		
		divOptions.appendChild(upSize);

		var downSize = document.createElement("input");
		downSize.type = "button";
		downSize.value = "-";
		downSize.onmousedown = function(){
			this.idInterval = setInterval(function(){updateFontSize(-3);}, 1);
		}
		downSize.onmouseup = function(){
			clearInterval(this.idInterval);
		}
		divOptions.appendChild(downSize);
		
		rootElm.appendChild(divOptions);

		divGraph.appendChild(this.graph);
		rootElm.appendChild(divGraph);
		
		this.updateDisplay();
	}

	this.initGraphPosition = function(){
		this.graph.style.left = (-(this.graphDimensions.width/2)+(width/2))+"px";
		this.graph.style.top = "15px";
	}

	this.updateDisplay = function(){
		this.graph.innerHTML = "";
		this.lines = [];
		
		var roots = [];
		var ln = this.dataset.length;
		for (var i=0; i<ln; i++){
			var item = this.dataset[i];
			if (item.id_type_object==<%=ObjectType.ORGANISATION_SERVICE%> && (item.id_organigram_node==item.id_organigram_node_parent)){
				roots.push(item.id_organigram_node);
			}
			this.nodes[item.id_organigram_node] = item;
		}

		function addNode(id){
			var container = document.createElement("div");
			container.style.display = "table";
			container.style.margin = "0 auto";
			
			var div = document.createElement("div");
			container.appendChild(div);
			
			self.displayNode(id, div, true);
			self.graph.appendChild(container);
		}

		if (this.rootNode) {
			addNode(this.rootNode);
		} else {
			roots.each(function(id){addNode(id);});
		}

		this.updateLines();
	}	

	this.updateLines = function(){
		this.lines.each(function(item){
			if (self.verticalMode){
				var d1 = Element.cumulativeOffset(item.node1).left;
				var d2 = Element.cumulativeOffset(item.node2).left;
				item.line.style.width = (d2-d1)+"px";
				var value = 10*(self.fontSize)/100;
				item.line.style.left = (item.node1.offsetLeft+(value))+"px";
				item.line.style.height = (value<2) ? "1px" : "2px";
			} else {
				var d1 = Element.cumulativeOffset(item.node1.firstChild.firstChild).top;
				var d2 = Element.cumulativeOffset(item.node2.firstChild.firstChild).top;
				item.line.style.height = (d2-d1+2)+"px";
				item.line.style.top = (item.node1.firstChild.firstChild.offsetTop)+"px";
			}
		});

		this.hLines.each(function(item){			
			var value = 10*(self.fontSize)/100;
			item.style.width = (value<2) ? "1px" : "2px";
		});
	}

	this.setDisplayPeople = function(b){
		this.viewPeople = b;
		this.updateDisplay();
	}

	this.setDisplayPreview = function(b){
		this.previewMode = b;
		this.fontSize = 55;
		this.graph.style.fontSize = this.fontSize+"%";
		this.initGraphPosition();
		this.updateDisplay();
	}
	
}

</script>


<div style="padding:50px">
	
	<table><tr>
		<td>
			<div id="organigram1"></div>
		</td>
		<td style="width:30px"></td>
		<td>
			<div id="organigram2"></div>
		</td>
	</tr></table>
	
</div>

<script>

var dataset = <%=engine.getJSON()%>.dataset;

var organigram1 = new Organigram('organigram1', 600, 400);
organigram1.setDataset(dataset);
organigram1.render();


var organigram2 = new Organigram('organigram2', 500, 300);
organigram2.setDataset(dataset);
organigram2.render(52);

</script>
<jsp:include page="/desk/mobile/include/footerHTML.jsp" flush="true" />