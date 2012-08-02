
<%@page import="org.coin.bean.ws.AddressBookWebService"%><%@page import="org.coin.bean.ws.PersonnePhysiqueWebService"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.mail.mailtype.MailUser"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@ page import="org.coin.util.*,java.sql.*,org.coin.fr.bean.*,modula.graphic.*,org.coin.bean.*" %>
<%@ page import="mt.modula.bean.mail.*,org.coin.mail.*,modula.marche.*" %> 
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf" %> 

<%
	String rootPath = request.getContextPath()+"/";
	Connection conn = ConnectionManager.getConnection();

	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	
	PersonnePhysique personne = candidat;
	if (organisation.getIdCreateur() == candidat.getIdPersonnePhysique()){
		try 
		{
			String sPP = request.getParameter("pp");
			personne = PersonnePhysique.getPersonnePhysique(Integer.parseInt(
                    SecureString.getSessionPlainString(
                            sPP,session)));
		} 
		catch (Exception e) 
		{
			personne = candidat;
		}
	}
	else{
		personne = candidat;
	}
	String sPPParamSecure = SecureString.getSessionSecureString(Long.toString(personne.getId()),session);
	
	String sMessage = "";
	String sAction = HttpUtil.parseStringBlank("sAction",request) ;
	
	boolean bLinkEmailAndLogin = Configuration.isEnabledMemory("individual.email.link.logon", true);
	
	if(sAction.equalsIgnoreCase("remove"))
	{
		sMessage = "suppression de "+personne.getCivilitePrenomNom()+ " effectuée avec succès";
		try
		{
			personne.removeWithObjectAttached();
		}
		catch(Exception e)
		{
			sMessage = "suppression de "+personne.getCivilitePrenomNom()+ " non effectuée";
		}
		
		response.sendRedirect(response.encodeRedirectURL(rootPath + sPublisherPath
				+ "/private/organisation/afficherOrganisation.jsp"
				+ "?iIdOnglet="+ Onglet.ONGLET_ORGANISATION_PERSONNES
				+ "&sMessage=" + sMessage));
	}
	
	if(sAction.equalsIgnoreCase("store"))
	{
		if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_DONNEES_ADMINISTRATIVES)
		{
			if(personne != null 
			&& request.getParameter("sEmail") != null 
			&& !request.getParameter("sEmail").equalsIgnoreCase(personne.getEmail()))
			{
				String sEmail = request.getParameter("sEmail");
				User user = null;
				try{user = User.getUserFromIdIndividual(personne.getIdPersonnePhysique());}
				catch(Exception e){
					personne.setEmail(sEmail);
				}
				try
				{
					if(user != null)
					{
						sMessage = "Changement de mail effectué avec succès";
						
						// change uniquement si la table de configuration accepte le lien entre login et email
						// vrai par défaut
						if(bLinkEmailAndLogin )
						{
							if(user.getIdUserStatus() == UserStatus.VALIDE
							|| user.getIdUserStatus() == UserStatus.EN_ATTENTE_DE_VALIDATION)
								sMessage += " - un mail a été envoyé pour valider le compte utilisateur";
							
							user.changeLoginFromForm(request,
									response,sEmail, 
									MailConstant.MAIL_PUBLISHER_CHANGEMENT_LOGIN,
									new MailModula());
						}
						personne.load(conn);
					}
				}
				catch(Exception e){sMessage = e.getMessage();}
			}
			
			personne.setFromFormWithoutEmail(request, "");
			if(!bLinkEmailAndLogin )
				personne.setEmail(request.getParameter("sEmail"));
			personne.store(conn);
		}
					
		if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_ADRESSE)
		{
			Adresse adresse = Adresse.getAdresse(personne.getIdAdresse());
			adresse.setFromForm(request, "");
			adresse.store(conn);
		}
	
		if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS)
		{
		}
		User user = null;
		if( iIdOnglet == Onglet.ONGLET_PERSONNE_PHYSIQUE_COMPTE_UTILISATEUR)
		{
			try{user = User.getUserFromIdIndividual(personne.getIdPersonnePhysique());}
			catch(Exception e){}
			
			if(user != null)
			{
				if(user.getIdUserStatus() == UserStatus.VALIDE)
				{
					String ancien = HttpUtil.parseStringBlank("ancien",request) ;
					String newMdp1 = HttpUtil.parseStringBlank("newMdp1",request) ;
					String newMdp2 = HttpUtil.parseStringBlank("newMdp2",request) ;
					
					if (!ancien.equalsIgnoreCase("")
					&& !newMdp1.equalsIgnoreCase("")
					&& !newMdp2.equalsIgnoreCase("")
					&& MD5.getEncodedString(ancien).equals(user.getPassword()))
					{
						if (newMdp1.equals(newMdp2))
						{
							user.sNewPassword = newMdp1;
							
							PersonnePhysique personneLoguee 
								= PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(),false,conn);
							String mdp = MD5.getEncodedString(newMdp1);
							user.setPassword(mdp);
							user.store(conn);
							
							
							Courrier courrier = MailUser.prepareMailNewPassword(
									MailConstant.MAIL_PUBLISHER_CHANGEMENT_MDP,
									personne, 
									newMdp1, 
									personneLoguee, 
									PersonnePhysiqueCivilite.getAllStatic(false, conn),  
									OrganisationTypeModula.isUserDesk(organisation),
									conn);


							MailModula mail = new MailModula();
							courrier.send(mail,conn);
							
							sMessage = "Mot de passe mis à jour avec succès - un mail vous a été envoyé";
							
							

						}
					}
				}
			
				if(request.getParameter("sLogin") != null && !request.getParameter("sLogin").equalsIgnoreCase(user.getLogin()))
				{
					String sEmail = request.getParameter("sLogin");
					try
					{
						try
						{
							sMessage = "Changement de login effectué avec succès";
							if(user.getIdUserStatus() == UserStatus.VALIDE 
							|| user.getIdUserStatus() == UserStatus.EN_ATTENTE_DE_VALIDATION)
								sMessage += " - un mail a été envoyé pour valider le compte utilisateur";
							
							user.sNewLogin = sEmail;
							user.changeLoginFromForm(request,
									response,
									sEmail,
									MailConstant.MAIL_PUBLISHER_CHANGEMENT_LOGIN,
									new MailModula());
						}
						catch(Exception e){sMessage = e.getMessage();}
					}
					catch(Exception e){sMessage = "Changement de login non effectué";}
				}
			}
		}
		
		
	    /**
         * Web Service
         */
        if(AddressBookWebService.isActivated(conn))
        {
            try{
                PersonnePhysiqueWebService wsPP = AddressBookWebService.newInstancePersonnePhysiqueWebService(conn);
                if(wsPP.isSynchronized(personne,conn))
                {
                    wsPP.synchroStore(personne, organisation, user, conn);
                }
            } catch(Exception e ) {
                e.printStackTrace();                    
            }
        }
		
		
		
		response.sendRedirect(response.encodeRedirectURL(rootPath + sPublisherPath
				+ "/private/organisation/afficherPersonnePhysique.jsp?pp=" 
						+ sPPParamSecure
				+ "&iIdOnglet="+ iIdOnglet
				+ "&sMessage=" + sMessage));
	}
	
	ConnectionManager.closeConnection(conn);
%>