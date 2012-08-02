<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*,org.coin.bean.conf.*,java.util.*" %>
<%
	String sTitle = "Groupe de compétences spécifiques (CPF): ";
	CodeCpfGroup item = null;
	String sPageUseCaseId = "xxx";
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	if (sAction.equals("create")) {
		item = new CodeCpfGroup();
	}
	if (sAction.equals("store")) {
		long lId = HttpUtil.parseLong("lId",request);
		
		item = CodeCpfGroup.getCodeCpfGroupMemory(lId,true);
		sTitle += "<span class=\"altColor\">"
		+ item.getId() + " - "
		+ item.getName() +"</span>";

	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/CodeCpfGroup.js"></script>
<script type="text/javascript">
function displayAllCPFGroup() {
	location.href = "<%=
		response.encodeURL("displayAllCPFGroup.jsp")
		%>";
}

function removeItem(id)
{
    if(confirm("Voulez vous vraiment effacer ce groupe de compétence ?")){
    	CodeCpfGroup.removeFromId(id,function() { 
            location.href = '<%=response
									.encodeURL("displayAllCPFGroup.jsp")%>';
           });
     }
}
</script>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyCPFGroup.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="lId" id="lId" value="<%=item.getId()%>" />
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		
		<table class="formLayout" cellspacing="3">
		<%=pave.getHtmlTrInput("Nom :", "sName", item.getName(), "size=\"100\"")%>
		<%=pave.getHtmlTrInput("Référence Externe :", "sReferenceExterne", item.getReferenceExterne(), "size=\"100\"")%>
		<tr>
			<td class="pave_cellule_gauche">
				<select name="lIdBoampCPF" size="15" style="width:400px" multiple="multiple" >
				<%
				Vector<BoampCPF> vCPFItem = CodeCpfGroupItem.getAllBoampCPFFromGroup(item.getId());
				Vector<BoampCPF> vCPF = BoampCPF.getAllStaticMemory();

				for (BoampCPF cpf : vCPF)
				{
					boolean bDisplayCPF = true;
					for (BoampCPF cpfItem : vCPFItem)
					{
						if(cpfItem.getId() == cpf.getId())
						{
							bDisplayCPF = false;
						}
					}
					if(bDisplayCPF )
					{
						out.write("<option value='"+ cpf.getId() +"'>" + cpf.getName() + "</option>");
					}
				}
		  %>
                </select>
			</td >
			<td >
				<table  >
					<tr>
						<td style="width : 100px" align="center">
							<a href="javascript:DeplacerTous(document.formulaire.lIdBoampCPFSelection,document.formulaire.lIdBoampCPF)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_GAUCHE%>"  
								alt="Enlever" /></a>
							<a href="javascript:DeplacerTous(document.formulaire.lIdBoampCPF,document.formulaire.lIdBoampCPFSelection)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_DROITE%>"  
								alt="Ajouter" /></a> 
						</td>
						<td>
							<select name="lIdBoampCPFSelection" size="15" style="width:400px" multiple="multiple" >
							<%
							for (BoampCPF cpfItem : vCPFItem)
							{
								out.write("<option value='"+ cpfItem.getId() +"'>" + cpfItem.getName() + "</option>");
							}
							%>
		                    </select>
							<input type="hidden" name="lIdBoampCPFSelectionList" />
						</td>
					</tr>
				</table>

		  </td>
		</tr>
		</table>
</div>


<div id="fiche_footer">
	<button type="submit" onclick="javascript:Visualise(document.formulaire.lIdBoampCPFSelection,document.formulaire.lIdBoampCPFSelectionList);">Valider</button>
<%
if(sAction.equals("store"))
{

%>
	<button type="button" onclick="removeItem(<%= item.getId() %>);">Supprimer</button>
<%
}
%>
	<button type="button" onclick="javascript:displayAllCPFGroup();">Annuler</button>
</div>
</form>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="modula.marche.MarchePieceJointeType"%>

<%@page import="org.apache.jasper.xmlparser.ParserUtils"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroupItem"%></html>
