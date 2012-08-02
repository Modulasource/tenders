
<%@ page import="org.coin.bean.*,org.coin.fr.bean.export.*,modula.graphic.*,modula.fqr.*" %>
<%@ page import="java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*" %>
<%@ page import="modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*" %>
<%@ page import="org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
    int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
    Marche marche = Marche.getMarche(iIdAffaire);

    String rootPath = request.getContextPath()+"/";
    String sTitle = "Avis rectificatif";
    String sHeadTitre = "Avis rectificatif";
    String sDirectives = "";
    
    String sAction = HttpUtil.parseStringBlank("sAction", request);
    
    int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
    int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
    boolean bCreationArec = HttpUtil.parseBoolean("bCreationArec", request, false);
    
    AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
    Validite validite = Validite.getValidite(ObjectType.AVIS_RECTIFICATIF, avis.getIdAvisRectificatif());

    String sFormPrefix = "";
    
    String sRedirect = "afficherAffaire";
    if(marche.isAffaireAATR(false))
        sRedirect = "afficherAttribution";
    
    String sTypeAvis = "AAPC";
    if(avis.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
        sTypeAvis = "AATR";
    
    boolean isLectureSeule = avis.isLectureSeule(false);
    boolean bIsAvisValide=  avis.isAvisValide(false);
    boolean bIsOngletsValides= avis.isOngletsValides(false);
    boolean bIsMailCandidatEnvoye = avis.isMailCandidatEnvoye(false);
    boolean bIsMailPublicationEnvoye = avis.isMailPublicationEnvoye(false);
    
    if(!bIsAvisValide)
    {
        sDirectives 
        = "Pour poursuivre l'Avis Rectificatif, cliquer sur le bouton \"Valider l'Avis\".<br />Vous pourrez ensuite modifier les onglets de l'"+sTypeAvis+".<br/>";
    }
    
    if(bIsAvisValide && !bIsOngletsValides)
    {
        sDirectives 
        = "Pour poursuivre l'Avis Rectificatif :<br />"
        + "1/ Modifier les onglets de l'"+sTypeAvis+".<br />"
        + "2/ Cliquer sur \"Valider les Onglets de l'"+sTypeAvis+"\".<br />";
    }
    
    if(bIsOngletsValides && (!bIsMailCandidatEnvoye || !bIsMailPublicationEnvoye))
    {
        sDirectives 
        = "Pour poursuivre l'Avis Rectificatif, Prévenir les publications et les candidats.<br />";
    }
%>

<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<script type="text/javascript" >
function confirmValidationAvis()
{
    return confirm("ATTENTION : vous allez valider l'Avis Rectificatif et vous ne pourrez plus le modifier ni le supprimer.\nVous pourrez ensuite modifier les onglets pour que les modifications soient prises en compte dans le système puis prévenir les candidats et les publications.");
}
function confirmValidationOnglets()
{
    return confirm("ATTENTION : vous allez valider la modification des onglets de l'<%= sTypeAvis %> et vous ne pourrez plus les modifier.\nVous pourrez ensuite prévenir les candidats et les publications.");
}
function confirmSuppressionAvis()
{
    return confirm("ATTENTION : vous allez supprimer l'Avis Rectificatif. Etes-vous sûr?");
}
</script>
</head>
<form name="formulaire" action="<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/modifierAvisRectificatif.jsp" ) %>" method='post' onSubmit="return checkForm();" >
 
<input type="hidden" name="iIdAvisRectificatif" value="<%= avis.getIdAvisRectificatif() %>" />
<input type="hidden" name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
<br />
<%
	boolean bExistPublicationBOAMP = false;
	boolean bIsForm14Selected = false;
	try
	{
	    int iTypePublication = PublicationType.TYPE_AAPC;
	    if(avis.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
	        iTypePublication = PublicationType.TYPE_AATR;
	    
	    Vector<PublicationBoamp> vPublicationBOAMP 
	        = PublicationBoamp.getAllPublicationBoampFromAffaire(iTypePublication,iIdAffaire);
	    if(vPublicationBOAMP != null && vPublicationBOAMP.size()>0)
	        bExistPublicationBOAMP = true;
	    
	    Vector<MarcheJoueFormulaire> vJoueForm = MarcheJoueFormulaire.getAllFromIdMarche(iIdAffaire);
	    if(vJoueForm != null && vJoueForm.size()>0) {
	        for(MarcheJoueFormulaire joueForm : vJoueForm) {
	            if(joueForm.getIdJoueFormulaire() == 14) {
	                bIsForm14Selected = true;
	            }
	        }
	    }
	}
	catch(Exception e){}
    
	boolean bInfoFormJoueCompleted = true;
	if(bIsForm14Selected) {
		Vector<AvisRectificatifRubrique> vArecRubrique = AvisRectificatifRubrique.getAllArecRubriqueForIdArecAndRubriqueType(iIdAvisRectificatif, AvisRectificatifRubrique.RUBRIQUE_TYPE_JOUE);
		if(vArecRubrique != null) {
			boolean bIsRubAvisImplique = false;
			boolean bIsRubModif = false;
			boolean bIsRubLocalisation = false;
			Vector<AvisRectificatifRubriqueJoue> vArecRubJoue = null;
			for(AvisRectificatifRubrique arecRub : vArecRubrique) {
				if(AvisRectificatifRubriqueJoue.getAvisRectificatifByReference(arecRub.getRubriqueJoue())
						.firstElement().getRubriqueJoue().equals("sAvisImplique")) bIsRubAvisImplique = true;
                if(AvisRectificatifRubriqueJoue.getAvisRectificatifByReference(arecRub.getRubriqueJoue())
                        .firstElement().getRubriqueJoue().equals("sModification")) bIsRubModif = true;
                if(AvisRectificatifRubriqueJoue.getAvisRectificatifByReference(arecRub.getRubriqueJoue())
                        .firstElement().getRubriqueJoue().equals("sModifLocalisation")) bIsRubLocalisation = true;
			}
			if(!bIsRubAvisImplique || !bIsRubModif || !bIsRubLocalisation) bInfoFormJoueCompleted = false;
		} else bInfoFormJoueCompleted = false; 
	}
%>
<%@ include file="pave/paveAvisResume.jspf" %>
<br/>
<%
if(avis.isAvisValide(false) && bIsForm14Selected)
{
%>
<%@ include file="pave/paveRubriquesJOUE.jspf" %>
<br/>
<%
}
if(bExistPublicationBOAMP)
{
%>
<%@ include file="pave/paveRubriquesBOAMP.jspf" %>
<br/>
<%
}
%>
<%@ include file="pave/paveResumeActions.jspf" %>
<br/>
<%
if(!sDirectives.equalsIgnoreCase(""))
{
%>
<div class="mention">
<%= sDirectives %>
</div>
<%
}
%>
<br />
<%
if(!isAvisValide && sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-7"))
{ 
%>
<button type="button" 
 onclick="if(confirmValidationAvis())Redirect('<%= response.encodeURL(rootPath
        + "desk/marche/algorithme/avis_rectificatif/validerAvisRectificatif.jsp?iIdAvisRectificatif="+avis.getIdAvisRectificatif()
        + "&amp;iIdOnglet="+iIdOnglet
        + "&amp;sAction=validateForm"
        + "&amp;iIdAffaire="+avis.getIdMarche()) %>')">Valider l'Avis</button>
<% 
}
if(isAvisValide && !isOngletsValides 
&& sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-7"))
{ 
	if(bInfoFormJoueCompleted) {
%>
<button type="button" 
 onclick="if(confirmValidationOnglets())Redirect('<%= response.encodeURL(rootPath
        + "desk/marche/algorithme/avis_rectificatif/validerAvisRectificatif.jsp?iIdAvisRectificatif="+avis.getIdAvisRectificatif()
        + "&amp;iIdOnglet="+iIdOnglet
        + "&amp;sAction=validateOnglets"
        + "&amp;iIdAffaire="+avis.getIdMarche()) %>')">Valider les Onglets de l'<%= sTypeAvis %></button>
        
        <%
	}
    if(bIsForm14Selected) {
%>
<button type="button" 
onclick="Redirect('<%= 
    response.encodeURL(
        rootPath+"desk/marche/algorithme/affaire/"+sRedirect+".jsp?sActionRectificatif=store"
        + "&amp;bFormJOUE=true"
        + "&amp;iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
        + "&amp;iIdOnglet=" + iIdOnglet 
        + "&amp;iIdAffaire=" + avis.getIdMarche()+"&#ancreHP") %>')">Modifier les renseignements relatifs au form 14</button>
<%
    }
}

if(!isLectureSeule 
&& sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-3"))
{ %>
<button type="button" 
onclick="Redirect('<%= 
    response.encodeURL(
        rootPath+"desk/marche/algorithme/affaire/"+sRedirect+".jsp?sActionRectificatif=store"
        + "&amp;iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
        + "&amp;iIdOnglet=" + iIdOnglet 
        + "&amp;bCreationArec="+bCreationArec
        + "&amp;iIdAffaire=" + avis.getIdMarche()+"&#ancreHP") %>')">Modifier</button>

<%
if(bExistPublicationBOAMP)
{
%>
    <button 
        type="button" 
        onclick="Redirect('<%= 
            response.encodeURL(
                rootPath+"desk/marche/algorithme/avis_rectificatif/modifierAvisRectificatifRubrique.jsp?"
                + "sAction=create"
                + "&iIdAffaire=" + iIdAffaire
                + "&iIdOnglet=" + iIdOnglet
                + "&iIdAvisRectificatifType=" + avis.getIdAvisRectificatifType() 
                + "&iIdAvisRectificatif=" + avis.getIdAvisRectificatif()
                + "&iIdAvisRectificatifRubriqueType=" + AvisRectificatifRubrique.RUBRIQUE_TYPE_TEXTE  
                + "&sIdAvisRectificatifRubriqueSousType=auLieuDe" )
                %>')">Ajouter Rubrique Texte<br/>'au lieu de'</button>
    <button 
        type="button" 
        onclick="Redirect('<%= 
            response.encodeURL(
                rootPath+"desk/marche/algorithme/avis_rectificatif/modifierAvisRectificatifRubrique.jsp?"
                + "sAction=create"
                + "&iIdAffaire=" + iIdAffaire
                + "&iIdOnglet=" + iIdOnglet
                + "&iIdAvisRectificatifType=" + avis.getIdAvisRectificatifType() 
                + "&iIdAvisRectificatif=" + avis.getIdAvisRectificatif()
                + "&iIdAvisRectificatifRubriqueType=" + AvisRectificatifRubrique.RUBRIQUE_TYPE_TEXTE 
                + "&sIdAvisRectificatifRubriqueSousType=apresLaMention" )
                %>')">Ajouter Rubrique Texte<br/>'après la mention'</button>

    <button
        type="button" 
        onclick="Redirect('<%= 
            response.encodeURL(
                rootPath+"desk/marche/algorithme/avis_rectificatif/modifierAvisRectificatifRubrique.jsp?"
                + "sAction=create" 
                + "&iIdAffaire=" + iIdAffaire
                + "&iIdOnglet=" + iIdOnglet
                + "&iIdAvisRectificatifType=" + avis.getIdAvisRectificatifType() 
                + "&iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
                + "&iIdAvisRectificatifRubriqueType=" + AvisRectificatifRubrique.RUBRIQUE_TYPE_DATE) 
                %>')">Ajouter Rubrique Date</button>

<%  
}
}

if(!isLectureSeule && sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-4"))
{
%>
<button type="button" 
    onclick="if(confirmSuppressionAvis())Redirect('<%= 
    response.encodeURL(
            rootPath+"desk/marche/algorithme/avis_rectificatif/modifierAvisRectificatif.jsp"
            + "?sActionRectificatif=remove"
            + "&iIdAvisRectificatif=" + avis.getIdAvisRectificatif())
            + "&iIdAffaire="+iIdAffaire %>')">Supprimer</button>
<%  }
if(isAvisValide && isOngletsValides && !isMailPublicationEnvoye
&& sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-9"))
{ %>

    <button type="button" onclick="Redirect('<%= 
            response.encodeURL(
            rootPath + "desk/marche/algorithme/affaire/afficherToutesPublications.jsp?"
            + "iIdAffaire="+iIdAffaire
            + "&iIdAvisRectificatif=" + avis.getIdAvisRectificatif() 
            //+ "&amp;sIsProcedureLineaire=rectificatif"
            + "&sUrlTraitement=desk/marche/algorithme/publication/publier"+sTypeAvis+"REC.jsp"
            + "');" ) %>" >Prévenir les publications</button>

<%  }

if(isAvisValide && isOngletsValides && !isMailCandidatEnvoye 
&& sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-8"))
{
%>
    <button type="button" 
    onclick="javascript:openModal('<%= 
        response.encodeURL(
                rootPath + "desk/marche/algorithme/avis_rectificatif/prevenirCandidatsAvisRectificatifForm.jsp"
                + "?iIdAvisRectificatif=" + avis.getIdAvisRectificatif()
                + "&iIdAffaire="+iIdAffaire
                + "&iIdOnglet="+iIdOnglet)
    %>','Prévenir les candidats', '720px', '620px');">Prévenir les candidats</button>

<%  } %>

<br />
</form>