
<%@ page import="org.coin.util.treeview.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, org.coin.util.*"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String rootPath = request.getContextPath()+"/";
	marche.setFromFormPaveAnnulation(request, "");
	marche.store();
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet")); 
	String sIsProcedureLineaire = null;
	try{
		sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	}
	catch(Exception e){}
	String sUrlRedirect = rootPath+"desk/export/boamp/afficherXmlGenereBoampPourAvisAnnulation.jsp?iIdExport="+iIdExport+"&iIdAffaire="+iIdAffaire+"&iIdOnglet="+iIdOnglet+"&sIsProcedureLineaire="+sIsProcedureLineaire;
%>
<html>
<head>
<script type="text/javascript">
	function onAfterPageLoading(){
		opener.parent.main.document.location = "<%= response.encodeURL(sUrlRedirect)%>";
		window.close();			
	}
</script>
</head>
<body onload="onAfterPageLoading()">
</body>
</html>