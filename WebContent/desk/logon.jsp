<%

	String userAgent = request.getHeader("user-agent").toLowerCase();
	if (userAgent.contains("blackberry")
	|| userAgent.contains("iphone")
	|| userAgent.contains("android")
	|| userAgent.contains("opera mobi")
	|| userAgent.contains("opera mini")
	|| userAgent.contains("iemobile"))
	{
		response.sendRedirect(request.getContextPath()+"/desk/mlogon.jsp");
		return;
	}
%>
<%@ include file="/include/new_style/headerDeskUtf8.jspf" %>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.bean.*" %>
<%@page import="org.coin.security.PreventSqlInjection"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="java.util.Vector"%>
<%@page import="java.sql.SQLException"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.security.SecureString"%>
<%@page import="modula.TreeviewNoeud"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@ include file="include/localization.jspf" %>
<%
	sessionUserHabilitation.unsetAsSuperUser();
	sessionUser.logout();

	String sVersionApplication = "";
    {
		sVersionApplication = mt.modula.Version.VERSION_APPLICATION ;
	}

	String a = HttpUtil.parseStringBlank("a", request);
	String sTitle = locMessage.getValue(1,"Utilisateur inconnu - Authentifiez-vous!");

	String slogin = request.getParameter("login");
	String crypto = request.getParameter("cryptogramme");
	String sMotCache = ""+session.getAttribute("sMotCache");
	//	Code ajouté pour contrecarrer les injections SQL
	if(slogin != null)
		slogin = PreventSqlInjection.cleanEmail(slogin);
	if(crypto != null)
		crypto = PreventSqlInjection.cleanAlphaNumeric(crypto);
	if(sMotCache != null)
		sMotCache = PreventSqlInjection.cleanAlphaNumeric(sMotCache);


	/**
	 * logon
	 */
	if(HttpUtil.parseLong("lIdCoinUserAccessModuleType", request, 0)
	== CoinUserAccessModuleType.TYPE_LDAP) {
		crypto = request.getParameter("pass"); ;
	}
	
	/**
	 * SU auto login
	 */
	String aaa = HttpUtil.parseStringBlank("aaa", request);
	int code = -1 ;
	if(!aaa.equals(""))
	{
		try{
			String[] saaa = SecureString.getPlainString(aaa).split(":");
			sessionUser.setId(Long.parseLong(saaa[1])) ;
			sessionUser.load();
			sessionUser.isLogged = true;
			code = User.LOGON_OK;
			
			if(saaa[2].equals("true"))
			{
				sessionUserHabilitation.setAsSuperUser();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	} else {
		code = sessionUser.logonSecureDesk(
				slogin,
				crypto,
				sMotCache);
	}
	

	String sWelcomeImagePath = "images/icones/logo_marque_blanche_home_small.jpg";
	try {
		sWelcomeImagePath = Configuration.getConfigurationValueMemory("design.desk.welcome.image.path");
	} catch (CoinDatabaseLoadException e){
	}
	
	if(!sWelcomeImagePath.contains("http://")
	&& !sWelcomeImagePath.contains("https://")){
		sWelcomeImagePath = rootPath + sWelcomeImagePath;
	}
	
	if(sessionLanguage.getId() == Language.LANG_ENGLISH_PI)
	{
		sWelcomeImagePath += "_pirate.png";
	}
	

%>
<script type="text/javascript" src="<%= rootPath %>include/crypto.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/cryptage.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/crypto/sha2.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/crypto/sha256.js" ></script>
</head>
<body style="padding:0" <%= sessionLanguage.getWritingDirection() %> >
<div class="center">
	<div style="margin-top:20px">
		<img src="<%= sWelcomeImagePath %>" alt="Demat"/>
	</div>
	<br/>
<%
	session.removeAttribute("sMotCache");
	sMotCache = org.coin.security.Password.getWord();
	session.setAttribute("sMotCache",sMotCache);

	String sMessage = "";
	if(session.getAttribute("bMessage") != null)
	{
		if(((String)session.getAttribute("bMessage")).equalsIgnoreCase("true"))
		{
		session.removeAttribute("bMessage");
		sMessage = locMessage.getValue(10,"Votre compte est désormais validé.<br />"
		+ "Vous recevrez un email comprenant vos codes d'accès (login et mot de passe)"
		+ "à la plate-forme.");
		}
		else{sMessage = locMessage.getValue(11,"Vous ne pouvez pas valider ce compte.");}
	}
	
    String sLangSelected = "selected='selected'";
	String sBlocLoginName = locMessage.getValue(2,"Authentification de l'utilisateur");
	String sFieldLanguageName = locMessage.getValue(3,"Langue");

	String sMessagePleaseAuthenticate = locMessage.getValue(4,"Veuillez vous authentifier");
	String sMessageAuthenticationFailed = locMessage.getValue(5,"Authentification erronée");
	String sMessageAccountDesactived = locMessage.getValue(6,"Votre compte est désactivé");
	String sMessageYouAreUsingFirefox = locMessage.getValue(7,"Vous utilisez Firefox ! ");
	String sMessageThisSiteIsOptimizedForFirefox = locMessage.getValue(8,"Ce site est optimisé pour le navigateur open-source Firefox");
	String sMessageYouAreUsingOldInternetExplorerVersion =locMessage.getValue(9,
		"Vous utilisez une ancienne version d'Internet Explorer, si vous ne souhaitez pas passer à Firefox,"
		+ " installez la version 7 d'Internet Explorer !");
	
	if (!sessionUser.getIsLogged())
	{
		String messageErreur = "";
		switch (code)
		{
		case User.LOGON_ERR_EMPTY_LOGIN :
			messageErreur = sMessagePleaseAuthenticate;
			if(!sMessage.equalsIgnoreCase(""))
				messageErreur = sMessage;
			break;
			
		case User.LOGON_ERR_EMPTY_PASSWORD :
			messageErreur = locMessage.getValue(12,"Le mot de passe est vide");
			break;
			
		case User.LOGON_ERR_UNKNOW_LOGIN :
			messageErreur = sMessageAuthenticationFailed;
			break;
		
		case User.LOGON_ERR_BAD_PASSWORD :
			messageErreur = sMessageAuthenticationFailed;
			break;
	
		case User.LOGON_ERR_DESACTIVATED_LOGIN  :
			messageErreur = locMessage.getValue(6,"Votre compte est désactivé");
			break;
	
		case User.LOGON_ERR_ACCOUNT_EXPIRED:
			messageErreur = "Votre compte a expiré";
			break;
		
		case User.LOGON_OK :
			messageErreur = "Autorisation accordée";
			break;
			
		}
		
		
		if(code==User.LOGON_ERR_BAD_PASSWORD)
		{
			if(session.getAttribute("tentative") == null)
			{
				session.setAttribute("tentative",0);
			}
			session.setAttribute("tentative",(((Integer)session.getAttribute("tentative"))+1));
			
			if(((Integer)session.getAttribute("tentative")) >= 5 )
			{
				messageErreur = locMessage.getValue(13,"Votre mot de passe n'est pas valide et votre compte est bloqué. "
				+ "Veuillez contacter un administrateur.");
				if(sessionUser.getIdIndividual() > 0)
				{
					try{
						sessionUser.setIdUserStatus(UserStatus.INVALIDE);
						sessionUser.store();
					}catch(Exception e){}
				}
			}
		}
	
		if(slogin == null)
		{
			slogin = Configuration.getConfigurationValueMemory("modula.dev.login.default", "");
		}
		
		//User sessionUser ;
		sessionUser.setAbstractBeanLocalization(sessionLanguage);
	
	
%>
<form action="<%=response.encodeURL("logon.jsp") %>" 
	method="post" 
	name="form_inscription" 
	id="form_inscription_id">
    
    <input type="hidden" name="a" value="<%= a %>" />
    
	<div style="width:350px;margin:0 auto;">
		<div class="box">
			<div class="boxTitle"><div><%= sBlocLoginName %></div></div>
			<div class="boxContent">				
				<table cellspacing="3" class="formLayout" style="margin:10px auto 10px" >
				    <tr id="trLogin">
				      <td class="right"><%= sessionUser.getLoginLabel() %> : </td>
				      <td>
				      	<input id="login" name="login" 
							maxlength="80" 
				      		style="width:200px" 
				      		class="styled" 
				      		value="<%= (slogin!=null ? slogin :"")%>" />
				      </td>
				    </tr>
					<tr id="trPassword">
				      <td class="right"><%= sessionUser.getPasswordLabel() %> : </td>
				      <td>
				      	<input id="pass" name="pass"  
							type="password" 
				      		style="width:200px" 
				      		class="styled"
				      		/>
				      </td>
				    </tr>	
<%
		if(Configuration.isEnabledMemory("server.localization",false))
		{
			sessionLanguage.setAbstractBeanLocalization(sessionLanguage.getId());
		
%>			
					<tr>
				      <td class="right"><%= sFieldLanguageName %> : </td>
				      <td class="left">

			<script type="text/javascript">
			function onClickSelectFlag()
			{
				var item = $("langList");
				var calframe = $("langCombo");
				var input = item.cloneNode(true);
				
				calframe.style.position = "absolute";
				//calframe.style.left = 0;
				calframe.style.top = Element.getHeight(input) + 30;
				Element.toggle('langCombo');
			}
			
			</script>
			
				<span id="langList">
				   <a target="_top" href="javascript:void(0);"
				   	  onclick="onClickSelectFlag();"><img border="0" src="<%= rootPath %>images/flags/<%= 
				   		  sessionLanguage.getShortLabel() 
				   %>.gif" /> </a><%= sessionLanguage.getName()  %>
                
				<div id="langCombo" style="width:100px; padding:2px;display:none;position:absolute;border: 1px solid #C2CCE0;background : #FFFFFF;">
					<table >
						
				<%
				
				Vector<Language> vLangAvailable = Language.getAllLanguageAvailable();
				for(Language langSelected : vLangAvailable)
				{
					String sUrlLangSelection = response.encodeURL(rootPath 
                            + "desk/logon.jsp?system_iIdSessionLanguage="
                            + langSelected.getId() +"&nonce=" + System.currentTimeMillis());
%>
				   <tr>
				   		<td style="vertical-align:middle">
						   <a  target="_top" href="<%= sUrlLangSelection
		                        %>"><img border="0" src="<%= rootPath %>images/flags/<%=
		                        	langSelected.getShortLabel() 
		                        %>.gif" /></a>
                        </td>
                        <td style="text-align:left;vertical-align:middle">&nbsp;
					   		<a  target="_top" href="<%= sUrlLangSelection %>">
                        		<%= langSelected.getName() %></a>
                    	</td>
                    </tr>
<%
				}
%>
            		</table>
				</div>				   
				</span>
				      </td>
				    </tr>		
<%
		}

		CoinUserAccessModuleType accessType = null;
		boolean bLoadModuleConn = true;
		long lIdCoinUserAccessModuleType = HttpUtil.parseLong("lIdCoinUserAccessModuleType", request, 0);
		
		if(lIdCoinUserAccessModuleType == 0)
		{
			lIdCoinUserAccessModuleType = Configuration.getIntValueMemory("server.user.access.module.type.id.default",0);
		}
		
		if(lIdCoinUserAccessModuleType > 0)
		{
			try {
				accessType = CoinUserAccessModuleType.getCoinUserAccessModuleTypeMemory(
						lIdCoinUserAccessModuleType);
			} catch(SQLException se){bLoadModuleConn = false;}
		} else {
			accessType = new CoinUserAccessModuleType();
		}
		
		if(Theme.getTheme().equalsIgnoreCase("veolia"))
		{
			bLoadModuleConn = false;
		}
		if(bLoadModuleConn && accessType != null) {
			
%>

				   <tr>
				   		<td style="vertical-align:middle">
				   			Connexion : 
                        </td>
                        <td style="text-align:left;vertical-align:middle">
                        	<%= accessType.getAllInHtmlSelect("lIdCoinUserAccessModuleType") %>
                    	</td>
                    </tr>
<%
		} else {
%>
					<tr>
				   		<td >
						   	<input type="hidden" 
								name="lIdCoinUserAccessModuleType" 
								id="lIdCoinUserAccessModuleType" 
								value="<%= CoinUserAccessModuleType.TYPE_MODULA %>" />
                        </td>
					</tr>
					
<%
		}
%>
				</table>
				<div class="center" style="margin:5px 0 5px">
					<input type="hidden" name="passage" value="1" />
					<input type="hidden" name="cryptogramme" id="cryptogramme" value="" />

					<button  type="submit"  
						id="btnSubmit"><%= localizeButton.getValueLogin() %></button>
 				</div>
				<div style="text-align:right; margin:5px 0 5px">
					Version <%= sVersionApplication %>
				</div>
			</div>
		</div>
		<br />
		<p style="color:#900" class="center">
		<%= (messageErreur!=null ?messageErreur :"")%>
		</p>
	</div>
</form>

<script type="text/javascript">
var g_bCanStartLogin = false;

/**
 * I dont remember why I do this ..
 */
/*
function submitEnter(e)
{
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	else return true;
	
	if (keycode == 13)
	{
		try {
			e.stopPropagation();
			e.preventDefault(); 
		} catch (e) {}
		doLogin();
	    var form = $('form_inscription_id');
	    form.submit();
			
		return false;
	}
	else
	   return true;
}
*/



function doLogin() {
	if($("btnSubmit")== null || $("btnSubmit").disabled) return;

	if(!g_bCanStartLogin) return;
	g_bCanStartLogin = false;
	$("btnSubmit").disabled=true;

	
	var bSubmitForm  = false;

	/**
	 * for LDAP , need to send the clear password 
	 */
	if($("lIdCoinUserAccessModuleType").value == <%= 
		CoinUserAccessModuleType.TYPE_LDAP %>) 
	{
		bSubmitForm = true;
	}


	/**
	 * for CERTIFICATE 
	 */
	if($("lIdCoinUserAccessModuleType").value == <%= 
		CoinUserAccessModuleType.TYPE_CERTIFICATE %>) 
	{
		displayCertificateLogin();
		g_bCanStartLogin = true;
		$("btnSubmit").disabled=false;
		bSubmitForm = false;
	}


	/**
	 * for Modula 
	 */
	if($("lIdCoinUserAccessModuleType").value == <%= 
		CoinUserAccessModuleType.TYPE_MODULA %>) 
	{
		cipherPasswordHiddenWord();
		bSubmitForm = true;
	}

	
	if(bSubmitForm)
	{
		//$("form_inscription_id").submit();
		return true;
	}
    return false;
}
<%
	boolean bDisplayFullGuiApplet = false;
%>
function displayCertificateLogin() {
	var title = "Certificat";
	var url = "<%= response.encodeURL(
			rootPath + "include/logon/logonApplet.jsp?bDisplayFullGui=" + bDisplayFullGuiApplet) %>";

	var w = <%= bDisplayFullGuiApplet?600:500 %>;
	var h = <%= bDisplayFullGuiApplet?300:200 %>;
	
	if(!isNotNull(title)) title = "";
	mt.utils.displayModal({
		type:"iframe",
		url:url,
		title:((title)?title:"&nbsp;"),
		width:w,
		height:h
	});
}

function cipherPasswordHiddenWord()
{
	cipherPassword('pass','cryptogramme','<%= sMotCache %>');
}



document.observe("dom:loaded", function() {
	
	$('login').focus();
	//$('form_inscription_id').addEventListener("keypress", submitEnter, false);
	//$('login').addEventListener("keypress", submitEnter, false);
	//$('form_inscription_id').onkeypress = submitEnter;
	
	g_bCanStartLogin = true;

	<% if(bLoadModuleConn && accessType != null){ %>
	$("lIdCoinUserAccessModuleType").onchange 
		= function() {
		Element.show("trLogin");
		Element.show("trPassword");
	
		if(this.value == <%= CoinUserAccessModuleType.TYPE_CERTIFICATE %>) {
			Element.hide("trLogin");
			Element.hide("trPassword");
			displayCertificateLogin();
			
		}
	}


	$("lIdCoinUserAccessModuleType").onchange();	
	<%}%>
	
    var form = $('form_inscription_id');
	form.onsubmit = function(){
		doLogin();
	}

	
});

</script>
<%
	}
	else
	{
		/**
		 * go to the desk !
		 */
		String sDeskUrl = rootPath + "desk/index.jsp" ;

		
		try{
			sDeskUrl = SecureString.getPlainString(a);
			/**
			 * control authorized starting pages
			 */
			if(
			!sDeskUrl.contains( "desk/index.jsp")
			&& !sDeskUrl.contains( "desk/paraph/index.jsp")
			){
				/**
				 * force to the normal index.jsp
				 */
				sDeskUrl = rootPath + "desk/index.jsp" ;
			}
		} catch(Exception e){}
		
		response.sendRedirect(
					response.encodeRedirectURL( 
							sDeskUrl));
		return;
	}

%>
<div id="testFocus"></div>

<br/>
<%
	if(Configuration.isTrueMemory("design.desk.welcome.useragent.display",true))
	{ 
%>
<div class="center" style="border-style: 1px solid;" >
<%
if(request.getHeader("User-Agent").contains("Firefox"))
{
	out.write(sMessageYouAreUsingFirefox);
} 

%>
	<a target="_blank" href="http://www.mozilla-europe.org/fr/products/firefox/" style="text-decoration:none">
	<%= sMessageThisSiteIsOptimizedForFirefox %>
	<img alt="Téléchargez Firefox" src="<%= rootPath %>images/icons/firefox.png" />
	</a>
<%
if(request.getHeader("User-Agent").contains("MSIE")
&& (!request.getHeader("User-Agent").contains("MSIE 7.0")
	&& !request.getHeader("User-Agent").contains("MSIE 8.0")
	)
)
{
	%>
	<br>
	<a target="_blank" href="http://www.microsoft.com/france/windows/downloads/ie/getitnow.mspx" style="text-decoration:none">

<%= sMessageYouAreUsingOldInternetExplorerVersion %>
	
	<img alt="Téléchargez IE" src="<%= rootPath %>images/icons/ie7.png" />
	</a>
	<%
} 

if(request.getHeader("User-Agent").contains("Macintosh"))
{
	%>
	<br>
	<a target="_blank" href="http://www.apple.com/macosx/features/safari/" style="text-decoration:none">
	Vous utilisez un Mac, ce site est optimisé pour Safari 419.3
	<img alt="Téléchargez Safari" src="<%= rootPath %>images/icons/safari.png" />
	</a>
<%
} 

%>
</div>
<% } %>

<!-- 
<div>
Google chrome frame available on client side <%= GoogleChromeFrame.isPluginAvailable(request) %><br/>
Google chrome frame enabled on server side <%= GoogleChromeFrame.isEnabled() %>
</div>
 -->
 <noscript>
<br/>
<div style="padding:5px;width:500px;margin:0 auto;border:1px solid #900;background-color:#FFDFEC" class="center">
<b><em><%= locMessage.getValue(14,"Warning, in order to use this application, you must enable javascript.") %></em></b>
</div>
</noscript>
</div>
</body>
</html>