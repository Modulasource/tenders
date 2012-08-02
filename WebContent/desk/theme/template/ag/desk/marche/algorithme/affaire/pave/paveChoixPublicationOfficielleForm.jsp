<%
    long lIdMarche = HttpUtil.parseLong("lIdMarche",request,0);

    String rootPath = request.getContextPath()+"/";
    String sPublicationOfficielleTableStyle =" style='display:none' ";
    boolean bExistPubOff = false;
	Export exportBoamp = PublicationBoamp.getExportBoampFormMarche((int)lIdMarche);
	if (exportBoamp != null) {
		bExistPubOff = true;
        sPublicationOfficielleTableStyle ="";
	}

%><%@page import="org.coin.fr.bean.export.PublicationBoamp"%>
<%@page import="org.coin.fr.bean.export.Export"%>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.bean.ObjectType"%><%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.util.HttpUtil"%>
<table class="pave" >
 	<tr> 
		<td class="pave_titre_gauche" colspan="2">
		Publications Officielles
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
        <td class="pave_cellule_gauche" style="vertical-align:middle" >
        &nbsp;
        </td>
        <td class="pave_cellule_droite">

<%

    //if(sessionUserHabilitation.isSuperUser() )
    {
        Vector<Export> vExportsAFF = Export.getAllExportFromSource((int)lIdMarche,ObjectType.AFFAIRE);
        long lDefaultPublication = Configuration.getLongValueMemory("modula.marche.publication.default.idorganisation",0);
        Organisation orgPub = Organisation.getOrganisation(lDefaultPublication);
        
        String sChecked ="";
        int iIsPubliePapier = 0;

        Vector<Multimedia> vMultimedias
          = Multimedia.getAllMultimedia(MultimediaType.TYPE_LOGO,
        		  (int)lDefaultPublication,
                  ObjectType.ORGANISATION);
        
        boolean bExistPubPapier = false;
        for(int j=0;j<vExportsAFF.size();j++){
            Export exportAFF = vExportsAFF.get(j); 
            if(exportAFF.getIdObjetReferenceDestination() == orgPub.getIdOrganisation())
            {
            	bExistPubPapier = true;
            }
        }
        if(!bExistPubOff && vExportsAFF.isEmpty() && lIdMarche == 0){
        	//par defaut on séléctionne la publication papier seule
        	//si aucune publication existe et qu'on est en mode création
        	//sinon si on coche aucune publication ca va mettre celle par défaut à l'affichage
        	bExistPubPapier = true;
        }
%>
        <div style="margin-top:3px">
        <input type="radio" 
               name="radioPub" 
               id="pubPapOnly"
        	<%= (bExistPubPapier && !bExistPubOff)?"checked=\"checked\"":"" %>
            class="organisationSelectedClass"  />
         <%=orgPub.getRaisonSociale() %>
         
         <% if(vMultimedias.size()>0) { %>
        <span class="post-picture">
                <img style="width:100px;vertical-align:middle"
                src="<%= response.encodeURL(
                        rootPath+ "publisher_portail/DownloadFilePublisher?" 
                        + DownloadFile.getSecureTransactionStringFullJspPage(
                                request, 
                                vMultimedias.firstElement().getIdMultimedia() , 
                                ObjectType.MULTIMEDIA,
                                false /* permet de ne pas recharger le logo à chaque fois */)
                        +"&amp;sContentType="+vMultimedias.firstElement().getContentType()
                        +"&amp;sAction=view") %>" alt="Logo <%=orgPub.getRaisonSociale() %>" />
        </span>
        <% }  %>
        </div>
        <div style="margin-top:4px">
            <input
                type="radio" 
                name="radioPub" 
                id="pubAll"
                <%= (bExistPubPapier && bExistPubOff)?"checked=\"checked\"":"" %>
                class="organisationSelectedClass" /> <%=orgPub.getRaisonSociale() %> + BOAMP et/ou JOUE
         </div>
         <div style="margin-top:4px">
            <input 
                type="radio" 
                name="radioPub" 
                id="pubOffOnly"
                <%= (!bExistPubPapier && bExistPubOff)?"checked=\"checked\"":"" %>
                class="organisationSelectedClass" /> BOAMP et/ou JOUE uniquement
        </div>
        <div style="margin-top:4px">
            <input 
                type="radio" 
                name="radioPub" 
                id="pubNone"
                <%= (!bExistPubPapier && !bExistPubOff)?"checked=\"checked\"":"" %>
                class="organisationSelectedClass" /> Aucune publication officielle
        </div>

        </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<input type="hidden" name="organisationSelected" id="organisationSelected" value="" />
<input type="hidden" name="bPublicationOfficielle" id="bPublicationOfficielle" value="" />
<script>
Event.observe(window, 'load', function(){
    try{
        $$(".organisationSelectedClass").each(function(item){
            item.onclick = function(){
                switch(this.id){
                    case "pubNone":
                    cacher('tablePublicationOfficielle');
                    $("organisationSelected").value = "";
                    $("bPublicationOfficielle").value = "false";
                    break;
                    case "pubOffOnly":
                    montrer('tablePublicationOfficielle');
                    $("organisationSelected").value = "";
                    $("bPublicationOfficielle").value = "true";
                    break;
                    case "pubAll":
                    montrer('tablePublicationOfficielle');
                    $("organisationSelected").value = "<%= orgPub.getIdOrganisation() %>";
                    $("bPublicationOfficielle").value = "true";
                    break;
                    case "pubPapOnly":
                    cacher('tablePublicationOfficielle');
                    $("organisationSelected").value = "<%= orgPub.getIdOrganisation() %>";
                    $("bPublicationOfficielle").value = "false";
                    break;
                }
            }
            if(item.checked) item.onclick();
        });
    } catch(e){}
});
</script>
<%
    }
%>