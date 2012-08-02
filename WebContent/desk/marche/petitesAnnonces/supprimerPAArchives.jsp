
<%@ page import="modula.marche.*,modula.algorithme.*, org.coin.util.*" %>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Suppression des petites annonces archivées";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
	String sUrlRedirect = "";
	int iNbArchives = 0;
	int iTypeProcedurePA = AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE;
	String sWhereClause = " WHERE id_algo_affaire_procedure = "+iTypeProcedurePA;
	java.util.Vector<Marche> vMarche = Marche.getAllMarcheWithWhereClause(sWhereClause);
	for(int i =0;i<vMarche.size();i++){
		boolean bIsArchive = false;
		try{
			bIsArchive = vMarche.get(i).isAffaireArchivee();
		}
		catch(Exception e){}
		if (bIsArchive) {vMarche.get(i).removeWithObjectAttached();iNbArchives++;}
	}
	
	sMessTitle = "Succ&egrave;s de l'&eacute;tape";
	sMess = "Toutes les petites annonces archivées ("+iNbArchives+") et leurs pièces jointes ont été supprimées du système Modula.";
	sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
	sUrlRedirect = rootPath+"desk/marche/petitesAnnonces/afficherToutesPetitesAnnonces.jsp";
	
	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);
	session.setAttribute("sessionMessageUrlRedirect", sUrlRedirect);
	try{
		response.sendRedirect(response.encodeRedirectURL(rootPath+"include/afficherMessageDesk.jsp"));
	}
	catch(java.io.IOException ioe){}
%>
