<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="java.util.*,org.w3c.dom.*,org.coin.util.*,org.coin.fr.bean.*,modula.commission.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sPageUseCaseId = "CU-PUBLISSIMO-002";
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Synchronisation du carnet d'adresses" ;
%><%@ include file="../include/checkHabilitationPage.jspf" %>
<%@ include file="../include/headerDesk.jspf" %>
</head>
<body>
<a name="ancreHP">&nbsp;</a>
	<div class="titre_page"> <%=sTitle%> </div>
<%
	String sFileName = request.getParameter("sFilename");
	String sPathFileFTP = sessionUser.getPath() + "/web/ftp/carnetAdresses/"; 
	CarnetAdresseWrapper ca = new CarnetAdresseWrapper(sPathFileFTP);
	try{
		out.write("<table class=\"pave\">" +
					"<tr><td class=\"pave_cellule_droite\">" +
					"&nbsp;Lecture du fichier XML sur le répertoire FTP, cette opération peut prendre quelques instants, merci de patienter." +
					"</td></tr>");
	}
	catch(Exception e){e.printStackTrace();}
	out.flush();
	Connection conn = ConnectionManager.getDataSource().getConnection();
	ca.synchroniserFichier(sFileName, conn); 
 	try{
		out.write("</table>");
	}
	catch(Exception e){e.printStackTrace();}
	conn.close();
	
	PersonnePhysique personne =	PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	modula.journal.Evenement.addEvenement(personne.getIdPersonnePhysique(), "CU-PUBLISSIMO-002", sessionUser.getIdUser(),
	 personne.getIdPersonnePhysique()+" "+ personne.getPrenom()+" "+ personne.getNom()+" "+"Importe le carnet d'adresses PUBLISSIMO");

	String sMessTitle="Succès de l'import du carnet d'adresse PUBLISSIMO.";
	String sMess = "Tous les organismes ainsi que les commissions et les personnes physiques qui les composent ont été synchronisés avec la base Modula.";
	String sUrlIcone = modula.graphic.Icone.ICONE_SUCCES;
%>
<br />
<%@include file="../../include/message.jspf" %>
<div style="text-align:center">
	<input type="button" onclick="Redirect('<%=response.encodeURL("afficherListeFichiersSynchroCarnetAdresses.jsp")%>')" 
		value="Retour à la liste des fichiers à synchroniser" />
</div>
<%@ include file="../include/footerDesk.jspf" %>
</body>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
</html>