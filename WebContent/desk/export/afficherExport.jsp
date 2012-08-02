<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.export.*" %>
<%
	String sTitle = "Afficher un transfert";
	String sSubmitButtonName = "";
%>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%
	int iIdExportType = 1;
	String sUrlRedirect ="afficherTousExport.jsp?foo=1";
	
	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	Export export = null;
	String sAction = request.getParameter("sAction");
	
	export = Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
	sSubmitButtonName = "Modifier";
	
	 
	Vector <ExportType> vExportType = ExportType.getAllStaticMemory();
	
	String sTypeObjetSourceName = "indéfini";
	try{sTypeObjetSourceName = modula.TypeObjetModula.getTypeObjetModulaName( export.getIdTypeObjetSource());}
	catch(Exception e){}
	
	String sObjetReferenceSourceName = "?";
	
	try{
		sObjetReferenceSourceName =
			modula.TypeObjetModula.getIdObjetReferenceName(
				export.getIdTypeObjetSource(), 
				export.getIdObjetReferenceSource());
	} catch (Exception e) {}
	
	String sObjetReferenceDestinationName = "?";
	try{
		sObjetReferenceDestinationName = 
			modula.TypeObjetModula.getIdObjetReferenceName(
				export.getIdTypeObjetDestination(), 
				export.getIdObjetReferenceDestination());
	} catch (Exception e) {}
	
	String sExportModeName = "";
	try {
		sExportModeName= ExportMode.getExportModeNameMemory(export.getIdExportMode());
	} catch (Exception e) {
		sExportModeName = "indéfini !! : id type=" + export.getIdExportMode();
	}
	
	Vector vTypeObjetModula = modula.TypeObjetModula.getAllTypeObjetModula();
	Vector<ExportParametre> vExportParametres = ExportParametre.getAllFromIdExport(export.getIdExport());
	
	
	%>
	<form action="none" method="post" >
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td class="pave_cellule_gauche">Libellé :</td>
			<td class="pave_cellule_droite"><%= export.getName() %>
			</td>
		</tr>

		<tr>
			<td class="pave_cellule_gauche">Mode :</td>
			<td class="pave_cellule_droite">
				<%= sExportModeName %>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : source</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td class="pave_cellule_gauche">Type de source :</td>
			<td class="pave_cellule_droite"><%=  sTypeObjetSourceName %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Référence de la source :</td>
			<td class="pave_cellule_droite"><%= sObjetReferenceSourceName %></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : destination</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td class="pave_cellule_gauche">Sens :</td>
			<% 
				String sExportSensImage = "";
				String sExportSensImageTag ;
				if(export.getIdExportSens() == 1)
				{
					sExportSensImage = Icone.ICONE_GAUCHE;
					sExportSensImageTag = "<img src=\"" + rootPath + sExportSensImage+"\" width=\"10\" alt=\"Sens du transfert\" /> (Export)";
				}
				else
				{
					sExportSensImage = Icone.ICONE_DROITE;
					sExportSensImageTag = "<img src=\"" + rootPath + sExportSensImage+"\" width=\"10\" alt=\"Sens du transfert\" /> (Import)";
				}
				
				
			 %>
			<td class="pave_cellule_droite"><%= sExportSensImageTag  %>
			</td>
		</tr>
		
		<tr>
			<td class="pave_cellule_gauche">Type de destination :</td>
			<td class="pave_cellule_droite">
				<%
			    String sNameTypeObjetDestination = "indéfini";
				try{sNameTypeObjetDestination = modula.TypeObjetModula.getTypeObjetModulaName(export.getIdTypeObjetDestination());}
				catch(Exception e){}
				%>
				<%= sNameTypeObjetDestination %>
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">Référence de la destination :</td>
			<td class="pave_cellule_droite">
				<%= sObjetReferenceDestinationName %>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<%
	if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
	{
		Vector vDestinataires = ExportModeEmailDestinataire.getAllDestinatairesFromExport(export.getIdExport());
	%><%@ include file="pave/pageExportModeEmail.jspf" %><%
	} 
	
	if (export.getIdExportMode() == ExportMode.MODE_FTP) 
	{
		ExportModeFTP exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
	%><%@ include file="pave/pageExportModeFtp.jspf" %><%
	} 
	
	if (export.getIdExportMode() == ExportMode.MODE_HTTP) 
	{
	} 
	if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
	{
		ExportModeWS exportModeWS = ExportModeWS.getExportModeWS(export.getIdExportModeId());
	%><%@ include file="pave/pageExportModeWebService.jspf" %><%
	} 
	
	sUrlRedirect += "&amp;iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
				 + "&amp;nonce=" +System.currentTimeMillis();
	
	%>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : paramètres complémentaires</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
<%
	for(int i=0; i< vExportParametres.size() ; i++)
	{
		ExportParametre param = vExportParametres.get(i);
 %>
		<tr>
			<td class="pave_cellule_gauche">
				<%= param.getName() %></td>
			<td class="pave_cellule_droite">
				<table summary="none">
					<tr>
						<td><%= param.getValue() %></td>
						<td style="text-align:right">
							<button type="button" onclick="Redirect('<%=
								response.encodeURL( 
									 "modifierExportParametre.jsp?sAction=remove"
									+"&amp;iIdExportParametre=" + param.getIdExportParametre()
									+ "&amp;sUrlRedirect=" + sUrlRedirect) %>')" >Supprimer</button>
						</td>
					</tr>
				</table>
			</td>
		</tr>
<% }%>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td colspan="2" style="text-align:center">
				<button type="button" onclick="Redirect('<%=
					response.encodeURL( 
						 "modifierExportParametre.jsp?sAction=create"
						+ "&amp;iIdExport=" + export.getIdExport()
						+ "&amp;sUrlRedirect=" + sUrlRedirect)  %>')" >Ajouter Paramètre</button>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<div id="fiche_footer">
	<button type="button" onclick="Redirect('<%=
		response.encodeURL( 
			rootPath + "desk/export/modifierExportForm.jsp?sAction=store&amp;iIdExport="
			+ export.getIdExport()
			+ "&amp;sUrlRedirect=" + sUrlRedirect) %>')" ><%= sSubmitButtonName %></button>
	<button type="button" onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" >Retour</button>
    </div>
	</form>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>
