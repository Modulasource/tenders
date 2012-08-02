<%@ include file="headerXML.jspf" %>

<%@ page import="org.coin.util.*,modula.marche.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	int idInfosBulle = Integer.parseInt(request.getParameter("id"));
	String sTitle = "Avertissement Juridique "+idInfosBulle;
	
    InfosBulles item = new InfosBulles(idInfosBulle);
    item.bUseHttpPrevent = false;
    item.load();

    String sInfo = "";
    //sInfo =  Outils.replaceAll(InfosBulles.getInfosBullesContenuWeb(idInfosBulle, false,rootPath),"\n","<br />");

    sInfo =  item.getName();
    //sInfo = new String( sInfo.getBytes("UTF-8") , "UTF-8");
    //sInfo = new String( sInfo.getBytes() , "UTF-8");
    // WORK ONLY ON S20
    sInfo = new String( sInfo.getBytes("UTF-8") , "ISO-8859-1");
    
    System.out.println("\n\nsInfo: " + sInfo);
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
</head>
<body>
<span class="titre_page" style="padding-left:10px;padding-right:10px;">
	<%= sTitle %>
</span>&nbsp;&nbsp;
<img style="text-align:right;vertical-align:middle" src="<%=rootPath+modula.graphic.Icone.ICONE_AJ%>" alt="<%=sTitle%>" /><br />
<br />
<div align="left" style="font-weight:bold;">
<%= sInfo %>
</div>
<br /><br />
<button type="button" onclick="window.close();" >Fermer</button>
</body>
</html>
