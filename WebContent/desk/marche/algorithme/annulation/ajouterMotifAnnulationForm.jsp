<%@ include file="/include/headerXML.jspf" %>

<%@ page import="org.coin.util.treeview.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, org.coin.util.*"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String rootPath = request.getContextPath()+"/";
	String sTitle = "Annuler l'affaire - Motif";
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet")); 
	String sIsProcedureLineaire = null;
	try{
		sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	}
	catch(Exception e){}
	String sUrlRedirect = rootPath+"desk/export/boamp/afficherXmlGenereBoampPourAvisAnnulation.jsp?iIdExport="+iIdExport+"&iIdAffaire="+iIdAffaire;
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
<script type="text/javascript">
	function checkForm(){
		if(document.formulaire.sMotifAnnulation.value.length<5){
			alert("Le motif d'annulation doit faire au moins 5 caractères");
			document.formulaire.sMotifAnnulation.focus();
			return false;
		}
	}
</script>
</head>
<body>
<div class="titre_page"><%=sTitle %></div>
<form name="formulaire" action="<%=response.encodeURL("ajouterMotifAnnulation.jsp") %>" onsubmit="javascript:return checkForm()">
<table class="pave" >
	<tr onclick="montrer_cacher('paveMotifAnnulation')">
		<td class="pave_titre_gauche" colspan="2">Motif d'annulation</td>
	</tr>
	<tr>
		<td>
			<table id="paveMotifAnnulation" >
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td class="pave_cellule_gauche">
						Motif d'annulation * :
					</td>
					<td class="pave_cellule_droite">
					<input type="hidden" name="iIdExport" value="<%=iIdExport %>" />
					<input type="hidden" name="iIdOnglet" value="<%=iIdOnglet %>" />
					<input type="hidden" name="sIsProcedureLineaire" value="<%=sIsProcedureLineaire %>" />
					<textarea cols="80" rows="15" name="sMotifAnnulation" ><%=marche.getMotifAnnulation() %></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="2" style="text-align:center">
						<input type="submit" value="Valider" />
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
		</td>
	</tr>
</table>
</form>
<%@ include file="/include/footerDesk.jspf" %>
</body>
</html>