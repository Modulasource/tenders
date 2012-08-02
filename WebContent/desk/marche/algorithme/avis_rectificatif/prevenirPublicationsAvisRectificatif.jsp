<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Prévenir les publications de l'avis rectificatif de l'affaire réf. " + marche.getReference() ;
	int iIdAvisRectificatif = Integer.parseInt( request.getParameter("iIdAvisRectificatif") );
	AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);

	avis.setMailPublicationEnvoye(true);
	avis.store();
	
	String sRedirect = "afficherAffaire";
	boolean bIsAATR = false;
	AvisAttribution avisAttrib = null;
	if(marche.isAffaireAATR(false))
	{
		sRedirect = "afficherAttribution";
		bIsAATR = true;
		avisAttrib = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	}
	
	if(avis.isAllEtapesForRectificationValides())
	{
		if(bIsAATR)
		{
			avisAttrib.setAATREnCoursDeRectification(false);
			avisAttrib.store();
		}
		else
		{
			marche.setAffaireEnCoursDeRectification(false);
			marche.store();
		}
	}
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	//modula.journal.Evenement.addEvenement(marche.getIdMarche(), "IHM-DESK-AFF-RECT-9", sessionUser.getIdUser(), "Les publications ont été prévenues de la publication d'un avis rectificatif");
	String sMessTitle = "Etape non effectuée";
	String sMess = "Traitement des publications non opérationnel";
	String sUrlIcone = Icone.ICONE_WARNING;
	
	String sURLRedirect = response.encodeURL(rootPath+"desk/marche/algorithme/affaire/"+sRedirect
			+".jsp?sActionRectificatif=show&amp;iIdAvisRectificatif=" 
			+ avis.getIdAvisRectificatif() + "&amp;iIdOnglet=" + iIdOnglet
			+ "&amp;iIdAffaire=" + avis.getIdMarche()
			+ "&amp;none="+System.currentTimeMillis()
			+"&#ancreHP");
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/message.jspf" %>
<div style="text-align:center">
	<button type="button" value="" onclick="RedirectURL('<%= sURLRedirect %>')" >Fermer la fenêtre</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.util.HttpUtil"%>
</html>