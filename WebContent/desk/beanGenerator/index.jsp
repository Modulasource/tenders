<%
	String sTitle = "CoinDatabaseAbstractBean Generator Gettin' Jiggy with it";
	
	
	BeanGenerator.bUseSpecificConnection = false;

	JSONArray tableList = null;
	try{
		
		tableList = BeanGenerator.getTableList();
	} catch (Exception e ){
		e.printStackTrace();
	}
%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.util.BeanGenerator"%>
<script type="text/javascript">

var tables = <%=tableList  %>;

function displayTables() {
	var swapColNum = Math.ceil(tables.length/3)+1;
	var swapIndex = 0;
	var div = $('table_list_1');
	var colIndex = 1;
	tables.each(function(item, index){
		if (item.indexOf("QRTZ")==-1) {
			var divElm = document.createElement("div");
			divElm.style.padding = "2px";
			var elm = document.createElement("a");
			elm.href = "javascript:void(0)";
			elm.innerHTML = item;
			elm.onclick = function() {
				location.href = "<%=response.encodeRedirectURL("displayTable.jsp?sTableName=")%>"+item;
			}
			divElm.appendChild(elm);
			
			if (swapIndex>=swapColNum) {
				swapIndex = 0;
				colIndex++;
				div = $('table_list_'+colIndex);
			}
			
			div.appendChild(divElm);
			swapIndex++;
		}
	});
}

onPageLoad = displayTables;

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
<%
	String sPrefix = BeanGenerator.CONFIG_PREFIX;

	if(BeanGenerator.bUseSpecificConnection && Configuration.isTrueMemory(sPrefix + "use", false))
	{

	
%>

<div style="padding:30px;background:#EFF5FF;border:solid;">
	<table class="fullWidth" style="text-align:left">
		<tr>
			<td style="text-align:right;" >Configuration table connection : </td>
			<td ><%= sPrefix %></td>
		</tr>
		<tr>
			<td style="text-align:right;" >Connection type : </td>
			<td ><%= Configuration.getConfigurationValueMemory(sPrefix + "db.type") %></td>
		</tr>
		<tr>
			<td style="text-align:right;">Url : </td>
			<td ><%= Configuration.getConfigurationValueMemory(sPrefix + "url") %></td>
		</tr>
		<tr>
			<td style="text-align:right;">User name : </td>
			<td ><%= Configuration.getConfigurationValueMemory(sPrefix + "username") %></td>
		</tr>
		<tr>
			<td style="text-align:right;">Password : </td>
			<td ><%= Configuration.getConfigurationValueMemory(sPrefix + "password") %></td>
		</tr>
	</table>
</div>


<%
	}
%>
<div style="padding:30px;background:#EFF5FF">
	<table class="fullWidth" style="text-align:left"><tr>
		<td id="table_list_1" class="top"></td>
		<td id="table_list_2" class="top"></td>
		<td id="table_list_3" class="top"></td>
	</tr></table>
</div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.json.JSONArray"%></html>