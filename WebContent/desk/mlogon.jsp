<%@ include file="/mobile/include/header.jspf" %>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.security.SecureString"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueParametre"%>

<%@page import="org.coin.bean.CoinUserAccessModuleType"%>
<%@page import="org.coin.security.PreventSqlInjection"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="java.sql.SQLException"%>
<jsp:include page="/desk/mobile/include/headerHTML.jsp" />
<%

	sessionUserHabilitation.unsetAsSuperUser();
	sessionUser.logout();

	
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
		if (request.getParameter("login")!=null)
		{
			/**
			 * Becareful between login.jsp and mlogin.jsp
			 * cryptogram != cryptogramme 
			 * and pwd != pass
			 */
			String slogin = request.getParameter("login");
			String crypto = request.getParameter("cryptogram");
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
			== CoinUserAccessModuleType.TYPE_LDAP){
				crypto = request.getParameter("pwd");
				//crypto = request.getParameter("pass"); ;
			}
			
			code = sessionUser.logonSecureDesk(
					slogin,
					crypto,
					sMotCache);
	
			
			
			if (!PersonnePhysiqueParametre.isEnabled(sessionUser.getIdIndividual(), "smart.phone.access")){
				code = User.LOGON_ERR_ACCOUNT_UNAUTHORIZED;
			}
		}
		
		
		
	}


	String userAgent = request.getHeader("user-agent");
	String sSmartphoneType = "";
	if (userAgent.toLowerCase().contains("blackberry")){
		sSmartphoneType = "BlackBerry";
	} else if (userAgent.toLowerCase().contains("iphone")){
		sSmartphoneType = "Iphone";
	} else if (userAgent.toLowerCase().contains("android")){
		sSmartphoneType = "smartphone Android";
	}
		
		
	if (code==User.LOGON_OK){
		response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/paraph/mobile/blackberry/index.jsp"));
		return;
	}
	
	String sMotCache = org.coin.security.Password.getWord();
	session.setAttribute("sMotCache",sMotCache);
	
	
	
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


%>

<script type="text/javascript" src="<%=rootPath%>include/js/md5.js" ></script>

<style>
body{
	background-color:#f9fafb;
}
</style>

<div style="padding-top:10px">
	
	<div style="text-align:center">
		<img src="<%=rootPath%>images/parapheur/logo_mpi_mobile.png" />		
		<form action="<%=response.encodeURL("mlogon.jsp") %>" method="post" id="loginForm" style="width:210px;margin:20px auto">
			<div style="font-weight:bold">Identifiant :</div>
			<input type="text" name="login" autocorrect="off" autocapitalize="off" style="width:200px"/>
			<div style="font-weight:bold">Mot de passe :</div>
			<input type="password" name="pwd" style="width:200px"/>
			<div style="font-weight:bold">Connexion :</div>
            <%= accessType.getAllInHtmlSelect("lIdCoinUserAccessModuleType") %>

			<input type="hidden" name="cryptogram"/>
			<div style="text-align:center;margin-top:10px">
			<input type="submit" name="submit" value="S'identifier"/>
			</div>
			
			<%if (code == User.LOGON_ERR_ACCOUNT_UNAUTHORIZED){ %>
			<div style="padding-top:15px;text-align:center;font-size:13px;color:#900">
				Vous n'êtes pas autorisé à utiliser la version mobile du parapheur
			</div>
			<%} %>
			
			<% if (!sSmartphoneType.isEmpty()){ %>
			<div style="padding-top:15px;text-align:center;font-size:12px;color:#777">optimisé pour votre <%=sSmartphoneType%></div>
			<%} %>
			
		</form>
	</div>

</div>

<script>
function init(){
	var form = $('loginForm');
	form.onsubmit = function(){

		if($("lIdCoinUserAccessModuleType").value == <%= 
			CoinUserAccessModuleType.TYPE_LDAP %>) 
		{
			return true;
		}
		
		
		this.cryptogram.value = MD5(MD5(this.pwd.value)+"<%=sMotCache%>");
		return true;
	}
}
init();
</script>
<jsp:include page="/desk/mobile/include/footerHTML.jsp"/>