<%@page import="java.sql.Timestamp"%>

<%@ page import="modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String rootPath = request.getContextPath()+"/";
	String sAction = request.getParameter("sAction");
	int iIdPiece = Integer.parseInt(request.getParameter("iIdPiece"));
	
	MarchePieceJointe pieceJointe = MarchePieceJointe.getMarchePieceJointe(iIdPiece);
	if (pieceJointe != null)
	{
		if (sAction.equalsIgnoreCase("virtualRemove"))
		{
			pieceJointe.setLienActif(false);
			pieceJointe.setDateModif(new Timestamp(System.currentTimeMillis()));
			pieceJointe.store();

			boolean bIsDCEDisponible = marche.isDCEDisponible(false);
			
			if (bIsDCEDisponible)
			{
				marche.setDCEModifieApresPublication(true); 
				marche.setCandidatsPrevenusModificationDCE(false);
				marche.store();
			}
		}
		else if (sAction.equalsIgnoreCase("remove")){
		 pieceJointe.remove();
		}
	}
	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherAffaire.jsp?iIdOnglet=7&sAction=store&iIdAffaire=" + marche.getIdMarche()));
%>