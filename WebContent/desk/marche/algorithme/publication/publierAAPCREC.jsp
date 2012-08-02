<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.export.*" %>
<%@ page import="org.coin.fr.bean.*,modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Publicité de l'Avis Rectificatif de l'AAPC";
	
	String sImageStatusValide = "<img width='16' src='"+ rootPath + modula.graphic.Icone.ICONE_SUCCES + "' />";
	String sImageStatusNonValide = "<img width='16' src='"+ rootPath + modula.graphic.Icone.ICONE_WARNING + "' />";
	int iIdAvisRectificatif = HttpUtil.parseInt("iIdAvisRectificatif", request, 0);
	try{
		AvisRectificatif avis = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
		avis.setMailPublicationEnvoye(true);
		avis.store();
		
		if(marche.isAffaireAAPC() && avis.isAllEtapesForRectificationValides())
		{
			marche.setAffaireEnCoursDeRectification(false);
			marche.store();
		}
	}
	catch(Exception e){}
%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body onload="cacher('patienter');">
<% 
String sHeadTitre = "Publicité de l'Avis Rectificatif de l'AAPC"; 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %><br />
<br />
<div id="patienter" style="text-align:center" class="mention">
Veuillez patientez, Traitement en cours ...
</div>
<br />
<table class="pave" 
	<tr><td colspan="2" class="pave_titre_gauche">Traitement des publications Web</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche"><%=sImageStatusValide %></td>
		<td class="pave_cellule_droite" style="vertical-align:middle">&nbsp;Publication de l'avis rectificatif sur le site Internet des journaux du portail</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<br />
<%
	if(marche.isPubliePapier()){
%>
<table class="pave"><tr><td colspan="2" class="pave_titre_gauche">Traitement des publications Papier</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
<%
		out.flush();
		Vector<Publication> vPublicationsAAPCREC 
			= Publication.getAllPublicationFromMarcheAndTypeAndEtat(
					iIdAffaire,
					PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AAPC,
					PublicationEtat.ETAT_A_ENVOYER,
					false,
					false);
		
		for(int i=0;i<vPublicationsAAPCREC.size();i++)
		{
			Publication publi = vPublicationsAAPCREC.get(i);
			try{
				PublicationSpqr spqr = PublicationSpqr.getPublicationSpqrFromPublication(publi.getIdPublication());
				spqr.load();
			}
			catch(Exception e){
				Export export = Export.getExport(publi.getIdExport());
				String sRaisonSociale = "";
				try
				{
					if(export.getIdTypeObjetDestination() == org.coin.bean.ObjectType.ORGANISATION)
					{
						Organisation org = Organisation.getOrganisation(
								export.getIdObjetReferenceDestination(), false);
						sRaisonSociale = org.getRaisonSociale();
					}
				}
				catch(Exception e2){}
				
				try
				{
					out.write("<tr>");
					publi.publish(sessionUser,request);
					out.write("<td class=\"pave_cellule_gauche\">" +  sImageStatusValide + "</td>");
					out.write("<td class=\"pave_cellule_droite\">&nbsp;Publication de l'avis rectificatif sur " 
						+ sRaisonSociale + "</td>");
					out.write("</tr>");
					out.flush();
				}
				catch(Exception e3)
				{
					e.printStackTrace();
				}
			}
		}
%>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<%
	}else{
		Connection conn = ConnectionManager.getConnection();
		PersonnePhysique ppFrom = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
		Marche affaire = Marche.getMarche(iIdAffaire, conn, false);
		PublicationPublissimo.publishCommerciauxWebOnly(ppFrom,affaire, conn);
		ConnectionManager.closeConnection(conn);
	}
	out.flush();
%>
<br />
<div style="text-align:center">
	<button type="button" 
		onclick="Redirect('<%= response.encodeURL(
				rootPath + "desk/marche/algorithme/affaire/afficherAffaire.jsp?"
					+ "iIdAffaire="+iIdAffaire
				+"&amp;iIdOnglet="+modula.graphic.Onglet.ONGLET_AFFAIRE_RECTIFICATIF
				+"&amp;iIdAvisRectificatif="+iIdAvisRectificatif
				+"&amp;sActionRectificatif=show"
				+"&amp;none="+System.currentTimeMillis()
				+"&#ancreHP") %>')" >Revenir à l'avis rectificatif</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
</html>