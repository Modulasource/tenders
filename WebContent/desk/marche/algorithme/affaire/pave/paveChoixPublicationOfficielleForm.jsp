<%
    long lIdMarche = HttpUtil.parseLong("lIdMarche",request,0);
    String rootPath = request.getContextPath()+"/";
    
    Export exportBoamp = null;
    String sPublicationOfficielleSelectedTrue ="";
    String sPublicationOfficielleSelectedFalse =" checked='checked' ";
    
    exportBoamp =PublicationBoamp.getExportBoampFormMarche((int)lIdMarche);
    if (exportBoamp != null) {
        sPublicationOfficielleSelectedTrue =" checked='checked' ";
        sPublicationOfficielleSelectedFalse = "";
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
        Publications papiers :
        </td>
        <td class="pave_cellule_droite">

<%

    //if(sessionUserHabilitation.isSuperUser() )
    {
        Vector<Export> vExportsAFF = Export.getAllExportFromSource((int)lIdMarche,ObjectType.AFFAIRE);
        Vector<Organisation> vOrganisationsPublication = Organisation.getAllOrganisationPublication();
        String sChecked ="";
        int iIsPubliePapier = 0;
        
        long lDefaultPublication = Configuration.getLongValueMemory("modula.marche.publication.default.idorganisation",0);

        Vector<Multimedia> vMultimediaTotal 
          = Multimedia.getAllMultimedia(MultimediaType.TYPE_LOGO,
                  vOrganisationsPublication,
                  ObjectType.ORGANISATION);

        for(int i=0;i<vOrganisationsPublication.size();i++){            
            Organisation organisationPublicationTemp 
                = vOrganisationsPublication.get(i);
            
            if(lDefaultPublication == 0 
            || lDefaultPublication == organisationPublicationTemp.getId()){
                
            String sBlocGestionPublicationSelected = "";
            for(int j=0;j<vExportsAFF.size();j++){
                Export exportAFF = vExportsAFF.get(j); 
                if(exportAFF.getIdObjetReferenceDestination() == organisationPublicationTemp.getIdOrganisation())
                {
                    sBlocGestionPublicationSelected="checked=\"checked\"";
                }
            }
            if(vExportsAFF.isEmpty() 
            && lDefaultPublication == organisationPublicationTemp.getId() 
            && lIdMarche==0){
            	//par defaut on séléctionne la publication papier seule
                //si aucune publication existe et qu'on est en mode création
                //sinon si on coche aucune publication ca va mettre celle par défaut à l'affichage
                sBlocGestionPublicationSelected="checked=\"checked\"";
            }
            
            Vector<Multimedia> vMultimedias = 
                Multimedia.getAllMultimedia(
                        MultimediaType.TYPE_LOGO, 
                        organisationPublicationTemp.getIdOrganisation(), 
                        ObjectType.ORGANISATION,
                        vMultimediaTotal);
            
%>
            <div style="margin-top:3px">
            <input type="checkbox" name="organisationSelected" value="<%=
                organisationPublicationTemp.getIdOrganisation() %>" 
                <%= sBlocGestionPublicationSelected %> 
                class="organisationSelectedClass"  />
             <%=organisationPublicationTemp.getRaisonSociale() %>
             
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
                            +"&amp;sAction=view") %>" alt="Logo <%=organisationPublicationTemp.getRaisonSociale() %>" />
            </span>
            <% }  %>
            </div>
<%
            }
        }
  
    }
%>
        </td>
    </tr>
    <tr>
        <td class="pave_cellule_gauche" style="vertical-align:middle" >
        Publications nationales/internationales * :
        </td>
        <td class="pave_cellule_droite">
            <input 
                type="radio" 
                name="bPublicationOfficielle" 
                value="false" 
                <%= sPublicationOfficielleSelectedFalse %>
                class="organisationSelectedClass" /> Aucune publication nationale ou internationnale<br/>
            <input 
                type="radio" 
                name="bPublicationOfficielle" 
                value="true" 
                <%= sPublicationOfficielleSelectedTrue %>
                class="organisationSelectedClass" /> BOAMP et/ou JOUE
        </td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
</table>
<script>
Event.observe(window, 'load', function(){
    try{
        $$(".organisationSelectedClass").each(function(item){
            item.onclick = function(){
                switch(this.name){
                    case "bPublicationOfficielle":
                    if(this.value=="false") cacher('tablePublicationOfficielle');
                    else montrer('tablePublicationOfficielle');
                    break;
                }
            }
            if(item.checked) item.onclick();
        });
    } catch(e){}
});
</script>