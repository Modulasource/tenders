
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.modula.bean.mail.MailMarcheFqr"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.fr.bean.mail.MailConstant"%>
<%@page import="modula.commission.Commission"%>
<%@page import="org.coin.fr.bean.mail.MailType"%>
<%@page import="mt.modula.bean.mail.MailModula"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.mail.*"%>
<%@page import="modula.candidature.*"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="modula.journal.*"%>
<%@page import="mt.modula.affaire.fqr.*"%>
<%@ include file="/include/new_style/headerDesk.jspf"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.marche.Marche"%>
<%
	Marche marche = Marche.getMarche(HttpUtil.parseInt("iIdAffaire",
			request));

	Connection conn = ConnectionManager.getConnection();
	PersonnePhysique personne = PersonnePhysique
			.getPersonnePhysique(sessionUser.getIdIndividual());

	String sAction = HttpUtil.parseStringBlank("sAction", request);
	MarcheFqr marcheFqr = null;
	String sUseCase = null;

	if (sAction.equals("create")) {
		marcheFqr = new MarcheFqr();
		marcheFqr.setIdMarcheFqrType(HttpUtil.parseLong(
				"lIdMarcheFqrType", request));
		marcheFqr.setTitre(request.getParameter("sTitre"));
		marcheFqr.setQuestion(request.getParameter("sQuestion"));
		marcheFqr.setReponse(request.getParameter("sReponse"));
		marcheFqr.setIdPersonnePhysique(sessionUser.getIdIndividual());
		marcheFqr.setIdMarche(marche.getId());
		marcheFqr.setIdMarcheFqrStatut(MarcheFqrStatut.STATUT_VALIDE);
		marcheFqr.create();

		sUseCase = "IHM-DESK-FQR-003";
		sAction = "sendAllEmail";
	}

	if (sAction.equals("respond")) {
		marcheFqr = MarcheFqr.getMarcheFqr(HttpUtil.parseInt(
				"lIdMarcheFqr", request));
		marcheFqr.setReponse(request.getParameter("sReponse"));
		marcheFqr.setIdMarcheFqrStatut(MarcheFqrStatut.STATUT_VALIDE);
		marcheFqr.store();

        sUseCase = "IHM-DESK-FQR-004";
		sAction = "sendAllEmail";
	}

	if (sAction.equals("sendAllEmail")) {
		Organisation oOrganisationAP = Organisation
				.getOrganisation(Commission.getCommission(
						marche.getIdCommission()).getIdOrganisation());
		Vector<Candidature> vCand = Candidature
				.getAllCandidatureFromMarche(marche.getIdMarche());
		Vector<PersonnePhysique> vPersonnePhysique = MailMarcheFqr
				.getAllPersonnePhysiqueFromCandidature(vCand);

		for (Candidature cand : vCand) {
			PersonnePhysique dest = null;
			try {
				dest = PersonnePhysique.getPersonnePhysique(
						cand.getIdPersonnePhysique(), 
						vPersonnePhysique);
				
				MailMarcheFqr
						.prepareAndSendCourrierEvenement(
								MailConstant.MAIL_REPONDRE_QUESTION_FQR,
								sUseCase, 
								"FQR : Réponse à la question " + marcheFqr.getTitre(),
								marche, 
								dest,
								personne, 
								sessionUser, 
								oOrganisationAP,
								conn);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	if (sAction.equals("refuse")) {
		marcheFqr = MarcheFqr.getMarcheFqr(HttpUtil.parseInt(
				"lIdMarcheFqr", request));
		marcheFqr.setIdMarcheFqrStatut(MarcheFqrStatut.STATUT_REFUSE);
		marcheFqr.store();

		Organisation oOrganisationAP
		  = Organisation.getOrganisation(
				  Commission.getCommission(
						marche.getIdCommission()).getIdOrganisation());
		
		Vector<Candidature> vCand = Candidature.getAllCandidatureFromMarche(marche.getIdMarche());
		Vector<PersonnePhysique> vPersonnePhysique = MailMarcheFqr.getAllPersonnePhysiqueFromCandidature(vCand);

		for (Candidature cand : vCand) {
			PersonnePhysique dest = null;
			try {
				dest = PersonnePhysique.getPersonnePhysique(cand.getIdPersonnePhysique(), vPersonnePhysique);
				
				if(dest.getIdPersonnePhysique() == marcheFqr.getIdPersonnePhysique() )
				{
					MailMarcheFqr.prepareAndSendCourrierEvenement(
							MailConstant.MAIL_SUPPRIMER_QUESTION_FQR,
							"IHM-DESK-FQR-005", 
							"FQR : Question refusée " + marcheFqr.getTitre(), 
							marche, 
							dest,
							personne, 
							sessionUser, 
							oOrganisationAP, 
							conn);
				}
			} catch (Exception e) {

			}
		}

	}

	ConnectionManager.closeConnection(conn);

	response.sendRedirect(response
			.encodeRedirectURL("afficherFQR.jsp?iIdAffaire="
					+ marche.getId()));
%>