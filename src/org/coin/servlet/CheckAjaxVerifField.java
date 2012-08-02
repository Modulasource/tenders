/*
 * Created on 19 août 2005
 *
 */
package org.coin.servlet;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coin.bean.User;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.security.DwrSession;
import org.coin.security.MD5;
import org.coin.security.PreventInjection;
import org.coin.security.SessionException;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author François
 *
 * Vérifie lors de l'inscription d'une candidature (publisher) que l'adresse Email du gérant
 * saisie n'est pas déjà présente dans la table des personnes.
 * 
 */

@RemoteProxy
public class CheckAjaxVerifField extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	public static final int PERSONNE_PHYSIQUE_EMAIL = 1;
	public static final int COIN_USER_MDP = 2;
	public static final int ORGANISATION_RAISON_SOCIALE = 3;
	public static final int COIN_USER_LOGIN = 4;

	//TODO : gerer la comparaison avec trim et indépendant de la casse
	//ca renvoie une erreur de syntaxe js
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	{
		response.setHeader("Cache-Control", "no-cache");
		
		int iField = -1;
		try{iField = Integer.parseInt(request.getParameter("iField"));}
		catch(Exception e){}
		
		String sValue = "";
		try{sValue = PreventInjection.preventStore(request.getParameter("sValue"));}
		catch(Exception e){}
		
		int iIdUser = -1;
		try{iIdUser = Integer.parseInt(request.getParameter("iIdUser"));}
		catch(Exception e){}
		
		String sReturn = checkField(iField, sValue, iIdUser,-1);
		
		try
		{
			response.getWriter().write(sReturn);
		}
		catch(Exception e){}
	}
	
	@RemoteMethod
	public static String doAjaxStaticWithoutSessionUser(String jsonStringData) throws JSONException, SessionException{
		DwrSession.isSessionExist();
		
		JSONObject jsonData = new JSONObject(jsonStringData);
		int iField = -1;
		try {iField = jsonData.getInt("iField");}
		catch(Exception e){}
		
		String sValue = "";
		try {sValue = PreventInjection.preventStore(jsonData.getString("sValue"));} 
		catch(Exception e){}
		
		int iIdUser = -1;
		try {iIdUser = jsonData.getInt("iIdUser");} 
		catch(Exception e){}
		
		int iIdOrganisation = -1;
		try {iIdOrganisation = jsonData.getInt("iIdOrganisation");} 
		catch(Exception e){}

        return checkField(iField, sValue, iIdUser,iIdOrganisation);
	}
	
	private static String checkField(int iField, String sValue, int iIdUser,int iIdOrganisation){
		String sReturn = "";
		try 
		{
			if (iField == -1
			|| sValue == null || sValue.equalsIgnoreCase(""))
			{
				sReturn = "not_exist";
			}
			else
			{
				switch (iField) 
				{
					case PERSONNE_PHYSIQUE_EMAIL:
						if (PersonnePhysique.isPersonnesPhysiquesWithEmail(sValue))
							sReturn = "exist";
						else
							sReturn = "not_exist";
						break;
						
					case COIN_USER_MDP:
						User user = null;
						try{user = User.getUser(iIdUser);}
						catch(Exception e){}
						
						if(user == null || !MD5.getEncodedString(sValue).equalsIgnoreCase(user.getPassword()))
							sReturn = "exist";
						else
							sReturn = "not_exist";
						break;
						
					case ORGANISATION_RAISON_SOCIALE:
						if (Organisation.isOrganisationWithRaisonSocialeWithout(sValue,iIdOrganisation))
							sReturn = "exist";
						else
							sReturn = "not_exist";
						break;
						
					case COIN_USER_LOGIN:
						if (User.isUserWithLogin(sValue))
							sReturn = "exist";
						else
							sReturn = "not_exist";
						break;

				default:
					sReturn = "not_exist";
					break;
				}
			}
		} 
		catch (Exception e) 
		{
			sReturn = "not_exist";
		}
		
		return sReturn;
	}
	
	protected void doGet(
			HttpServletRequest request, 
			HttpServletResponse response) {
		// Renvoi à la fonction doPost()
		doPost(request, response);
	}
}
