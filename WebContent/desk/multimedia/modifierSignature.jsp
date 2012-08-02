
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%><%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ page import="org.coin.fr.bean.*,java.io.*"%>
<%@page import="mt.paraph.folder.util.ParaphFolderWorkflowCircuit"%>
<%@page import="java.util.Vector"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = request.getParameter("sAction");
	String sUrlRedirect ="";
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn" , conn);
	
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect") ;
	}

	
	if(sAction.equals("remove"))
	{
		/** remove PPparametre and multimedia */
		int iIdMultimedia = Integer.parseInt(request.getParameter("iIdMultimedia"));
		Multimedia multi = Multimedia.getMultimedia(iIdMultimedia);
		

		
		try{
			MultimediaParameter.removeAllFromMultimedia(multi, conn);
			
			long lIdMainSignature 
				= PersonnePhysiqueParametre.getMainSignatureForPersonnePhysique(
					multi.getIdReferenceObjet(),
					conn);
			
			if(lIdMainSignature  == multi.getId()) {
				/**
				* remove the main sign
				 */
			 	PersonnePhysiqueParametre.removeMainSignatureForPersonnePhysique(
			 			multi.getIdReferenceObjet());
			}
			
		} catch(Exception e){
			e.printStackTrace();
		}
		
		multi.remove(conn);
		
		/*
		
		 erff .. its only provided for person
		 
		sUrlRedirect = rootPath+"desk/multimedia/modifierMultimedia.jsp?sAction=remove"
		+ "&sUrlRedirect=" + sUrlRedirect
	 	+ "&iIdMultimedia=" + multi.getId();	
		System.out.println(sUrlRedirect);
		*/
		
		sUrlRedirect = rootPath+"desk/organisation/afficherPersonnePhysique.jsp"
			+ "?iIdPersonnePhysique=" + multi.getIdReferenceObjet()
			+ "&iIdOnglet=" + Onglet.ONGLET_PERSONNE_PHYSIQUE_SCANNED_SIGNATURE;
	}	
	
	response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
	ConnectionManager.closeConnection(conn);
	
%>
