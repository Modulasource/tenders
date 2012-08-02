<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.db.CoinDatabaseRemoveException"%>

<%@ page import="org.coin.fr.bean.*,modula.commission.*,java.util.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sPageUseCaseId = "IHM-DESK-COM-005";
%><%@ include file="../include/checkHabilitationCommissionMembrePage.jspf" %><%

	Vector<Marche> vMarche = Marche.getAllMarcheFromCommission(iIdCommission);
	if(vMarche.size()>0) {
		String sReferenceMarche = "";
		for (int i = 0; i < vMarche.size(); i++)
		{
			/** 
			 * Ajouter un test poru savoir si c'est une PA , un AATR ou un AAPC
			 */
			
			Marche marche = vMarche.get(i);
			sReferenceMarche += 
				"<b>" + marche.getReference() + "</b> - objet : " + marche.getObjet() +  "<br/>";
		}
		
		
		throw new CoinDatabaseRemoveException("Vous ne pouvez pas supprimer cette commission "
				+ "car il y a encore des marchés et/ou PA rattachés : <br/>" 
				+ sReferenceMarche );
	
	}
	

	Vector<CommissionMembre> vMembres = CommissionMembre.getAllCommissionMembre(iIdCommission);
	if(vMembres.size()>0) {
		throw new CoinDatabaseRemoveException("Vous ne pouvez pas supprimer cette commission "
				+ "car il y a encore des membres rattachés");

	}

	

		
	
	for (int i = 0; i < vMembres.size(); i++)
	{
		CommissionMembre membre = vMembres.get(i);
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique());
		membre.remove();
	}
	commission.remove();

	response.sendRedirect(response.encodeRedirectURL("afficherTouteCommission.jsp"));
%>
