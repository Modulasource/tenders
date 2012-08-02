
<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.fr.bean.export.PublicationBoamp"%>
<%@page import="org.coin.fr.bean.export.Export"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%

	Marche marche = (Marche) request.getAttribute("marche");
	int iIdAffaire = marche.getIdMarche();
	
	String sFormPrefix = request.getParameter("sFormPrefix");
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = request.getParameter("sPageUseCaseId");
	
	boolean bIsContainsAAPCPublicity = Boolean.parseBoolean(request.getParameter("bIsContainsAAPCPublicity"));
	boolean bIsContainsEnveloppeAManagement = Boolean.parseBoolean(request.getParameter("bIsContainsEnveloppeAManagement"));
	boolean bIsContainsCandidatureManagement = Boolean.parseBoolean(request.getParameter("bIsContainsCandidatureManagement"));
	boolean bIsForcedNegociationManagement = Boolean.parseBoolean(request.getParameter("bIsForcedNegociationManagement"));
	boolean bIsLinkedPublicityAndCandidature = Boolean.parseBoolean(request.getParameter("bIsLinkedPublicityAndCandidature"));
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );

	
	String sPavePublicationsTitre = "Publications sur le site Internet";
	sFormPrefix = "";

    %><%@ include file="pavePublications.jspf" %><%

    String sPaveDelaisValiditeTitre = "Planning";
	sFormPrefix = "";
%>

<%@page import="modula.graphic.Theme"%>
<br />
<%@ include file="paveDelaisValidite.jspf" %>
<br />
<jsp:include page='<%= Theme.getDeskTemplateFilePath("/desk/marche/algorithme/affaire/pave/paveChoixPublicationOfficielleForm.jsp",request)%>' flush="false">
<jsp:param name="lIdMarche" value="<%= marche.getId() %>" />
</jsp:include> 
<br />
<%
	Export exportBoamp =PublicationBoamp.getExportBoampFormMarche((int)marche.getId());
	
	if (exportBoamp != null) {
		%><%@ include file="pavePublicationsOfficielles.jspf" %><%
	} 
%>