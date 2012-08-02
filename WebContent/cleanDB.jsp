
<%@page import="org.coin.fr.bean.Delegation"%>
<%@page import="mt.modula.affaire.param.MarcheVolume"%>
<%@page import="mt.modula.affaire.personne.MarchePersonneItem"%>
<%@page import="modula.marche.justification.MarcheJustificationSelected"%>
<%@page import="modula.marche.justification.MarcheJustificationCommentaire"%>
<%@page import="modula.marche.justification.MarcheJustificationAutreRenseignement"%>
<%@page import="modula.marche.joue.MarcheJoueInfo"%>
<%@page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%@page import="modula.marche.geo.MarcheCodeNuts"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.export.Publication"%><%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.fr.bean.OrganisationType"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@ page import="org.coin.bean.*,modula.candidature.*,modula.marche.*,java.util.*" %>
<%

	// Mis en commentaire pour éviter les mauvaises surprises ...

	/*	
	
	Vector<Marche> vMarches = Marche.getAllMarcheWithWhereClause("");
	for(Marche item:vMarches){
		out.write(item.getObjet() + "<BR/>");
		item.removeWithObjectAttached();
	}
	
	Vector<MarcheParametre> vMarcheParametre = MarcheParametre.getAllStatic();
	for(MarcheParametre item:vMarcheParametre ){
		out.write(item.getName() + "<BR/>");
		item.remove();
	}
	
	Vector<AncienAAPC> vAncienAAPC = AncienAAPC.getAll();
	for(AncienAAPC item:vAncienAAPC){
		out.write(item.getAncienAAPCFilename() + "<BR/>");
		item.remove();
	}
    
	Vector<Publication> vPublication = Publication.getAllPublication();
    for(Publication item : vPublication) {
    	item.removeWithObjectAttached();
    }
    
    // Ne pas supprimer les personnes rattachées à l'organisme système
	Vector<PersonnePhysique> vPersonnePhysique = PersonnePhysique.getAllWithWhereClause("WHERE id_organisation <> 2");
	for(PersonnePhysique item : vPersonnePhysique) {
		out.write(item.getNom() + "<BR/>");
		item.removeWithObjectAttached();
	}
	
	Vector<User> vUser = User.getAllStatic();
	for(User item : vUser) {
		if(item.getIdUserType() != 4) {
			item.remove();
		}
	}
	
    Vector<Candidature> vCandidature = Candidature.getAllStatic();
    for(Candidature item : vCandidature) {
    	item.removeWithObjectAttached();
    }
    
	ConnectionManager.executeUpdate("delete from ancien_avis");
	ConnectionManager.executeUpdate("delete from article_loi_marche");
	ConnectionManager.executeUpdate("delete from avis_attribution");
	ConnectionManager.executeUpdate("delete from avis_rectificatif");
	ConnectionManager.executeUpdate("delete from avis_rectificatif_rubrique");
	ConnectionManager.executeUpdate("delete from boamp_departement_publication");
	ConnectionManager.executeUpdate("delete from boamp_properties");
	ConnectionManager.executeUpdate("delete from coin_document");
	ConnectionManager.executeUpdate("delete from coin_document_library");
	ConnectionManager.executeUpdate("delete from coin_document_signatory");
	ConnectionManager.executeUpdate("delete from coin_export");
	ConnectionManager.executeUpdate("delete from coin_export_mode_email_destinataire");
	ConnectionManager.executeUpdate("delete from coin_export_mode_email_destinataire_piece_jointe");
	ConnectionManager.executeUpdate("delete from commission");
	ConnectionManager.executeUpdate("delete from commission_membre");
	ConnectionManager.executeUpdate("delete from competence_par_marche");
	ConnectionManager.executeUpdate("delete from competence_par_organisation");
	ConnectionManager.executeUpdate("delete from correspondant");
	ConnectionManager.executeUpdate("delete from correspondant_info");
	ConnectionManager.executeUpdate("delete from coup_coeur");
	ConnectionManager.executeUpdate("delete from courrier");
	ConnectionManager.executeUpdate("delete from demande_info_complementaire");
	ConnectionManager.executeUpdate("delete from enveloppe_a");
	ConnectionManager.executeUpdate("delete from enveloppe_a_lot");
	ConnectionManager.executeUpdate("delete from enveloppe_a_piece_jointe");
	ConnectionManager.executeUpdate("delete from enveloppe_b");
	ConnectionManager.executeUpdate("delete from enveloppe_b_piece_jointe");
	ConnectionManager.executeUpdate("delete from enveloppe_c");
	ConnectionManager.executeUpdate("delete from enveloppe_c_piece_jointe");
	ConnectionManager.executeUpdate("delete from evenement");
	ConnectionManager.executeUpdate("delete from export_marco");
	ConnectionManager.executeUpdate("delete from coin_user_group");
	ConnectionManager.executeUpdate("delete from jeton_horodatage");
	ConnectionManager.executeUpdate("delete from marche_boite_envoi");
	ConnectionManager.executeUpdate("delete from marche_cpv_objet");
	ConnectionManager.executeUpdate("delete from marche_critere");
	ConnectionManager.executeUpdate("delete from marche_fqr");
	ConnectionManager.executeUpdate("delete from marche_justif_negocie");
	ConnectionManager.executeUpdate("delete from marche_langue");
	ConnectionManager.executeUpdate("delete from marche_lot");
	ConnectionManager.executeUpdate("delete from marche_veille");
	ConnectionManager.executeUpdate("delete from marche_veille_abonnes");
	ConnectionManager.executeUpdate("delete from mesure");
	ConnectionManager.executeUpdate("delete from mesure_point");
	ConnectionManager.executeUpdate("delete from organisation_graphisme");
	ConnectionManager.executeUpdate("delete from organisation_parametre");
	ConnectionManager.executeUpdate("delete from publication_accuse");
	ConnectionManager.executeUpdate("delete from validite");
		
	
	
	
	Vector<Organisation> vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_CANDIDAT);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_ACHETEUR_PUBLIC);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	
	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_ANNONCEUR);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_CONSULTANT);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_PARTICULIER);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	
	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_PUBLICATION);
	for(Organisation item:vOrganisation){
		out.write(item.getName() + "<BR/>");
		item.removeWithObjectAttached();
	}

	vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_EXTERNAL);
    for(Organisation item:vOrganisation){
        out.write(item.getName() + "<BR/>");
        item.removeWithObjectAttached();
    }
    
    vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_EXTERNAL_CASUAL);
    for(Organisation item:vOrganisation){
        out.write(item.getName() + "<BR/>");
        item.removeWithObjectAttached();
    }
    
    vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_BUSINESS_UNIT);
    for(Organisation item:vOrganisation){
        out.write(item.getName() + "<BR/>");
        item.removeWithObjectAttached();
    }
    
    vOrganisation = Organisation.getAllOrganisationsWithIdType(OrganisationType.TYPE_HEAD_QUARTER);
    for(Organisation item:vOrganisation){
        out.write(item.getName() + "<BR/>");
        item.removeWithObjectAttached();
    }
    
    */
%>