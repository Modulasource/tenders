<%@ include file="/mobile/include/header.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="mt.mobile.db.SearchEngine"%>
<%
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
	"orga.id_reference_object as reference_object_organigram";
engine.setSelect(select);

ArrayList<Object> values = new ArrayList<Object>();
values.add(ObjectType.PERSONNE_PHYSIQUE);
engine.addTableWithLeftJoin("personne_physique pp on (pp.id_personne_physique=onode.id_reference_object and onode.id_type_object=?)", values);

values = new ArrayList<Object>();
values.add(ObjectType.ORGANISATION_SERVICE);
engine.addTableWithLeftJoin("organisation_service os on (os.id_organisation_service=onode.id_reference_object and onode.id_type_object=?)", values);

engine.addTableWithLeftJoin("organigram orga on (orga.id_organigram=onode.id_organigram)");

values = new ArrayList<Object>();
values.add(ObjectType.ORGANISATION);
values.add(ObjectType.ORGANISATION);
values.add(2860);
//engine.addWhereClause("(orga.id_type_object!=?) or(orga.id_type_object=? and orga.id_reference_object=?)", values);

engine.setGroupByClause("onode.id_organigram_node");
engine.run();
%>
<jsp:include page="/desk/mobile/include/headerHTML.jsp" flush="true" />
<script>
var organigram = <%=engine.getJSON()%>;
organigram = organigram.dataset;

var roots = [];
var nodes = {};

var ln = organigram.length;
for (var i=0; i<ln; i++){
	var item = organigram[i];
	if (item.id_type_object==401 && (item.id_organigram_node==item.id_organigram_node_parent)){
		roots.push(item.id_organigram_node);
	}
	nodes[item.id_organigram_node] = item;
}

function displayNode(id_node, elm){	
	var item = nodes[id_node];
	
	var divMain = document.createElement("div");
	var span = document.createElement("span");
	
	if (item.id_type_object==401) {
		span.style.fontWeight = "bold";
		span.style.color = "#2f4361";
		span.style.textDecoration = "underline";
		span.innerHTML = item.service;
		
		elm.style.backgroundColor = "#EEE";
		
		elm.style.borderTop = "1px solid #CCC";
		elm.style.borderLeft = "1px solid #CCC";
		elm.style.borderRight = "2px solid #CCC";
		elm.style.borderBottom = "2px solid #CCC";

		elm.style.margin = "2px";
		
		//elm.style.padding = "4px";
		divMain.style.padding = "4px";
	}
	if (item.id_type_object==4) {
		span.style.fontSize = "15px";
		span.innerHTML = item.people;
		elm.style.backgroundColor = "#FFF";
	}

	
	divMain.appendChild(span);

	var divPeople = document.createElement("div");
	divPeople.style.marginLeft = "4px";
	
	var divSubs = document.createElement("div");
	divSubs.style.paddingLeft = "40px";
	
	//divSubs.style.border = "1px solid #0F0";

	var numPeople = 0;
	var numService = 0;
	
	organigram.each(function(node){

		
		if (node.type_object_organigram=401 && node.reference_object_organigram==item.id_reference_object && (node.id_organigram_node==node.id_organigram_node_parent)){
			var elmNode = document.createElement("div");
			divPeople.appendChild(elmNode);
			displayNode(node.id_organigram_node, elmNode);
			numPeople++;
		}
		
		
		if (node.id_organigram_node_parent==item.id_organigram_node && node.id_organigram_node_parent!=node.id_organigram_node){
			var elmNode = document.createElement("div");
			divSubs.appendChild(elmNode);
			displayNode(node.id_organigram_node, elmNode);
			numService++;
		}
		
	});

	elm.appendChild(divMain);
	if (numPeople>0) elm.appendChild(divPeople);
	if (numService>0) elm.appendChild(divSubs);
}

</script>

<div style="padding:20px">
	<table><tr>
		<td id="graph"></td>
	</tr></table>
</div>

<script>
var rootElm = $('graph');
roots.each(function(id){
	
	try {
		var div = document.createElement("div");
		displayNode(id, div);
		rootElm.appendChild(div);
	} catch(e){}
});
</script>
<jsp:include page="/desk/mobile/include/footerHTML.jsp" flush="true" />