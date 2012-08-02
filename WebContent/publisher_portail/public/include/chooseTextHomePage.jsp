
<%@page import="org.coin.fr.bean.OrganisationParametre"%>
<%@page import="modula.graphic.CSS"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%
    String rootPath = request.getContextPath() +"/";
	String sUrlTextHome= "textHomePage.jsp";
	String sTextHomPageHtml =null ;
    try{
		/** Example : *.jsp?design_use_organisation_id=179 */
		int iMyDesignUseOrganisationId = -1;
	    try{iMyDesignUseOrganisationId = (Integer)session.getAttribute(CSS.DESIGN_USE_ORGANISATION_ID);}
	    catch(Exception e){
	    	iMyDesignUseOrganisationId = Integer.parseInt((String)session.getAttribute(CSS.DESIGN_USE_ORGANISATION_ID));
	    }
	    
	    String sEncodingPage="UTF-8";
        sEncodingPage = Configuration.getConfigurationValueMemory("server.multimedia.encoding",  "toto");
        if(sEncodingPage.equals("toto")){
        	// petite bidouille pour accepter les NULL
            sEncodingPage = null;
        }
		try{
			sTextHomPageHtml = Multimedia.getMultimediaFirstOccurenceValueString(
    			MultimediaType.TYPE_TEXT_HOME_PAGE,
       			iMyDesignUseOrganisationId,
       			ObjectType.ORGANISATION,
       			sEncodingPage);
		
		} catch (Exception e) {
		}
    	
     
        if(sTextHomPageHtml != null)
        {
        	sTextHomPageHtml = HTMLEntities.htmlentities(sTextHomPageHtml);
            sTextHomPageHtml = Outils.replaceAll(sTextHomPageHtml, "[rootPath]", rootPath);
        	
        	String sUrlPrefix = Configuration.getConfigurationValueMemory("publisher.portail.multimedia.url", "https://prod.modula-demat.com/multimediaClientsModula/eurosud/common");
        	sTextHomPageHtml = Outils.replaceAll(sTextHomPageHtml, "[url.design]", sUrlPrefix);
            sTextHomPageHtml = HttpUtil.encodeAllUrl(sTextHomPageHtml, "##__", "__##", response);
            
            Border b1 = new Border("F5F5F5",12,100,"blr",request);
            sTextHomPageHtml = Outils.replaceAll(sTextHomPageHtml, "[border.top]", b1.getHTMLTop());
            sTextHomPageHtml = Outils.replaceAll(sTextHomPageHtml, "[border.bottom]", b1.getHTMLBottom());
          	
        }else {        	
            sUrlTextHome = OrganisationParametre.getOrganisationParametreValue(
                    iMyDesignUseOrganisationId, 
                    "publisher.portail.textHomePage.url");
       	
        }
    } catch(Exception e) {
    	//e.printStackTrace();
    	try{
			sUrlTextHome = Configuration.getConfigurationValueMemory("publisher.portail.textHomePage.url");
		} catch(Exception ee) {}
	}

    //System.out.println("sUrlTextHome = \n" +sUrlTextHome);
    //System.out.println("sTextHomPageHtml = \n" +sTextHomPageHtml);
    
   if(sTextHomPageHtml != null)
   {
	    out.println(sTextHomPageHtml);
   } else {
	   
%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="java.io.InputStream"%>
<%@page import="org.coin.ui.Border"%>

<%@page import="org.coin.util.HTMLEntities"%>

<jsp:include page="<%= sUrlTextHome %>" flush="false" >
		<jsp:param name="rootPath" value="<%= rootPath %>" />
</jsp:include>
<% } %>