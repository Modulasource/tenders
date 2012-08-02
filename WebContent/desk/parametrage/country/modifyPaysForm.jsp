<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.html.*" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.fr.bean.Pays"%>
<% 
	String sTitle = "Country : "; 

	Pays item = null;
	String sPageUseCaseId = "xxx";
	
	String sAction = request.getParameter("sAction");
	if(sAction.equals("create"))
	{
		item = new Pays();
		sTitle += "<span class=\"altColor\">New Object Type</span>"; 
	}
	
	if(sAction.equals("store"))
	{
		item = Pays.getPays(request.getParameter("sId"));
		sTitle += "<span class=\"altColor\">"+item.getId()+"</span>"; 
	}

	HtmlBeanTableTrPave pave = new HtmlBeanTableTrPave();
	pave.bIsForm = true;
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
	
	ObjectLocalization olFr = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_FRENCH, ObjectType.PAYS ,item.getIdString());
	ObjectLocalization olEn = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_ENGLISH, ObjectType.PAYS ,item.getIdString());

%>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/ObjectType.js"></script>
</head>
<body>

<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<form action="<%= response.encodeURL("modifyPays.jsp") %>" method="post" name="formulaire">
<div id="fiche">
		<input type="hidden" name="sAction" value="<%= sAction %>" />
		<table class="formLayout" cellspacing="3">
		    <%= pave.getHtmlTrInput("ID :", "sId", item.getIdString(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("Name :", "sLibelle", item.getLibelle(),"size=\"100\"") %>
		    <%= pave.getHtmlTrInput("ISO 3166 Alpha 2 :", "sIso3166Alpha2", item.getIso3166Alpha2(),"size=\"100\"") %>
		</table>

<br/>
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2">
				Localization
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
			French :
			</td>
			<td class="pave_cellule_droite">
			<input type="text" name="sLocalization_fr" size="100" maxlength="255" 
			value="<%= olFr.getValue() %>" />
			</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
			English :
			</td>
			<td class="pave_cellule_droite">
			<input type="text" name="sLocalization_en" size="100" maxlength="255" 
			value="<%= olEn.getValue() %>" />
			</td>
		</tr>
	</table>	

		
</div>
<div id="fiche_footer">
	<button type="submit" >Valid</button>
	<button type="button" onclick="javascript:doUrl('<%=
			response.encodeURL("displayAllPays.jsp") %>');" >
			<%= localizeButton.getValueCancel() %></button>
</div>
</form>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>

</html>
