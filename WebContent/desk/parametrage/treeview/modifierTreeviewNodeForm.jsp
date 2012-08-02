<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.treeview.*" %>
<% 
	String sTitle = "HTML TreeView : <span class=\"altColor\">Modification d'un noeud</span>"; 
	int iIdNode = Integer.parseInt(request.getParameter("iIdNode"));
	TreeviewNode node = TreeviewNode.getTreeviewNode(iIdNode);
	boolean bReadOnly = false;
	
	int iIdRootNode = 1;
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}


	ObjectLocalization olFr = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_FRENCH, ObjectType.TREEVIEW_NODE ,node.getId());
	ObjectLocalization olEn = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_ENGLISH, ObjectType.TREEVIEW_NODE ,node.getId());
	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<form name="formulaire" method="post" action="<%= response.encodeURL("modifierTreeviewNode.jsp" ) %>" >
	<input type="hidden" name="action" value="store" />
	<input type="hidden" name="action" value="create" />
	<input type="hidden" name="iIdNode" value="<%= node.getId() %>" />
	<input type="hidden" name="iFirstChildNode" value="<%= node.iFirstChildNode %>" />
	<input type="hidden" name="iNextSiblingNode" value="<%= node.iNextSiblingNode %>" />
	<input type="hidden" name="iIdRootNode" value="<%= iIdRootNode %>" />
	<%@ include file="pave/paveTreeviewNodeForm.jspf" %>
<br />
	<button type="submit" name="submit" >Modifier</button>
	&nbsp;<button type="reset" name="RAZ" onclick="Redirect('<%= 
		response.encodeURL(
			"modifierTreeviewForm.jsp?iIdRootNode=" + iIdRootNode) %>')">
			Retour</button>

</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>