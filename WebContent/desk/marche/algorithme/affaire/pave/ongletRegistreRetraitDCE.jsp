<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.util.HttpUtil"%>
<%
	int iIdMarche = Integer.parseInt(request.getParameter("iIdMarche"));
	Marche marche = Marche.getMarche(iIdMarche);
	
	String rootPath = request.getContextPath()+"/";
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarcheAndPA(marche);
	
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	
	boolean bDisplayPdf = false;
	try {
		bDisplayPdf = Boolean.parseBoolean(request.getParameter("bDisplayPdf"));
	} catch (Exception e) {}
	
	String sIconeFichierDefaultNewStyle = rootPath+Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE;
	if(bDisplayPdf) {
		sIconeFichierDefaultNewStyle = HttpUtil.getUrlWithProtocolAndPort(rootPath+Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE, request).toExternalForm();
	}

    if(Configuration.isTrue("allow.dce.download.outside.connection", true)) {
%>
<table class="pave" colspan="2">
    <tr>
        <td class="pave_titre_gauche" >Registre des retraits du DCE anonymes</td> 
    </tr>
    <tr>
        <td>
            Nombre de téléchargements anonymes : <%= marche.getCountAnonymDCEDl() %>
        </td> 
    </tr>
</table>
<br/>
<%
    }

    CandidatureDCE candidatureDCE = new CandidatureDCE(marche, vLots);
    candidatureDCE.prepare();

    for(int k=0; k < candidatureDCE.vDCE.size();k++)
    {
        Vector<Object> vDCELot = candidatureDCE.vDCE.get(k);
        String sTitrePaveDCE = (String)vDCELot.get(0);
%>

<%@page import="java.util.Vector"%>
<%@page import="modula.candidature.Candidature"%>
<%@page import="modula.marche.MarcheLot"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.fr.bean.Organisation"%>

<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="mt.modula.affaire.candidature.CandidatureDCE"%>

<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<table class="pave" >
    <tr>
        <td class="pave_titre_gauche" colspan="2"><%= sTitrePaveDCE %></td> 
    </tr>
    <tr>
        <td colspan="2">
            <table class="liste" >
                <tr>
                    <th>Raison sociale</th>
                    <th>Format</th>
                    <th>Date du retrait</th>
                    <th>Statut</th>
                    <th>&nbsp;</th>
                </tr>
<%



        for (int l = 1; l < vDCELot.size() ;l ++)
        {
            Candidature candidature = (Candidature)vDCELot.get(l);
            Organisation candidat = Organisation.getOrganisation(candidature.getIdOrganisation());
            PersonnePhysique candidatPP = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());
            
            String sDateRetraitDCE = "Pas encore retiré";
            String sStatut = "";
            try
            {
                sStatut = candidature.getStatutLibelleValue(Candidature.ID_STATUS_VALIDE);
            }
            catch(Exception e){}
            if ( candidature.isDCERetire(false) )
            {
                sDateRetraitDCE = CalendarUtil.getDateFormattee(candidature.getDateRetraitDCE());
            }
            
            String sFormat = "électronique";
            try {
                if ( candidature.isDCEPapier(false) )
                {
                    sFormat = "papier";
                }
            } catch (Exception e) {sFormat = "Indéfini";}
            
            String sUrlTarget = response.encodeURL(
                rootPath+"desk/organisation/afficherCandidature.jsp?iIdPersonnePhysique=" 
                        + candidature.getIdPersonnePhysique() 
                         +"&iIdMarche="+marche.getIdMarche());
            
            if(iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_PETITE_ANNONCE){
                  sUrlTarget = response.encodeURL(
                          rootPath+"desk/organisation/afficherOrganisation.jsp?iIdOrganisation=" 
                                  + candidature.getIdOrganisation());
            }
    
%>
                <tr class="liste<%=l%2%>" onmouseover="className='liste_over'" 
                    onmouseout="className='liste<%=l%2%>'" 
                    onclick="parent.addParentTabForced('chargement ...','<%= sUrlTarget %>')"
                    style="cursor: pointer;"
                     >
                    <td style="width:40%"><%=
                        candidat.getRaisonSociale() + " - " + candidatPP.getEmail() %></td>
                    <td style="width:15%"><%= sFormat %></td>
                    <td style="width:35%"><%= sDateRetraitDCE %></td>
                    <td style="width:10%"><%= sStatut %></td>
                    <td style="width:10%;text-align:right">
                        <img src="<%=sIconeFichierDefaultNewStyle%>" alt="Afficher" title="Afficher"
                         />
                    </td>
                </tr>                   
<%
        }
%>
                
            </table>
        </td>
    </tr>  
    <tr>
        <td colspan="5">&nbsp;</td> 
    </tr>
</table>
<br/>
<%
    }
%>

