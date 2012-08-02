<%@ include file="/include/new_style/headerDesk.jspf" %>
<% 
	String sTitle = "Modification en masse des Mails Types"; 
	String sPageUseCaseId = "IHM-DESK-xxx";
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId);

	String sAction = HttpUtil.parseStringBlank("sAction", request);
	String sSearchString = HttpUtil.parseStringBlank("sSearchString", request);
	String sReplacementString = HttpUtil.parseStringBlank("sReplacementString", request);
	
	String sMessage = "";
	
	if(sAction.equals("replaceAll"))
	{
		String sSearchString2 = PreventInjection.preventStore(sSearchString);
        sSearchString2 = XMLEntities.cleanUpXMLEntities(sSearchString2);
        sSearchString2 = Outils.replaceAll(sSearchString2, "\\\"", "\"");
        sSearchString2 = Outils.replaceAll(sSearchString2, "\\\'", "\'");

        String sReplacementString2 = PreventInjection.preventStore(sReplacementString);
		sReplacementString2 = XMLEntities.cleanUpXMLEntities(sReplacementString2 );
		sReplacementString2 = Outils.replaceAll(sReplacementString2, "\\\"", "\"");
        sReplacementString2 = Outils.replaceAll(sReplacementString2, "\\\'", "\'");
		
        System.out.println("sSearchString2 : " + sSearchString2);
        System.out.println("sReplacementString2 : " + sReplacementString2 );
		
        MailType.replaceAll(
        		sSearchString2 ,
				sReplacementString2);
		sMessage = "Remplacement effectué";
	}
	
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
<form id="form" action="<%= response.encodeURL("modifyAllBatchMailTypeForm.jsp") %>" >
<div class="rouge" style="text-align:left" id="divError"></div>
	<table class="formLayout fullWidth" >
	<input type="hidden" name="sAction" value="replaceAll" />
	<tr>
		<td class="label">
			Remplacer :
		</td>
		<td class="frame">
			<input type="text" name="sSearchString" value="<%= sSearchString %>" size="80" />
		</td>
	</tr>
	<tr>
		<td class="label">
			Par :
		</td>
		<td class="frame">
			<input type="text" name="sReplacementString" value="<%= sReplacementString %>" size="80" />
		</td>
	</tr>
	
	<tr>
		<td class="label">
			
		</td>
		<td class="frame">
			<%= sMessage %>
		</td>
	</tr>
	</table>
</div>
<div id="fiche_footer">
	<button type="submit" >Valider</button>
</div>
</form>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.mail.MailType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.security.PreventInjection"%>

<%@page import="org.coin.util.XMLEntities"%>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="org.coin.util.Outils"%></html>
