<%@ include file="../include/headerXML.jspf" %>

<%@ page import="org.coin.bean.html.*,org.coin.bean.form.*,java.security.cert.*,java.io.*,java.util.*" %>
<%
	String sTitle = "Afficher ";
	int iIdAutoForm = 1;
	// iIdAutoForm = Integer.parseInt(request.getParameter("iIdAutoForm"));
	
	TypedDataEntered tde = new TypedDataEntered(1,iIdAutoForm);
	String sCreateSql = tde.computeSqlQueryCreateTable();
	String sDropSql = tde.computeSqlQueryDropTable();
	
	//org.coin.db.ConnectionManager.executeUpdate(sCreateSql);
	//org.coin.db.ConnectionManager.executeUpdate(sDropSql);
	String sCreateSqlHtml = org.coin.util.Outils.getTextToHtml(sCreateSql);
	//String sCreateSqlHtml = org.coin.util.Outils.getTextToHtml(sDropSql);
	
	AutoForm af = AutoForm.getAutoForm(iIdAutoForm);
	Vector<AutoFormField> vFormFields = af.getAllFields(true);
	
	vFormFields = af.getAllFields(false);

	%>
<%@ include file="../../include/new_style/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
</head>
<body >
	<br/>
	<%= sCreateSqlHtml %>
	<br/>

</body>
</html>