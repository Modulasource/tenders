
<%@page import="org.coin.bean.boamp.BoampFormulaireType"%>
<%@page import="mt.modula.affaire.publication.PublicationXlsAvisRecapitulatif"%>
<%@page import="modula.commission.Commission"%>
<%@page import="modula.Validite"%>
<%@page import="modula.algorithme.AlgorithmeModula"%>
<%@page import="modula.algorithme.PhaseEtapes"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="modula.marche.*"%>
<%@page import="modula.candidature.*"%>
<%@page import="org.apache.poi.hssf.usermodel.*"%>
<%@page import="org.apache.poi.poifs.filesystem.POIFSFileSystem"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.*"%>
<%@page import="org.coin.db.*"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.util.excel.PoiExcelUtil"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%

	Organisation organisation = Organisation.getOrganisation(HttpUtil.parseLong("lId", request));


	Connection conn = ConnectionManager.getConnection();

    Calendar calDateStart = CalendarUtil.getCalendar( HttpUtil.parseTimestamp("tsDateStart", request, null) );
    Calendar calDateEnd = CalendarUtil.getCalendar( HttpUtil.parseTimestamp("tsDateEnd", request, null) );

    
	
    Multimedia multiTemplate = Multimedia.getMultimedia(
    		HttpUtil.parseInt("lIdMultimediaTemplate", request) );
    
    File file = PublicationXlsAvisRecapitulatif.generateAvisRecapitulatif(
			organisation.getId(),
			multiTemplate,
			calDateStart,
			calDateEnd,
			conn);
    
    /**
     * Create Petite Annonce Avis Recaptulatif .. need to refactor a little 
     */
    String sReference = "Avis recapitulatif";
    String sObjet = "Avis recapitulatif";
    
    
    PublicationXlsAvisRecapitulatif.createPetiteAnnonceAvisRecapitulatif(
    		organisation.getId(),
    		sessionUser.getIdIndividual(),
    		sReference ,
    		sObjet,
    		file,
            conn);
    
	response.sendRedirect(response.encodeURL("prepareAvisRecapitulatif.jsp?lId="+ organisation.getId()));
%>
