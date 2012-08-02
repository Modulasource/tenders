
<%@ page import="java.util.*,org.coin.util.treeview.*" %>
<%  String sTitle = "HTML TreeView";
	String rootPath = request.getContextPath()+"/";

	int iIdRootNode = 1;
	try {
		iIdRootNode = Integer.parseInt(request.getParameter( "iIdRootNode" ) );	
	} catch(Exception e) {}

	
	Enumeration eEnum = request.getParameterNames();
	int iAddType = Integer.parseInt(request.getParameter("iAddType"));
	TreeviewNode node;
	int iIdNode=0;
	if (request.getMethod().equalsIgnoreCase("post")
			&& request.getParameter("node_post")!=null){
		
		iIdNode = Integer.parseInt(request.getParameter("node_post"));
		node = TreeviewNode.getTreeviewNode(iIdNode );
		switch (iAddType )
		{
			case 1 : 
				node.createNewFirstChildNode();
				break ;
			
			case 2 : 
				node.createNewNextSiblingNode();
				break ;
			
		}
	}
	response.sendRedirect(
			response.encodeRedirectURL(
				"modifierTreeviewForm.jsp?"
				+"iIdRootNode=" + iIdRootNode  
				+"#ancre_"+iIdNode));

%>
