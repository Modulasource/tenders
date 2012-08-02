package org.coin.apache.tomcat;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionListener;
import javax.servlet.http.HttpSessionEvent;

/**
 * Permet d'avoir toujours la liste des connexions actives
 * 
 * 
 * @author david.keller
 *
 */
public class SessionManager implements HttpSessionListener {

	private static List<HttpSession> listActiveSession = new ArrayList <HttpSession>();

	public void sessionCreated(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		listActiveSession.add(session);
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		HttpSession session = event.getSession();
		for (int i = 0; i < listActiveSession.size(); i++) {
			HttpSession temp = listActiveSession.get(i);
			if(temp.getId().equals(session.getId()))
			{
				listActiveSession.remove(i);
			}
		}
	}

	public static HttpSession getSession(String sJSessionId) {
		for (int i = 0; i < listActiveSession.size(); i++) {
			HttpSession session = listActiveSession.get(i);
			if(session.getId().equals(sJSessionId))
			{
				return session;
			}
		}
		return null;
	}


	public static void invalidateSession(String sJSessionId) {
		for (int i = 0; i < listActiveSession.size(); i++) {
			HttpSession session = listActiveSession.get(i);
			if(session.getId().equals(sJSessionId))
			{
				session.invalidate();
			}
		}
	}

	
	public static int getActiveSessionCount() {
		return listActiveSession.size();
	}

	public static List<HttpSession> getAllActiveSession() {
		return listActiveSession;
	}

}