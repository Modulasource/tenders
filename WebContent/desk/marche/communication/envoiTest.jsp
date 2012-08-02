<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,org.coin.fr.bean.mail.*,mt.modula.bean.mail.*" %>
<%
	// R�cup�ration du mail dans la session
	PersonnePhysique ppRecipiendaire = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sTitle = "Envoi de l'email de test";
	String sMessTitle = "";
	String sMess = "";
	String sUrlIcone = "";
%>
</head>
<body>
<%@ include file="../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<%
if (request.getParameter("id") != null){
	int iIdMailType = Integer.parseInt(request.getParameter("id"));
	MailType mailType = MailType.getMailTypeMemory(iIdMailType,false);
	
	MailModula mm = new MailModula();
	mm.setSubject("[TEST] " + mailType.getObjetType());
	mm.setTo(ppRecipiendaire.getEmail());
	mm.addMessage(mailType.getContenuType());
	mm.addMessageHTML(mailType.getContenuTypeHTML());

	if (mm.send()){
		sMessTitle = "Succ�s de l'envoi de l'email test";
		sUrlIcone = rootPath + Icone.ICONE_SUCCES;
		sMess = "Vous allez bient�t recevoir l'email de test dans votre bo�te � lettre.";
	}else{
		sMessTitle = "Echec de l'envoi de l'email test";
		sUrlIcone = rootPath + Icone.ICONE_SUCCES;
		sMess = "Un probl�me de transmission s'est produit lors de l'envoi de l'email de test. Nous vous conseillons "
			+ " de recommencer la proc�dure d'envoi.";
	}
}else{
	sMessTitle = "Echec de l'envoi de l'email test";
	sUrlIcone = rootPath+Icone.ICONE_ERROR;
	sMess = "L'email type propos� pour envoi de test n'est pas coh�rent.";
}
%>
<table class="pave" align="center">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%=sMessTitle%></td>
	</tr>
	<tr>
		<td class="message_icone"><img src="<%=sUrlIcone%>"></td>
		<td><%=sMess%></td>
	</tr>
</table>
<br /><br />
<div style="text-align:center">
	<button type="button" name="fermer"  onclick="window.close();" >Fermer</button>
</div>
</div>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>