<%@ include file="../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.*,org.coin.bean.html.*,org.coin.fr.bean.export.*,java.util.*" %>
<%
	String sSubmitButtonName = "";
	String sUrlRedirect ="afficherTousExport.jsp?foo=1";
	

	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}
	Export export = null;
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		export = new Export();

		export.setIdObjetReferenceSource( Integer.parseInt(request.getParameter("iIdObjetReferenceSource")) );
		export.setIdTypeObjetSource( Integer.parseInt(request.getParameter("iIdTypeObjetSource")) );
		sSubmitButtonName = "Créer";
	}

	if(sAction.equals("store"))
	{
		export = Export.getExport(Integer.parseInt(request.getParameter("iIdExport")));
		sSubmitButtonName = "Modifier";
		
	}
	String sTitle = sSubmitButtonName + " Transfert";
%>
<script>
onPageLoad = function(){
    $("sName").className = "dataType-notNull obligatory";
    <% if(sAction.equals("create")) {%>
    $("iIdExportMode").className = "dataType-notNull dataType-id dataType-integer obligatory";
    <%}%>
    $("iIdTypeObjetDestination").className = "dataType-notNull dataType-id dataType-integer obligatory";
    $("iIdObjetReferenceDestination").className = "dataType-notNull dataType-id dataType-integer obligatory";
}
</script>
</head>
<body>
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<% 

	Vector <ExportType> vExportType = ExportType.getAllStaticMemory();
	
	String sTypeObjetSourceName = "indéfini";
	try{sTypeObjetSourceName = modula.TypeObjetModula.getTypeObjetModulaName( export.getIdTypeObjetSource());}
	catch(Exception e){}
	
	String sObjetReferenceSourceName = 
		modula.TypeObjetModula.getIdObjetReferenceName(
			export.getIdTypeObjetSource(), 
			export.getIdObjetReferenceSource());
	
	Vector vTypeObjetModula = modula.TypeObjetModula.getAllTypeObjetModula();
	Vector vExportMode = ExportMode.getAllStaticMemory();
	Vector<ExportParametre> vExportParametres = ExportParametre.getAllFromIdExport(export.getIdExport());
	
	sUrlRedirect += "&amp;iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
			 + "&amp;nonce=" +System.currentTimeMillis();

	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	%>
	<form action="<%= response.encodeURL( "modifierExport.jsp?sAction=" + sAction ) %>" method="post" class="validate-fields" >
		<input type="hidden" name="iIdExport" value="<%= export.getIdExport() %>" />	
		<input type="hidden" name="iIdTypeObjetSource" value="<%= export.getIdTypeObjetSource() %>" />	
		<input type="hidden" name="iIdObjetReferenceSource" value="<%= export.getIdObjetReferenceSource() %>" />
		<input type="hidden" name="sUrlRedirect" value="<%= sUrlRedirect%>" />
		<input type="hidden" name="iIdExportModeId" value="<%= export.getIdExportModeId() %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%= hbFormulaire.getHtmlTrInput("Libellé :","sName",export.getName(),"") %>
		<%
			if(sAction.equals("create")) 
			{
				ExportMode mode = new ExportMode(export.getIdExportMode());
				%>
				<%= hbFormulaire.getHtmlTrSelect("Mode :","iIdExportMode",mode) %>
				<% 
			} 
			else 
			{
				String sExportModeName = "";
				try {
					sExportModeName= ExportMode.getExportModeNameMemory(export.getIdExportMode());
				} catch (Exception e) {
					sExportModeName = "indéfini !! : id type=" + export.getIdExportMode();
				}
				
				hbFormulaire.bIsForm = false;
				%>
				<%= hbFormulaire.getHtmlTrInput("Mode :","",sExportModeName,"") %>
				<input type="hidden" name="iIdExportMode" value="<%= export.getIdExportMode() %>" />
				<%
				hbFormulaire.bIsForm = true;
			}%>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<% hbFormulaire.bIsForm = false; %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : source</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%= hbFormulaire.getHtmlTrInput("Type de source :","",sTypeObjetSourceName,"") %>
		<%= hbFormulaire.getHtmlTrInput("Référence de la source :","",sObjetReferenceSourceName,"") %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	<% hbFormulaire.bIsForm = true; %>
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : destination</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td class="pave_cellule_gauche" >Sens :</td>
			<% 
				String iIdExportSens1Selected = "";
				String iIdExportSens2Selected = " checked=\"checked\"";
				if( export.getIdExportSens()== 1)
				{
					iIdExportSens1Selected = "checked=\"checked\"";
					iIdExportSens2Selected = "";
				}
			 %>
			<td class="pave_cellule_droite" >
				<input type="radio" name="iIdExportSens"  value="1" <%= 
					iIdExportSens1Selected %>/><img src="<%= 
						rootPath + Icone.ICONE_GAUCHE 
						%>" width="10" alt="Sens du transfert" />(Export)<br />
				<input type="radio" name="iIdExportSens"  value="2" <%= 
					iIdExportSens2Selected %>/><img src="<%= 
						rootPath + Icone.ICONE_DROITE 
						%>" width="10" alt="Sens du transfert" />(Import)
			</td>
		</tr>
		<%
			TypeObjetModula type = new TypeObjetModula(export.getIdTypeObjetDestination());
		%>
		<%= hbFormulaire.getHtmlTrSelect("Type de destination :","iIdTypeObjetDestination",type) %>
		<%= hbFormulaire.getHtmlTrInput(
				"Référence de la destination :","iIdObjetReferenceDestination",
				export.getIdObjetReferenceDestination(),"") %>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<br />
	
	<%
	if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
	{
		Vector vDestinataires = ExportModeEmailDestinataire.getAllDestinatairesFromExport(export.getIdExport());
	%><%@ include file="pave/pageExportModeEmailForm.jspf" %><%
	} 
	if (export.getIdExportMode() == ExportMode.MODE_FTP) 
	{
		ExportModeFTP exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
	%><%@ include file="pave/pageExportModeFtpForm.jspf" %><%
	} 
	if (export.getIdExportMode() == ExportMode.MODE_HTTP) 
	{
	} 
	if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
	{
		ExportModeWS  exportModeWS = ExportModeWS.getExportModeWS(export.getIdExportModeId());
	%><%@ include file="pave/pageExportModeWebServiceForm.jspf" %><%
	} 
	
	sUrlRedirect += "&amp;iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
				 + "&amp;nonce=" +System.currentTimeMillis();
	
	%>
	
	<%if(sAction.equals("store"))
	{ %>
	<table class="pave" summary="Transfert : paramètres complémentaires">
		<tr>
			<td class="pave_titre_gauche" colspan="2">Transfert : paramètres complémentaires</td>
		</tr>
		<tr>
			<td colspan="2">
				<input type="hidden" name="iParamSize" value="<%= vExportParametres.size() %>" />
			</td>
		</tr>
		<%
			for(int i=0; i< vExportParametres.size() ; i++)
			{
				ExportParametre param = vExportParametres.get(i);
		 %>
		<tr>
			<td class="pave_cellule_gauche" >
				<input type="hidden" name="param_<%= i %>" value="<%= param.getIdExportParametre() %>" />
				<input type="text" name="paramName_<%= i %>" value="<%= param.getName() %>" />
			</td>
			
			<td class="pave_cellule_droite" >
				<input type="text" name="paramValue_<%= i %>" value="<%= param.getValue() %>" size="100" />
			</td>
		</tr>
		<% }%>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<% }%>

	<br />
	<div id="fiche_footer">
	<button type="submit" ><%= sSubmitButtonName %></button>
	<button type="button"  onclick="Redirect('<%=
		response.encodeURL( sUrlRedirect ) %>')" 
		>Retour</button>
	</div>
	
	</form>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.graphic.Icone"%>
</html>
