<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<% 
String sRequestPage = HttpUtil.parseStringBlank("page",request);
String sPage = (String)application.getAttribute("page_"+ sRequestPage+"_"+sDesignUseOrganisationId);
String sEncoding = Configuration.getConfigurationValueMemory("server.encoding",  "UTF-8");
sEncoding = "ISO-8859-1";

String sUrlPrefix = Configuration.getConfigurationValueMemory("publisher.portail.multimedia.url", "https://prod.modula-demat.com/multimediaClientsModula/eurosud/common");


try{
if(sPage == null)
{
   	sPage = Multimedia.getMultimediaFirstOccurenceValueString(
               MultimediaType.TYPE_SITE_PUBLISHER_PAGE,
               "page_"+sRequestPage+".html",
               sDesignUseOrganisationId,
               ObjectType.ORGANISATION,
               sEncoding
               );
} else {
    
    /**
     * is there a flag to update the data ?
     */
    try {
        Configuration confFlag = 
            Configuration.getConfigurationMemory("system_message::update_multimedia_site_publisher_page_"+sRequestPage);
        
        confFlag.remove();
       
       	sPage = Multimedia.getMultimediaFirstOccurenceValueString(
                   MultimediaType.TYPE_SITE_PUBLISHER_PAGE,
                   "page_"+sRequestPage+".html",
                   sDesignUseOrganisationId,
                   ObjectType.ORGANISATION,
                   sEncoding
                   );
        
    } catch (Exception e) {
        
    }
}
//sPage = FileUtil.getStringContentFromFile("D:\\developpement\\sources\\modula_wtp_head\\config\\site\\affiches_grenoble\\page_utilitaire.html");
application.setAttribute("page_"+ sRequestPage+"_"+sDesignUseOrganisationId,sPage);

String sUrlAutoCompletion = "";
if(sPage.contains("[directive::url.activate.auto.design_use_organisation_id]"))
{
    sUrlAutoCompletion += "design_use_organisation_id=" + sDesignUseOrganisationId;
}

String sMessage = HttpUtil.parseStringBlank("sMessage",request);
sPage = Outils.replaceAll(sPage, "[message]", sMessage);

sPage = Outils.replaceAll(sPage,"[url.design]", sUrlPrefix);
sPage = Outils.replaceAll(sPage, "[rootPath]", rootPath);
sPage = Outils.replaceAll(sPage, "[sDesignUseOrganisationId]", sDesignUseOrganisationId);
sPage = HttpUtil.encodeAllUrl(sPage, "##__", "__##", sUrlAutoCompletion, response);

Border b1 = new Border("F5F5F5",12,100,"blr",request);
sPage = Outils.replaceAll(sPage, "[border.top]", b1.getHTMLTop());
sPage = Outils.replaceAll(sPage, "[border.bottom]", b1.getHTMLBottom());


}
catch(Exception e){e.printStackTrace();}
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body style="text-align:justify">
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<br />
<%= Outils.isNullOrBlank(sPage)?"":sPage %>
<br />
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
<%@page import="javax.tools.JavaCompiler"%>
<%@page import="org.coin.util.FileUtil"%>
</html>