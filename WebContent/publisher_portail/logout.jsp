<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@page import="modula.graphic.CSS"%>
<%@page import="org.coin.bean.conf.Configuration"%>

<%@ page import="java.util.*" %>
<%
	sessionUser.logout();
	session.setAttribute("sessionCurrentApplicationName","publisher_portail");
	
	Enumeration eEnum;
	eEnum = session.getAttributeNames();
	
	//String sDesignUseOrganisationId = "";
	try{sDesignUseOrganisationId = ((Integer)session.getAttribute( CSS.DESIGN_USE_ORGANISATION_ID )).toString();}
	catch(Exception e){sDesignUseOrganisationId = (String)session.getAttribute( CSS.DESIGN_USE_ORGANISATION_ID );}
	String sDesignCssCurrenUrl = (String) session.getAttribute( CSS.DESIGN_CSS_CURRENT_URL );

	while (eEnum.hasMoreElements())
	{
		session.removeAttribute(eEnum.nextElement().toString());
	}
	
	session.setAttribute( CSS.DESIGN_USE_ORGANISATION_ID  , sDesignUseOrganisationId);
	session.setAttribute( CSS.DESIGN_CSS_CURRENT_URL ,sDesignCssCurrenUrl );

	String sIndex = rootPath + "publisher_portail/index.jsp" ;
	try {sIndex = Configuration.getConfigurationValueMemory("publisher.portail.homepage");
	} catch (Exception e) {}
	
	String sLastIndex = sIndex;
	
    if (Configuration.isTrueMemory("publisher.portail.homepage.use.domain.name", false))
    {
    	sIndex = "http://" + request.getServerName();
    	
    	try {
	    	if(request.getServerName().equals("prod.modula-demat.com")
	    		|| request.getServerName().equals("modula-demat.com")) 
	    		sIndex = Configuration.getConfigurationValueMemory("publisher.url");
    	} catch (Exception e) {
    		sIndex = sLastIndex;
    	}
    }
	
	
%>
<script>
if(parent.updateMenu){
parent.updateMenu(<%= sessionUser.isLogged %>);
}
</script>
<script type="text/javascript" >
    function redirect() {
        var bForceTopLocationRedirect=<%= 
        	Configuration.isTrueMemory("publisher.portail.force.top.location.redirect", true)
        	%>;
        if(bForceTopLocationRedirect){
	        top.location="<%= response.encodeURL(sIndex) %>";
        } else {
        	doUrl("<%= response.encodeURL(sIndex) %>");
   		}
    }
    setTimeout("redirect()",1000); // delai en millisecondes
</script>
</head>
<body>
Vous allez être redirigé vers l'accueil
</body>
</html>