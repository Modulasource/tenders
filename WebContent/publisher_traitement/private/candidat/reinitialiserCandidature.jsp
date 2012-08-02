
<%@ page import="org.coin.fr.bean.*,modula.*, modula.candidature.*, java.util.*" %>
<%@ include file="../../public/include/beanSessionUser.jspf" %>
<%@ include file="../../public/include/beanCandidat.jspf" %> 
<%@ include file="../../../include/publisherType.jspf" %>
<%
	String rootPath = request.getContextPath()+"/";
	
	String sCand = request.getParameter("cand");
	Candidature candidature = Candidature.getCandidature(Integer.parseInt(
            SecureString.getSessionPlainString(
            sCand,session)));
	if (candidature == null)
	{
		%><html><body>Dossier inconnu</body></html><% 
		return;	
	}
	
	String sAction=request.getParameter("action");
	
	if(sAction.equalsIgnoreCase("candidature") || sAction.equalsIgnoreCase("all"))
	{
		Vector vEnveloppesA = EnveloppeA.getAllEnveloppeAFromCandidature(candidature.getIdCandidature());
		for (int i = 0; i < vEnveloppesA.size(); i++)
		{
			EnveloppeA eEnveloppe = (EnveloppeA)vEnveloppesA.get(i);
			eEnveloppe.removeWithObjectAttached();
		}
		candidature.setEnveloppeAConstituee(false);
	}
	
	if(sAction.equalsIgnoreCase("offre"))
	{
		String sIdEnveloppeB = request.getParameter("iIdEnveloppeB");
		EnveloppeB enveloppeB = EnveloppeB.getEnveloppeB(Integer.parseInt(sIdEnveloppeB));
		enveloppeB.removeWithObjectAttached();
	
		candidature.setEnveloppeBConstituee(false);
	}
	
	if(sAction.equalsIgnoreCase("offreC"))
	{
		String sIdEnveloppeC = request.getParameter("iIdEnveloppeC");
		EnveloppeC enveloppeC = EnveloppeC.getEnveloppeC(Integer.parseInt(sIdEnveloppeC));
		enveloppeC.removeWithObjectAttached();
	
		candidature.setEnveloppeCConstituee(false);
	}
	candidature.setDossierCachete(false); 
	candidature.store();
	/* Message */
	String sMess = "";
	String sMessTitle = "Succès";
	String sTitle = "";
	String sUrlIcone= modula.graphic.Icone.ICONE_SUCCES;
	
	if(sAction.equalsIgnoreCase("candidature")) sTitle="Votre candidature a été réinitialisée.";
	if(sAction.equalsIgnoreCase("offre") || sAction.equalsIgnoreCase("offreC")) sTitle="Votre offre a été réinitialisée.";
	if(sAction.equalsIgnoreCase("all")) sTitle="Votre dossier de candidature a été intégralement réinitialisé.";
	sMess = sTitle 	+ "<br /><br /><button onclick=javascript:Redirect('"
					+ response.encodeURL(rootPath + sPublisherPath
					+ "/private/candidat/consulterDossier.jsp?cand="
					+ sCand + "&amp;iIdOnglet=2") 
					+ "') type='button' >Constituer à nouveau le dossier de candidature</button>";

	/* /Message */

	session.setAttribute("sessionPageTitre", sTitle);
	session.setAttribute("sessionMessageTitre", sMessTitle);
	session.setAttribute("sessionMessageLibelle", sMess);
	session.setAttribute("sessionMessageUrlIcone", sUrlIcone);

	response.sendRedirect( response.encodeURL(rootPath + "include/afficherMessagePublisher.jsp")  );		
%>