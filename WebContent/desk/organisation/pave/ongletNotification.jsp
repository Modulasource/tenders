<jsp:useBean id="sessionLanguage" class="org.coin.localization.Language" />
<%@page import="org.coin.util.JavascriptVersion"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.localization.Localize" %>
<%@page import="org.coin.fr.bean.PersonnePhysique" %>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre" %>
<%@page import="mt.paraph.folder.util.ParaphFolderMail" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.Vector" %>
<%@page import="org.json.*" %>
<%@page import="org.coin.localization.LocalizeButton" %>
<%
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}
	String rootPath = request.getContextPath() +"/";
%>
<jsp:include page="/include/js/localization/localization.jsp" flush="false">
	<jsp:param name="iIdLang" value="<%= localizeButton.iIdLanguage %>" />
</jsp:include>
<script src="<%=rootPath%>include/js/json2.js" ></script>
<script src="<%=rootPath%>include/js/singleListAdminGUI.js?v=<%=JavascriptVersion.SINGLE_LIST_ADMIN_GUI%>"></script>
<style>
	HR {
		background-color: #EAEDF3;
		border-width: 0px;
		border-bottom: 1px solid #E3DFCB;
		height: 5px;
	}
</style>
<%
	/** DB Connection **/
	Connection conn = (Connection) request.getAttribute ("conn");

	/** Localization **/
	Localize locTab = (Localize) request.getAttribute("locTabs");
	Localize locButton = (Localize) request.getAttribute ("locAddressBookButton");
	Localize locBloc = (Localize) request.getAttribute ("locBloc");
	Localize locMessage = (Localize) request.getAttribute ("locMessage");
	Localize locTitle = (Localize) request.getAttribute ("locTitle");

	/** HTTP Parameters **/
	long lIdPersonnePhysique = Long.valueOf (request.getParameter("lIdPersonne"));
	int iIdOnglet = Integer.valueOf (request.getParameter ("iIdOnglet"));
	String sAction = request.getParameter ("sAction");
	
	/** Action **/
	final int ACTION_SHOW = 1;
	final int ACTION_UPDATE = 2;
	int iAction = "update".equals (sAction) ? ACTION_UPDATE : ACTION_SHOW;
	
	%>
	<script>
	var addressesAdminGUI = new SingleListAdminGUI ();
	addressesAdminGUI.onValidation = function (label){
		if (mt.utils.isEmailValid (label))
			return true;
		alert (MESSAGE_TITLE[3]);		
		return false;
	};

	function getAddresses (){
		var options = addressesAdminGUI.listBox.select.options;
		var vAddresses = [];
		for (var i = 0; i < options.length; ++i)
			vAddresses [i] = options [i].listBoxItem.label;
		return eval (JSON.stringify (vAddresses));
	}

	function onFormNotificationsSubmit (){
		var hddAddresses = $("hddAddresses");
		hddAddresses.value = getAddresses ();
		return true;
	}
	</script>
	<%
	
	switch (iAction){
		/** Show the form **/
		case ACTION_SHOW:
		{
			/** Form state **/
			boolean bDisableMailNotification = 
								ParaphFolderMail.isMailNotificationDisabled(
									lIdPersonnePhysique,
									conn);
			
			boolean bDisableMailNotificationLogged = 
				ParaphFolderMail.isMailNotificationLoggedDisabled(
					lIdPersonnePhysique,
					conn);
			
			
			/** HTML Renderization **/
			%>
			<form id="formNotifications" method="POST" onsubmit="onFormNotificationsSubmit ()">
			<table class="pave">
				<tr><td class="pave_titre_gauche"><%=locTitle.getValue(40, "Les options de notification")%></td></tr>
				<tr>
					<td>
						<input type="hidden" name="lIdPersonne" value="<%=lIdPersonnePhysique%>" />
						<input type="hidden" name="iIdOnglet" value="<%=iIdOnglet%>" />
						<input type="hidden" name="sAction" value="update" />
						<input type="hidden" name="sAddresses" id="hddAddresses" />
						<table cellpadding="5" cellspacing="10" style="vertical-align:middle">
							<tr>
								<td style="vertical-align:bottom;">
									<input type="checkbox" name="bDisableMailNotification" value="true"
										autocomplete="off" <%=bDisableMailNotification ? "checked" : ""%> /></td>
								<td style="vertical-align:middle"><%=locTitle.getValue (38, "Ne plus recevoir de mails de notifications du système")%></td>
							</tr>
							<tr>
								<td style="vertical-align:bottom;">
									<input type="checkbox" name="bDisableMailNotificationLogged" value="true"
										autocomplete="off" <%=bDisableMailNotificationLogged ? "checked" : ""%> /></td>
								<td style="vertical-align:middle"><%=locTitle.getValue (39, "Ne pas recevoir de mails si ma session est ouverte")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td class="pave_titre_gauche"><%=locTitle.getValue (41, "Autres adresses e-mail")%></td></tr>
				<tr>
					<td>
						<table style="text-align: center">
							<tr><td><div id="divListAdminGUI" /></td></tr>
						</table>							
					</td>
				</tr>
				<tr><td><hr/></td></tr>
				<tr><td style="text-align:center"><button type="submit"><%=locButton.getValue (37, "Valider")%></button></td></tr>
			</table>
			</form>
			<script>
			$("divListAdminGUI").appendChild (addressesAdminGUI.getElement ());
			</script>
			<%
		}
		break;
		
		/** Update part **/
		case ACTION_UPDATE:
		{
			/** HTTP Parameters **/
			boolean bDisableMailNotification = "true".equals (request.getParameter ("bDisableMailNotification"));
			boolean bDisableMailNotificationLogged = "true".equals (request.getParameter ("bDisableMailNotificationLogged"));
			String sAddresses = request.getParameter ("sAddresses");
			
			/** Alternative e-mail addresses**/
			JSONArray jsonAddresses = new JSONArray (sAddresses);
			Vector <String> vAddresses = new Vector <String> ();
			for (int i = 0; i < jsonAddresses.length(); ++i)
				vAddresses.add (jsonAddresses.getString(i));

			/** Database access **/
			ParaphFolderMail.setMailNotificationDisabled(lIdPersonnePhysique, bDisableMailNotification, conn);
			ParaphFolderMail.setMailNotificationLoggedDisabled(lIdPersonnePhysique, bDisableMailNotificationLogged, conn);
			PersonnePhysique personnePhysique = PersonnePhysique.getPersonnePhysique (lIdPersonnePhysique);
			personnePhysique.setAdditionalEMailAddresses (vAddresses);
			
			/** HTML Renderization **/
			%>
			<form id="formNotifications" method="POST" onsubmit="onFormNotificationsSubmit ()">
			<table class="pave">
				<tr><td><div id="message" style="text-align: left;" class="rouge"><%=locMessage.getValue (60, "Mail notification options have been saved successfully")%></div><br/></td></tr>
				<tr><td class="pave_titre_gauche"><%=locTitle.getValue(40, "Les options de notification")%></td></tr>
				<tr>
					<td>
						<input type="hidden" name="lIdPersonne" value="<%=lIdPersonnePhysique%>" />
						<input type="hidden" name="iIdOnglet" value="<%=iIdOnglet%>" />
						<input type="hidden" name="sAction" value="update" />
						<input type="hidden" name="sAddresses" id="hddAddresses" />
						<table cellpadding="5" cellspacing="10" style="vertical-align:middle">
							<tr>
								<td style="vertical-align:bottom;">
									<input type="checkbox" name="bDisableMailNotification" value="true"
										autocomplete="off" <%=bDisableMailNotification ? "checked" : ""%> /></td>
								<td style="vertical-align:middle"><%=locTitle.getValue (38, "Ne plus recevoir de mails de notifications du système")%></td>
							</tr>
							<tr>
								<td style="vertical-align:bottom;">
									<input type="checkbox" name="bDisableMailNotificationLogged" value="true"
										autocomplete="off" <%=bDisableMailNotificationLogged ? "checked" : ""%> /></td>
								<td style="vertical-align:middle"><%=locTitle.getValue (39, "Ne pas recevoir de mails si ma session est ouverte")%></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td class="pave_titre_gauche"><%=locTitle.getValue (41, "Autres adresses e-mail")%></td></tr>
				<tr>
					<td>
						<table style="text-align: center">
							<tr><td><div id="divListAdminGUI" /></td></tr>
						</table>							
					</td>
				</tr>
				<tr><td><hr/></td></tr>
				<tr><td style="text-align:center"><button type="submit"><%=locButton.getValue (37, "Valider")%></button></td></tr>
			</table>
			</form>
			<script>
			$("divListAdminGUI").appendChild (addressesAdminGUI.getElement ());
			</script>
		<%
		}
		break;
	}
%>
<script>
<%
{
	PersonnePhysique personnePhysique = PersonnePhysique.getPersonnePhysique (lIdPersonnePhysique, true, conn);
	for (String address : personnePhysique.getAdditionalEMailAddresses())
		out.println ("addressesAdminGUI.addItem ('" + address + "', '" + address + "');");
}
%>
addressesAdminGUI.listBox.setSelectedIndex (0);
</script>