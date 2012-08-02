<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="java.util.Vector"%>
<%@page import="mt.paraph.folder.ParaphFolder"%>
<%@page import="org.coin.bean.ObjectType"%>
<%


	OrganisationService organisation = OrganisationService.getOrganisationService(HttpUtil.parseInt("lId", request));
	
	
	String sTitle = "";
	sTitle = " <span class='altColor'>Admin paraph : "+organisation.getName() 
	        + "</span>";

	        
	Vector<ParaphFolder> vParaphFolder = ParaphFolder.getAllParaphFolderTemplate(
			ObjectType.ORGANISATION,
			organisation.getId());
	
	        
%>
<script type="text/javascript">
var rootPath = "<%=rootPath%>";

window.onload = function(){

}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
    <div class="fullWidth">
<%
    Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
    
    
    vBarBoutons.add( 
            new BarBouton(5,
                "Retour ",
                response.encodeURL(rootPath 
                        + "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="
                                + organisation.getId()),
                rootPath+"images/icons/36x36/home.png", 
                "",
                "",
                "",
                "",
                true) );
    
    
    out.write( BarBouton.getAllButtonHtmlDesk(vBarBoutons));

%>
</div>
</div>
<script type="text/javascript">
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    menuBorder.render($('menuBorder'));
});

function addForm() {

    var sName = prompt("Veuillez saisir le nom du formulaire");

	var sUrl  = "<%= response.encodeURL(rootPath 
        + "desk/paraph/folder/modifyParaphFolder.jsp"
        + "?sAction=createTemplate"  
        + "&lIdTypeObjectOwner=" + ObjectType.ORGANISATION 
        + "&lIdReferenceObjectOwner=" + organisation.getId() 
        + "&lIdParaphFolderType=" + ParaphFolderType.TYPE_FORM
        + "&sName="  
        )%>" + sName;

	doUrl(sUrl );
}
</script>

<br />

<button onclick="addForm()">Ajouter un formulaire</button>

<br />
<div class="dataGridHolder fullWidth">
    <table class="dataGrid fullWidth">
        <tr class="header">
            <td width="40px" >Date</td>
            <td width="50%" >Nom</td>
            <td width="20px">&nbsp;</td>
        </tr>

<%
    for(ParaphFolder item : vParaphFolder)
    {
%>
        <tr>
            <td><%= item.getDateCreation() %></td>
            <td><%= item.getName() %></td>
            <td>
                <img src="<%= 
                	rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                	onclick="doUrl('<%=
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
</div>


<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="mt.paraph.folder.ParaphFolderType"%>
<%@page import="org.coin.fr.bean.OrganisationService"%></html>