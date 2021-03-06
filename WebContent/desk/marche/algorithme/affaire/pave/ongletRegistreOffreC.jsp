<%@page import="java.util.Vector"%>
<%@page import="modula.marche.MarcheLot"%>
<%@page import="modula.candidature.*"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="modula.Validite"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="modula.marche.Marche"%>  
<%@page import="org.coin.util.HttpUtil"%>       
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
	
    boolean bIsEnvCAnonyme = marche.isEnveloppesCAnonyme(false);
    
    Vector<Long> vIdCandidatures = new Vector<Long>();
    
    for (int i = 0; i < vLots.size() ;i ++) 
    {
        MarcheLot lot = vLots.get(i);
        String sReference = "";
        if(vLots.size() == 1) sReference = "march� ref." + marche.getReference();
        else sReference = "lot ref." + lot.getReference();
        
        int iIdValidite = -1;
        int k = 0;
        Vector<EnveloppeC> vEnveloppeC = EnveloppeC.getAllEnveloppesCCacheteesFromLotOrderedByValiditeDate(lot.getIdMarcheLot());
        boolean bAfficheEnveloppe = false;
        
        for (int j = 0; j < vEnveloppeC.size() ;j ++)
        {
            EnveloppeC oEnveloppeC = vEnveloppeC.get(j);
            Candidature candidature = Candidature.getCandidature(oEnveloppeC.getIdCandidature());
            boolean bIsPapier = candidature.isCandidaturePapier(false);
            
            Vector<EnveloppeCPieceJointe> vEnvCPJ = EnveloppeCPieceJointe.getAllEnveloppeCPiecesJointesFromEnveloppe((int)oEnveloppeC.getId());
            if( (vEnvCPJ != null && vEnvCPJ.size()>0) || bIsPapier)
            {
                bAfficheEnveloppe = true;
                
                k = k%2;
                if(iIdValidite != oEnveloppeC.getIdValidite())
                {
                    k = 0;
                    if(iIdValidite != -1)
                    {
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
                    iIdValidite = oEnveloppeC.getIdValidite();
                    int iRowVal = Validite.getValiditeRowFromAffaire(iIdValidite,lot.getIdMarche());
                    String sNego = "";
                    if(iRowVal > 0) sNego = " ("+Outils.sConverionEntierLiterralFeminin[iRowVal-1]+" n�gociation)"; 
%>

<table class="pave" summary="none">
    <tr>
        <td class="pave_titre_gauche" colspan="2">Registre des offres de prestation du <%= sReference + sNego %></td> 
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
                }
                String sDateCachetageOffre = "Offre non cachet�e";
        
                if ( oEnveloppeC.isCachetee(false) )
                {
                    sDateCachetageOffre = CalendarUtil.getDateFormattee(oEnveloppeC.getDateFermeture());
                }
            
                String sFormat = "�lectronique";
                if ( bIsPapier )
                {
                    sFormat = "papier";
                }
                
                boolean bHorsDelai = oEnveloppeC.isHorsDelais(false);
                
                String sStatut = oEnveloppeC.getStatutLibelleValueCourant();
                if(!marche.isEnveloppesCDecachetees(false))
                    sStatut = "Ind�fini";
            
                String sUrlTarget = rootPath+"desk/organisation/afficherCandidature.jsp?iIdPersonnePhysique=" + candidature.getIdPersonnePhysique()
                        +"&amp;iIdMarche="+marche.getIdMarche();
                Organisation organisationCDT = Organisation.getOrganisation(candidature.getIdOrganisation());
                String sNomCandidature = organisationCDT.getRaisonSociale();
                if(bIsEnvCAnonyme)
                {
                    sNomCandidature = "Candidature ORG"+organisationCDT.getId();
                    sUrlTarget += "&amp;bAnonyme=true";
                }
            
                %>
                <tr class="liste<%=k%>" onmouseover="className='liste_over'" 
                    onmouseout="className='liste<%=k%>'" 
                    onclick="Redirect('<%= response.encodeURL(sUrlTarget)  %>')"
                     >
                    <td style="width:40%"><%= sNomCandidature %></td>
                    <td style="width:15%"><%= sFormat %></td>
                    <td style="width:35%"><%= sDateCachetageOffre %></td>
                    <td style="width:10%"><%= sStatut.equalsIgnoreCase("")?"Ind�fini":sStatut %></td>
                    <td style="width:10%;text-align:right">
                    <%=(bHorsDelai)?"<img src='"+sIconeHorsDelai+"' alt='Hors d�lai' title='Hors d�lai'/> ":"" %>
                        <a href="<%= response.encodeURL(sUrlTarget) %>">
                                <img src="<%=sIconeFichierDefault %>"  alt="Afficher" title="Afficher"/>
                        </a>
                    </td>
                </tr>
                <%  
                
                
                
                for(int iEnvCPJ=0;iEnvCPJ<vEnvCPJ.size();iEnvCPJ++)
                {
                    EnveloppeCPieceJointe envCPJ = (EnveloppeCPieceJointe)vEnvCPJ.get(iEnvCPJ);
                    if(envCPJ.getChiffrage() == 0)
                    {
                        /**
                         * La pi�ces n'est plus chiffr�e, elle peut etre affich�e � l'AP. Et aussi t�l�chargeable.
                         */
                        String sURLCPJ = "desk/DownloadFileDesk?"
                                + DownloadFile.getSecureTransactionStringFullJspPage(
                                        request, 
                                        envCPJ.getIdEnveloppePieceJointe(), 
                                        TypeObjetModula.ENVELOPPE_C );

                                
                        sURLCPJ = response.encodeURL(rootPath+ sURLCPJ);
                        %>
                        <tr class="liste<%=j%2%>" onmouseover="className='liste_over'" 
                            onmouseout="className='liste<%=j%2%>'" 
                             >
                            <td style="width:40%"></td>
                            <td style="width:15%;text-align: right">Pi�ce jointe</td>
                            <td style="width:35%"><%= envCPJ.getNomPieceJointe() %> (<%= envCPJ.getFileSizeInMegaBytes() %>)</td>
                            <td style="width:10%">Statut : <%= envCPJ.getFileStateName() %></td>
                            <td style="width:10%;text-align:right">
                                <a href="<%= response.encodeURL(sURLCPJ) %>">
                                <img src="<%=sIconeDownload %>" alt="Afficher" title="Afficher"/>
                                </a>
                            </td>
                        </tr>                   
                        <%
                    }
                }
                
            }
            k++;
        }
        if(vEnveloppeC.size()==0 || !bAfficheEnveloppe)
        {
%>
    <table class="pave" summary="none">
        <tr>
            <td class="pave_titre_gauche" colspan="2">Registre des offres de prestation du <%= sReference %></td> 
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

