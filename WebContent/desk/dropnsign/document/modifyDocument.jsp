<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.pki.certificate.signature.PkiCertificateSignature"%>
<%@page import="org.coin.bean.addressbook.IndividualActionType"%>
<%@page import="org.coin.bean.addressbook.IndividualActionState"%>
<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.ged.GedConstant"%>
<%@page import="org.coin.bean.ged.GedDocumentType"%>
<%@page import="org.coin.bean.ged.GedFolderUtil"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@include file="/include/new_style/headerJspUtf8.jspf" %>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	GedDocument item = null;
	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);

	if(sAction.equals("remove"))
	{
		item = GedDocument.getGedDocument(HttpUtil.parseLong("lId", request));
		item.setFromForm(request, "");
		item.removeWithObjectAttached();
	}
	
	if(sAction.equals("convertPdf"))
	{
		item = GedDocument.getGedDocument(HttpUtil.parseLong("lId", request));
		GedFolderUtil.convertGedDocumentInPdf(item, 0, conn);
	}

	if(sAction.equals("removeSignature"))
	{
		item = GedDocument.getGedDocument(HttpUtil.parseLong("lId", request));
		PkiCertificateSignature pkiCertificateSignature 
			= PkiCertificateSignature.getPkiCertificateSignature(
					HttpUtil.parseLong("lIdPkiCertificateSignature", request));
		pkiCertificateSignature.remove(conn);
	}

	if(sAction.equals("removeDocumentRevision"))
	{
		item = GedDocument.getGedDocument(HttpUtil.parseLong("lId", request));
		GedDocumentRevision rev
			= GedDocumentRevision.getGedDocumentRevision(
					HttpUtil.parseLong("lIdGedDocumentRevision", request));
		rev.remove(conn);
	}
	
	if(sAction.equals("assignToSign"))
	{
		item = GedDocument.getGedDocument(HttpUtil.parseLong("lId", request));
		long lIdIndividualDestination = HttpUtil.parseLong("lIdIndividualDestination", request);
		IndividualAction action = new IndividualAction();
		action.setIdIndividualSource(sessionUser.getIdIndividual());
		action.setIdIndividualDestination(lIdIndividualDestination);
		action.setIdIndividualActionState(IndividualActionState.STATE_ASSIGNED);
		action.setIdIndividualActionType(IndividualActionType.TYPE_SIGN);
		action.setIdActionObjectType(ObjectType.GED_DOCUMENT);
		action.setIdActionObjectReference(item.getId());
		action.create(conn);
	}
	ConnectionManager.closeConnection(conn);
	
	
	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath + "desk/dropnsign/document/displayFolder.jsp"
						+ "?lId=" + item.getIdGedFolder()
					)
			);
%>