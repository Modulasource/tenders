<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@page import="org.coin.bean.ged.GedFolderType"%>
<%@page import="mt.fondationleclerc.GedDocumentDuplicateThread"%>

<%@ include file="/include/beanSessionUser.jspf"%>
<%
	
	/**
	 * Here its a multipart/form-data
	 */
	String sPageUseCaseId = "IHM-DESK-FONDATION-LECLERC-GERER-DOCUMENTS";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	String sAction = HttpUtil.parseString("sAction", request, "");
	
	GedDocument item = GedDocument.getGedDocument(HttpUtil.parseLong("lId",request));
    
	/**

	*/
	
	String sDestinationPath = Configuration.getConfigurationValueMemory("ged.pathOnHardDrive", "");
	
    Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
    	if (!itemField.isFormField() && itemField.getSize()>0) {
	        item.setDocumentName(itemField.getName());
	        item.setDocument(itemField.getInputStream());
	        item.setDocumentContentType(itemField.getContentType()); 
	        item.setDocumentLength(itemField.getSize());
	        item.store();
	        if (item.isOnHardDrive() && !sDestinationPath.equals("")){
				item.removeFromHardDrive();
	        	String sName = sDestinationPath+Password.getWord()+"-"+item.getId();
	        	File fOut = new File(sName+"."+Outils.getExtensionFromFilename(item.getDocumentName()));
	        	try{itemField.write(fOut);
	        		item.setPathOnHardDrive(fOut.getAbsolutePath());
	        	}catch(Exception e){e.printStackTrace();}
	        	
				try {
					Shell sh = new Shell();
					sh.command("ffmpeg -i "+fOut.getAbsolutePath()+" -an -r 1 -ss 00:00:05 -t 00:00:01.1 -f image2 -y "+sName+".jpg").consume();
				} catch (Exception e) {e.printStackTrace();}
				
				File fileCapture = new File(sName+".jpg"); 
				fileCapture.deleteOnExit();
				try {item.createThumbnailFromImage(item.getConnection(), fileCapture);
				}catch(Exception e) {e.printStackTrace();}
				fileCapture.delete();
				
	        	
	        	/**   ,
	        	//Create thumbnail for videos :
	        		try {
					Process proc = Runtime.getRuntime().exec("harris.sh");
					}
					catch(IOException e) {
					
					}
					
					http://ffmpeg.org/ffmpeg-doc.html#SEC7
					
					ffmpeg -i toto_stream.flv -r 1 -f image2 toto-%03d.jpg    
					ffmpeg -i toto_stream.flv -r 1 -s 300x100 -f image2 toto-%03d.jpg  
					ffmpeg -i toto_stream.flv -an -ss 00:01:00 -an -r 1 -vframes 1 -y %d.jpg
					
					ffmpeg -i toto_stream.flv -r 1 -ss 00:00:05 -t 00:00:01.1 -f image2 655.jpg
	        	*/
	        	
	        }else{
	        	item.storeDocumentFile();
	        }
	    }
	}
	item.store();
	item.createThumbnail(item.getConnection());
	
	
	
	// Duplication du document
	new GedDocumentDuplicateThread (item.getId()).start();
	
	if (sAction.equals("modify")){ 
		String sReturnMessage = "Fichier correctement envoyé.";
		int iCode = 1;
	%>
		<%@page import="org.coin.security.Password"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="java.io.File"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="com.developpez.adiguba.shell.ProcessConsumer"%>
<%@page import="com.developpez.adiguba.shell.Shell"%><html>
		<head>
		<script type="text/javascript">
		parent.onUploadDone(<%=iCode%>, "<%= sReturnMessage %>");
		</script>
		</head>
		<body></body>
		
		</html>
<% } %>