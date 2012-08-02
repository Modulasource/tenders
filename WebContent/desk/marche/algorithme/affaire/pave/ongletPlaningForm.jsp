<%@page import="org.coin.fr.bean.export.Export"%>
<%@page import="org.coin.fr.bean.export.PublicationBoamp"%>
<%@page import="org.coin.autoform.component.*"%>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.graphic.Theme"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.export.PublicationEtat"%>
<%@page import="org.coin.fr.bean.export.PublicationDestinationType"%>
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
	boolean bIsRectification = HttpUtil.parseBoolean("bIsRectification", request,false);
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	
	String sPavePublicationsTitre = "Publications sur le site Internet";
	sFormPrefix = "";
	
	if(!bIsRectification){
%><%@ include file="pavePublicationsForm.jspf" %><%
	} else {
%><%@ include file="pavePublications.jspf" %>

<br/><%
	}
	
	String sPaveDelaisValiditeTitre = "Planning";
	sFormPrefix = "";
%>

<%@ include file="paveDelaisValiditeForm.jspf" %>
<br />
<jsp:include page='<%= Theme.getDeskTemplateFilePath(
		"/desk/marche/algorithme/affaire/pave/paveChoixPublicationOfficielleForm.jsp",request)
%>' flush="false">
<jsp:param name="lIdMarche" value="<%= marche.getId() %>" />
</jsp:include> 
<br />
<%

	/** 
	 * copy paste of ongletRensPublicationsCommon.jspf :( !!!
	 */
	
	Export exportBoamp =PublicationBoamp.getExportBoampFormMarche((int)marche.getId());

	int iTypePublicationMustBePublish = PublicationType.TYPE_AAPC;
	PublicationBoamp avisInitial =null;
	
	if (exportBoamp != null)
	{
		Vector<PublicationBoamp> vPublicationBoampValides = null;
		try{
			vPublicationBoampValides 
				= PublicationBoamp.getAllPublicationBoampFromAffaireAndEtatAndType(
					marche.getIdMarche(),
					PublicationEtat.ETAT_PUBLIEE,
					iTypePublicationMustBePublish);
		}catch(Exception e){}
		
		if(vPublicationBoampValides != null
		&& vPublicationBoampValides.size() == 0) {
			
			avisInitial = new PublicationBoamp ();
		
		//	 Champs non renseignables
			avisInitial.setNomFichier("");
			avisInitial.setFichier("");
			avisInitial.setArXml("");
			avisInitial.setMessage("");
			avisInitial.setXml("");
			avisInitial.setIdPublicationReference(0);
			avisInitial.setReferenceExterne("");
		
		
		//	champs automatiques
			avisInitial.setIdPublicationEtat(PublicationEtat.ETAT_PUBLIEE /*= 8*/);
			avisInitial.setIdPublicationDestinationType(PublicationDestinationType.TYPE_BOAMP /*= 1*/);
			avisInitial.setIdTypeObjet(TypeObjetModula.AFFAIRE /*= 1*/);
			avisInitial.setIdReferenceObjet(marche.getIdMarche() );
			avisInitial.setIdExport(exportBoamp.getIdExport()); 
			avisInitial.setFormatWebService(true);
			avisInitial.setFormatPapier(false);
			avisInitial.setIdPublicationType(PublicationType.TYPE_AAPC); 
		}
		else {
			avisInitial = vPublicationBoampValides.lastElement();
		}
		
	}
%>
<%
	if(!bIsRectification){
	%><%@ include file="pavePublicationsOfficiellesForm.jspf" %><%
	}
	else if(bIsRectification && exportBoamp != null)
	{
		if(sessionUserHabilitation.isSuperUser()){
%><%@ include file="pavePublicationsOfficiellesForm.jspf" %><%
		} else {
%><%@ include file="pavePublicationsOfficielles.jspf" %><%
		}
	}
%>

<%
	if(sessionUserHabilitation.isSuperUser())
	{
		boolean bStartWithAATR = false;
%>
		<% 
		if(exportBoamp != null)
		{
		%>
		<%@ include file="paveBoampExport.jspf" %>
		<%
		} else {
			%><input type="hidden" name="bExportBoampDefined" value="false" /><% 
		}
	}
%>


					

