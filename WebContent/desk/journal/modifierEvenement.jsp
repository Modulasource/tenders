
<%@ page import="modula.journal.*,org.coin.util.*,org.coin.bean.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	// extra param
	String sType = request.getParameter("sType") ;
	String sIdObjet = request.getParameter("sIdObjet") ;
	String sExtraParam = "";
	String rootPath = request.getContextPath()+"/";

	if (sType != null){
		sExtraParam += "&sType=" + sType;
	} 
	
	if ( sIdObjet != null){
		sExtraParam += "&sIdObjet=" + sIdObjet ;
	} 
	
	String sAction = request.getParameter("sAction") ;

	if(sAction.equals("create"))
	{
		Evenement oEvenement = new Evenement ();
		oEvenement.setIdTypeEvenement( Integer.parseInt( request.getParameter("iIdTypeEvenement")) );
		oEvenement.setIdReferenceObjet( Integer.parseInt( request.getParameter("iIdReferenceObjet")) );
		oEvenement.setIdUser(sessionUser.getIdUser());
		oEvenement.setDateDebutEvenement(
			CalendarUtil.getConversionTimestamp(
				request.getParameter("tsDateDebutEvenement") 
				+ " "
				+ request.getParameter("tsDateDebutEvenementHeure") ));
		
		oEvenement.setDateFinEvenement(
			CalendarUtil.getConversionTimestamp(
				request.getParameter("tsDateFinEvenement") 
				+ " " 
				+ request.getParameter("tsDateFinEvenementHeure") ));
		
		oEvenement.setCommentaireLibre(request.getParameter("sCommentaireLibre"));
				
		oEvenement.create();
		response.sendRedirect(
				response.encodeRedirectURL(
						rootPath + "desk/journal/afficherTousEvenementsParMois.jsp?sType=" 
								+ ObjectType.PERSONNE_PHYSIQUE
								+ "&sIdObjet=" + oEvenement.getIdReferenceObjet()) );
		return;
	}
	
	int iIdEvenement = -1;
	if (request.getParameter("iIdEvenement") != null) {
		iIdEvenement = Integer.parseInt(request.getParameter("iIdEvenement"));
	} 
	else
	{
		// TODO : renvoyer vers la page d'erreur;
		System.out.println("Error : iIdEvenement est nul !");
		return;
	}
	
	modula.journal.Evenement evt = modula.journal.Evenement.getEvenement(iIdEvenement );
	modula.journal.TypeEvenement typeEvt = modula.journal.TypeEvenement.getTypeEvenementMemory(evt.getIdTypeEvenement() );

	if(sAction.equals("remove"))
	{
		evt.remove();
		try{ 
			modula.ws.certeurope.Jeton jeton = modula.ws.certeurope.Jeton.getJeton(evt.getIdJetonHorodatage());
			jeton.remove(); 
		} catch (Exception e) {}
	}
	response.sendRedirect(response.encodeRedirectURL("afficherTousEvenements.jsp?" + sExtraParam) );
	
%>