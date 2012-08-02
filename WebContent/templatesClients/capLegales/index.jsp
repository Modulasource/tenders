<%@ include file="/include/headerXML.jspf" %>
<%
    String sTitle = "Cap Légales";

	String sDesignUseOrganisationId = request.getParameter("design_use_organisation_id");
	String sBandeauPath = "";
	String sUrlCommonMultimedia = "";
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
	catch(Exception e){
	}
%>
<%@include file="/templatesClients/common/indexHeader.jspf" %>
<style type="text/css">
<!--
 
h1{
    background-color:#0C3470;
    background-image:none;
}
// -->
</style>
<body >

<table style="width:900px;height:800px;vertical-align:top" 
    align="center" cellpadding="0" cellspacing="0">

  <tr>
    <td colspan="2" style="text-align: center; width:900px;">
    	<img src="<%= sBandeauPath%>" alt="Cap Légales" />
    </td> 
  </tr>
  <tr>
    <td colspan="2" style="text-align: center">
		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000"
		 codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,0,0"
		 width="900px" height="43" id="bandeau" align="" >
		 <param name="movie" value="images/bandeau.swf" />
		  <param name="quality" value="high" /> 
		  <param name="bgcolor" value="#FFFFFF" /> 
		  <embed src="images/bandeau.swf" quality="high" 
		      bgcolor="#FFFFFF"  width="850" height="43" name="bandeau" align=""
		      type="application/x-shockwave-flash" 
		      pluginspace="http://www.macromedia.com/go/getflashplayer"></embed>
		</object>
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
			src="<%= rootPath %>publisher_portail/public/annonce/afficherAnnonces.jsp?filtreType=marche.reference&filtre=<%=
				sFiltre%>&design_use_organisation_id=<%= sDesignUseOrganisationId
				%>" >
		</iframe>
    </td>
  </tr>
</table>
</body>
</html>