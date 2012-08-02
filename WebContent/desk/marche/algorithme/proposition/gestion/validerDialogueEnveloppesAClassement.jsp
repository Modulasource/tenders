<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.coin.util.*,modula.candidature.*,modula.marche.*" %>
<%@page import="modula.journal.Evenement"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "";
	int classement = 1;
	
	String sAction = request.getParameter("sAction");
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String[] idDialogues = Outils.parserChaineVersString(request.getParameter("idDialogues"),"|");
	String[] idNonDialogues = Outils.parserChaineVersString(request.getParameter("idNonDialogues"),"|");

	if(sAction.equalsIgnoreCase("fermer"))
	{
		lot.setEnCoursDeDialogue(false);
		lot.store();
		
		Vector<EnveloppeALot> vNonDialogues = EnveloppeALot.getAllEnveloppeALotNonAdmisNonNotifiesForDialogueFromLot(lot.getIdMarcheLot());
		for (int i = 0; i < vNonDialogues.size(); i++)
		{
			EnveloppeALot oEnveloppeALot = vNonDialogues.get(i);
			oEnveloppeALot.setNotifieNonAdmisDialogue(true);
			oEnveloppeALot.store();
		}
		
		response.sendRedirect(response.encodeRedirectURL("afficherDialogueLotsEtEnveloppesA.jsp?iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire+"&iIdOnglet="+(lot.getNumero()-1)+"&nonce="+System.currentTimeMillis()+"#tabClassement"));
		return;
	}
	
	if(sAction.equalsIgnoreCase("lancer"))
	{
		lot.setEnCoursDeDialogue(true);
		lot.store();
		
		response.sendRedirect(response.encodeRedirectURL("afficherDialogueLotsEtEnveloppesA.jsp?iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire="+iIdAffaire+"&iIdOnglet="+(lot.getNumero()-1)+"&nonce="+System.currentTimeMillis()+"#tabClassement"));
		return;
	}
		
	if (idDialogues != null)
	{
		for (int i = 0; i < idDialogues.length; i++)
		{
			if ( (!idDialogues[i].equalsIgnoreCase("")) && (!idDialogues[i].equalsIgnoreCase("|")) )
			{
				EnveloppeALot oEnveloppeALot = EnveloppeALot.getEnveloppeALot(Integer.parseInt(idDialogues[i]));
				oEnveloppeALot.setAdmisDialogue(true);
				oEnveloppeALot.setClassement(classement);
				oEnveloppeALot.store();
			
				classement ++;
			}
		}
	}
	
	if (idNonDialogues != null)
	{
		for (int i = 0; i < idNonDialogues.length; i++)
		{
			if ( (!idNonDialogues[i].equalsIgnoreCase("")) && (!idNonDialogues[i].equalsIgnoreCase("|")) )
			{
				EnveloppeALot oEnveloppeALot = EnveloppeALot.getEnveloppeALot(Integer.parseInt(idNonDialogues[i]));
				oEnveloppeALot.setAdmisDialogue(false);
				oEnveloppeALot.setClassement(classement);
				oEnveloppeALot.store();
			}
		}
	}
	
	boolean bClassementEnregistre  = false;
	if(sAction.equals("enregistrer")) bClassementEnregistre = true;
	else if(sAction.equals("cloturer"))
	{
		lot.setDialogueFige(true);
		lot.store();
		Evenement.addEvenement(lot.getIdMarche() ,"IHM-DESK-AFF-77", sessionUser.getIdUser(),"Clôture des dialogues du lot n°"+lot.getNumero());
	}
	
	if(MarcheLot.isAllLotsFromMarcheFigesForDialogue(iIdAffaire))
	{
		response.sendRedirect(response.encodeRedirectURL("afficherEnveloppesA.jsp?iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdAffaire=" + iIdAffaire+"&#ancreHP"));
	}
	else
	{
		response.sendRedirect(response.encodeRedirectURL("afficherDialogueLotsEtEnveloppesA.jsp?bClassementEnregistre="+bClassementEnregistre+ "&iIdAffaire=" + iIdAffaire+"&iIdLot="+iIdLot+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes+"&iIdOnglet="+(lot.getNumero()-1)+"&nonce="+System.currentTimeMillis()+"#tabClassement"));
	}
%>