<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@ page import="org.coin.fr.bean.export.*,modula.algorithme.*" %>
<%@ page import="org.coin.fr.bean.*,modula.marche.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Publicité de l'AAPC";


	
	String sImageStatusValide = "<img width='16' src='"+ rootPath + Icone.ICONE_SUCCES + "' />";
	String sImageStatusNonValide = "<img width='16' src='"+ rootPath + Icone.ICONE_WARNING + "' />";
	
	int iIdNextPhaseEtapes = -1;
	if(request.getParameter("iIdNextPhaseEtapes") != null)
		iIdNextPhaseEtapes = Integer.parseInt(request.getParameter("iIdNextPhaseEtapes"));
%>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body onload="cacher('patienter');">
<% 
String sHeadTitre = "Publicité de l'AAPC"; 
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
<table class="pave" >
	<tr><td colspan="2" class="pave_titre_gauche">Traitement des publications Web</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td class="pave_cellule_gauche"><%=sImageStatusValide %></td>
		<td class="pave_cellule_droite" style="vertical-align:middle">&nbsp;Publication de l'AAPC sur le site Internet</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
</table>
<br />
<%
	if(marche.isPubliePapier(false)){
%>
<table class="pave"><tr><td colspan="2" class="pave_titre_gauche">Traitement des publications Papier</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
<%
		out.flush();
		Vector<Publication> vPublicationsAAPC 
			= Publication.getAllPublicationFromMarcheAndTypeAndEtat(
					iIdAffaire,PublicationType.TYPE_AAPC,
					PublicationEtat.ETAT_A_ENVOYER,
					false,
					false);
		
				
		for(int i=0;i<vPublicationsAAPC.size();i++)
		{
			Publication publi = vPublicationsAAPC.get(i);
			try{
				PublicationSpqr spqr = PublicationSpqr.getPublicationSpqrFromPublication(publi.getIdPublication());
				
				if(spqr == null) {
					throw new CoinDatabaseLoadException("Non SPQR","");
				}
			} catch(CoinDatabaseLoadException e){
							
				//on publie toutes les publications qui ne sont pas de type SPQR
				Export export = Export.getExport(publi.getIdExport());
				String sRaisonSociale 
					= "Warning Raison sociale non trouvée : export objet dest type=" + export.getIdTypeObjetDestination() 
					+ " ref=" + export.getIdObjetReferenceDestination();
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
				catch(Exception e2){
					e2.printStackTrace();
				}
				
				try
				{
					out.write("<tr>");
					String sImageStatusPublish = sImageStatusValide;
					String sPublishException = "";
                    try {
                    	   publi.publish(sessionUser,request);
	                } catch(Exception e4) {
	                	sImageStatusPublish = sImageStatusNonValide;
	                    e4.printStackTrace();
	                    sPublishException 
		                    = e4.getMessage()
		                    + "<br/>"
	                        + "Erreur : " + sPublishException;
	                }
					out.write("<td class=\"pave_cellule_gauche\">" +  sImageStatusPublish + "</td>");
					out.write("<td class=\"pave_cellule_droite\">&nbsp;Publication de l'AAPC sur " 
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
	}
	else{
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
		e.printStackTrace();
	}

	
	marche.setAffaireEnvoyeePublisher(true);
	marche.setAffaireEnvoyeeAutresSupportsPublication(true);
	marche.store();


%>
<br />
<div style="vertical-align:middle;text-align:center">
	<button type="button" 
		onclick="Redirect('<%= 
			response.encodeURL(rootPath 
					+ "desk/marche/algorithme/affaire/poursuivreProcedure.jsp"
					+ "?sAction=next"
					+ "&iTesterConditions=1"
					+ "&iIdAffaire=" + marche.getId()) 
		%>')" >Poursuivre la procédure</button>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>