<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.export.*,modula.graphic.*,modula.fqr.*,java.sql.*,org.coin.fr.bean.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*,org.coin.bean.*" %>
<%
	String sSelected ;
	String sUrlCancel = "";
	String sTitle = null;
	String sPaveObjetMarcheTitre ;
	String sFormPrefix = "";
	String sPaveTypeMarcheTitre ; 
	String sAction = "";
	String sReference = "";
	String sObjet = "";
	int iIdAffaire;
	Marche marche = null;
	boolean bShowForm = false;
	String sRedirection;
	String sPage="";
	
	sAction = request.getParameter("sAction");
	if(request.getParameter("sAction") == null) sAction="";

	String sIdAffaire = null;
	sIdAffaire = request.getParameter("iIdAffaire");
	iIdAffaire = Integer.parseInt(sIdAffaire );

	marche = Marche.getMarche(iIdAffaire );

	session.setAttribute( "sessionIdAffaire",  "" + marche.getIdMarche() ) ;
	sTitle = "Afficher une Petite annonce"; 
		
	boolean bLectureSeule = marche.isLectureSeule(false);
	
	boolean isFirstHiddenOngletValide = false;
	try{isFirstHiddenOngletValide = marche.isOngletInstancie(0);}
	catch(Exception e){}	
	
	if((!isFirstHiddenOngletValide)&&(!bLectureSeule)) sAction = "store";
	
	MarcheType oMarcheType = null;
	try{
		oMarcheType = MarcheType.getMarcheType( marche.getIdMarcheType() ); 
	}catch(Exception e){
		oMarcheType = new MarcheType();
	}
	
	Commission commissionSelected = null;
	Organisation organisation = null;
	if(marche.getIdCommission() > 0)
	{
		commissionSelected = Commission.getCommission(marche.getIdCommission());
		organisation = Organisation.getOrganisation(commissionSelected.getIdOrganisation(), false); 
	}
	else
	{
		commissionSelected = new Commission();
		organisation = new Organisation(false); 
	}
	
	//System.out.println("organisation = " + organisation.getId());
	String sPageUseCaseId = "IHM-DESK-PA-2";
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
%>
<script type="text/javascript" src="<%= rootPath + "include/js/desk/petite_annonce/pavePetiteAnnonce.js" %>" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/date.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/cryptage.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/calendrier.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/overlib_mini.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/produitCartesien.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxComboList.js?v=<%= JavascriptVersion.AJAX_COMBO_LIST_JS %>"></script>

<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/component/calendar/calendar.css" media="screen" />

<script type="text/javascript" src="<%= rootPath %>include/component/calendar/calendar.js"></script>
<script type="text/javascript">
<!--
	var rootPath = "<%= rootPath %>";
//-->



function showModalFrame(sTitle, sUrl)
{
    var doc;
    try{doc = parent.document;doc.appendChild(doc.createTextNode(""));}
    catch(e){doc = document;}
   
    
   
    var popupDiv = doc.createElement("div");
    popupDiv.style.position = "relative";
    popupDiv.style.backgroundColor = "#EFF5FF";
    popupDiv.style.padding = "0 7px 0 7px";

    var img = doc.createElement("img");
    img.style.position = "absolute";
    img.style.top = "3px";
    img.style.right = "3px";
    img.style.cursor = "pointer";
    img.src = "<%=rootPath%>images/icons/close.gif";
    img.onclick = function(){
        try {new parent.Control.Modal.close();}
        catch(e) { Control.Modal.close();}
    }

    popupDiv.appendChild(img);
    
    
    var divHeader = doc.createElement("div");
    divHeader.style.textAlign = "center";
    divHeader.style.lineHeight = "28px";
    divHeader.innerHTML = sTitle;
    divHeader.style.height = "28px";
    
    var divIframe = doc.createElement("div");
    divIframe.style.border = "1px solid #888";
    divIframe.style.backgroundColor = "#AAA";
    
    var iframe = doc.createElement("iframe");
    iframe.name = "offerPopup";
    iframe.id = "offerPopup";
    iframe.src = sUrl;
    iframe.style.width = "100%";
    iframe.style.height = "430px";
    iframe.style.border = 0;
    iframe.style.margin = 0;
    iframe.align = "top";
    iframe.frameBorder = "0";
    iframe.border = "1";
    divIframe.appendChild(iframe);
                                
    var divFooter = doc.createElement("div");
    divFooter.style.textAlign = "center";
    divFooter.style.lineHeight = "6px";
    divFooter.style.height = "6px";
    
    popupDiv.appendChild(divHeader);
    popupDiv.appendChild(divIframe);
    popupDiv.appendChild(divFooter);

    var modal ;
   try{ 
       modal = new parent.Control.Modal(false,{width: 700, contents: popupDiv, overlayCloseOnClick:false, overlayDisplay: false});
   } catch(e) {
       modal = new Control.Modal(false,{width: 700, contents: popupDiv, overlayCloseOnClick:false, overlayDisplay: false});
   }

	modal.container.insert(popupDiv);
    modal.open();

}

</script>

<%@ include file="pave/paveTypeMarcheJavascriptDuProduitCartesien.jspf" %>
<script type="text/javascript">
<%@ include file="pave/paveCheckPetiteAnnonce.jspf" %>
</script>
<% 
if(sAction.equals("store") ) {
	bShowForm = true;
%>
<script type="text/javascript">
if (document.addEventListener) {
    document.addEventListener("DOMContentLoaded", onAfterPageLoading, null);
}
</script>
<%
	}
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<% String sHeadTitre = ""; %>
<%
	if(sAction.equals("store")) {
	%><%@ include file="/desk/include/headerPetiteAnnonceOnlyButtonDisplayPA.jspf" %><%
	} else {
	%><%@ include file="/desk/include/headerPetiteAnnonce.jspf" %><%
	}
	
	if(bShowForm )
	{
%>
	<form action="<%= response.encodeURL("modifierPetiteAnnonce.jsp") %>" 
	 method="post" name="formulaire" onSubmit="return checkForm()" >
<%
	}

	if(sessionUserHabilitation.isHabilitate("IHM-DESK-PA-3"))
	{
%>
		<table id="formulaire_principal" >
			<tr>
				<td style="text-align:right">
				<%@ include file="pave/paveBoutonSubmit.jspf" %>
				</td> 
			</tr>
		</table>
		<br />
<%
	}

	boolean bAfficheDateCandidature = true;
	boolean bIsPAGrouped = marche.isPAGrouped(false);

	if(sAction.equals("store"))	
	{ 
		String sPavePetiteAnnonceTitre = "Petite annonce";  
		String sPavePublicationsTitre = "Publication sur le site Internet";
%><%@ include file="pave/paveChoisirOrganismeForm.jspf" %><%
%><%@ include file="pave/pavePetiteAnnonceForm.jspf" %><%
%><%@ include file="pave/pavePublicationsForm.jspf" %><%
	} else {
		String sPavePetiteAnnonceTitre = "Petite annonce"; 
		String sPavePublicationsTitre = "Publication sur le site Internet";
%><%@ include file="pave/paveChoisirOrganisme.jspf" %><%
%><%@ include file="pave/pavePetiteAnnonce.jspf" %><%
%><%@ include file="pave/pavePublications.jspf" %><%
	}

    if(sessionUserHabilitation.isHabilitate("IHM-DESK-PA-3"))
    {
%>

	<table >
		<tr>
			<td style="text-align:right">
			<%@ include file="pave/paveBoutonSubmit.jspf" %>
			</td>
		</tr>
	</table>
<%
    }
    
	if(sAction.equals("store") )
	{
%>
	<br />
	<%
		if(bShowForm)
		{ 
	%>
	</form>
	<%
		}
	}
%>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>