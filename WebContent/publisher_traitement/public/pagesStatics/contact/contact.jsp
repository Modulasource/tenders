<%
String sTitle = "Contacter Matamore";
%>
<%@ include file="../../../../include/headerPublisher.jspf" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%
	String sContactRedirection = request.getParameter("sContactRedirection");
	String sNom = "";
	String sPrenom = "";
	String sRaisonSociale = "";
	String sEmail = "";
	String sTel = "" ;
	String sCivilite = "";
	String sInfosDemandeesHTML = "";
	String sInfosDemandees = "";
	String sFormation = "";
	String sCertificat = "";
	try{
		sNom = request.getParameter("nom");
	}catch(Exception e){}
	try{
		sPrenom = request.getParameter("prenom");
	}catch(Exception e){}
	try{
		sCivilite = request.getParameter("civilite");
	}catch(Exception e){}
	try{
		sEmail = request.getParameter("email");
	}catch(Exception e){}
	try{
		sRaisonSociale = request.getParameter("raison_sociale");
	}catch(Exception e){}
	try{
		sTel = request.getParameter("tel");
	}catch(Exception e){}
	try{
		sCertificat = request.getParameter("certificat");
	}catch(Exception e){}
	try{
		sFormation = request.getParameter("formation");
	}catch(Exception e){}
	try{
		if (sCertificat.equals("1")) {
			sInfosDemandeesHTML += " - les modalités d'obtention d'un certificat électronique.<br />";
			sInfosDemandees += " - les modalités d'obtention d'un certificat électronique.\n";
		}
	}catch(Exception e){}
	try{
		if (sFormation.equals("1")){
			sInfosDemandeesHTML += " - nos programmes de formation et d'accompagnement aux entreprises.<br />";
			sInfosDemandees += " - nos programmes de formation et d'accompagnement aux entreprises.\n";
		}
	}catch(Exception e){}
	String sMessage = "Merci, "+sCivilite+" "+sNom+" \n.Vous recevrez prochainement des informations concernants :<br />"+sInfosDemandeesHTML;

	
	String sContenu = sCivilite+" "+sNom+" " +sPrenom+ " de la société "+sRaisonSociale+" a demandé des informations concernant : \n"+sInfosDemandees+"\n son numéro de téléphone est le :"+sTel+"\nson email est :"+sEmail;
	Courrier courrier = new Courrier();
    courrier.setTo("assistance.modula@matamore.com");
	courrier.setDateStockage(new java.sql.Timestamp(System.currentTimeMillis()));
	courrier.setDateEnvoiPrevu(new java.sql.Timestamp(System.currentTimeMillis()));
	courrier.setSend(false);

	courrier.setSubject("Demande d'informations provenant d'une plate-forme Modula");
	
	courrier.setMessage(sContenu);
	courrier.create();
	MailModula mail = new MailModula();
	mail.computeFromCourrier(courrier);
	if(mail.send()){
		courrier.setSend(true);
		courrier.setDateEnvoiEffectif(new java.sql.Timestamp(System.currentTimeMillis()));
		courrier.store();
	}
	
	response.sendRedirect(response.encodeURL(rootPath+sContactRedirection+"?sMessage="+sMessage+"#formContact"));

%>