<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.candidature.*,org.coin.util.*,java.util.*,modula.marche.*" %>
<%@ page import="modula.journal.*,org.coin.fr.bean.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
		
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	
	lot.setAttribue(true);
	lot.store();
	
	Vector<EnveloppeB> vEnveloppesBttribuees = EnveloppeB.getAllEnveloppesBAttribueesFromLot(lot.getIdMarcheLot());
	
	if(vEnveloppesBttribuees.size() == 0)
	{	
		response.sendRedirect(response.encodeRedirectURL("declarerLotInfructueux.jsp?iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire+"&#ancreHP"));
		return;
	}
	
	for(int i=0;i<vEnveloppesBttribuees.size();i++)
	{
		EnveloppeB oEnveloppeB = vEnveloppesBttribuees.get(i);
		oEnveloppeB.setAttribueedefinitif(true);
		oEnveloppeB.setAttribuee(true);
		oEnveloppeB.store();
		Candidature candidature = Candidature.getCandidature(oEnveloppeB.getIdCandidature());
		PersonnePhysique candidat = PersonnePhysique.getPersonnePhysique(candidature.getIdPersonnePhysique());
		Evenement.addEvenement(lot.getIdMarche() ,"IHM-DESK-AFF-35", sessionUser.getIdUser(),"Le lot n°"+lot.getNumero()+" a été attribué définitivement à "+candidat.getCivilitePrenomNom());
	}
	
	if(MarcheLot.isAllLotsAttribuesOrInfructeuxFromAffaire(iIdAffaire)) 
	{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
		marche.store();
		Evenement.addEvenement(iIdAffaire ,"IHM-DESK-AFF-18", sessionUser.getIdUser(),"Tous les lots du marché ont été attribués");
	}
	
	response.sendRedirect(response.encodeRedirectURL(
			"afficherLotsEtEnveloppesB.jsp?iIdLot="+iIdLot
			+"&iIdOnglet="+lot.getNumero()+"&iIdAffaire="+iIdAffaire+"&#ancreHP"));
	return;
%>