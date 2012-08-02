<%@page import="modula.configuration.*"%>
<%@page import="org.coin.bean.conf.*"%>
<%@page import="modula.applet.util.*"%>
<%@page import="modula.applet.*"%>
<%@page import="modula.candidature.*"%>
<%@page import="java.sql.*"%>
<%
	/* Traitement des demandes d'informations complémentaires */
	if (vDemandes.size() > 0)
	{
		for (DemandeInfoComplementaire demande : (Vector<DemandeInfoComplementaire>)vDemandes)
		{
		%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="modula.applet.AppletConstitutionEnveloppe"%>
<br />
		<table class="pave" >
		<tr>
			<td class="pave_titre_gauche">
			Demande d'informations complémentaires du <%= CalendarUtil.getDateCourte(demande.getDateDebutRemise()) %> 
			au <%= CalendarUtil.getDateCourte(demande.getDateFinRemise()) %>
			</td>
		</tr>
		<tr><td><%= demande.getEtat() %></td></tr>
		<%
			/* Cas où la date de remise de la demande d'infos complémentaires n'a pas encore été fixée */
			if (demande.getDateFinRemise() != null)
			{
				Timestamp tsDateJour = new Timestamp(System.currentTimeMillis());
				Timestamp tsDateFinRemise = demande.getDateFinRemise();
				Timestamp tsDateFinUrgence = new Timestamp(tsDateFinRemise.getTime()+(marche.getDelaiUrgence()*60*60*100));
				
				if ( demande.isFlagFermetureRemise() 
					&& (tsDateJour.after(tsDateFinRemise)))
				{
					/* Demande infos complémentaire FERMEE && date fin remise atteinte*/
					sTitleListPJ = "Liste des pièces fournies pour la demande complémentaire";
					iIdTypeObjetEnv = ObjectType.ENVELOPPE_A;
					iIdTypeObjetEnvPJ = ObjectType.ENVELOPPE_A_PJ;
					vPiecesJointes = EnveloppeAPieceJointe.getAllEnveloppeAPieceJointeFromDemandeInfo(demande.getIdDemandeInfoComp());
					Vector vPiecesHorsDelais = EnveloppeAPieceJointe.getAllEnveloppeAPieceJointeHorsDelaisFromDemandeInfo(demande.getIdDemandeInfoComp());
					for(EnveloppeAPieceJointe pjHorsDelais : (Vector<EnveloppeAPieceJointe>)vPiecesHorsDelais)
						vPiecesJointes.add(pjHorsDelais);

					boolean bIsDemandeInfoCompDecachetees = true;
					if (vPiecesJointes.size() != EnveloppeAPieceJointe.getNbPieceJointeDecacheteeFromDemandeInfo(demande.getIdDemandeInfoComp()))
					{
						/* Si des pièces n'ont pas été décachetées alors on lance l'applet pour les décacheter */
						bIsDemandeInfoCompDecachetees = false;
						%>
							<tr>
								<td style="text-align:center">
									<applet code="modula.applet.AppletDecachetageEnveloppe.class" width="550" height="320" 
								  archive="<%= rootPath + "include/jar/" + AppletConstitutionEnveloppe.APPLET_VERSION %>"> 
										<param name="iIdMarche" value="<%= marche.getIdMarche() %>" >
										<param name="sUrlTraitement" value="<%= oURLTraitement.toString() %>" > 
										<param name="bIsDecachete" value="<%= bIsDemandeInfoCompDecachetees %>">
										<param name="iIdDemandeInfoComp" value="<%= demande.getIdDemandeInfoComp() %>">
										<param name="sTypeEnveloppe" value="<%= demande.getTypeEnveloppe() %>">
										<param name="sPathServlet" value="<%= oURLServlet.toString() %>">
										<param name="sPathImage" value="<%= oURLImage.toString() %>">
										<param name="sSessionId" value="<%= sSessionId %>">
										<param name="iTypeApplet" value="<%= AppletConstant.APPLET_DECACHETAGE_INFOS_COMPLEMENTAIRES %>">
										<param name="bSimulate" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_APPLET_SIMULATE) %>">
										<param name="sMailUser" value="<%= user.getEmail() %>">
										<param name="sNomUser" value="<%= user.getNom() %>">
										<param name="sPrenomUser" value="<%= user.getPrenom() %>">
										<param name="bAuthentificationUser" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AUTHENTIFICATION_UTILISATEUR) %>">
										<param name="bACValidation" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.UNSEALING_USE_CERTIFICATE_CHAIN) %>">
										<param name="bAVActive" value="<%= Configuration.getConfigurationValueMemory(ModulaConfiguration.MODULA_SECURITE_AV) %>">
									</applet>
								</td>
							</tr>
						<%
					}
					else
					{
						/* Dans le cas où toutes les pièces sont décachetées on les affiche prêtes à l'emploi */
					%>
						<tr><td>
						<%@ include file="tableListPJ.jsp" %>
						</td></tr>
					<%
					}
				}
			}
		%></table><%
		}
	}
%>
	<%
if (!bIsCandidaturePapier && !bIsClassementEnveloppesFige && 
!DemandeInfoComplementaire.existeDemandeInfoEnCoursPourEnveloppe(
		DemandeInfoComplementaire.TYPE_ENVELOPPE_A, eEnveloppe.getIdEnveloppe()))
{
%>
<div style="text-align:center">
	<button type="button" onclick="location.href='<%= response.encodeURL(rootPath
			+ "desk/marche/algorithme/ceu/creerDemandeInfosForm.jsp"
					+ "?id="+ eEnveloppe.getIdEnveloppe() 
				    + "&iIdAffaire=" + marche.getId()
					+ "&type=A"
				    + "&iIdLot="+iIdLot ) 
			%>'">
	Demander des informations complémentaires
	</button>
</div>
<%
	}
%>