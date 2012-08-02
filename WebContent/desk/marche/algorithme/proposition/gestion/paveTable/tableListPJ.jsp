<%@page import="modula.candidature.EnveloppePieceJointe"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="org.coin.security.Quarantaine"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.security.ClamAV"%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">
		<%= sTitleListPJ %>
		</td>
	</tr>
	<tr>
		<td>
			<table class="liste" summary="none">
				<tr>
					<th>Nom du document</th>
					<th style="text-align:right">T&eacute;l&eacute;chargement</th>
				</tr>
				<%
					/* Traitement des pièces jointes de l'enveloppe courante */
					for (int j = 0; j < vPiecesJointes.size(); j++)
					{
						/* Récupération de l'objet EnveloppeAPieceJointe courant */
						EnveloppePieceJointe pieceJointe = ((Vector<EnveloppePieceJointe>)vPiecesJointes).get(j);

						boolean bIsDecacheteLocalement = pieceJointe.isDecacheteLocal(false);
						boolean bIsVirus = pieceJointe.isVirus(false);
						
						String sURLFile = "desk/DownloadFileDesk?"
								+ DownloadFile.getSecureTransactionStringFullJspPage(
										request, 
										pieceJointe.getIdEnveloppePieceJointe() , 
										iIdTypeObjetEnv );
								
						sURLFile = response.encodeURL(rootPath+ sURLFile);
						String sIconFile = rootPath + Icone.ICONE_DOWNLOAD;
						
						String sNomPJ = pieceJointe.getNomPieceJointe();
						
						Quarantaine virus = null;
						if(bIsVirus)
						{
							bExistVirus = true;
							try{virus = Quarantaine.getAllQuarantaineFromTypeAndReferenceObjet(iIdTypeObjetEnvPJ,pieceJointe.getIdEnveloppePieceJointe()).firstElement();}
							catch(Exception e){}
							
							sNomPJ = "<font class=\"rouge\">" + pieceJointe.getNomPieceJointe() + " vérolé : "+ClamAV.getVirusFromReport(virus.getRapport())+" *</font>";
							sURLFile = response.encodeURL(
									rootPath+ "desk/DownloadFileDesk?"
											+ DownloadFile.getSecureTransactionStringFullJspPage(
													request, 
													virus.getId(), 
													ObjectType.QUARANTAINE ));
							
							sIconFile = rootPath + Icone.ICONE_DOWNLOAD_VIRUS;
							
							String sURLRapportFile = response.encodeURL(
									rootPath+ "desk/DownloadFileDesk?"
											+ DownloadFile.getSecureTransactionStringFullJspPage(
													request, 
													virus.getId(), 
													ObjectType.QUARANTAINE_RAPPORT ));
							String sIconRapportFile = rootPath + Icone.ICONE_FICHIER_DEFAULT;
							
							sNomPJ += "&nbsp;&nbsp;<a href=\""+sURLRapportFile+"\">";
							sNomPJ += "<img src=\""+sIconRapportFile+"\"  title=\"Rapport\" alt=\"Rapport\" />";
							sNomPJ += "</a>";
						}
						%>
					<tr>
						<td> 
						<%= sNomPJ %>
						</td>
						<td style="text-align:right">
						<%
						if (pieceJointe.getChiffrage() == 0)
						{
							if(bIsDecacheteLocalement && !bIsVirus)
							{
								String sFilePath = sVaultPath+sFileSeparator+"mdemat"+iIdAffaire+sFileSeparator
								+eEnveloppe.getIdCandidature()+sFileSeparator+sTypeEnveloppe+eEnveloppe.getIdEnveloppe()
								+sFileSeparator+pieceJointe.getIdEnveloppePieceJointe()+"_"+pieceJointe.getNomPieceJointe();	
							%>
							<applet code="org.coin.applet.OpenLocalFile.class" width="70" height="20" 
				  			archive="<%=  rootPath + "include/jar/SOpenLocalFile.jar" %>">
				  			<param name="sFilePath" value="<%= sFilePath %>" />
							</applet>
							<%
							}
							%>
							<a href="<%= sURLFile %> ">
								<img src="<%= sIconFile %>"  title="Télécharger" alt="Télécharger" />
							</a>
						<%
						}else{%><%= "Pièce non décachetée" %><%}%>
						</td>
					</tr>
					<%
					}
					%>
				</table>
			</td>
		</tr>
	</table>