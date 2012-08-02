
<%@ page import="org.coin.util.*,java.util.*, modula.marche.*" %>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sHiddenRedirectURL = HttpUtil.parseStringBlank("sHiddenRedirectURL", request);
	boolean bIsRectification = HttpUtil.parseBoolean("bIsRectification", request,false);

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
%>
<%@page import="modula.graphic.Icone"%>
<script type="text/javascript">
function confirmSubmit(phrase,url){
	var agree=confirm("Etes vous sûr de vouloir "+phrase);
	if (agree)
		Redirect(url);
	else
		return false ;
}
function confirmLotissement(bAfficheMessage){
	var agree = true;
	if(bAfficheMessage)
	{
		agree=confirm("Attention si vous avez déjà defini des lots, celà les supprimera, Etes-vous sûr?");
	}
	if (agree)
	{
		document.formulaire.sHiddenRedirectURL.value = "<%= sHiddenRedirectURL %>&nonce=<%=System.currentTimeMillis()%>#ancreHP";
		document.formulaire.submit();
	}
	else
		return false ;
}
</script>


<input type="hidden" name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet %>" />
<input type="hidden" name="sHiddenRedirectURL" value="" />
<%
	String sNbLots = "";
	String sCheckedUnique = "";
	String sCheckedSepare = "";
	String sOnClickUnique = "";
	String sOnClickSepare = "";
	
	switch(vLots.size())
	{
		case 0:
			sNbLots = "Aucun lot";
			sCheckedUnique = "";
			sCheckedSepare = "";
			sOnClickUnique = "onclick=\"return confirmLotissement();cacher('trGestionLots');\" ";
			sOnClickSepare = "onclick=\"return confirmLotissement();montrer_cacher('trGestionLots');\" ";
			break;
			
		case 1:
			sNbLots = "Non Alloti";
			sCheckedUnique = "checked='checked'";
			sCheckedSepare = "";
			sOnClickUnique = "onclick=\"cacher('trGestionLots');\" ";
			sOnClickSepare = "onclick=\"return confirmLotissement();montrer_cacher('trGestionLots');\" ";
			break;
			
		default:
			sNbLots = vLots.size() + " lots";
			sCheckedUnique = "";
			sCheckedSepare = "checked='checked'";
			sOnClickUnique = "onclick=\"return confirmLotissement(true);cacher('trGestionLots');\" ";
			sOnClickSepare = "onclick=\"montrer_cacher('trGestionLots');\" ";
			break;
	}
%>


<table class="pave">
	<tr>
		<td class="pave_titre_gauche">Allotissement de l'affaire</td>
		<td class="pave_titre_droite"><%= sNbLots %></td>
	</tr>	
	<tr>
		<td class="pave_cellule_gauche" style="vertical-align:middle">Allotissement de l'affaire: </td>
		<td class="pave_cellule_droite" style="vertical-align:middle">
		<input <%= bIsRectification?"disabled=\"disabled\"":"" %> type="radio" name="iLotissement<%= bIsRectification?"_rectif":"" %>" value="1" <%= sCheckedUnique %> <%= sOnClickUnique %>  />Unique&nbsp;&nbsp;
		<input <%= bIsRectification?"disabled=\"disabled\"":"" %> type="radio" name="iLotissement<%= bIsRectification?"_rectif":"" %>" value="2" <%= sCheckedSepare %> <%= sOnClickSepare %> />Alloti
		<% if(bIsRectification){ %>
		<input type="hidden" name="iLotissement" value="<%= (sCheckedSepare.equalsIgnoreCase("")?"1":"2") %>" />
		<%} %>
		</td>
	</tr>
	<tr id="trGestionLots" >
		<td colspan="2">
			<table  width="100%">
				<tr>
					<td class="pave_cellule_gauche">&nbsp;</td>
					<td class="pave_cellule_droite">&nbsp;</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche" style="vertical-align : top;">
						<a href='javascript:openModal("<%=response.encodeURL(rootPath+"include/avertissementUtilisateur.jsp?id="+InfosBullesConstant.GERER_LOTS)%>","Avertissement");'>
						<img src="<%=rootPath + Icone.ICONE_AU%>" alt="Avertissement utilisateur" title="Avertissement utilisateur" width="21" height="21"  style="vertical-align:middle" />
						</a>
						Possibilité de présenter une offre pour :
					</td>
					<td class="pave_cellule_droite">
					<%
					Vector presentationOffres = MarchePresentationOffre.getAllMarchePresentationOffre();
					for (int i = 0; i < presentationOffres.size(); i++)
					{
						MarchePresentationOffre presentation = (MarchePresentationOffre)presentationOffres.get(i);
						String sChecked = "";
						if ( ( i == 0) 
						|| (presentation.getId() == marche.getPresentationOffre() ) ) 
							sChecked = "checked";
					%>
					<input type="radio" name="<%= sFormPrefix %>iPresentationOffre" 
						value="<%= presentation.getId() %>"
						<%= sChecked %> /> <%= presentation.getName() %>&nbsp;
					<%
					}
					%>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<table class="pave" width="100%">
						<% if(!bIsRectification){ %>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2" style="text-align:center">
									<button type="button" 
									onclick="javascript:openModal('<%= 
										response.encodeURL(rootPath 
												+ "desk/marche/algorithme/affaire/modifierLotForm.jsp"
												+ "?sAction=create"
												+ "&iIdOnglet=" + iIdOnglet
												+ "&iIdAffaire=" + marche.getId() ) 
						%>','Ajouter un lot', '800px', '500px');" >ajouter un lot</button>
								</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
							</tr>	
							<%} %>
							<tr>
								<td colspan="2">
									<table class="liste" width="100%">
										<tr>
											<th>Numéro</th>
											<th>Référence</th>
											<th>Désignation réduite</th>
											<th>Date d'exécution</th>
											<th>Date de livraison</th>
											<th>&nbsp;</th>
										</tr>					
										<%
										if(vLots != null)
										{
										for (int j = 1; j <= vLots.size(); j++)
										{
											MarcheLot lot = vLots.get(j-1);
											String sUrlModification = response.encodeURL(rootPath 
													+ "desk/marche/algorithme/affaire/modifierLotForm.jsp"
													+ "?sAction=store"
                                                    + "&iIdMarcheLot=" + lot.getIdMarcheLot()
                                                    + "&iIdAffaire=" + marche.getId()
													+ "&iIdOnglet="+iIdOnglet) ;
										%>
										<tr class="liste<%=j%2%>" onmouseover="className='liste_over'" 
						  				onmouseout="className='liste<%=j%2%>' ">
						    				<td style="width:1%"><%= lot.getNumero()  %></td>
						    				<td style="width:10%"><%= lot.getReference()  %></td>
						    				<td style="width:20%"><%= lot.getDesignationReduite()  %></td>
									    	<td style="width:15%"><%= CalendarUtil.getDateCourte( lot.getDateExecution() )  %></td>
									    	<td style="width:15%"><%= CalendarUtil.getDateCourte( lot.getDateLivraison() )   %></td>
									    	<td style="width:5%">
												<table >
													<tr>
														<td>
														<%
														if(lot.getNumero() != 1)
														{
														%>
															<a href="javascript:Redirect('<%= response.encodeURL("modifierOrdreLot.jsp?sAction=moveUp&amp;iIdMarcheLot="+lot.getIdMarcheLot()+"&amp;iIdOnglet="+iIdOnglet+"&amp;iIdAffaire="+marche.getId()) %>')">
																<img width="15" height="12" title="monter" alt="monter"  
																	src="<%= rootPath + Icone.ICONE_HAUT %>" />
															</a>	
														<%
														}
														%>	
														</td>	
														<td>
														<%
														if( (lot.getNumero() != vLots.size()) )
														{
														%>	
															<a href="javascript:Redirect('<%= response.encodeURL("modifierOrdreLot.jsp?sAction=moveDown&amp;iIdMarcheLot="+lot.getIdMarcheLot()+"&amp;iIdOnglet="+iIdOnglet+"&amp;iIdAffaire="+marche.getId()) %>')">
																<img width="15" height="12" title="descendre" alt="descendre"  
																	src="<%= rootPath + Icone.ICONE_BAS %>" />
															</a>
														<%
														}
														%>	
														</td>
														<td>
															<a href="javascript:void(0);" onclick="javascript:openModal('<%= 
																sUrlModification 
																%>','Modifier le lot <%= Outils.replaceAll( lot.getReference(), "&#039;", "\\'") %>', '800px', '500px');">
																<img title="modifier" alt="modifier"  src="<%= rootPath + "images/icones/modifier_marche.gif" %>" />
															</a>
														</td>
														<td>
														<%
														if(vLots.size() > 2 && !bIsRectification)
														{
														%>	
															<a href="javascript:void(0);" onclick="confirmSubmit('supprimer le lot <%= lot.getReference() 
																%> ?','<%= response.encodeURL("modifierLot.jsp"
																		+ "?sAction=remove"
																		+ "&iIdMarcheLot=" +lot.getIdMarcheLot()
																		+ "&iIdOnglet="+iIdOnglet
																		+ "&iIdAffaire="+marche.getId()
                                                                        ) %>')">
																<img width="18" height="20" title="supprimer" alt="supprimer"  src="<%= 
																	rootPath + Icone.ICONE_SUPPRIMER %>" />
															</a>
														<%
														}
														%>
														</td>
													</tr>
												</table>
											</td>
										</tr>
										<%
										}
										}
										%>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr >
			</table>
		</td>
	</tr >
	</table>