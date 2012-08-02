<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.Iterator"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*, java.sql.*, java.io.*" %>
<%@ page import="modula.marche.*" %>
<%
	String sTitle = "Chargement de fichier";
    int iIdAffaire = 0;
	/**
	 * Here its a multipart/form-data
	 */
	String sPageUseCaseId = "IHM-DESK-xxx";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	MarchePieceJointe item = MarchePieceJointe.getMarchePieceJointe(HttpUtil.parseLong("lId",request));
	
	Iterator<?> iter = HttpUtil.getItemList(request);
	while (iter.hasNext()) {
	    FileItem itemField = (FileItem) iter.next();
	    if (!itemField.isFormField()) {
	
	        //if(itemField.getFieldName().equals("document"))
	        //{
	            item.setNomPieceJointe(itemField.getName());
	            item.setPieceJointe(itemField.getInputStream());
	            item.store();
	            item.storePieceJointe();
	        //}
	    }
	    if(itemField.isFormField()){
	         if(itemField.getFieldName().equals("iIdAffaire"))
            {
	        	 iIdAffaire = Integer.parseInt(itemField.getString());
            }
	    }
	}
	
	
    Marche marche = Marche.getMarche(iIdAffaire);
    boolean bIsDCEDisponible = marche.isDCEDisponible(false);
    
    if (bIsDCEDisponible)
    {
        marche.setDCEModifieApresPublication(true); 
        marche.setCandidatsPrevenusModificationDCE(false);
        marche.store();
    }
%>