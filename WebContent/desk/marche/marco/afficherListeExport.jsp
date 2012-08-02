<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="java.util.*,org.w3c.dom.*,org.coin.util.*,modula.ws.marco.*" %>
<% String sTitle = "Exports de Marco" ;%>
<script type="text/javascript" >
	function removeAffaire()
	{
		return confirm("Vous allez supprimer définitivement l'import Marco. Etes vous sûr(e)?");
	}
</script>
</head>
<body>
<%@ include file="../../../../include/new_style/headerFiche.jspf" %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"><%=sTitle%></td>
		</tr>
		<tr>
			<td>
				<table class="liste" summary="none">
					<tr>
						<th style="width:20%">Mise à jour</th>
						<th style="width:15%">Code P.R.M.</th>
						<th style="width:15%">Code Affaire</th>
						<th style="width:40%">Libellé de l'affaire</th>
						<th style="width:10%">Import</th>
					</tr>
		
	<%
		boolean bAvaiable = true;		
		Vector vExports = ExportMarco.getAll();
		MarcoAffaire aff = null;
		
		for(int i = 0 ; i < vExports.size()  ; i++)
		{
			ExportMarco export = (ExportMarco ) vExports.get(i);
			try {
				Document doc = BasicDom.parseXmlStream(export.getExport() , false);
				if (doc != null)
				{
					aff = new MarcoAffaire(BasicDom.getFirstChildElementNode(BasicDom.getFirstChildElementNode(doc)));
				}
				bAvaiable = true;
			} catch (Exception e) {
				System.out.println("exception pour l'export " + export.getIdExportMarco());
				//e.printStackTrace();
				aff = new MarcoAffaire();
				aff.sCodeOrigine = "Analyse échouée !";
				bAvaiable = false;
			}
			
			String sUrlTarget = response.encodeURL("afficherExportPostAnalyse.jsp?iIdExportMarco="+export.getIdExportMarco());
			String sUrlTargetRemove = response.encodeURL("modifierExport.jsp?sAction=remove&amp;iIdExportMarco="+export.getIdExportMarco());
	%>
					<tr class="liste<%=i%2%>" 
						onmouseover="className='liste_over'" 
						onmouseout="className='liste<%=i%2%>'" 
						onclick="Redirect('<%= sUrlTarget %>')">
						<td style="text-align:left;width:20%"><%= org.coin.util.CalendarUtil.getDateFormattee(export.getDateDerniereModification())%></td>
						<td style="width:15%"><%= aff.sCodeOrigine %></td>
						<%
						if (bAvaiable ) 
						{%>
						<td style="text-align:left;width:15%"><%= aff.sNumeroAffaire + " - " + aff.dossiers[0].lots.length + " lot(s)" %></td>
						<td style="text-align:left;width:40%"><%= aff.sLibelle %></td>
						<td style="text-align:right;width:10%">
						<a href='<%= sUrlTarget %>' >
							<img width="21" height="21" 
								src="<%= rootPath +modula.graphic.Icone.ICONE_CONTINUER_PROCEDURE %>" 
								 
								alt="Continuer la proc&eacute;dure" 
								title="Continuer la proc&eacute;dure" 
								onmouseover="this.src='<%= rootPath +modula.graphic.Icone.ICONE_CONTINUER_PROCEDURE_OVER%>'" 
								onmouseout="this.src='<%= rootPath +modula.graphic.Icone.ICONE_CONTINUER_PROCEDURE%>'" />
						</a>
						<a href='<%= sUrlTargetRemove %>' >
							<img width="21" height="21" 
								src="<%= rootPath %>images/icones/annuler_marche.gif" 
								 
								alt="Supprimer l'import" 
								title="Supprimer l'import" 
								onmouseover="this.src='<%= rootPath %>images/icones/annuler_marche_over.gif'" 
								onmouseout="this.src='<%= rootPath %>images/icones/annuler_marche.gif'"
								onclick="javascript:return removeAffaire()" />
						</a>
						</td><%
						} else {
						%> <td style="width:15%">&nbsp;</td><td style="width:50%">&nbsp;</td><td style="width:10%">&nbsp;</td>
						<% }%> 
						
					</tr>
		<%
			}
		//<a href='../desk/marche/marco/choisirPRM.jsp?idaffaire=<%= export.getIdExportMarco() 
		
		%>
				</table>
			</tr>
	</table>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
