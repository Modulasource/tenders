<%@page import="modula.marche.Marche"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,java.util.*, modula.marche.cpv.*,modula.graphic.*,java.sql.*" %>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="modula.TypeObjetModula"%>
<%
	String sTitle = "Préparer l'avis récapitulatif";


    Organisation organisation = Organisation.getOrganisation(HttpUtil.parseLong("lId", request));
    organisation.setAbstractBeanLocalization(sessionLanguage);
	request.setAttribute("organisation", organisation);
	request.setAttribute("localizeButton",  localizeButton);

	Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
	vBarBoutons.add( 
            new BarBouton(1,
                "Retour à l'organisation",
                response.encodeURL(rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
                        + organisation.getIdOrganisation()),
                rootPath+"images/icons/36x36/home.png", 
                "",
                "",
                "",
                "",
                true) );
	
    Multimedia multi = null;
	try{
		multi = Multimedia.getMultimediaFirstOccurence(
		               MultimediaType.TYPE_TEMPLATE_AVIS_RECAPITULATIF,
		               organisation.getIdOrganisation(),
		               ObjectType.ORGANISATION);

	} catch(Exception e){
		multi = Multimedia.getMultimediaFirstOccurence(
                 MultimediaType.TYPE_TEMPLATE_AVIS_RECAPITULATIF,
                Configuration.getIntValueMemory("system.idorganization", 2),
                ObjectType.ORGANISATION);
	}
	
    String sUrlDlTemplate = "desk/DownloadFileDesk?"
        + "&amp;" + DownloadFile.getSecureTransactionStringFullJspPage(
                request, 
                multi.getIdMultimedia(),
                TypeObjetModula.MULTIMEDIA )
        + "&amp;sContentType="+ multi.getContentType()
        ;

   sUrlDlTemplate = response.encodeURL(rootPath+ sUrlDlTemplate);


%>
<link rel="stylesheet" type="text/css" href="<%=rootPath %>include/component/calendar/calendar.css" media="screen" />
<script type="text/javascript" src="<%=rootPath%>include/component/calendar/calendar.js"></script>
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    menuBorder.render($('menuBorder'));
});
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
    <div class="fullWidth">
<%=  BarBouton.getAllButtonHtmlDesk(vBarBoutons) %>
    </div>
</div>
<br/>
<br/>

<form action="<%= response.encodeURL("generateXlsFileAvisRecap.jsp?lId=" + organisation.getId()) %>" method="post">
<input type="hidden" name="lIdMultimediaTemplate" value="<%= multi.getId() %>" />
<table class="pave" >
	<tr>
		<td class="pave_titre_gauche"> Avis récapitulaif</td>
    </tr>
    <tr>
        <td >
<!-- 
            Année : 
            <select name="iYear">
                <option>2007</option>
                <option>2008</option>
                <option>2009</option>
            </select>
            <br/>
 -->
             <input type="text" name="tsDateStart" class="dataType-date dataType-notNull" value="<%= 
            	CalendarUtil.getDateCourte( new Timestamp( (long)System.currentTimeMillis()
            			- (long)(1000L * 60L * 60L * 24L * 365L) )) 
            	%>" /> à 
            <input type="text" name="tsDateEnd" class="dataType-date dataType-notNull" value="<%=
            	CalendarUtil.getDateCourte( new Timestamp( System.currentTimeMillis())) 
                %>" />

        </td>
    </tr>
	<tr>
	    <td >
            <button type="button" 
                onclick="doUrl('<%=
                	sUrlDlTemplate
                	%>')" >Télécharger l'avis recapitulatif vierge</button>
            <button type="submit" 
                >Géréner l'avis recapitulatif</button>
		</td>
	</tr>
</table>
</form>
<br/>
<jsp:include page="/desk/marche/petitesAnnonces/pave/blocAllAffairePetiteAnnonce.jsp">
<jsp:param value="recap_attr" name="sAction"/>
</jsp:include>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="org.coin.db.CoinDatabaseLoadException"%></html>
