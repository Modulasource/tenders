<%
	int iIdMarche = Integer.parseInt(request.getParameter("iIdMarche"));
	Marche marche = Marche.getMarche(iIdMarche);

	String rootPath = request.getContextPath()+"/";
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarcheAndPA(marche);
	
	boolean bDisplayPdf = false;
    try {
        bDisplayPdf = Boolean.parseBoolean(request.getParameter("bDisplayPdf"));
    } catch (Exception e) {}
    
    String sIconeDownload = rootPath+Icone.ICONE_DOWNLOAD;
    String sIconeFichierDefault = rootPath+Icone.ICONE_FICHIER_DEFAULT;
    String sIconeHorsDelai = rootPath+"images/icones/hors_delai.gif";
    if(bDisplayPdf) {
        sIconeDownload = HttpUtil.getUrlWithProtocolAndPort(sIconeDownload, request).toExternalForm();
        sIconeFichierDefault = HttpUtil.getUrlWithProtocolAndPort(sIconeFichierDefault, request).toExternalForm();
        sIconeHorsDelai = HttpUtil.getUrlWithProtocolAndPort(sIconeHorsDelai, request).toExternalForm();
    }
	
    boolean bIsDialogue = false;
    boolean bIsAllLotsFigesForDialogue = false; 
    if(AffaireProcedure.isDialogueComplete(marche.getIdAlgoAffaireProcedure()))
    {
        bIsDialogue = true;
        bIsAllLotsFigesForDialogue = MarcheLot.isAllLotsFromMarcheFigesForDialogue(marche.getIdMarche());
    }
    
    boolean bIsEnvAAnonyme = marche.isEnveloppesAAnonyme(false);
    
    for (int i = 0; i < vLots.size() ;i ++)
    {
        MarcheLot lot = vLots.get(i);
        String sReference = "";
        if(vLots.size() == 1) sReference = "march� ref." + marche.getReference();
        else sReference = "lot ref." + lot.getReference();
%>
<%@page import="modula.marche.MarcheLot"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.Validite"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="modula.candidature.EnveloppeALot"%>
<%@page import="modula.candidature.EnveloppeA"%>
<%@page import="modula.candidature.Candidature"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.candidature.EnveloppeAPieceJointe"%>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="org.coin.util.CalendarUtil"%>

<%@page import="modula.algorithme.AffaireProcedure"%>

<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.util.HttpUtil"%>
<table class="pave" >
    <tr>
        <td class="pave_titre_gauche" colspan="2">Registre des candidatures du <%= sReference %></td> 
    </tr>
    <tr>
        <td colspan="2">
            <table class="liste" summary="none">
                <tr>
                    <th>Raison sociale</th>
                    <th>Format</th>
                    <th>Date du cachetage</th>
                    <th>Statut</th>
                    <th>&nbsp;</th>
                </tr>
<%
    Vector<Validite> vValiditeEnveloppeA = Validite.getAllValiditeEnveloppeAFromAffaire(marche.getIdMarche());
    Validite oValiditeEnveloppeA = null;
    Timestamp tsDateValiditeEnveloppeAFin = null;
    if(vValiditeEnveloppeA != null)
    {
        if(vValiditeEnveloppeA.size() == 1)
        {
            oValiditeEnveloppeA = vValiditeEnveloppeA.firstElement();
            tsDateValiditeEnveloppeAFin = oValiditeEnveloppeA.getDateFin();
        }
    }
    Vector<EnveloppeALot> vEnveloppeALot 
        = EnveloppeALot.getAllEnveloppeALotCacheteesFromLotOrderedByDate(lot.getIdMarcheLot());

    Vector<EnveloppeALot> vEnveloppeALotAll
        = EnveloppeALot.getAllEnveloppeALotFromLot(lot.getIdMarcheLot());

    for (int j = 0; j < vEnveloppeALotAll.size() ;j ++)
    {
        EnveloppeALot oEnveloppeALot = vEnveloppeALotAll.get(j);
        EnveloppeA oEnveloppeA = EnveloppeA.getEnveloppeA(oEnveloppeALot.getIdEnveloppeA());
        Candidature oCandidature = Candidature.getCandidature(oEnveloppeA.getIdCandidature());
            
        boolean bDisplayEnveloppe = false;
        for (int k = 0; k < vEnveloppeALot.size() ;k ++)
        {
            EnveloppeALot oEnveloppeALotTemp = vEnveloppeALot.get(k);
            if(oEnveloppeALotTemp.getId() == oEnveloppeALotTemp.getId())
            {
                /**
                 * L'enveloppe peut etre affich�e car elle appartient � l'ensemble
                 * getAllEnveloppeALotCacheteesFromLotOrderedByDate()
                 */
                bDisplayEnveloppe = true;
                break;
            } 
        }   
        if(!bDisplayEnveloppe)
        {
            /**
             * Il faut toujours afficher les candidatures papiers
             */
            if(!oCandidature.isCandidaturePapier(false))
                continue;   
        }
        
        
        String sDateCachetageCandidature = "Candidature non cachet�e";
        
        String sStatut = "Ind�fini";
        if(oEnveloppeALot != null)
        {
            try{sStatut = oEnveloppeALot.getStatutLibelleValue(EnveloppeALot.ID_STATUS_RECEVABLE);}
            catch(Exception e){sStatut = "Ind�fini";}
            
            boolean bIsRecevable = oEnveloppeALot.isRecevable(false);
            
            if(bIsRecevable && bIsDialogue && bIsAllLotsFigesForDialogue)
            {
                try{sStatut = oEnveloppeALot.getStatutLibelleValue(EnveloppeALot.ID_STATUS_ADMIS_DIALOGUE);}
                catch(Exception e){}
            }
        }
        
        if(oEnveloppeA != null)
        {
            if ( oEnveloppeA.isCachetee(false) )
            {
                sDateCachetageCandidature = CalendarUtil.getDateFormattee(oEnveloppeA.getDateFermeture());
            }
    }

        String sFormat = "�lectronique";
        if ( oCandidature.isCandidaturePapier(false) )
        {
            sFormat = "papier";
        }
    
        if(oEnveloppeA != null)
        {
            boolean bHorsDelai = oEnveloppeA.isHorsDelais(false);
            
            String sUrlTarget = rootPath+"desk/organisation/afficherCandidature.jsp?iIdPersonnePhysique=" + oCandidature.getIdPersonnePhysique()
                    +"&amp;iIdMarche="+marche.getIdMarche();
            Organisation organisationCDT = Organisation.getOrganisation(oCandidature.getIdOrganisation());
            String sNomCandidature = organisationCDT.getRaisonSociale();
            if(bIsEnvAAnonyme)
            {
                sNomCandidature = "Candidature ORG"+organisationCDT.getId();
                sUrlTarget += "&amp;bAnonyme=true" ;
            }
            

            
%>
                <tr class="liste<%=j%2%>" onmouseover="className='liste_over'" 
                    onmouseout="className='liste<%=j%2%>'" 
                    onclick="Redirect('<%= response.encodeURL(sUrlTarget) %>')"
                     >
                    <td style="width:40%"><strong><%= sNomCandidature + " (" + oCandidature.getId()  + ")" %></strong></td>
                    <td style="width:15%"><strong><%= sFormat %></strong></td>
                    <td style="width:35%"><strong><%= sDateCachetageCandidature %></strong></td>
                    <td style="width:10%"><strong><%= sStatut.equalsIgnoreCase("")?"Ind�fini":sStatut %></strong></td>
                    <td style="width:10%;text-align:right">
                    <%=(bHorsDelai)?"<img src='"+sIconeHorsDelai+"' alt='Hors d�lai' title='Hors d�lai'/> ":"" %>
                        <a href="<%= response.encodeURL(sUrlTarget) %>">
                        <img src="<%=sIconeFichierDefault %>" alt="Afficher" title="Afficher"/>
                        </a>
                    </td>
                </tr>                   
<%
            String sEnveloppeAPJRow ="";
            /** 
             * attention en mode triche il est possible qu'aucune PJ s'affichent 
             * car elles seront consid�r�es comme anti-dat�es.
             */
            Vector vEnveloppeAPJ = EnveloppeAPieceJointe.getAllEnveloppeAPiecesJointesBeforeMarcheDateClotureFromEnveloppe(oEnveloppeA.getIdEnveloppe());
            for(int iEnvAPJ=0;iEnvAPJ<vEnveloppeAPJ.size();iEnvAPJ++)
            {
                EnveloppeAPieceJointe envAPJ = (EnveloppeAPieceJointe)vEnveloppeAPJ.get(iEnvAPJ);
                if(envAPJ.getChiffrage() == 0)
                {
                    /**
                     * La pi�ces n'est plus chiffr�e, elle peut etre affich�e � l'AP. Et aussi t�l�chargeable.
                     */
                    String sURLAPJ = "desk/DownloadFileDesk?"
                            + DownloadFile.getSecureTransactionStringFullJspPage(
                                    request,
                                    envAPJ.getIdEnveloppePieceJointe() , 
                                    TypeObjetModula.ENVELOPPE_A);
                            
                    sURLAPJ = response.encodeURL(rootPath+ sURLAPJ);
                    
                    %>
                    <tr class="liste<%=j%2%>" onmouseover="className='liste_over'" 
                        onmouseout="className='liste<%=j%2%>'" 
                         >
                        <td style="width:40%"></td>
                        <td style="width:15%">Pi�ce jointe</td>
                        <td style="width:35%"><%= envAPJ.getNomPieceJointe() %> (<%= envAPJ.getFileSizeInMegaBytes() %>)</td>
                        <td style="width:10%">Statut : <%= envAPJ.getFileStateName() %></td>
                        <td style="width:10%;text-align:right">
                            <a href="<%= response.encodeURL(sURLAPJ) %>">
                            <img src="<%=sIconeDownload %>" alt="Afficher" title="Afficher"/>
                            </a>
                        </td>
                    </tr>                   
                    <%
                }
            }


        }
    }
%>
                
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2">&nbsp;</td> 
    </tr>
</table>
<br/>
<%
}
%>