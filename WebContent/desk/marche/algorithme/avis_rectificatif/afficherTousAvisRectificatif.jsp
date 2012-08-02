<%@page import="org.coin.util.HttpUtil"%>

<%@ page import="java.util.*,modula.*, modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-AFF-RECT-2";
	String sTitle = "Afficher les avis rectificatifs"; 
	String sHeadTitre = ""; 
	boolean bAfficherPoursuivreProcedure = false;
	
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	
	int iIdAvisRectificatifType = AvisRectificatifType.TYPE_AAPC;
	if(marche.isAffaireAATR(false))
		iIdAvisRectificatifType = AvisRectificatifType.TYPE_AATR;
	
	Vector<AvisRectificatif> vAvisRectificatif 
		= AvisRectificatif.getAllAvisRectificatifWithType(
				marche.getIdMarche(),
				iIdAvisRectificatifType);

%>
<%@include file="pave/paveTousAvis.jspf" %>
