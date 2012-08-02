<jsp:useBean id="sessionLanguage" class="org.coin.localization.Language" />
<%@page import="org.coin.util.JavascriptVersion"%>
<%@page import="org.coin.util.*"%>
<%@page import="org.coin.localization.LocalizationConstant"%>
<%@page import="org.coin.localization.Localize" %>
<%@page import="org.coin.fr.bean.PersonnePhysique" %>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre" %>
<%@page import="mt.paraph.folder.util.ParaphFolderMail" %>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.Vector" %>
<%@page import="org.json.*" %>
<%@page import="org.coin.localization.LocalizeButton" %>
<%
/** Localization **/
	LocalizeButton localizeButton = null;
	try {
		localizeButton = new LocalizeButton(request);
	}catch (Exception e) {
		e.printStackTrace();
	}
	Localize locTitle = (Localize) request.getAttribute ("locTitle");
	Localize locBloc = (Localize) request.getAttribute ("locBloc");

	/** DB Connection **/
	Connection conn = (Connection) request.getAttribute ("conn");
	
	/** HTTP Parameters **/
	
	long lIdPersonnePhysique = HttpUtil.parseLong("lIdPersonne",request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request);	
	
	long lReloadValue
		= PersonnePhysiqueParametre.getPersonnePhysiqueParametreValueOptionalLong(
				lIdPersonnePhysique,
				PersonnePhysiqueParametre.PARAM_AUTO_RELOAD,
				0,
				conn);
	
	%>
	<script>
	onPageLoad = function() {

		try{
			showAutoReload();
		}catch(err){}

	}

	function showAutoReload()
	{
		var value;
		<%			
			if(lReloadValue > 0)
			{
			%>
				value=<%=lReloadValue%>;
				parent.showReload(true,false,value);
			<%
			}else{%>
				parent.showReload(false);
			<%}%>
	}
	
	</script>
	
		<form action="<%= response.encodeURL("modifierPersonnePhysique.jsp")%>"
			method="post"
		 	name="formReload" 
		 	id="formReload" >
			<table class="pave">
				<tr><td class="pave_titre_gauche"><%=locTitle.getValue(45, "Sélectionnez le temps de rafraîchissement")%></td></tr>
				<tr>
					<td>
						<input type="hidden" name="iIdPersonnePhysique" value="<%=lIdPersonnePhysique%>" />
						<input type="hidden" name="iIdOnglet" value="<%=iIdOnglet%>" />
						
						<table cellpadding="5" cellspacing="10" style="vertical-align:middle">
							<tr>
								<td style="vertical-align:bottom;">
									<select id="cbAutoReloadInverval" name="cbAutoReloadInverval">
										<option value="0" <%= (lReloadValue == 0)?"selected='selected'":""%>>0 s (<%=locBloc.getValue(17, "Desactivé")%>)</option>
										<option value="5000" <%= (lReloadValue == 5000)?"selected='selected'":""%>>5 s</option>
										<option value="15000" <%= (lReloadValue == 15000)?"selected='selected'":""%>>15 s</option>
										<option value="30000" <%= (lReloadValue == 30000)?"selected='selected'":""%>>30 s</option>
										<option value="60000" <%= (lReloadValue == 60000)?"selected='selected'":""%> >1 min</option>
										<option value="300000" <%= (lReloadValue == 300000)?"selected='selected'":""%>>5 min</option>
										<option value="600000" <%= (lReloadValue == 600000)?"selected='selected'":""%>>10 min</option>
									</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr><td style="text-align:center"><button type="submit"><%= localizeButton.getValueSubmit() %></button></td></tr>
			</table>
		</form>
