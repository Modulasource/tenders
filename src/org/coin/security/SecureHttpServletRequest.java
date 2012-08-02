package org.coin.security;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.Principal;
import java.util.Enumeration;
import java.util.Locale;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletInputStream;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SecureHttpServletRequest implements HttpServletRequest{

	private HttpServletRequest req;
	public boolean bActivate = true;
	
	public SecureHttpServletRequest(HttpServletRequest req){
		this.req = req;
	}

	public Object getAttribute(String arg0) {
		return this.req.getAttribute(arg0);
	}

	public Enumeration getAttributeNames() {
		return this.req.getAttributeNames();
	}

	public String getCharacterEncoding() {
		return this.req.getCharacterEncoding();
	}

	public void setCharacterEncoding(String arg0) throws UnsupportedEncodingException {
		this.req.setCharacterEncoding(arg0);
		
	}

	public int getContentLength() {
		return this.req.getContentLength();
	}

	public String getContentType() {
		return this.req.getContentType();
	}

	public ServletInputStream getInputStream() throws IOException {
		return this.req.getInputStream();
	}

	public String getParameter(String arg0) {
		if(this.bActivate)
			return PreventInjection.preventLoad(this.req.getParameter(arg0));
		else
			return this.req.getParameter(arg0);
			
	}

	public Enumeration getParameterNames() {
		return this.req.getParameterNames();
	}

	public String[] getParameterValues(String arg0) {
		return this.req.getParameterValues(arg0);
	}

	public Map getParameterMap() {
		return this.req.getParameterMap();
	}

	public String getProtocol() {
		return this.req.getProtocol();
	}

	public String getScheme() {
		return this.req.getScheme();
	}

	public String getServerName() {
		return this.req.getServerName();
	}

	public int getServerPort() {
		return this.req.getServerPort();
	}

	public BufferedReader getReader() throws IOException {
		return this.req.getReader();
	}

	public String getRemoteAddr() {
		return this.req.getRemoteAddr();
	}

	public String getRemoteHost() {
		return this.req.getRemoteHost();
	}

	public void setAttribute(String arg0, Object arg1) {
		this.req.setAttribute(arg0,arg1);
	}

	public void removeAttribute(String arg0) {
		this.req.removeAttribute(arg0);
	}

	public Locale getLocale() {
		return this.req.getLocale();
	}

	public Enumeration getLocales() {
		return this.req.getLocales();
	}

	public boolean isSecure() {
		return this.req.isSecure();
	}

	public RequestDispatcher getRequestDispatcher(String arg0) {
		return this.req.getRequestDispatcher(arg0);
	}

	/**
	 * @deprecated
	 */
	public String getRealPath(String arg0) {
		return this.req.getRealPath(arg0);
	}

	public int getRemotePort() {
		return this.req.getRemotePort();
	}

	public String getLocalName() {
		return this.req.getLocalName();
	}

	public String getLocalAddr() {
		return this.req.getLocalAddr();
	}

	public int getLocalPort() {
		return this.req.getLocalPort();
	}

	public String getAuthType() {
		return this.req.getAuthType();
	}

	public Cookie[] getCookies() {
		return this.req.getCookies();
	}

	public long getDateHeader(String arg0) {
		return this.req.getDateHeader(arg0);
	}

	public String getHeader(String arg0) {
		return this.req.getHeader(arg0);
	}

	public Enumeration getHeaders(String arg0) {
		return this.req.getHeaders(arg0);
	}

	public Enumeration getHeaderNames() {
		return this.req.getHeaderNames();
	}

	public int getIntHeader(String arg0) {
		return this.req.getIntHeader(arg0);
	}

	public String getMethod() {
		return this.req.getMethod();
	}

	public String getPathInfo() {
		return this.req.getPathInfo();
	}

	public String getPathTranslated() {
		return this.req.getPathTranslated();
	}

	public String getContextPath() {
		return this.req.getContextPath();
	}

	public String getQueryString() {
		return this.req.getQueryString();
	}

	public String getRemoteUser() {
		return this.req.getRemoteUser();
	}

	public boolean isUserInRole(String arg0) {
		return this.req.isUserInRole(arg0);
	}

	public Principal getUserPrincipal() {
		return this.req.getUserPrincipal();
	}

	public String getRequestedSessionId() {
		return this.req.getRequestedSessionId();
	}

	public String getRequestURI() {
		return this.req.getRequestURI();
	}

	public StringBuffer getRequestURL() {
		return this.req.getRequestURL();
	}

	public String getServletPath() {
		return this.req.getServletPath();
	}

	public HttpSession getSession(boolean arg0) {
		return this.req.getSession(arg0);
	}

	public HttpSession getSession() {
		return this.req.getSession();
	}

	public boolean isRequestedSessionIdValid() {
		return this.req.isRequestedSessionIdValid();
	}

	public boolean isRequestedSessionIdFromCookie() {
		return this.req.isRequestedSessionIdFromCookie();
	}

	public boolean isRequestedSessionIdFromURL() {
		return this.req.isRequestedSessionIdFromURL();
	}

	/**
	 * @deprecated
	 */
	public boolean isRequestedSessionIdFromUrl() {
		return this.req.isRequestedSessionIdFromUrl();
	}
}
