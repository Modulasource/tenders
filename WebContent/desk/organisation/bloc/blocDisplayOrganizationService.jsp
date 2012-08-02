<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.sql.Connection"%>
<%@page import="modula.graphic.Onglet"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);

	
	Vector<Organigram> vOrganisationOrganigramInterService
			= Organigram.getAllFromObject(
				ObjectType.ORGANISATION,
				organisation.getId(),
				ObjectType.ORGANISATION_SERVICE);

	

%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<div class="right">
<%	
	if( vOrganisationOrganigramInterService.size() == 0)
	{
%>
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/organigramme/modifyOrganisationOrganigram.jsp?sAction=create"
		+ "&iIdOrganisation=" + organisation.getIdOrganisation()
		+ "&lIdTypeObject=" + ObjectType.ORGANISATION
		+ "&lIdTypeObjectNode=" + ObjectType.ORGANISATION_SERVICE
		+ "&iIdOnglet=" + iIdOnglet ) %>')"
		>Ajouter l'organigramme</button>
<%
	}
	else
	{
		Organigram organigram = (Organigram )vOrganisationOrganigramInterService.firstElement();
%>
	<div class="right">
	<button
		type="button"
		onclick="javascript:Redirect('<%= response.encodeURL(
		rootPath + "desk/organisation/groupe/modifyOrganisationServiceForm.jsp?sAction=create"
		+ "&iIdOrganisation=" + organisation.getIdOrganisation()
		+ "&lIdOrganigramInterService=" + organigram.getId()
		) %>')"
		>Ajouter un service</button>
	</div>
	<br />

 <%
		if(!HttpUtil.parseBoolean("bDisplayOrganigramNode", request, false))
		{
%>
    <button
        type="button"
        onclick="javascript:Redirect('<%= response.encodeURL(
        rootPath + "desk/organisation/afficherOrganisation.jsp?"
        + "&iIdOrganisation=" + organisation.getIdOrganisation()
        + "&iIdOnglet=" + Onglet.ONGLET_ORGANISATION_SERVICE 
        + "&bDisplayOrganigramNode=true"
        ) %>')"
        >Afficher les postes</button>
<%
		} else {
%>			
<script type="text/javascript">
function toggleAllUserInfo()
{

    $$(".person_information").each(
    	    function(item, index) 
    	    {
        		Element.toggle(item);
    		}
   	);
}
</script>

	<input type="checkbox" onclick="toggleAllUserInfo();" /> Afficher infos complémentaires

<%		
		}


		
		request.setAttribute("organigram",organigram);

%>

	</div>
<br />
<br/>
<br/>

<div class="dataGridHolder">
	<table class="dataGrid fullWidth">
		<tr>
			<td> Les services : </td>
		</tr>
		<tr>
			<td>
<jsp:include page="../pave/blocOrganisationService.jsp" />		
			</td>
		</tr>
	</table>
</div>
<%
	}
%>