<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.coin.util.*,modula.candidature.*,modula.marche.*" %>
<%@page import="modula.journal.Evenement"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "";
	int classement = 1;
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sAction = HttpUtil.parseString("sAction", request,"");
	String[] idRetenues = Outils.parserChaineVersString(request.getParameter("idRetenues"),"|");
	String[] idNonConformes = Outils.parserChaineVersString(request.getParameter("idNonConformes"),"|");

	if (idRetenues != null)
	{
		for (int i = 0; i < idRetenues.length; i++)
		{
			if ( (!idRetenues[i].equalsIgnoreCase("")) && (!idRetenues[i].equalsIgnoreCase("|")) )
			{
				EnveloppeC eEnveloppe = EnveloppeC.getEnveloppeC(Integer.parseInt(idRetenues[i]));
				eEnveloppe.setRetenue(true);
				eEnveloppe.setConforme(true);
				eEnveloppe.setNotifieNonConforme(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();
				
				Vector<EnveloppeB> vEnveloppeB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(eEnveloppe.getIdCandidature(),eEnveloppe.getIdLot(),eEnveloppe.getIdValidite());
				if(vEnveloppeB != null && vEnveloppeB.size()==1)
				{
					EnveloppeB eEnveloppeB = vEnveloppeB.firstElement();
					eEnveloppeB.setRetenue(true);
					eEnveloppeB.setConforme(true);
					eEnveloppeB.setNotifieNonConforme(false);
					eEnveloppeB.setClassement(classement);
					eEnveloppeB.store();
				}
				classement ++;
			}
		}	
	}
	
	if (idNonConformes != null)
	{
		for (int i = 0; i < idNonConformes.length; i++)
		{
			if ( (!idNonConformes[i].equalsIgnoreCase("")) && (!idNonConformes[i].equalsIgnoreCase("|")) )
			{
				EnveloppeC eEnveloppe = EnveloppeC.getEnveloppeC(Integer.parseInt(idNonConformes[i]));
				eEnveloppe.setConforme(false);
				eEnveloppe.setRetenue(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();
				
				Vector<EnveloppeB> vEnveloppeB = EnveloppeB.getAllEnveloppeBFromCandidatureAndLotAndValidite(eEnveloppe.getIdCandidature(),eEnveloppe.getIdLot(),eEnveloppe.getIdValidite());
				if(vEnveloppeB != null && vEnveloppeB.size()==1)
				{
					EnveloppeB eEnveloppeB = vEnveloppeB.firstElement();
					eEnveloppeB.setConforme(false);
					eEnveloppeB.setRetenue(false);
					eEnveloppeB.setClassement(classement);
					eEnveloppeB.store();
				}
			}
		}	
	}
	
	boolean bClassementEnregistre  = false;
	if(sAction.equals("enregistrer")) bClassementEnregistre = true;
	else if(sAction.equals("figer"))
	{
		lot.setClassementEnveloppesCFige(true);
		lot.store();
		Evenement.addEvenement(
				lot.getIdMarcheLot() ,
				"IHM-DESK-AFF-38", 
				sessionUser.getIdUser(),
				"classement du lot figé pour les offres");
	}
	
	response.sendRedirect(response.encodeRedirectURL("afficherLotsEtEnveloppesC.jsp?none="
			+System.currentTimeMillis()
			+"&bClassementEnregistre="+bClassementEnregistre
			+"&iIdAffaire="+iIdAffaire
			+"&iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
			+"&iIdOnglet="+lot.getNumero()+"&#tabClassement"));
%>