<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.marche.MarchePassation"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="mt.modula.affaire.candidature.CandidatureDCE"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.marche.MarcheLot"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	Organisation organisation = (Organisation)request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton)request.getAttribute("localizeButton");
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	String rootPath = request.getContextPath() +"/";

	Vector<Marche> vMarches 
	  = Marche.getAllMarchePetiteAnnonceFromIdOrganisation(
	  		organisation.getIdOrganisation(), 
	  		" ORDER BY mar.reference ");

	if(sAction.equalsIgnoreCase("recap_attr")){
		Vector<Marche> vAvisRecap = new Vector<Marche>();
		for(Marche marche : vMarches)
		{
		    if(marche.isRecapAATR(false))
		    {
		    	vAvisRecap.add(marche);
		    }
		}
		vMarches = vAvisRecap;
	}

%>
<script type="text/javascript">
<!--
function confirmAndDoUrl(sConfirmMessage, url){
    if(!confirm(sConfirmMessage))
        return false;
    
    doUrl(url);
}

//-->
</script>    
<div>
    <table class="pave" >
        <tr>
            <td>
                <table class="liste" >
                    <tr>
                        <th>Date</th>
                        <th>Réference</th>
                        <th>Objet</th>
                        <th>Mode passation</th>
                        <th>Nombre de téléchargements du DCE</th>
                        <th>Pièce jointe</th>
                        <th>&nbsp;</th>
                    </tr>
    <%
            for(int i=0; i < vMarches.size(); i++)
            {
                int j = i % 2;
                Marche marche = vMarches.get(i);
                String sPassation = "";
                String sGlobalPassation = "";
                try
                {
                	/*
                    int iIdMarchePassation 
	                    = AffaireProcedure.getAffaireProcedureMemory(
	                            marche.getIdAlgoAffaireProcedure())
	                            .getIdMarchePassation();

                    MarchePassation mp = MarchePassation.getMarchePassationMemory(iIdMarchePassation);
                    sGlobalPassation = mp.getLibelleGlobal();
                    sPassation = mp.getLibelle();
                    */
                    sPassation = MarchePassation.getMarchePassationNameMemory(marche.getPetiteAnnoncePassation());
                    
                }
                catch(Exception e){
                	sPassation = e.getMessage();
                	//e.printStackTrace();
                }
            %>
        <tr class="liste<%=j%>">
            <td><%= CalendarUtil.getDateFormattee(marche.getDateModification())   %></td>
            <td><%= marche.getReference()  %></td>
            <td><%=
            	Outils.linkify( 
                        Outils.getTextToHtml( 
                                Outils.getStringNotNullNeant( 
                                        marche.getObjet())),
                        " target='_blank'") 
                %> </td>
            <td><%= sPassation %></td>
            <td style="text-align: center;">
<%

			if(marche.isAAPCPieceJoine())
			{
				Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarcheAndPA(marche);
				CandidatureDCE candidatureDCE = new CandidatureDCE(marche, vLots);
				candidatureDCE.prepare();
				candidatureDCE.computeCandidatureWithDceDownloaded();
				
%>
            <%= candidatureDCE.lDceDownloadedCount  %>
<%
			}
%>
            </td>
            <td>
<%
			
				if(marche.isAAPCPieceJoine())
				{
%>          
            
            <img src="<%= rootPath + Icone.ICONE_PIECE_JOINTE %>" 
                   style="vertical-align:middle;cursor: pointer;" 
                   alt="Pièce Jointe"
                   title="<%= Outils.getString(marche.getNomAAPC(),"Pas de pièce jointe") %>"
                   onclick="javascript:doUrl('<%= 
                    	response.encodeURL(
	                        rootPath+ "publisher_portail/DownloadFilePublisher?" 
	                        + DownloadFile.getSecureTransactionStringFullJspPage(
                                request, 
                                marche.getIdMarche()  , 
                                TypeObjetModula.AAPC )) %>');"
                />
<%
				}
%>                
            </td>
            <td style="text-align:right;width:5%">
                <img src="<%=rootPath+Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
						style="vertical-align:middle;cursor: pointer;" 
                        alt="Afficher l'annonce" 
                        title="Afficher l'annonce"
                        onclick="javascript:doUrl('<%= response.encodeURL(
                            rootPath + "desk/marche/petitesAnnonces/afficherPetiteAnnonce.jsp?iIdAffaire="
                            + marche.getIdMarche()) %>')"
                    />



                <img src="<%=rootPath + "images/icons/book.gif" %>" 
                        style="vertical-align:middle;cursor: pointer;" 
                        alt="Afficher le registre" 
                        title="Afficher le registre"
                        onclick="javascript:doUrl('<%=
                        	response.encodeURL(
                        			rootPath + 
                        			"desk/marche/algorithme/affaire/afficherRegistre.jsp?sAction=create&iIdAffaire=" 
                        			+ marche.getIdMarche())
                             %>')"
                    />
                    
                    
                    
<%
	if(sessionUserHabilitation.isSuperUser())
	{

%>                    
                <img src="<%=rootPath+Icone.ICONE_SUPPRIMER_NEW_STYLE %>" 
                        style="vertical-align:middle;cursor: pointer;" 
                        alt="Supprimer" 
                        title="Supprimer"
                        onclick="javascript:confirmAndDoUrl('Supprimer cet avis ?', '<%= response.encodeURL(
                            rootPath + "desk/marche/petitesAnnonces/modifierPetiteAnnonce.jsp"
                                    + "?sPageRedirect=prepareAvisRecapitulatif"
                            		+ "&sAction=remove"
                                    + "&iIdAffaire=" + marche.getIdMarche()) 
                            %>')"
                    />
<%
	}
%>
            </td>
        </tr>   
            <%
            }
    %>
                </table>
            </td>
        </tr>
    </table>
    </div>