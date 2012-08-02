<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,modula.candidature.*,modula.marche.*" %>
<%@ page import="modula.journal.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "";
	int classement = 1;
	
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	MarcheLot lot = MarcheLot.getMarcheLot(iIdLot);
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request,-1);
	String sAction = HttpUtil.parseString("sAction", request,"");
	String[] idAttribuees = Outils.parserChaineVersString(request.getParameter("listeAttribuees_ids"),"|");
	String[] idNonAttribues= Outils.parserChaineVersString(request.getParameter("listeNonAttribuees_ids"),"|");
	String[] idNonConformes = Outils.parserChaineVersString(request.getParameter("listeNonConformes_ids"),"|");
	String[] idNonRetenues = Outils.parserChaineVersString(request.getParameter("listeNonRetenues_ids"),"|");
	
	if (idAttribuees != null)
	{
		for (int i = 0; i < idAttribuees.length; i++)
		{
			if ( (!idAttribuees[i].equalsIgnoreCase("")) && (!idAttribuees[i].equalsIgnoreCase("|")) )
			{
				EnveloppeB eEnveloppe = EnveloppeB.getEnveloppeB(Integer.parseInt(idAttribuees[i]));
				eEnveloppe.setAttribuee(true);
				eEnveloppe.setRetenue(true);
				eEnveloppe.setConforme(true);
				eEnveloppe.setNotifieNonConforme(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();
				
				classement ++;
			}
		}	
	}
	
	if (idNonAttribues != null)
	{
		for (int i = 0; i < idNonAttribues.length; i++)
		{
			if ( (!idNonAttribues[i].equalsIgnoreCase("")) && (!idNonAttribues[i].equalsIgnoreCase("|")) )
			{
				EnveloppeB eEnveloppe = EnveloppeB.getEnveloppeB(Integer.parseInt(idNonAttribues[i]));
				eEnveloppe.setAttribuee(false);
				eEnveloppe.setRetenue(true);
				eEnveloppe.setConforme(true);
				eEnveloppe.setNotifieNonConforme(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();

				classement ++;
			}
		}
	}

	if (idNonRetenues != null)
	{
		for (int i = 0; i < idNonRetenues.length; i++)
		{
			if ( (!idNonRetenues[i].equalsIgnoreCase("")) && (!idNonRetenues[i].equalsIgnoreCase("|")) )
			{
				EnveloppeB eEnveloppe = EnveloppeB.getEnveloppeB(Integer.parseInt(idNonRetenues[i]));
				eEnveloppe.setConforme(true);
				eEnveloppe.setRetenue(false);
				eEnveloppe.setAttribuee(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();
			}
		}	
	}
	
	if (idNonConformes != null)
	{
		for (int i = 0; i < idNonConformes.length; i++)
		{
			if ( (!idNonConformes[i].equalsIgnoreCase("")) && (!idNonConformes[i].equalsIgnoreCase("|")) )
			{
				EnveloppeB eEnveloppe = EnveloppeB.getEnveloppeB(Integer.parseInt(idNonConformes[i]));
				eEnveloppe.setConforme(false);
				eEnveloppe.setRetenue(false);
				eEnveloppe.setAttribuee(false);
				eEnveloppe.setClassement(classement);
				eEnveloppe.store();
			}
		}	
	}
	
	boolean bClassementEnregistre  = false;
	if(sAction.equals("enregistrer")) bClassementEnregistre = true;
	else if(sAction.equals("figer"))
	{
		lot.setClassementEnveloppesBFige(true);
		lot.store();
		Evenement.addEvenement(lot.getIdMarche() ,"IHM-DESK-AFF-38", sessionUser.getIdUser(),"Classement des offres figé pour le lot n°"+lot.getNumero());
	}
	else if(sAction.equals("finaliser"))
	{
		lot.setEnCoursDeNegociation(false);
		lot.setNegociationFige(true);
		lot.store();
		Evenement.addEvenement(lot.getIdMarche(),"IHM-DESK-AFF-38", sessionUser.getIdUser(),"Fin des negociations - finalisation du classement du lot n°"+lot.getNumero());
	}
	else if(sAction.equals("negociation"))
	{
		lot.setEnAttenteDeNegociation(true);
		lot.store();
	}

	if(sAction.equals("negociation")) {
		response.sendRedirect(
				response.encodeURL(
					rootPath 
					+ "desk/marche/algorithme/proposition/gestion/modifierPlanningReceptionOffresForm.jsp"
					+ "?iIdNextPhaseEtapes=" +iIdNextPhaseEtapes
					+ "&iIdAffaire=" + iIdAffaire
					+ "&bNegociation=true"
					+ "&iIdOnglet="+lot.getNumero()+"&#tabClassement"));
	} else {
		response.sendRedirect(
				response.encodeRedirectURL(
						"afficherLotsEtEnveloppesB.jsp?none="+System.currentTimeMillis()
								+"&bClassementEnregistre="+bClassementEnregistre
								+"&iIdLot="+iIdLot
								+"&iIdAffaire="+iIdAffaire
								+"&iIdNextPhaseEtapes="+iIdNextPhaseEtapes
								+"&iIdOnglet="+lot.getNumero()+"&#tabClassement"));
	}
%>