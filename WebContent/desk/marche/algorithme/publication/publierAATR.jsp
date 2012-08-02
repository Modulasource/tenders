<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.export.*,modula.algorithme.*" %>
<%@ page import="org.coin.fr.bean.*,modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Publicité de l'AATR";
	
	String sImageStatusValide = "<img width='16' src='"+ rootPath + modula.graphic.Icone.ICONE_SUCCES + "' />";
	String sImageStatusNonValide = "<img width='16' src='"+ rootPath + modula.graphic.Icone.ICONE_WARNING + "' />";
	
	int iIdNextPhaseEtapes = -1;
	if(request.getParameter("iIdNextPhaseEtapes") != null)
		iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body onload="cacher('patienter');">
<% 
	String sHeadTitre = "Publicité de l'AATR"; 
	boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
<br />
<div id="patienter" style="text-align:center" class="mention">
Veuillez patientez, Traitement en cours ...
</div>
<br />
<table class="pave" >
	<tr><td colspan="2" class="pave_titre_gauche">Traitement des publications Web</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche"><%=sImageStatusValide %></td>
		<td class="pave_cellule_droite" style="vertical-align:middle">&nbsp;Publication de l'AATR sur le site Internet des journaux du portail</td>
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
		Vector<Publication> vPublicationsAATR
			= Publication.getAllPublicationFromMarcheAndTypeAndEtat(
					iIdAffaire,
					PublicationType.TYPE_AATR,
					PublicationEtat.ETAT_A_ENVOYER,
					false,
					false);
		
		for(int i=0;i<vPublicationsAATR.size();i++)
		{
			Publication publi = vPublicationsAATR.get(i);
			try{
				PublicationSpqr spqr = PublicationSpqr.getPublicationSpqrFromPublication(publi.getIdPublication());
				spqr.load();
			}
			catch(Exception e){
				Export export = Export.getExport(publi.getIdExport());
				String sRaisonSociale = "";
				try
				{
					if(export.getIdTypeObjetDestination() == ObjectType.ORGANISATION)
					{
						Organisation org 
							= Organisation.getOrganisation(
									export.getIdObjetReferenceDestination(), 
									false);
						
						sRaisonSociale = org.getRaisonSociale();
					}
				}
				catch(Exception e2){}
				
				try
				{
					out.write("<tr>");
					String sImageStatusPublish = sImageStatusValide;
                    String sPublishException = "";
					try
	                {
					    publi.publish(sessionUser,request);
	                }
	                catch(Exception e4)
	                {
	                	sImageStatusPublish = sImageStatusNonValide;
                        e4.printStackTrace();
                        sPublishException 
                            = e4.getMessage()
                            + "<br/>"
                            + "Erreur : " + sPublishException;
                    }	                
					out.write("<td class=\"pave_cellule_gauche\">" +  sImageStatusPublish + "</td>");
					out.write("<td class=\"pave_cellule_droite\">&nbsp;Publication de l'AATR sur " 
						+ sRaisonSociale 
						+ sPublishException
						+ "</td>");
					out.write("</tr>");
					out.flush();
				}
				catch(Exception e3)
				{
					e3.printStackTrace();
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

	boolean bIsPetiteAnnonce = false;
	int iTypeProcedure = AffaireProcedure.getTypeProcedure(marche.getIdAlgoAffaireProcedure());
	if(iTypeProcedure == AffaireProcedure.TYPE_PROCEDURE_PETITE_ANNONCE) bIsPetiteAnnonce = true;
	
	int iNbEtape = 3;
	if(bIsPetiteAnnonce) iNbEtape = 0;
	for(int i=0;i<iNbEtape;i++){
		PhaseEtapes oPhaseEtapes = AlgorithmeModula.getNextPhaseEtapesInProcedure(iIdNextPhaseEtapes);
		iIdNextPhaseEtapes = (int)oPhaseEtapes.getId();
	}
	try{
		marche.setIdAlgoPhaseEtapes(iIdNextPhaseEtapes);
	}
	catch(Exception e){
		System.out.println("Exception > publierAATR.jsp: "+e.getMessage());
	}
	AvisAttribution avis = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	
	avis.setAATREnvoyeSurPublisher(true);
	avis.setAATREnvoyeAutresSupportPublication(true);
	avis.store();
	marche.store();
%>
<br />
<div style="vertical-align:middle;text-align:center">
	<button type="button"
		onclick="Redirect('<%= response.encodeURL(rootPath 
				+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
				+ "?sAction=next"
				+ "&iTesterConditions=1"
				+ "&iIdAffaire=" + marche.getId()) 
		%>')" >Poursuivre la procédure</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.bean.ObjectType"%>
</html>