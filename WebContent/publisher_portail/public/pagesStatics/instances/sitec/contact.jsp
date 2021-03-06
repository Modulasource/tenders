<%
String sTitle = "Contacter Matamore";
%>
<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*" %> 
<%
	String sNom = "";
	String sPrenom = "";
	String sRaisonSociale = "";
	String sEmail = "";
	String sTel = "" ;
	String sCivilite = "";
	String sInfosDemandees = "";
	String sOffreEssai = "";
	String sContact = "";

	sNom = request.getParameter("nom");
	sPrenom = request.getParameter("prenom");
	sCivilite = request.getParameter("civilite");
	sEmail = request.getParameter("email");
	sRaisonSociale = request.getParameter("raison_sociale");
	sTel = request.getParameter("tel");
	sOffreEssai = request.getParameter("offreEssai");
	sContact = request.getParameter("contact");
%>

<%@page import="org.coin.util.WindowsEntities"%>
<%@page import="org.coin.util.HTMLEntities"%>

<%@page import="org.coin.util.Outils"%>
<%@page import="org.coin.util.HttpUtil"%><script  type="text/javascript" >
var contact_raison_sociale = "<%= sRaisonSociale %>";
var contact_nom = "<%= sNom %>";
var contact_prenom = "<%= sPrenom %>"; 
var contact_tel = "<%= sTel %>";
var contact_email = "<%= sEmail %>";
</script>
<%
	try{
	    Configuration confContactAnalyzer = Configuration.getConfigurationMemory("publisher.contact.analyser.hit.javascript", false);
	    out.write(
	    		WindowsEntities.cleanUpWindowsEntities(
	    				HTMLEntities.unhtmlentitiesComplete(
	    						confContactAnalyzer.getDescription())));
	} catch (Exception e) {
		//e.printStackTrace();
	}
%>
<%
	try{
		if (sOffreEssai.equals("1")) {
			sInfosDemandees += " - est int�ress� par une offre � l'essai.\n";
		}
	}catch(Exception e){}
	try{
		if (sContact.equals("1")){
			sInfosDemandees += " - souhaite �tre contact� pour avoir des informations sur les programmes de formation et d'accompagnement aux entreprises.\n";
		}
		if (sContact.equals("2")){
			sInfosDemandees += " - souhaite obtenir des informations sur les conditions tarifaires d'acc�s au portail et b�n�ficier d'une pr�sentation fonctionnelle compl�te.\n";
		}
		
	}catch(Exception e){}
	String sMessage = "Merci "+sCivilite+" "+sNom+", \n votre demande a bien �t� prise en compte.";

	
	String sContenu = sCivilite+" "+sNom+" " +sPrenom+ " de la soci�t� "+sRaisonSociale+" : \n"+sInfosDemandees+"\n son num�ro de t�l�phone est le :"+sTel+"\nson email est :"+sEmail;
	Courrier courrier = new Courrier();  
	courrier.setTo(Configuration.getConfigurationValueMemory("publisher.portail.contact.email","commercial@matamore.com"));
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
%>
<div style="text-align:center;margin-top:20px;">
	<p><%=Outils.replaceNltoBr(sMessage)%></p>
</div>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>