<%
	String sTableName = request.getParameter("sTableName");
	String sTitle = sTableName;
%>
<%@page import="org.coin.util.BeanGenerator"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<style>
.fill {
	color:#900;
	background-color:lightyellow;
}
</style>
<script>
var sTableName = "<%=sTableName%>";
var columns = <%=BeanGenerator.getFieldsFromTableName(sTableName)%>;
var column_dg;
var codeIndent = 0;
var className = "";

var javaTypes = [
	{value:"String", data:0, prefix:"s", setMethod:"setString", getMethod:"getString", defaultValue:'""'},
	{value:"long", data:1, prefix:"l", setMethod:"setLong", getMethod:"getLong", defaultValue:"0"},
	{value:"int", data:2, prefix:"i", setMethod:"setInt", getMethod:"getInt", defaultValue:"0"},
	{value:"Timestamp", data:3, prefix:"ts", setMethod:"setTimestamp", getMethod:"getTimestamp", defaultValue:"null"},
	{value:"boolean", data:4, prefix:"b", setMethod:"setBoolean", getMethod:"getBoolean", defaultValue:"false"},
	{value:"float", data:5, prefix:"f", setMethod:"setFloat", getMethod:"getFloat", defaultValue:"0"}
];

function displayTableView() {
	column_dg = new mt.component.DataGrid("column_dg");
	column_dg.setHeader(['Nom', 'Type', 'JavaType','Use Prevent']);
	column_dg.setColumnStyle(0, {paddingRight:"20px"});
	column_dg.setColumnStyle(1, {paddingRight:"20px"});
	columns.each(function(item, index){
		var select = document.createElement("select");
		mt.html.setSuperCombo(select);
		select.populate(javaTypes, getJavaTypeObj(item.type).data);
		
		var cbPrevent = document.createElement("input");
        cbPrevent.type = "checkbox";
        cbPrevent.checked = true;
		 
		 select.onchange = function(){
		   column_dg.dataSet[index].cells[3].innerHTML = "";
		   if(this.value == 0){
		    cbPrevent = document.createElement("input");
            cbPrevent.type = "checkbox";
            cbPrevent.checked = true;
		    column_dg.dataSet[index].cells[3].appendChild(cbPrevent);
		   }
		 }
		 
		if(getJavaTypeObj(item.type) != javaTypes[0]){
           cbPrevent = null;  
        }
        
		column_dg.addItem([item.name, item.type, select, cbPrevent]);
	});
	column_dg.render();
}

function generateVariableNames() {
	className = $('className').value;

	columns.each(function(item, index){
		var javaTypeIndex = column_dg.dataSet[index].cells[2].firstChild.value;
		var obj = javaTypes[javaTypeIndex];
		item.javaTypeObj = obj;
		item.prefixedName = obj.prefix+getCamelString(item.name);
		
		item.usePrevent = false;
		try{item.usePrevent = column_dg.dataSet[index].cells[3].firstChild.checked;}
		catch(e){item.usePrevent = false;}
	});
}

function getIndentString() {
	var str = "";
	for (var i=0; i<codeIndent; i++) {
		str += "&nbsp;&nbsp;&nbsp;&nbsp;";
	}
	return str;
}

function div(s) {
	return "<div>"+getIndentString()+s+"</div>";
}

function getJavaTypeObj(s) {
	if (s.indexOf('char')!=-1) {
		return javaTypes[0];
	}
	if (s.indexOf('tinyint(1)')!=-1) {
		return javaTypes[4];
	}
	if (s.indexOf('int')!=-1) {
		return javaTypes[1];
	}
	if (s.indexOf('float')!=-1) {
		return javaTypes[5];
	}
	if (s.indexOf('datetime')!=-1) {
		return javaTypes[3];
	}
	return javaTypes[0];
}

function getCamelString(s) {
	var splits = s.split("_");
	var newName = [];
	splits.each(function(item){
		newName.push(item.toUpperCase().substring(0,1)+item.substring(1,item.length));
	});
	return newName.join("");
}

function generateBean() {

	var timeStamped = $('timeStamped').checked;
	var memory = $('memory').checked;
	
	var bUseHttpPrevent = $('bUseHttpPrevent').checked;
	var bUseFieldValueFilter = $('bUseFieldValueFilter').checked;

	codeIndent = 0;
	generateVariableNames();
	
	var newline = "<br/>";
	var indent = "";
	
	sCode = div("/*")
		+ div("* Mt Software - France "+(new Date()).getFullYear()+", tous droits réservés")
		+ div("* Contact : contact@mtsoftware.fr - http://www.mtsoftware.fr")
		+ div("*/")
		+ newline;
		
	sCode += div('package <span class="fill">FILL_HERE</span>;');
	sCode += newline;
	sCode += div('import org.coin.db.*;');
	sCode += div('import org.coin.util.CalendarUtil;');
	sCode += div('import org.coin.util.Outils;');
	sCode += newline;
	sCode += div('import org.json.JSONArray;');
	sCode += div('import org.json.JSONException;');
	sCode += div('import org.json.JSONObject;');
	sCode += newline;	
	sCode += div('import javax.naming.NamingException;');
	sCode += div('import javax.servlet.http.HttpServletRequest;');
	sCode += div('import java.sql.*;');
	sCode += div('import java.util.Vector;');	
	
	sCode += newline;
	
	if (timeStamped) {
		sCode += div('public class '+className+' extends CoinDatabaseAbstractBeanTimeStamped {');
	} else if (memory){
		sCode += div('public class '+className+' extends CoinDatabaseAbstractBeanMemory {');
	} else {
		sCode += div('public class '+className+' extends CoinDatabaseAbstractBean {');
	}
	codeIndent++;
	sCode += newline;
	sCode += div('private static final long serialVersionUID = 1L;');
	sCode += newline;

	columns.each(function(item, index){
		if (index!=0) {
			if (!timeStamped || (timeStamped && (item.prefixedName!="tsDateCreation" && item.prefixedName!="tsDateModification"))) {
				sCode += div('protected '+item.javaTypeObj.value+' '+item.prefixedName+';');
			}
		}
	});
	
	if (memory) {
		sCode += newline;
		sCode += div('public static Vector&lt;'+className+'&gt; m_v'+className+' = null;');
	}
    
	sCode += newline;
	sCode += div('public '+className+'() {');
	codeIndent++;
	sCode += div('init();');
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public '+className+'(long lId) {');
	codeIndent++;
	sCode += div('init();');
	sCode += div('this.lId = lId;');
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public void init() {');
	codeIndent++;
	sCode += div('super.TABLE_NAME = "'+sTableName+'";');
	sCode += div('super.FIELD_ID_NAME = "id_"+ super.TABLE_NAME;');
	sCode += div('super.SELECT_FIELDS_NAME =');
	var list = [];
	columns.each(function(item, index){
		if (index!=0) list.push(item.name);
	});
	codeIndent+=2;
	sCode += div('" '+list.join(',"<br/>'+getIndentString()+'+ " ')+'";');
	codeIndent-=2;
	
	sCode += newline;
	sCode += div('super.SELECT_FIELDS_NAME_SIZE = super.SELECT_FIELDS_NAME.split(",").length;');	
	sCode += newline;
	sCode += div('super.lId = 0;');	
	columns.each(function(item, index){
		if (index!=0) {
			if (timeStamped && (item.prefixedName=="tsDateCreation" || item.prefixedName=="tsDateModification")) {
				sCode += div('super.'+item.prefixedName+' = '+item.javaTypeObj.defaultValue+';');
			} else {
				sCode += div('this.'+item.prefixedName+' = '+item.javaTypeObj.defaultValue+';');
			}
		}
	});
	sCode += newline;
	if (!bUseHttpPrevent) {
        sCode += div('super.bUseHttpPrevent = false;');
    }
    if (!bUseFieldValueFilter) {
        sCode += div('super.bUseFieldValueFilter = false;');
    }
	
	codeIndent--;
	sCode += div('}');
	
	if (memory) {
		sCode += newline;
		sCode += div('public void populateMemory()');
		sCode += div('throws NamingException, SQLException, InstantiationException, IllegalAccessException {');
		codeIndent++;
		sCode += div('m_v'+className+' = getAllStatic();');
		codeIndent--;
		sCode += div('}');
		
		sCode += newline;
		sCode += div('public Vector&lt;'+className+'&gt; getItemMemory() {');
		codeIndent++;
		sCode += div('return m_v'+className+';');
		codeIndent--;
		sCode += div('}');
		
		sCode += newline;
		sCode += div('@SuppressWarnings("unchecked")');
		sCode += div('public &lt;T&gt; Vector&lt;T&gt; getAllMemory()');
		sCode += div('throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {');
		codeIndent++;
		sCode += div('return (Vector&lt;T&gt;) getAllStaticMemory();');
		codeIndent--;
		sCode += div('}');
	}
	
	sCode += newline;
	sCode += div('public void setPreparedStatement(PreparedStatement ps) throws SQLException {');
	codeIndent++;
	sCode += div('int i = 0;');
	columns.each(function(item, index){
		if (index!=0) {
			if (timeStamped && (item.prefixedName=="tsDateCreation" || item.prefixedName=="tsDateModification")) {
				sCode += div('ps.'+item.javaTypeObj.setMethod+'(++i, super.'+item.prefixedName+');');
			}
			else if(item.usePrevent){
			    sCode += div('ps.'+item.javaTypeObj.setMethod+'(++i, preventStore(this.'+item.prefixedName+'));');
			}
			else {
				sCode += div('ps.'+item.javaTypeObj.setMethod+'(++i, this.'+item.prefixedName+');');
			}
		}
	});
	codeIndent--;
	sCode += div('}');

	sCode += newline;
	sCode += div('public void setFromResultSet(ResultSet rs) throws SQLException {');
	codeIndent++;
	sCode += div('int i = 0;');
	columns.each(function(item, index){
		if (index!=0) {
			if (timeStamped && (item.prefixedName=="tsDateCreation" || item.prefixedName=="tsDateModification")) {
				sCode += div('super.'+item.prefixedName+' = rs.'+item.javaTypeObj.getMethod+'(++i);');
			} 
			else if(item.usePrevent){
                sCode += div('this.'+item.prefixedName+' = preventLoad(rs.'+item.javaTypeObj.getMethod+'(++i));');
            }
			else {
				sCode += div('this.'+item.prefixedName+' = rs.'+item.javaTypeObj.getMethod+'(++i);');
			}
		}
	});
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public static '+className+' get'+className+'(long lId) throws CoinDatabaseLoadException, SQLException, NamingException {');
	codeIndent++;
	sCode += div(className+' item = new '+className+'(lId);');
	sCode += div('item.load();');
	sCode += div('return item;');
	codeIndent--;
	sCode += div('}');
	
	if (memory) {
		sCode += newline;		
		sCode += div('public static '+className+' get'+className+'Memory(long lId)');
		sCode += div('throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {');
		codeIndent++;
		sCode += div('for ('+className+' item : getAllStaticMemory()) {');
		codeIndent++;
		sCode += div('if (item.getId()==lId) return item;');
		codeIndent--;
		sCode += div('}');
		sCode += div('throw new CoinDatabaseLoadException("" + lId, "static");');
		codeIndent--;
		sCode += div('}');
	}
	
	sCode += newline;
	sCode += div('public void setFromForm(HttpServletRequest request, String sFormPrefix) {');
	codeIndent++;
	columns.each(function(item, index){
		if (index!=0) {
			if (!timeStamped || (timeStamped && (item.prefixedName!="tsDateCreation" && item.prefixedName!="tsDateModification"))) {
				sCode += div('try {');
				codeIndent++;
				switch(item.javaTypeObj.value) {
					case "String":
						sCode += div('this.'+item.prefixedName+' = request.getParameter(sFormPrefix + "'+item.prefixedName+'");');
						break;
					case "long":
						sCode += div('this.'+item.prefixedName+' = Long.parseLong(request.getParameter(sFormPrefix + "'+item.prefixedName+'"));');
						break;
					case "int":
						sCode += div('this.'+item.prefixedName+' = Integer.parseInt(request.getParameter(sFormPrefix + "'+item.prefixedName+'"));');
						break;
					case "Timestamp":
						sCode += div('this.'+item.prefixedName+' = CalendarUtil.getConversionTimestamp(request.getParameter(sFormPrefix + "'+item.prefixedName+'"), "dd/MM/yyyy");');
						break;
					case "boolean":
						sCode += div('this.'+item.prefixedName+' = Boolean.parseBoolean(request.getParameter(sFormPrefix + "'+item.prefixedName+'"));');
						break;
					case "float":
						sCode += div('this.'+item.prefixedName+' = Float.parseFloat(request.getParameter(sFormPrefix + "'+item.prefixedName+'"));');
						break;
				}
				codeIndent--;
				sCode += div('} catch(Exception e){}');
			}
		}			
	});
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public static Vector&lt;'+className+'&gt; getAllWithSqlQueryStatic(String sSQLQuery)');
	sCode += div('throws InstantiationException, IllegalAccessException, NamingException, SQLException {');
	codeIndent++;
	sCode += div(className+' item = new '+className+'();');
	sCode += div('return getAllWithSqlQuery(sSQLQuery, item);');
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public static Vector&lt;'+className+'&gt; getAllStatic()');
	sCode += div('throws InstantiationException, IllegalAccessException, NamingException, SQLException {');
	codeIndent++;
	sCode += div(className+' item = new '+className+'();');
	sCode += div('String sSQLQuery');
	sCode += div('= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME');
	sCode += div('+ " FROM " + item.TABLE_NAME;');
	sCode += div('return getAllWithSqlQuery(sSQLQuery, item);');
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public static Vector&lt;'+className+'&gt; getAllStatic(Connection conn)');
	sCode += div('throws InstantiationException, IllegalAccessException, NamingException, SQLException {');
	codeIndent++;
	sCode += div(className+' item = new '+className+'();');
	sCode += div('String sSQLQuery');
	sCode += div('= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME');
	sCode += div('+ " FROM " + item.TABLE_NAME;');
	sCode += div('return getAllWithSqlQuery(sSQLQuery, item, conn);');
	codeIndent--;
	sCode += div('}');
	
	if (memory) {
		sCode += newline;
		sCode += div('public static Vector&lt;'+className+'&gt; getAllStaticMemory()');
		sCode += div('throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {');
		codeIndent++;
		sCode += div('reloadMemoryStatic(new '+className+'());');
		sCode += div('return m_v'+className+';');
		codeIndent--;
		sCode += div('}');
		
		sCode += newline;
		sCode += div('public static Vector&lt;'+className+'&gt; getAllMemoryFromXXXX(long lIdXXXX)');
		sCode += div('throws InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {');
		codeIndent++;
		sCode += div('Vector&lt;'+className+'&gt; vResult = new Vector&lt;'+className+'&gt;();');
		sCode += div('/*for ('+className+' item : getAllStaticMemory()) {');
		codeIndent++;
		sCode += div('if (item.getIdXXXX() == lIdXXXX) vResult.add(item);');
		codeIndent--;
		sCode += div('}*/');
		sCode += div('return vResult;');
		codeIndent--;
		sCode += div('}');
	}
	
	sCode += newline;
	sCode += div('public static Vector&lt;'+className+'&gt; getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)');
	sCode += div('throws InstantiationException, IllegalAccessException, NamingException, SQLException {');
	codeIndent++;
	sCode += div(className+' item = new '+className+'();');
	sCode += div('return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);');
	codeIndent--;
	sCode += div('}');
	
	/*
	sCode += newline;
	sCode += div('@SuppressWarnings("unchecked")');
	sCode += div('public &lt;T&gt; Vector&lt;T&gt; getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {');
	codeIndent++;
	sCode += div('return (Vector&lt;T&gt;) getAllWithSqlQueryStatic(sSqlquery);');
	codeIndent--;
	sCode += div('}');
	*/
	
	var isNameExist = false;
	columns.each(function(item, index){
		if (item.prefixedName=="sName") isNameExist = true;
	});
	
	if (!isNameExist) {
		sCode += newline;
		sCode += div('@Override');
		sCode += div('public String getName() {');
		codeIndent++;
		sCode += div('return "'+sTableName+'_"+this.lId;');
		codeIndent--;
		sCode += div('}');
	}
	
	columns.each(function(item, index){
		if (index!=0) {
			if (!timeStamped || (timeStamped && (item.prefixedName!="tsDateCreation" && item.prefixedName!="tsDateModification"))) {
				sCode += newline;
				if (item.prefixedName=="sName") sCode += div('@Override');
				sCode += div('public '+item.javaTypeObj.value+' get'+getCamelString(item.name)+'() {return this.'+item.prefixedName+';}');
				sCode += div('public void set'+getCamelString(item.name)+'('+item.javaTypeObj.value+' '+item.prefixedName+') {this.'+item.prefixedName+' = '+item.prefixedName+';}');
			}
		}
	});
	
	sCode += newline;
	sCode += div('public JSONObject toJSONObject() throws JSONException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException, NamingException, SQLException {');
	codeIndent++;
	sCode += div('JSONObject item = new JSONObject();');
	sCode += div('item.put("lId", this.lId);');
	columns.each(function(item, index){
		if (index!=0) {
			if (timeStamped && (item.prefixedName=="tsDateCreation" || item.prefixedName=="tsDateModification")) {
				sCode += div('item.put("'+item.prefixedName+'", super.'+item.prefixedName+');');
			} else if (item.javaTypeObj.value=="float"){
                sCode += div('item.put("'+item.prefixedName+'", Float.toString(Outils.round(this.'+item.prefixedName+')));');
            }else {
				sCode += div('item.put("'+item.prefixedName+'", this.'+item.prefixedName+');');
			}
		}
	});
	sCode += div('return item;');
	codeIndent--;
	sCode += div('}');
	
	sCode += newline;
	sCode += div('public static JSONObject getJSONObject(long lId) throws CoinDatabaseLoadException, SQLException, NamingException, JSONException, InstantiationException, IllegalAccessException {');
	codeIndent++;
	sCode += div(className+' item = get'+className+'(lId);');
	sCode += div('JSONObject data = item.toJSONObject();');
	sCode += div('return data;');
	codeIndent--;
	sCode += div('}');
	
	
	sCode += newline;
	sCode += div('public static JSONArray getJSONArray() throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseLoadException {');
	codeIndent++;
	sCode += div('JSONArray items = new JSONArray();');
	sCode += div('for ('+className+' item:getAllStatic()) items.put(item.toJSONObject());');
	sCode += div('return items;');
	codeIndent--;
	sCode += div('}');

	sCode += newline;
	sCode += div('public void setFromJSONObject(JSONObject item) {');
	codeIndent++;
	columns.each(function(item, index){		
		if (index!=0) {
			if (!timeStamped || (timeStamped && (item.prefixedName!="tsDateCreation" && item.prefixedName!="tsDateModification"))) {
				sCode += div('try {');
				codeIndent++;
				sCode += div('this.'+item.prefixedName+' = item.'+item.javaTypeObj.getMethod+'("'+item.prefixedName+'");');			
				codeIndent--;
				sCode += div('} catch(Exception e){}');
			}
		}
	});
	codeIndent--;
	sCode += div('}');

	
	sCode += newline;
	sCode += div('public static long storeFromJSONString(String jsonStringData) throws JSONException {');
	codeIndent++;
	sCode += div('return storeFromJSONObject(new JSONObject(jsonStringData));');
	codeIndent--;
	sCode += div('}');
	
	
	sCode += newline;
	sCode += div('public static long storeFromJSONObject(JSONObject data) {');
	codeIndent++;
	sCode += div('try {');
	codeIndent++;
	sCode += div(className+' item = null;');
	sCode += div('try{');
	codeIndent++;
	sCode += div('item = '+className+'.get'+className+'(data.'+columns[0].javaTypeObj.getMethod+'("lId"));');
	codeIndent--;
	sCode += div('} catch(Exception e){');
	codeIndent++;
	sCode += div('item = new '+className+'();');
	sCode += div('item.create();');
	codeIndent--;
	sCode += div('}');
	sCode += div('item.setFromJSONObject(data);');
	sCode += div('item.store();');
	sCode += div('return item.getId();');
	codeIndent--;
	sCode += div('} catch(Exception e){');
	codeIndent++;
	sCode += div('return 0;');
	codeIndent--;
	sCode += div('}');	
	codeIndent--;
	sCode += div('}');
	
	
	sCode += newline;
	codeIndent--;
	sCode += div('}');
	
	$('java_code').innerHTML = sCode;
}

onPageLoad = function() {
	displayTableView();
	$('className').value = getCamelString(sTableName);
	$('generate_btn').onclick = generateBean;
	
	$('timeStamped').onclick = function() {
		if (this.checked) $('memory').checked = false;
	}
	$('memory').onclick = function() {
		if (this.checked) $('timeStamped').checked = false;
	}

}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">

	<div style="padding:30px;background:#EFF5FF">
		<table><tr>
			<td>
				<div id="column_dg"></div>
			</td>
			<td class="top" style="padding:20px">
				<div>ClassName : <input id="className" type="text" /></div>
				<div style="margin-top:6px;"><input id="timeStamped" type="checkbox"/>&nbsp;&nbsp;CoinDatabaseAbstractBeanTimeStamped</div>
				<div style="margin-top:6px;"><input id="memory" type="checkbox"/>&nbsp;&nbsp;CoinDatabaseAbstractBeanMemory</div>
				<br/>
				<div style="margin-top:6px;"><input id="bUseHttpPrevent" type="checkbox" checked="checked"/>&nbsp;&nbsp;bUseHttpPrevent : activer ou desactiver le PreventLoad et PreventStore</div>
				<div style="margin-top:6px;"><input id="bUseFieldValueFilter" type="checkbox" checked="checked"/>&nbsp;&nbsp;bUseFieldValueFilter : Permet de desactiver tous les filtres sur les champs</div>
			</td>
		</tr></table>	
	</div>
	<div style="margin-top:15px;text-align:center">
		<button id="generate_btn">Generate the bean !</button>
	</div>
	<div style="margin-top:10px;padding:30px;background:#EFF5FF">
		<div id="java_code" style="text-align:left;font-size:12px;font-family:Courier New;background-color:#FFF;border:1px solid #36C;padding:20px">
		</div>
	</div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>