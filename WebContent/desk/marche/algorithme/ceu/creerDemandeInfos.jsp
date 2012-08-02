<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.marche.*, modula.candidature.* " %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Demande d'informations complémentaires pour l'affaire réf. " + marche.getReference();
	String sFormPrefix = "";
	
	String sTypeEnveloppe = request.getParameter(sFormPrefix + "sTypeEnveloppe");
	int iIdEnveloppe = Integer.parseInt(request.getParameter(sFormPrefix + "iIdEnveloppe"));
	int iIdLot = Integer.parseInt(request.getParameter("iIdLot"));
	
	DemandeInfoComplementaire demande = new DemandeInfoComplementaire();
	demande.setDemandeInfo(request.getParameter(sFormPrefix + "sDemandeInfo"));
	demande.setIdEnveloppe(iIdEnveloppe);
	demande.setTypeEnveloppe(sTypeEnveloppe);
	
	demande.create();
	
	/* Récupération de l'identifiant de la candidature */
	EnveloppeA enveloppe = EnveloppeA.getEnveloppeA(iIdEnveloppe);
	String sMessTitle = "Succès de l'étape";
	String sMess = "La demande d'informations complémentaires a été stockée et sera envoyée avec toutes les autres demandes.";
	String sUrlIcone = Icone.ICONE_SUCCES;
%>
<script type="text/javascript">
onPageLoad = function(){
	try{parent.frames[0].showEnvoiComp();}
	catch(e){parent.showEnvoiComp();}
}
</script>
</head>
<body>
<div style="padding:15px">
	<table height="100%">
	<tr>
    	<td style="vertical-align:middle" height="100%">
<%@ include file="/include/message.jspf" %>
		<div style="text-align:center">
			<button type="button"
				onclick="location.href='<%= response.encodeURL(rootPath
				+ "desk/marche/algorithme/proposition/gestion/ouvrirEnveloppeA.jsp?iIdCandidature=" 
						+ enveloppe.getIdCandidature() + "&amp;iIdLot="+iIdLot ) %>'" >
				Revenir à la candidature</button>
		</div>
		</td>
	</tr>
</table>
</div>
</body>
<%@page import="modula.graphic.Icone"%>
</html>