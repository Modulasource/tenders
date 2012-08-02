<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="include/localization.jspf" %>
<%
	String sAction = request.getParameter("sAction");
%>

<script language="JavaScript">

function fixElement(element, message, select) {
	alert(message);
	if(select)
		element.select();
	element.focus();
}

function verify(form) {
	var passed = false;
	var sIdParaphFolder =  document.getElementById("sIdParaphFolder");
	if (sIdParaphFolder.value == "") {
		fixElement(sIdParaphFolder, "<%=locMessage.getValue(1,"S'il vous plaît entrez le numéro du dossier") %>",false);
	}
	else if(isNaN(sIdParaphFolder.value))
	{
		fixElement(sIdParaphFolder, "<%=locMessage.getValue(2,"N'est pas un nombre valide, s'il vous plaît essayez de nouveau") %>",true);
	}
	else {
		passed = true;
	}
	return passed;
}

onPageLoad = function(){
	document.getElementById("sIdParaphFolder").focus();
}
</script>

</head>
<body>
<form name="formulaire" id="formulaire" method="post" action="<%=response.encodeURL("inputParaphFolderAdmin.jsp")%> " onSubmit = "return verify(this);">
<input type="hidden" name="sAction" value="<%= sAction %>" />
	<table align="center" width="300" border="0" cellspacing="5" cellpadding="2">
		<tr></tr>
		<tr></tr>
		<tr></tr>
	    <tr>
		    <td class="label" align="right"><%=locTitle.getValue(2,"Numéro du dossier") %> :</td>
			<td><input name="sIdParaphFolder" type="text" id="sIdParaphFolder" size="10"></td>
		</tr>
		<tr></tr>
		<tr></tr>
	    <tr align="center">
	    	<td colspan="2"><button type="submit" ><%= localizeButton.getValueSubmit() %></button>&nbsp;&nbsp;&nbsp;<button type="button" onclick="javascript:closeModal();" ><%= localizeButton.getValueCancel() %></button></td>
		</tr>
		
    </table>    
</form>
</body>
</html>