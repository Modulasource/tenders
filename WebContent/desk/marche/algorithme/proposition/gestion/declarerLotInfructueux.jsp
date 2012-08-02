<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.journal.Evenement"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "";
	sessionUserHabilitation.isHabilitateException("IHM-DESK-AFF-34");

	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = Icone.ICONE_SUCCES;
	
	lot.setInfructueux(true);
	lot.store();
	
	sMessTitle = "D�clarer le lot infructueux";
	sMess = "Le lot n�" + lot.getNumero() + " de l'affaire r�f. " + marche.getReference() + " a �t� d�clar� infructueux.";
	Evenement.addEvenement(marche.getIdMarche(),	"IHM-DESK-AFF-34", sessionUser.getIdUser(),sMess);


	if(MarcheLot.isAllLotsInfructueuxFromAffaire(marche.getIdMarche())) 
	{
		sMess = "L'affaire r�f. " + marche.getReference() + " a �t� d�clar�e infructueuse.";
		Evenement.addEvenement(marche.getIdMarche(),	"IHM-DESK-AFF-33", sessionUser.getIdUser(),sMess);
	}
	
	if(MarcheLot.isAllLotsAttribuesOrInfructeuxFromAffaire(iIdAffaire)) 
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
		marche.store();
		Evenement.addEvenement(iIdAffaire ,"IHM-DESK-AFF-18", sessionUser.getIdUser(),"Tous les lots du march� ont �t� attribu�s");
	}
		
	response.sendRedirect(
			response.encodeRedirectURL("afficherLotsEtEnveloppesB.jsp?iIdOnglet="+lot.getNumero()
					+"&none="+System.currentTimeMillis()+"&iIdAffaire="+iIdAffaire+"&#ancreHP"));
%>