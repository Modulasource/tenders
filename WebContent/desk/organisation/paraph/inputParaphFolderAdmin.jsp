<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@page import="java.util.Vector"%>
<%@page import="mt.paraph.folder.ParaphFolder"%>
<%@page import="mt.paraph.sign.Paraph"%>
<%@page import="mt.paraph.sign.ParaphSignatureType"%>
<%@page import="mt.paraph.folder.ParaphFolderState"%>
<%@page import="mt.paraph.folder.ParaphFolderParameter"%>
<%@page import="mt.paraph.folder.ParaphFolderWorkflowNodeState"%>
<%@page import="mt.paraph.folder.util.ParaphFolderCancelLastSignature"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.ged.GedDocumentRevisionSeal"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotation"%>
<%@page import="org.coin.bean.ged.GedDocumentAnnotationType"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.journal.TypeEvenement"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.db.CoinDatabaseStoreException"%>
<%@page import="java.sql.Connection"%>
<%@page import="modula.journal.Evenement"%>
<%@page import="modula.journal.EvenementSeverite"%>
<%@ include file="include/localization.jspf" %>
</head>
<%	

	Connection conn = ConnectionManager.getConnection();	
	String sAction = request.getParameter("sAction");		

	long lId = Long.valueOf(request.getParameter("sIdParaphFolder")).longValue();
	String sMsgAlert = locMessage.getValue(3,"Successful process");
	Vector <String> vMessages = new Vector<String>();

	/** Action Close Dossier*/
	if (sAction.equals("updateState")) {
		ParaphFolder item = null;
		try {
			item = ParaphFolder.getParaphFolder(lId, false, conn);
			item.setIdParaphFolderState(ParaphFolderState.STATE_FINISHED);
			item.setDateEnd(new Timestamp(System.currentTimeMillis()));
			item.setDateCircuitEnd(new Timestamp(System.currentTimeMillis()));
		    item.store(conn);			
		} catch (Exception e) {	
			sMsgAlert = locMessage.getValue(5,"The process was not successful");
		}				
	}

	/** Action delete ParaphFolder*/
	if (sAction.equals("removeParaphFolder")) {
		ParaphFolder item = null;
		try {
			item = ParaphFolder.getParaphFolder(lId, false, conn);
			item.removeWithObjectAttached(conn);
		} catch (Exception e) {			
			sMsgAlert = locMessage.getValue(5,"The process was not successful");
		}

	}
	
	/** Action delete last Signature */	
	if (sAction.equals("removeLastParaph")) {
		
		ParaphFolder paraphFolder = ParaphFolder.getParaphFolder(lId, false, conn);
		ParaphFolderCancelLastSignature.removeLastParaph(
				paraphFolder, 
				sessionUser,
				locMessage,
				sMsgAlert,
				vMessages,
				conn);
	} //removeLastParaph
	
	ConnectionManager.closeConnection(conn);
%>

<script>
var sReportMessage = "<%=sMsgAlert%>" + "\n";
<% 
	for (String msg : vMessages) {
%>
	sReportMessage += "<%=msg%>" ;
	sReportMessage += "\n";
<%
	}
%>

alert("Report: \n " + sReportMessage);
closeModal();
</script>


<%@page import="mt.paraph.folder.ParaphFolderWorkflowNode"%>
<%@page import="mt.paraph.folder.ParaphFolderEntity"%>
<%@page import="org.coin.bean.ged.GedDocumentEntityType"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignatureType"%>
<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="mt.paraph.folder.util.ParaphFolderWorkflowCircuit"%></html>