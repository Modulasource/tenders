<%@ include file="/include/headerXML.jspf" %>
<%
    String sTitle = "JIR Marches";

    String sDesignUseOrganisationId = request.getParameter("design_use_organisation_id");
    String sBandeauPath = "";
    String sUrlCommonMultimedia = "";
    String sPreURI = "";
    String sIframeContent = "";
    
    try{
        sUrlCommonMultimedia = org.coin.bean.conf.Configuration.getConfigurationValueMemory("multimedia.commonUrl");
    }catch(Exception e){}
    try{
        String sSelfDocumentRoot = OrganisationParametre.getOrganisationParametreValue(Integer.parseInt(sDesignUseOrganisationId),"organisation.multimedia.documentRoot");
        Vector<Multimedia> vMultimedias = null;
        try{
            vMultimedias = Multimedia.getAllMultimedia(MultimediaType.TYPE_BANDEAU, Integer.parseInt(sDesignUseOrganisationId), ObjectType.ORGANISATION);
        }catch(Exception e) {}
        String sBandeauFile = vMultimedias.firstElement().getFileName();
        sBandeauPath = sUrlCommonMultimedia+"/"+sSelfDocumentRoot+"/"+sBandeauFile;
    }
    catch(Exception e){}
%>
<%@include file="/templatesClients/common/indexHeader.jspf" %>
<%	
	/*try {
	    sPreURI = request.getParameter("pre");
	
		if(sPreURI != null && !sPreURI.equals("")) {
		    sIframeContent = sPreURI + (sPreURI.contains("?")?"&":"?")+"design_use_organisation_id="+sDesignUseOrganisationId;
		} else {
		    sIframeContent = rootPath + "publisher_portail/index.jsp?design_use_organisation_id="+sDesignUseOrganisationId;
		}
    } catch (Exception e) {}
    
    String sParam = "";
    try {
        if(request.getParameter("filtreType") != null) {
            sParam = "&filtreType="+request.getParameter("filtreType");
        }
        if(request.getParameter("filtre") != null) {
            sParam += "&filtre="+request.getParameter("filtre");
        }
        sIframeContent += sParam;
    } catch(Exception e) {}*/
    sIframeContent = rootPath + "publisher_portail/index.jsp?design_use_organisation_id="+sDesignUseOrganisationId;
%>
<style type="text/css">
<!--
 
h1{
    background-color:#E2001A;
    background-image:none;
}
// -->
</style>
<body >

<table style="width:900px;height:800px;vertical-align:top" 
    align="center" cellpadding="0" cellspacing="0">

  <tr>
    <td colspan="2" style="text-align: center; width:1024px;">
        <img src="<%= sBandeauPath%>" alt="JIR Marchés" />
    </td> 
  </tr>
  <tr>
    <td colspan="2" style="width:900px;" >
        <h1>Portail des march&eacute;s publics</h1>
    </td>
  </tr>
  <tr>
    <td valign="top" style="width:150px;">
    <%@include file="/templatesClients/common/menu.jspf" %>
    </td>
    <td valign="top" style="width:750px;">
        <iframe
            name="main" id="main" frameborder="0"
            style="width:100%;height:3500px;text-align:left"
            src="<%= sIframeContent %>">
        </iframe>
    </td>
  </tr>
</table>
</body>
</html>