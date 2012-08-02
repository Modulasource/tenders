package org.coin.servlet;

import java.io.IOException;
import java.sql.Connection;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mt.modula.bean.mail.MailModula;

import org.coin.bean.User;
import org.coin.bean.UserStatus;
import org.coin.bean.UserType;
import org.coin.bean.conf.Configuration;
import org.coin.bean.ws.AddressBookWebService;
import org.coin.bean.ws.PersonnePhysiqueWebService;
import org.coin.bean.ws.UserWebService;
import org.coin.db.ConnectionManager;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.fr.bean.mail.MailConstant;
import org.coin.mail.Courrier;
import org.coin.mail.mailtype.MailUser;
import org.coin.security.Password;
import org.coin.util.Outils;

public class ValiderCompteUtilisateur extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(
		HttpServletRequest request,
		HttpServletResponse response) 
	throws IOException {

		HttpSession session = request.getSession();
		String rootPath = request.getContextPath()+"/";
		
		String sAction = "";
		try{sAction = request.getParameter("sAction");}
		catch(Exception e){}
		
	    String sUser = "";
	    try{sUser = request.getParameter("user");}
	    catch(Exception e){}
	    
	    String sCryptogram = "";
	    try{sCryptogram = request.getParameter("key");}
	    catch(Exception e){}
	    
		User user = null;
		try{user = User.getUserFromLogin(sUser);}
		catch(Exception e){
			try{user = User.getUserFromEmailIndividual(sUser);}
			catch(Exception e1){}
		}
		
		String sPublisher = "";
		try{sPublisher = Configuration.getConfigurationValueMemory("publisher.url");}
		catch(Exception e){
			sPublisher = request.getContextPath();
		}

		try{
		    if (Configuration.isTrueMemory("publisher.portail.homepage.use.domain.name", false))
		    {
		    	sPublisher = "http://" + request.getServerName() + rootPath;
		    }
		} catch(Exception e){}

	    boolean bValidation = false;
	    try
	    {
	    	if(user != null 
	    	&& user.getKey()!=null 
	    	&& !user.getKey().equalsIgnoreCase("") 
	    	&& user.getKey().equalsIgnoreCase(sCryptogram)
	    	&& user.getIdUserStatus() != UserStatus.VALIDE)
	    	{
	    		/**
	    		 * create : generate a new password
	    		 * store : only account validation
	    		 */
			    if(sAction.equalsIgnoreCase("create"))
			    {
			    	Connection conn = ConnectionManager.getConnection();
			    	
			    	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual(),false,conn);
			    	Organisation orga = Organisation.getOrganisation(personne.getIdOrganisation(),false,conn);
			    	String mdp = "";
			    	
			    	/**
			    	 * Web Service
			    	 */
			    	try{
			        	PersonnePhysiqueWebService wsPP = null;
			        	UserWebService wsUser  = null;
			        	wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
			        	wsUser = AddressBookWebService.newInstanceUserWebService(conn);
				    	
				    	if(wsPP.isSynchronized(personne, conn)){
				    		wsUser.updateUser(user, personne, orga, conn);
				    		mdp = user.sPasswordNoMD5;
				    	}

			    	} catch (Exception e) {
			    		//e.printStackTrace();
					}
			    	
			    	
			    	if(Outils.isNullOrBlank(mdp)){
			    		//mdp = Password.calcPassword(8, Password.CHARSET_NUM + Password.CHARSET_TINY);
			    		mdp = Password.getSyllabicPassword(2, 2);
			    	}
			    	user.setIdUserStatus(UserStatus.VALIDE);
		    		user.setPassword(org.coin.security.MD5.getEncodedString(mdp));
			    	user.setKey("");
		    		user.store(conn);
		
					Courrier courrier = MailUser.prepareCourrierPersonnePhysique(
							MailConstant.MAIL_DESK_CHANGEMENT_STATUT_COMPTE,
							personne,
							conn);
					
					MailUser.populateWebSite(courrier,false, personne, conn);
					courrier.replaceAllMessageKeyWord("[user_new_password]", mdp);

					MailModula mail = new MailModula();
					courrier.send(mail,conn);
					ConnectionManager.closeConnection(conn);	
					bValidation=true;
			    }
			    
			    if(sAction.equalsIgnoreCase("store"))
			    {
					user.setIdUserStatus(UserStatus.VALIDE);
					user.setKey("");
			    	user.store();
			    	bValidation=true;
			    }
	    	}
	    }
		catch(Exception e)
		{
			e.printStackTrace();
			response.getWriter().write(e.getMessage());
		}

		String sRedirect = request.getHeader("REFERER");

		if(user!=null){
			switch (user.getIdUserType()){
				case UserType.TYPE_CANDIDAT :
					sRedirect = request.getContextPath()+"/include/validation.jsp";
					String sMessage = "";
					String sIcone = "";
					if(bValidation){
						sMessage = "Votre compte est désormais validé.<br />"
							+ "Vous allez recevoir un email comprenant vos codes d'accès (login et mot de passe)"
							+ " qui vous permettront de vous connecter à la plate-forme.";
						sIcone = modula.graphic.Icone.ICONE_SUCCES;
					}else{
						sMessage = "Vous ne pouvez pas valider ce compte.";
						sIcone = modula.graphic.Icone.ICONE_ERROR;
						sRedirect = sPublisher;
					}
		
					session.setAttribute("sessionPageTitre", "Validation de votre compte utilisateur");
					session.setAttribute("sessionMessageTitre", "Validation de votre compte utilisateur");
					session.setAttribute("sessionMessageLibelle", sMessage);
					session.setAttribute("sessionMessageUrlIcone",  sIcone);
					break;
				
				default:
					sRedirect = request.getContextPath()+"/desk/logon.jsp";
					break;
			}
		} else {
			sRedirect = request.getContextPath()+"/include/validation.jsp";
			session.setAttribute("sessionPageTitre", "Validation de votre compte utilisateur");
			session.setAttribute("sessionMessageTitre", "Validation de votre compte utilisateur");
			session.setAttribute("sessionMessageLibelle", "unknow account for " + sUser);
			session.setAttribute("sessionMessageUrlIcone",  modula.graphic.Icone.ICONE_ERROR);			
		}
		
	    session.setAttribute("bMessage",Boolean.toString(bValidation));
		response.sendRedirect(response.encodeRedirectURL(sRedirect));
	}
	
	protected void doPost(
		HttpServletRequest request,
		HttpServletResponse response) throws  IOException {
		
		/* Renvoi à la fonction doGet() */
		doGet(request, response);
	}
}