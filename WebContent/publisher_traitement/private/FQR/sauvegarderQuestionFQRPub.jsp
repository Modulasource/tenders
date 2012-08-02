
<%@page import="mt.modula.affaire.fqr.MarcheFqrStatut"%>
<%@page import="mt.modula.affaire.fqr.MarcheFqr"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@ page import="modula.*,modula.fqr.*,org.coin.fr.bean.*,modula.candidature.*,modula.journal.*" %>
<%@ page import="modula.commission.*,org.coin.mail.*, java.sql.*, org.coin.util.*,mt.modula.bean.mail.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %>
<%
	Connection conn = ConnectionManager.getConnection();
	String rootPath = request.getContextPath()+"/";

	
	String sCand = request.getParameter("cand");
	Candidature candidature = Candidature.getCandidature(Integer.parseInt(
            SecureString.getSessionPlainString(
            sCand,session)));

	Marche marche = Marche.getMarche(candidature.getIdMarche(), conn, false);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(candidat.getIdPersonnePhysique());

	String sAction = HttpUtil.parseStringBlank("sAction", request);

	MarcheFqr marcheFqr = null;
    if (sAction.equals("create")) {
        marcheFqr = new MarcheFqr();
        marcheFqr.setIdMarcheFqrType(HttpUtil.parseLong(
                "lIdMarcheFqrType", request));
        marcheFqr.setTitre(request.getParameter("sTitre"));
        marcheFqr.setQuestion(request.getParameter("sQuestion"));
        //marcheFqr.setReponse(request.getParameter("sReponse"));
        marcheFqr.setIdPersonnePhysique(sessionUser.getIdIndividual());
        marcheFqr.setIdMarche(marche.getId());
        marcheFqr.setIdMarcheFqrStatut(MarcheFqrStatut.STATUT_A_VALIDER);
        marcheFqr.create();

        Organisation oOrganisationAP = Organisation.getOrganisation( marche.getIdOrganisationFromMarche(), false, conn);
        Vector<PersonnePhysique> vDestinataireAP 
	        = PersonnePhysique.getAllWithWhereClause(
	        		" WHERE id_organisation="+oOrganisationAP.getIdOrganisation()
	        		+" AND alerte_mail=1");
          
          
        for(PersonnePhysique dest : vDestinataireAP){
            MailMarcheFqr.prepareAndSendCourrierEvenement(
                          MailConstant.MAIL_NOUVELLE_QUESTION_FQR,
                          "IHM-PUBLI-FQR-001",
                          "FQR : Nouvelle question : " + marcheFqr.getTitre()
                          + " de " + personne.getPrenomNom() 
                          + ", entreprise " + organisation.getRaisonSociale() 
                          + " " + personne.getEmail(),
                          marche,
                          dest,
                          personne,
                          sessionUser,
                          oOrganisationAP,
                          conn
                          );
        }
          

        
    }
    ConnectionManager.closeConnection(conn);
	      

	
	response.sendRedirect( response.encodeRedirectURL(rootPath + sPublisherPath+
		"/private/candidat/consulterDossier.jsp?iIdOnglet=3&cand="
		+ sCand+"&mess=true") ); 

%>