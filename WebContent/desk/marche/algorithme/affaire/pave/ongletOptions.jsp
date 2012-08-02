
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	Marche marche = (Marche) request.getAttribute("marche");
	int iIdAffaire = marche .getIdMarche();
	String rootPath = request.getContextPath()+"/";
	
	String sActionRectificatif = "";
	try{sActionRectificatif = request.getParameter("sActionRectificatif");}
	catch(Exception e){}
	
	int iIdOnglet = -1;
	try{iIdOnglet= Integer.parseInt(request.getParameter("iIdOnglet"));}
	catch(Exception e){}
	
	int iIdAvisRectificatif = -1;
	int iTypeAvisRectificatif = -1;
	try	
	{
		iIdAvisRectificatif = Integer.parseInt(request.getParameter("iIdAvisRectificatif"));
		iTypeAvisRectificatif = Integer.parseInt(request.getParameter("iTypeAvisRectificatif"));
	}	
	catch(Exception e){}
	
	boolean bFormJOUE = false;
	try {
		bFormJOUE = Boolean.parseBoolean(request.getParameter("bFormJOUE"));
	} catch(Exception e) {}
	
	boolean bRectifFormJoueCompleted = true;
    try {
    	bRectifFormJoueCompleted = Boolean.parseBoolean(request.getParameter("bRectifFormJoueCompleted"));
    } catch(Exception e) {}
    if(!bRectifFormJoueCompleted) {
    	sActionRectificatif = "store";
    	bFormJOUE = true;
    }
    boolean bCreationArec = false;
    try {
    	bCreationArec = Boolean.parseBoolean(request.getParameter("bCreationArec"));
    } catch(Exception e) {}
	
if ((marche.getIdMarcheSynchro() == modula.marche.MarcheSynchro.MARCO) && (iIdOnglet == Onglet.ONGLET_AFFAIRE_EXPORT))
{
%>
	<jsp:include page="ongletExport.jsp" flush="true" >
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
	</jsp:include>
<%
}
else
{
	if(sActionRectificatif.equals(""))
	{
%>
	<jsp:include page="../../avis_rectificatif/afficherTousAvisRectificatif.jsp" flush="true">
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
	</jsp:include>
<%	
	}
	else if ((sActionRectificatif.equalsIgnoreCase("store")) || (sActionRectificatif.equalsIgnoreCase("create")) )
	{
%>
	<jsp:include page="../../avis_rectificatif/modifierAvisRectificatifForm.jsp" flush="true">
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" /> 
		<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
		<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" /> 
		<jsp:param name="iTypeAvisRectificatif" value="<%= iTypeAvisRectificatif %>" />
		<jsp:param name="bFormJOUE" value="<%= bFormJOUE %>" />  
		<jsp:param name="bRectifFormJoueCompleted" value="<%= bRectifFormJoueCompleted %>" />
        <jsp:param name="bCreationArec" value="<%= bCreationArec %>" />
	</jsp:include>
<%
	}
	else if (sActionRectificatif.equalsIgnoreCase("show"))
	{
	
%>
	<jsp:include page="../../avis_rectificatif/afficherAvisRectificatif.jsp" flush="true">
		<jsp:param name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
		<jsp:param name="sActionRectificatif" value="<%= sActionRectificatif %>" />
		<jsp:param name="iIdOnglet" value="<%= iIdOnglet %>" />
		<jsp:param name="iIdAvisRectificatif" value="<%= iIdAvisRectificatif %>" />
        <jsp:param name="bCreationArec" value="<%= bCreationArec %>" />
	</jsp:include>
<%
	}
}
%>
