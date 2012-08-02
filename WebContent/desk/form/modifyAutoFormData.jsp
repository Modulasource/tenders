
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.form.AutoFormFile"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.util.BasicDom"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="org.coin.util.XmlTransformerUtil"%>
<%@page import="org.coin.servlet.XmlTransformer"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.util.FileUtil"%>
<%@page import="org.coin.bean.form.AutoForm"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.form.document.AutoFormDocumentXsl"%>
<%@page import="org.coin.util.HttpUtil"%>
<%

	String sPrefixInternal = AutoForm.HTML_FORM_PREFIX_INTERNAL;
	long lIdAutoform = HttpUtil.parseLong(AutoForm.HTML_FORM_PREFIX_INTERNAL + "lIdAutoform", request);
	Connection conn = ConnectionManager.getConnection();

	String sXsl = AutoFormDocumentXsl.generateXsl(lIdAutoform, conn);
    System.out.println(sXsl);

	String sXmlData = HttpUtil.getRequestParametersXml(AutoForm.HTML_FORM_PREFIX_INTERNAL, request);

	sXmlData = "<autoForm>"
		+ "<data type='htmlParameter' >"
		+ sXmlData 
		+ "</data>"
		+ "</autoForm>";

	sXmlData = HTMLEntities.unhtmlentitiesComplete(sXmlData);
    Document doc = BasicDom.parseXmlStream(sXmlData,false);

    
    
    /**
     * Save values ?
     */
	boolean bSaveAllValue = HttpUtil.parseBooleanCheckbox(AutoForm.HTML_FORM_PREFIX_INTERNAL + "bSaveAllValue", request, false);

    if(bSaveAllValue)
    {
    	AutoFormFile aff = null;
        
    	try{
    		aff = AutoFormFile.getAutoFormFileFromAutoForm(
                    lIdAutoform, 
                    AutoFormFile.FILENAME_DEFAULT_VALUES,
                    false, 
                    conn);
    		
    		aff.remove(conn);
    	} catch (CoinDatabaseLoadException e) {
    	}
    	
    	aff = new AutoFormFile();
    	aff.setFilename(AutoFormFile.FILENAME_DEFAULT_VALUES); 
    	aff.setContent(sXmlData);
    	aff.setIdAutoform(lIdAutoform);
    	aff.create(conn);
    }
     
    String sFilePdf = "d:\\autoform.pdf";
    String sFileRtf = "d:\\autoform.rtf";
    String sFilenameXsl = "d:\\autoform.xsl";
    String sFilenameXml = "d:\\autoform.xml";
    File pdf = new File(sFilePdf);
    File rtf = new File(sFileRtf);
    File xml = new File(sFilenameXml);
    FileUtil.writeFileWithData(xml, sXmlData);

    
    
    /**
     * XSL
     */
     
    File fileXsl = new File(sFilenameXsl);
    FileUtil.writeFileWithData(fileXsl, sXsl);

	
    XmlTransformerUtil.xmlToFile(
            doc,
            fileXsl,
            pdf,
            XmlTransformerUtil.FICHIER_TYPE_PDF);
    
    
	ConnectionManager.closeConnection(conn);
%>