
<%@ page import="org.coin.fr.bean.export.*,modula.fqr.*,java.sql.*,org.coin.fr.bean.*" %>
<%@ page import="org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*" %>
<%@ page import="modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
    Marche marche = Marche.getMarche(iIdAffaire);

    String rootPath = request.getContextPath()+"/";
    String sDirectives = "";
    String sCancelUrl = "";
    Validite validite = null;
    String sPageUseCaseId = "";
    
    String sActionRectificatif = request.getParameter("sActionRectificatif");
    
    int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
    
    int iIdAvisRectificatif = Integer.parseInt(request.getParameter("iIdAvisRectificatif") );
    AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
    int iTypeAvisRectificatif = avis.getIdAvisRectificatifType();
    
    boolean bFormJOUE = HttpUtil.parseBoolean("bFormJOUE", request, false);
    boolean bCreationArec = HttpUtil.parseBoolean("bCreationArec", request, false);
    
    String sAlertFormIncompleted = "";
    boolean bRectifFormJoueCompleted = HttpUtil.parseBoolean("bRectifFormJoueCompleted", request, true);
    if(!bRectifFormJoueCompleted)
    	sAlertFormIncompleted = "Attention, certains champs du formulaire 'Renseignements complémentaires' n'ayant pas été renseignés, ils n'ont pu être sauvegardés.";
    
    String sRedirect = "afficherAffaire";
    if(marche.isAffaireAATR(false))
        sRedirect = "afficherAttribution";
    
    String sTypeAvis = "AAPC";
    if(avis.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
        sTypeAvis = "AATR";
    
    if(sActionRectificatif.equals("store"))
    {
        validite = Validite.getValidite(TypeObjetModula.AVIS_RECTIFICATIF, avis.getIdAvisRectificatif());
        sPageUseCaseId = "IHM-DESK-AFF-RECT-3";
    }
    
    sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
    

    {
        sDirectives 
            = "Les modifications ne doivent pas atteindre l'objet même du marché et ne doivent pas être discriminatoires.<br/>"
            + "Attention, pour publier un avis rectificatif, il convient de respecter un certain ordre : <br /><br/>"
            + "1/ Déterminer les points de l'"+sTypeAvis+" à modifier ; <br/>"
            + "2.a/ Noter les modifications dans le champ texte ci-dessous OU<br />"
            + "2.b/ Insérer un document constitutif de l'Avis rectificatif à l'aide du bouton parcourir ;<br />"
            + "3/ Cliquer sur le bouton \"Enregistrer\".<br />Vous pourrez ensuite : valider l'avis, modifier les onglets pour que les modifications soient prises en compte dans le système puis prévenir les candidats et les publications.";
    }
    
    

    boolean bIsForm14Selected = false;
    try {
		Vector<MarcheJoueFormulaire> vJoueForm = MarcheJoueFormulaire.getAllFromIdMarche(iIdAffaire);
		if(vJoueForm != null && vJoueForm.size()>0) {
		    for(MarcheJoueFormulaire joueForm : vJoueForm) {
		        if(joueForm.getIdJoueFormulaire() == 14) {
		            bIsForm14Selected = true;
		        }
		    }
		}
    } catch(Exception e) {}
%>

<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<form name="formulaire" action="<%= 
    response.encodeURL(rootPath 
        + "desk/marche/algorithme/avis_rectificatif/modifierAvisRectificatif.jsp?iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
        + "&amp;iIdAffaire=" + iIdAffaire
        + "&amp;sActionRectificatif="+sActionRectificatif
        + "&amp;iTypeAvisRectificatif="+iTypeAvisRectificatif
        + "&amp;bFormJOUE="+bFormJOUE
        + "&amp;iIdOnglet=" + iIdOnglet
        + "&amp;none="+System.currentTimeMillis()) 
    %>" method="post" onSubmit="return checkForm();" >
<div class="mention">
<%= sDirectives %>
</div>
<br/>
<div class="rouge">
<%= sAlertFormIncompleted %>
</div>
<br />
<%
if(bFormJOUE) {
%>
<%@ include file="pave/paveAvisResume.jspf" %>
<br/>
<%	
} else {
%>
<%@ include file="pave/paveAvisResumeForm.jspf" %>
<br/>
<%
}
%>
<%
boolean bExistPublicationBOAMP = false;
try
{
    int iTypePublication = PublicationType.TYPE_AAPC;
    if(avis.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
        iTypePublication = PublicationType.TYPE_AATR;
    
    Vector<PublicationBoamp> vPublicationBOAMP = PublicationBoamp.getAllPublicationBoampFromAffaire(iTypePublication,iIdAffaire);
    if(vPublicationBOAMP != null && vPublicationBOAMP.size()>0)
        bExistPublicationBOAMP = true;

}
catch(Exception e){}
if(bFormJOUE)
{
%>
<%@ include file="pave/paveRubriquesJOUEForm.jspf" %>
<br/>
<%  
}
if(bExistPublicationBOAMP)
{
	if(bFormJOUE) {
%>
<%@ include file="pave/paveRubriquesBOAMP.jspf" %>
<br/>
<%
	} else {
%>
<%@ include file="pave/paveRubriquesBOAMPForm.jspf" %>
<br/>
<%
	}
}
%>
<%@ include file="pave/paveResumeActions.jspf" %>
<br/>
<button type="submit" >Enregistrer</button>
<button type="button" onclick="Redirect('<%= 
    response.encodeURL( 
        rootPath+"desk/marche/algorithme/affaire/"+sRedirect+".jsp?sActionRectificatif=show"
        + "&amp;iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
        + "&amp;iIdOnglet=" + iIdOnglet 
        + "&amp;bCreationArec="+bCreationArec
        + "&amp;iIdAffaire=" + avis.getIdMarche()+"&#ancreHP" ) %>')">Annuler</button>
</form>
