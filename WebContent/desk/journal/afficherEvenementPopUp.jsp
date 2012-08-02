
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	// extra param
	String sType = request.getParameter("sType") ;
	String sIdObjet = request.getParameter("sIdObjet") ;
	String sExtraParam = "";
	
	if (sType != null){
		sExtraParam += "&sType=" + sType;
	} 
	
	if ( sIdObjet != null){
		sExtraParam += "&sIdObjet=" + sIdObjet ;
	} 
	
	String sTitle = "";
	String sFormPrefix = "";
	int iIdEvenement = Integer.parseInt(request.getParameter("iIdEvenement"));

	String rootPath = request.getContextPath()+"/";
	modula.journal.Evenement evt = modula.journal.Evenement.getEvenement(iIdEvenement );
	modula.journal.TypeEvenement typeEvt = modula.journal.TypeEvenement.getTypeEvenementMemory(evt.getIdTypeEvenement() );
	
	String sTypeEvenement = "unknow";

	switch (typeEvt.getIdTypeObjet())
	{
	case org.coin.bean.ObjectType.AFFAIRE : 
		sTypeEvenement = "Marche";
		break;
	case org.coin.bean.ObjectType.COMMISSION : 
		sTypeEvenement = "Commission";
		break;
	case org.coin.bean.ObjectType.ORGANISATION : 
		sTypeEvenement = "Organisation";
		break;
	case org.coin.bean.ObjectType.PERSONNE_PHYSIQUE : 
		sTypeEvenement = "PersonnePhysique";
		break;
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/journal/afficherEvenement" + sTypeEvenement + ".jsp?iIdEvenement="+iIdEvenement+ sExtraParam) );
%>