<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,org.coin.bean.html.*,java.util.*,org.quartz.*,org.coin.bean.cron.*,mt.modula.cron.*" %>
<%
	String sTitle = "Batch";
	String sPageUseCaseId = "IHM-DESK-PARAM-BATCH-1";
	
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	String sMessage = HttpUtil.parseStringBlank("sMessage",request);
	
	String[] conns = JavaUtil.getFieldNames(BatchConnection.class.getName(),
	RemoteControlServiceConnection.class,
	null);
	Pays pays = new Pays();
	pays.setAbstractBeanLocalization(sessionLanguage);
	
	if(sAction.equalsIgnoreCase("launch")){
		String sBatch = HttpUtil.parseStringBlank("sBatch",request);
		if(sBatch.equalsIgnoreCase("AttachContractBatch")){
	long lIdContract = HttpUtil.parseLong("lIdContract",request);
	String sIdPays = HttpUtil.parseStringBlank("sIdPays",request);
	String selectConn = HttpUtil.parseStringBlank("selectConn",request);

	Connection conn;
	int DBTYPE = ConnectionManager.getDbType();
	if(selectConn.equalsIgnoreCase("local")){
		conn = ConnectionManager.getConnection();
	}else{
		RemoteControlServiceConnection rc = BatchConnection.getRequestRemoteConnection(selectConn);
		rc.connect();
		ConnectionManager.setDbType(rc.iType);
		conn = rc.conn;
	}
	try{
		new AttachContractBatch().attachContract(lIdContract,
		sIdPays,
		conn);
	}catch(Exception e){e.printStackTrace();}
	finally{
		ConnectionManager.closeConnection(conn);
		ConnectionManager.setDbType(DBTYPE);
	}
		}
	}
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>
<script type="text/javascript">
var acContract;
onPageLoad = function(){
    acContract = new AjaxComboList("lIdContract", "getContract");
}
</script>
</head>
<body style="overflow: auto;">
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%
if(!sMessage.equalsIgnoreCase(""))
{
%>
<div class="rouge" style="text-align:left" id="message"><%= sMessage %></div>
<br />
<%
}
%>
<br/>
<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2"> Liste des batch </td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<tr>
						<th>Name</th>
						<th>Description</th>
						<th>Paramètres</th>
						<th>&nbsp;</th>
					</tr>
					<tr class="liste0" style="font-size:8px"> 
                        <td style="width:10%">AttachContractBatch</td>
                        <td style="width:20%">Attach generic contract to all bus vehicle from country</td>
					    <td style="width:20%">
					    <form action="<%= response.encodeURL("displayAllBatch.jsp?sAction=launch&sBatch=AttachContractBatch")%>" name="AttachContractForm" id="AttachContractForm" method="post">
					    <button type="button" id="AJCL_but_lIdContract"
			            class="<%= CSS.DESIGN_CSS_MANDATORY_CLASS %>" >Choose Contract</button>
			            <input class="dataType-notNull dataType-id dataType-id dataType-integer" type="hidden" id="lIdContract" 
			                name="lIdContract" value="" />
			            <br/>
					    <select name="selectConn">
					    <option value="local">Local Connection</option>
					    <% for(String sConn : conns){ %><option value="<%= sConn %>"><%= sConn %></option><%} %>
					    </select>
					    <%= pays.getAllInHtmlSelect("sIdPays") %>
					    </form>
					    </td>
					    <td style="text-align:right;width:5%">
					        <a class="image" href="javascript:$('AttachContractForm').submit()">
					        <img src="<%=rootPath+"images/icones/cog.gif"%>" alt="executer manuellement" title="executer"/>
					        </a>
					    </td>
                    </tr>
				</table>
			</td>
		</tr>
	</table>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.batch.BatchConnection"%>
<%@page import="mt.modula.batch.RemoteControlServiceConnection"%>
<%@page import="mt.veolia.vfr.contract.Contract"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="mt.veolia.vfr.batch.AttachContractBatch"%>
</html>