<%

	OrganisationService service = (OrganisationService ) request.getAttribute("service");
	String rootPath = request.getContextPath() +"/";
	PersonnePhysique personne = (PersonnePhysique ) request.getAttribute("personne");
	Connection conn = (Connection ) request.getAttribute("conn");


	Vector<ParaphFolder> vParaphFolder 
		= ParaphFolder.getAllParaphFolderTemplate(
				ObjectType.ORGANISATION_SERVICE,
				service.getId());
	
	Vector<ParaphFolderType> vTypeAllowed
		= ParaphFolderHabilitation.getAllParaphFolderTypeHabilitate(personne, conn);

%>

<%@page import="java.util.Vector"%>
<%@page import="mt.paraph.folder.ParaphFolder"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="mt.paraph.folder.util.ParaphFolderHabilitation"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="java.sql.Connection"%>
<script type="text/javascript">
<%
	String sPrefix = "service_" + service.getId() ;
	String sFieldlIdParaphFolderType = sPrefix + "_lIdParaphFolderType" ;
%>
function createParaphFolderTemplateForOrganizationService(
		lIdService, 
		lIdParaphFolderType) 
{

    var sName = prompt("Veuillez saisir le nom du circuit");

	var sUrl  = "<%= 
		response.encodeURL(rootPath 
	        + "desk/paraph/folder/modifyParaphFolder.jsp"
	        + "?sAction=createTemplate"  
	        + "&lIdTypeObjectOwner=" + ObjectType.ORGANISATION_SERVICE 
	        )%>"
        + "&lIdReferenceObjectOwner=" + lIdService 
        + "&lIdParaphFolderType=" + lIdParaphFolderType
        + "&sName=" + sName;
        
	if(isNotNull(sName)) {
		//doUrl(sUrl );
		parent.addParentTabForced("...", sUrl);
	}
}
</script>
<div align="right" >
<select id="<%= sFieldlIdParaphFolderType  %>" >
<%
	for(ParaphFolderType type : vTypeAllowed)
	{
%>
<option value="<%= type.getId() %>" ><%= type.getName() %></option>
<%		
	}
%>
</select>
<button onclick="createParaphFolderTemplateForOrganizationService(<%= service.getId() 
	%>,$('<%= sFieldlIdParaphFolderType %>').value)">Ajouter</button>
</div>
<br />
<%
	if(vParaphFolder.size() > 0)
	{
%>

    <table class="dataGrid fullWidth">
        <tr class="header">
            <td width="40px" >Date de création</td>
            <td width="20%" >Type</td>
            <td width="50%" >Nom</td>
            <td width="20px">&nbsp;</td>
        </tr>

<%
	    for(ParaphFolder item : vParaphFolder)
	    {
	    	ParaphFolderType pfType = ParaphFolderType.getParaphFolderTypeMemory(item.getIdParaphFolderType());
%>
        <tr class="liste0">
            <td><%= CalendarUtil.getDateCourte( item.getDateCreation() ) %></td>
            <td><%= pfType.getName() %></td>
            <td><%= item.getName() %></td>
            <td>
                <img src="<%= 
                	rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                	onclick="parent.addParentTabForced('...','<%=
                			 response.encodeURL(
                					 rootPath +  "desk/paraph/folder/prepareParaphFolder.jsp"
                					 + "?lId=" + item.getId())%>')" 
                	style="cursor: pointer;" />
            </td>
        </tr>
<%    	
	    }
%>
	</table>
<%
	}
%>