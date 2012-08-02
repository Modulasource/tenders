<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="/include/headerXML.jspf" %>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ page import="org.coin.bean.*,org.coin.security.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %> 
<%
	String slogin = request.getParameter("login");
	String crypto = request.getParameter("cryptogramme");
	String sMotCache = ""+session.getAttribute("sMotCache");
	String sType = HttpUtil.parseString("type",request,"ent");
		
	//Code ajouté pour contrecarrer les injections SQL
	if(slogin != null)
		slogin = PreventSqlInjection.cleanEmail(slogin);
	if(crypto != null)
		crypto = PreventSqlInjection.cleanAlphaNumeric(crypto);
	if(sMotCache != null)
		sMotCache = PreventSqlInjection.cleanAlphaNumeric(sMotCache);
	
	String sRedirectURL = "logon.jsp";
	String sRefererURL = request.getHeader("REFERER");
	sRedirectURL = sRefererURL;
	
	String sMessageErreur = "";
	String sMessage = "";
	if(session.getAttribute("bMessage") != null)
	{
		if(((String)session.getAttribute("bMessage")).equalsIgnoreCase("true")) 
		{ 
			session.removeAttribute("bMessage");
			sMessage = "Votre compte est désormais validé.<br />"
			+ "Vous allez recevoir un email comprenant vos codes d'accès (login et mot de passe)"
			+ " qui vous permettront de vous connecter à la plate-forme.";
			
			sRedirectURL = request.getContextPath()+"/include/afficherMessagePublisher.jsp";
			
			session.setAttribute("sessionPageTitre", "Validation de votre compte utilisateur");
			session.setAttribute("sessionMessageTitre", "Validation de votre compte utilisateur");
			session.setAttribute("sessionMessageLibelle", sMessage);
			session.setAttribute("sessionMessageUrlIcone",  modula.graphic.Icone.ICONE_SUCCES);
		}
		else{sMessage = "Vous ne pouvez pas valider ce compte.";}
	}
	session.removeAttribute("sMotCache");
	
	/**
	 * Logon
	 */
	int code = 0;
	if(sType.equalsIgnoreCase("ent")){
		code = sessionUser.logonSecurePublisher(slogin,crypto,sMotCache);
	}else{
		code = sessionUser.logonSecureDesk(slogin,crypto,sMotCache);
	}
	
    sessionUserHabilitation.unsetAsSuperUser();
    if (sessionUser.getIdUserType() == modula.UserConstant.USER_ADMIN) {
        sessionUserHabilitation.setAsSuperUser();
    }
	
	
	try{
		
		String sDebugValue = Configuration.getConfigurationValueMemory("debug.session");
		if(sDebugValue != null && sDebugValue.equalsIgnoreCase("enabled"))
		{
			sessionUserHabilitation.setDebugSession();
		}
	}
	catch(Exception e){}

	String sRedirect = "";
	if (!sessionUser.getIsLogged())
	{
		switch (code)
		{
		case User.LOGON_ERR_EMPTY_LOGIN :
			sMessageErreur = "L'identifiant est vide.";
			if(!sMessage.equalsIgnoreCase(""))
				sMessageErreur = sMessage;
			break;
	
		case User.LOGON_ERR_EMPTY_PASSWORD :
			sMessageErreur = "Le mot de passe est vide.";
			break;
	
		case User.LOGON_ERR_UNKNOW_LOGIN :
			//sMessageErreur = "L'identifiant est inconnu de la base de données.";
			sMessageErreur = "Authentification erronée";
			break;
	
		case User.LOGON_ERR_BAD_PASSWORD :
			//sMessageErreur = "Le mot de passe est incorrect.";
			sMessageErreur = "Authentification erronée";
			break;
	
		case User.LOGON_ERR_DESACTIVATED_LOGIN  :
			sMessageErreur = "Votre compte est désactivé.";
			break;
	
		case User.LOGON_OK :
			sMessageErreur = "Autorisation accordée.";
			break;
		}
		
		if(code==User.LOGON_ERR_BAD_PASSWORD)
		{
			if(session.getAttribute("tentative") == null)
				session.setAttribute("tentative",0);
			session.setAttribute("tentative",(((Integer)session.getAttribute("tentative"))+1));
			if(((Integer)session.getAttribute("tentative"))>=5){
				sMessageErreur = "Votre mot de passe n'est pas valide et votre compte est bloqué."
				 + " Veuillez contacter un administrateur.";
				if(sessionUser.getIdIndividual() > 0)
				{
					sessionUser.setIdUserStatus(UserStatus.INVALIDE);
					sessionUser.store();
				}
			}
		}
		//System.out.println("sRefererURL : " + sRefererURL);
		session.setAttribute("sMessageErreur",sMessageErreur);
		
		String sCharDelimiter = "?";
		
		if(sRefererURL == null) sRefererURL  ="";
		
		if(sRefererURL.contains("?")) sCharDelimiter = "&";
		
		sRedirect =
				response.encodeRedirectURL(
						sRefererURL+ sCharDelimiter + "nonce="+System.currentTimeMillis() );
		//return;
	}
	else if (sessionUser.getIsLogged())
	{
		if(sType.equalsIgnoreCase("ap")){
	          sRedirect = response.encodeURL(request.getContextPath()+"/desk/index.jsp"); 
                  
		}else{
		     sRedirect = 
		            response.encodeRedirectURL( "private/candidat/indexCandidat.jsp?nonce="
		                +System.currentTimeMillis());
		}
		//return;
	}
%>
<script>
<% 
	if(sessionUser.isLogged && sType.equalsIgnoreCase("ap")){%>
	top.location = "<%= sRedirect %>";
<%
	}else{
%>
	try{
		if(parent.updateMenu){
			parent.updateMenu(<%= sessionUser.isLogged %>);
		}
	} catch(e ) {}
	
	location.href = "<%= sRedirect %>";
<%
	}
%>
</script>