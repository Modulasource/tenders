<%@ include file="/include/headerXML.jspf" %>

<%@ page import="java.sql.*,org.coin.fr.bean.mail.*,org.coin.fr.bean.*,modula.commission.*,org.coin.util.treeview.*,java.text.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, modula.candidature.*, org.coin.util.*"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));//input type="hidden" value="<%=iIdAffaire ...dans paveMailer
	Marche marche = Marche.getMarche(iIdAffaire);
	String sTitle = "Pr&eacute;venir les membres du lancement de l'affaire réf. " + marche.getReference();
	String rootPath = request.getContextPath()+"/";
	
	/* Récupération des membres de la commission */
	Vector<CommissionMembre> vMembres = CommissionMembre.getAllCommissionMembre(marche.getIdCommission()); 
%>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/calendar.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/checkbox.js"></script>
</head>
<body>
<% 
String sHeadTitre = "Prévenir les membres du lancement de l'affaire"; 
boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="../../include/headerAffaire.jspf" %>
<form action="<%=response.encodeURL("prevenirMembres.jsp")%>" method="post"  name="form" id="form" onsubmit="return validation();">
<br />
<!-- Membres de la commission -->
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche"> Membres de la commission </td>
	</tr>
	<tr>
		<td>
			<table class="liste" summary="none">
				<tr>
					<td>
					<a href="javascript:selectAll('document.formulaires.selection')">Sélectionner tous les membres</a> - 
					<a href="javascript:unselectAll('document.formulaires.selection')">Désélectionner tous les membres</a> - 
					</td>
				</tr>
			</table>
			<div id="division" style="height:80;overflow:auto;width:100%;padding:2px;text-align:left">
<%
	int iNbCols = 3;
	int iNbElts = 5;
	double dNbElts = Math.ceil(vMembres.size()/iNbCols);
	for (int i = 0; i < vMembres.size(); i++)
	{
		CommissionMembre membre = vMembres.get(i);
		PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique());
		if(i==0)
		{
%>
				<div class="colonne" style="width:<%=Math.round(100/iNbCols)%>%">
<%
		}
		else if((i%iNbElts)==0)
		{
%>
				</div>
				<div class="colonne" style="width:<%=Math.round(100/iNbCols)%>%">
<%
		}
%>
			<input type="checkbox" name="selection" value="<%= membre.getIdCommissionMembre() %>"/>
						<%= MembreRole.getMembreRoleName(membre.getIdMembreRole()) %> - 
						<%= personne.getNom() +" "+personne.getPrenom() %>
			<br /><br />
<%
	}
%>
				</div>
			</div>
		</td>
	</tr>
</table>
<!-- /Membres de la commission -->
<br />
<%
MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_CAO_LANCEMENT_MARCHE);
String sTitrePave = "Mail à envoyer";
String[] sBalisesActives = {"[mode_passation]", "[reference]", "[nom_commission]", "[date_mise_en_ligne]",
							"[civilite_personne_loguee]", "[nom_personne_loguee]"};
boolean bJoindreAAPC = true;
boolean bJoindreAATR = false;
%>
<%@ include file="../../../include/paveMailer.jspf" %>
<br />
<div style="text-align:center">
	<input type="submit" name="store_btn" id="store_btn" value="Prévenir les membres" />
</div>
</form>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>