<%
	Enumeration eEnum = session.getAttributeNames();
	
	while (eEnum.hasMoreElements())
	{
		session.removeAttribute(eEnum.nextElement().toString());
	}


	String userAgent = request.getHeader("user-agent");
	if (userAgent.contains("Android") 
	|| userAgent.contains("iPhone") 
	|| userAgent.contains("BlackBerry"))
	{
		session.invalidate();
		response.sendRedirect(request.getContextPath()+"/desk/mlogon.jsp");
		return;
	}


%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="java.util.*" %>
<%
	String sTitle = "Déconnexion en cours ...";

	String a = HttpUtil.parseStringBlank("a", request);
	String aLink = "";
	if(!a.equals("")){
		aLink = "?a=" + a;
	}
	
	sessionUser.logout();
	String sDesignUseOrganisationId = "";
	try{
	    sDesignUseOrganisationId = (String) session.getAttribute(modula.graphic.CSS.DESIGN_USE_ORGANISATION_ID );
	} catch (Exception e ) {
		/** 
		 * tomcat is very strange ...
		 */
	    sDesignUseOrganisationId = "" + (Integer) session.getAttribute(modula.graphic.CSS.DESIGN_USE_ORGANISATION_ID );
	};
	
	
	String sDesignCssCurrenUrl = (String) session.getAttribute(modula.graphic.CSS.DESIGN_CSS_CURRENT_URL );
	session.setAttribute(modula.graphic.CSS.DESIGN_USE_ORGANISATION_ID  , sDesignUseOrganisationId);
	session.setAttribute(modula.graphic.CSS.DESIGN_CSS_CURRENT_URL ,sDesignCssCurrenUrl );
	
	session.invalidate();

%>
<script type="text/javascript" >
	function redirect() {
		top.location="<%= rootPath + "desk/logon.jsp" + aLink%>"
	}
	setTimeout("redirect()",0); // delai en millisecondes
</script>
</head>
<body>
Vous avez choisi de quitter la session ou la session a expirée au bout de 30 minutes
<br />
Vous allez être redirigé vers l'accueil
</body>
</html>