<%@page import="java.util.Vector"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ page import="org.coin.fr.bean.*,java.io.*"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sUrlRedirect ="";
	
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}

	if(sAction.equals("store"))
	{
		Connection conn = ConnectionManager.getConnection();
		int iIdMultimedia = Integer.parseInt(request.getParameter("lId"));
		Multimedia multi = Multimedia.getMultimedia(iIdMultimedia);
		multi.setLibelle(request.getParameter("sLibelle"));
		multi.store();
		
		Vector <MultimediaParameter> vMP 
			= MultimediaParameter.getAllFromMultimedia(multi, conn);
		for(MultimediaParameter mp : vMP)
		{
			mp.setName(request.getParameter("paramName_" + mp.getId()));
			mp.setValue(request.getParameter("paramValue_" + mp.getId()));
			mp.store();
		}
		
		response.sendRedirect(
				response.encodeRedirectURL(
							rootPath + "desk/multimedia/modifierMultimediaForm.jsp"
							+ "?lId=" + multi.getId()
							+ "&sAction=store"
							+ "&bUpdateParentFrame=true"
							+ "&sUrlRedirect=" + sUrlRedirect 
						));
		
		ConnectionManager.closeConnection(conn);
		return;
	}

	if(sAction.equals("createParam"))
	{
		int iIdMultimedia = Integer.parseInt(request.getParameter("lId"));
		Multimedia multi = Multimedia.getMultimedia(iIdMultimedia);
		MultimediaParameter mp = new MultimediaParameter();
		mp.setIdCoinMultimedia(iIdMultimedia);
		mp.create();
		
		
		response.sendRedirect(
				response.encodeRedirectURL(
							rootPath + "desk/multimedia/modifierMultimediaForm.jsp"
							+ "?lId=" + multi.getId()
							+ "&sAction=store"
							+ "&sUrlRedirect=" + sUrlRedirect 
						)); 
		return;
	}

	if(sAction.equals("removeParam"))
	{
		int iIdMultimediaParam = Integer.parseInt(request.getParameter("lIdMultimediaParam"));
		MultimediaParameter mp = MultimediaParameter.getMultimediaParameter(iIdMultimediaParam );
		mp.remove();
		
		
		response.sendRedirect(
				response.encodeRedirectURL(
							rootPath + "desk/multimedia/modifierMultimediaForm.jsp"
							+ "?lId=" + mp.getIdCoinMultimedia()
							+ "&sAction=store"
							+ "&sUrlRedirect=" + sUrlRedirect 
						)); 
		return;
	}


	
	
	if(sAction.equals("remove"))
	{
		int iIdMultimedia = Integer.parseInt(request.getParameter("iIdMultimedia"));
		Multimedia multi = Multimedia.getMultimedia(iIdMultimedia);
		if(multi.isPhysique()){
			String sCommonDocumentRoot = Configuration.getConfigurationValueMemory("multimedia.documentRoot");
			String sSelfDocumentRoot 
				= sCommonDocumentRoot
					+"/"+OrganisationParametre.getOrganisationParametreValue(
							multi.getIdReferenceObjet(),"organisation.multimedia.documentRoot");
			File fichier = new File(sSelfDocumentRoot+"/"+multi.getFileName());
			fichier.delete();
		}
		
		sUrlRedirect += "&iIdReferenceObjet=" + multi.getIdReferenceObjet()
				 + "&nonce=" +System.currentTimeMillis();
		
		MultimediaParameter mp = new MultimediaParameter();
		mp.remove("WHERE id_coin_multimedia=" + multi.getId());
		
		multi.remove();

		
		
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	
	
%>
</head>
<body>
<script type="text/javascript">
document.observe("dom:loaded", function() {
	closeModalAndRedirectTabActiveWithTime('<%= sUrlRedirect %>', 500);
});
</script>
</html>
