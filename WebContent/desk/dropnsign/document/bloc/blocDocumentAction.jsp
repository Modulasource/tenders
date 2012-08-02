<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.ged.GedDocumentRevision"%>
<%@page import="org.coin.bean.addressbook.IndividualLinkDom"%>
<%@page import="org.coin.bean.ged.GedDocument"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.addressbook.IndividualLink"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	
	GedDocument doc = (GedDocument) request.getAttribute("doc");
	IndividualLinkDom domLink = (IndividualLinkDom) request.getAttribute("domLink");
	Vector<GedDocumentRevision> vDocumentRevision = (Vector<GedDocumentRevision>) request.getAttribute("vDocumentRevision");

	String sUrlDisplayDocument
		= response.encodeURL(
			GedDocumentRevision.getUrlDownloadLastRevision(
					doc,
					vDocumentRevision,
					rootPath)
					+ "&sContentDisposition=inline#navpanes=0")
					;
	
	
%>

<div id="divActionDocument_<%= doc.getId() %>" class="overlay_action" style="display: none;">
<span class="span_button" onclick="displayPopDocument('<%= sUrlDisplayDocument %>');">Afficher</span><br/>
<span class="span_button" onclick="signDocument(<%= doc.getId() %>)">Signer</span><br/>
<%
	if(doc.getDocumentName().endsWith(".doc")||doc.getDocumentName().endsWith(".docx")||doc.getDocumentName().endsWith(".xls")||doc.getDocumentName().endsWith(".xlsx"))
	{
%>
<span class="span_button" onclick="modifyDocument(<%= doc.getId() %>)">Modifier le Contenu</span><br/>
<%
	}
%>
<span class="span_button" onclick="Element.toggle('lIdIndividualDestination_<%= doc.getId() %>_span')">A faire signer</span> 
<span style="display: none;" id="lIdIndividualDestination_<%= doc.getId() %>_span" >
<select id="lIdIndividualDestination_<%= doc.getId() %>" >
<%	
	for(IndividualLink link : domLink.vItemAccepted)
	{
		long lIdLinked = 0;
		if(link.getIdIndividualDestination() == sessionUser.getIdIndividual())
		{
			lIdLinked = link.getIdIndividualSource();
		} else {
			lIdLinked = link.getIdIndividualDestination();
		}
		
		PersonnePhysique p = PersonnePhysique.getPersonnePhysique(lIdLinked);
%>
<option value="<%= p.getId() %>"><%= p.getPrenomNom() %></option>
<%
	}
%>
</select>
<button onclick="assignToSign(<%= doc.getId() %>)">Ok</button>
</span>
<br/>
<span class="span_button" onclick="Element.toggle('lIdAddRevision_<%= doc.getId() %>_span')">Ajouter une révision</span> 
<form action="<%= response.encodeURL(
			rootPath + "desk/dropnsign/document/uploadDocumentRevision.jsp"
		+ "?lIdGedDocument=" + doc.getId() ) %>" 
		method="post"
		enctype="multipart/form-data"  >
<span style="display: none;" id="lIdAddRevision_<%= doc.getId() %>_span" >
	<input type="file" name="fileDocument" />
	<button type="submit">Ok</button>
</span>
</form>


<span class="span_button"onclick="Element.toggle('lIdModify_<%=doc.getId() %>_span')" >Modifier</span>
<form action="<%= 
	response.encodeURL(
			rootPath + "desk/dropnsign/document/uploadModifiedDocument.jsp"
			+ "?lIdGedDocument=" + doc.getId())
			%>"
			method="post"
			enctype="multipart/form-data" 
		 >
<span style="display: none;" id="lIdModify_<%=doc.getId() %>_span" >
	<input type="file" name="fileDocument" />
	<button type="submit">Ok</button>
</span>
</form>









<span class="span_button"onclick="removeDocument(<%= doc.getId() %>);" >Supprimer</span><br/>
<%
	if(!doc.getDocumentName().endsWith(".pdf"))
	{
		
%>
<span class="span_button" onclick="convertPdfDocument(<%= doc.getId() %>);">Convertir en PDF</span><br/>
<%
	}
%>
</div>
