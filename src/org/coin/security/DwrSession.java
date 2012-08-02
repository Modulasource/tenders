package org.coin.security;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.coin.bean.User;
import org.coin.bean.UserHabilitation;
import org.coin.localization.Language;
import org.directwebremoting.WebContext;
import org.directwebremoting.WebContextFactory;

public class DwrSession {

	public static HttpSession getSession() {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		HttpSession hsSession = hsrRequest.getSession();
		return hsSession;
	}
	
	public static User getUser() {
		WebContext ctx = WebContextFactory.get();
		return (User)ctx.getSession().getAttribute("sessionUser");
	}
	
	public static HttpServletRequest getRequest() {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		return hsrRequest;
	}
	
	public static HttpServletResponse getResponse() {
		WebContext ctx = WebContextFactory.get();
		HttpServletResponse hsrResponse = ctx.getHttpServletResponse();
		return hsrResponse;
	}
	
	public static User getUserSession(String sSessionUserBeanName) {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		
		HttpSession hsSession = hsrRequest.getSession();
		User uUserSession = (User) hsSession.getAttribute(sSessionUserBeanName );
		
		return uUserSession;
	}
	
	public static Language getLanguageSession(String sSessionLanguageBeanName) {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		
		HttpSession hsSession = hsrRequest.getSession();
		Language uLanguageSession = (Language) hsSession.getAttribute(sSessionLanguageBeanName );
		
		return uLanguageSession;
	}
	
	public static User getUserSessionLogged(String sSessionUserBeanName) throws SessionException {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		
		HttpSession hsSession = hsrRequest.getSession();
		User uUserSession = (User) hsSession.getAttribute(sSessionUserBeanName );

		if(uUserSession == null || !uUserSession.isLogged ) 
			throw new SessionException ("Session expired, you will be disconnected...");

		return uUserSession;
	}
	
	public static boolean isUserSessionLogged(String sSessionUserBeanName) throws SessionException {
		getUserSessionLogged(sSessionUserBeanName);
		return true;
	}
	
	public static boolean isUserSessionExist(String sSessionUserBeanName) throws SessionException {
		User uUserSession = getUserSession(sSessionUserBeanName);
		if(uUserSession == null)
			throw new SessionException ("Session expired, you will be disconnected...");
		return true;
	}
	
	
	public static boolean isSessionExist() throws SessionException {
		HttpSession hsSession = getSession();
		if(hsSession == null)
			throw new SessionException ("Session expired, you will be disconnected...");
		return true;
	}
	
	public static UserHabilitation getUserHabilitationSession(String sSessionUserHabilitationBeanName) {
		WebContext ctx = WebContextFactory.get();
		HttpServletRequest hsrRequest = ctx.getHttpServletRequest();
		
		HttpSession hsSession = hsrRequest.getSession();
		
		UserHabilitation uUserHabilitationSession 
			= (UserHabilitation) 
				hsSession.getAttribute(sSessionUserHabilitationBeanName);
		
		return uUserHabilitationSession;
		
	}
	
}
