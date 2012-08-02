<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="modula.configuration.*,modula.commission.*"%>
<%@ page import="org.coin.fr.bean.mail.*,mt.modula.bean.mail.*,org.coin.fr.bean.*"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ page import="org.coin.util.*"%>
<%@ include file="../include/beanSessionIdCommission.jspf" %>
<%
	String sPageUseCaseId = "IHM-DESK-COM-006";
	
	String sMailFromDefaut = Configuration.getConfigurationValueMemory(ModulaConfiguration.MAIL_FROM_DEFAUT);
		
	if(sMailFromDefaut == null )
	{
		// TODO : c'est pas bon .. il faut le mettre dans les logs.
		System.out.println("Pas de valeur de mail par defaut sp�cifi�es dans la table de config");
		return ;
	}
		
	boolean benvoieMail = false;
	CommissionMembre membre = new CommissionMembre();
	membre.setFromForm(request, "");
	
	if (membre.getIdCommission() == 0)
	{
		membre.setIdCommission(commission.getIdCommission());
		/* Modification de la base */
		if (!membre.isMembre())
		{
			switch (membre.getIdMembreRole())
			{
				case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_PRESIDENT: /* Cas du pr�sident */
					if (!membre.isPresidentExiste())
					{
						membre.store();
					}
					else
					{
						response.sendRedirect(rootPath + "desk/errorAdmin.jsp?idError=8");
						
					}
					break;
				case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE:
					if (!membre.isSecretaireExiste())
					{
						membre.store();
					}
					else
					{
						response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=9"));
						
					}
					break;
				default:
					if (!membre.isMembre())
					{
						membre.store();
						
					}
					else
					{
						response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=11"));
						
					}
					break;
			}
		}
		else
		{
			response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=11"));
		}
	}
	else
	{
		/* Cr�ation d'un nouveau membre avec les m�mes infos */
		membre.setIdCommission(commission.getIdCommission());
		if (membre.isMembre())
		{
			response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=11"));
		}
	
		switch(membre.getIdMembreRole())
		{
		case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_PRESIDENT : /* Cas du pr�sident */
			if (!membre.isPresidentExiste())
			{
				membre.create();
			}
			else
			{
				response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=8"));
			}
			break;
		case CommissionMembre.COMMISSION_MEMBRE_ID_ROLE_SECRETAIRE: /* Cas du Secr�taire */
			if (!membre.isSecretaireExiste())
			{
				membre.create();
			}
			else
			{
				response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=9"));
			}
			break;
		default:
			if (!membre.isMembre())
			{
				membre.create();
			}
			else
			{
				response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=11"));
			}
				break;
		}
		
	}
	if (benvoieMail){
	/* Envoie du MailType au membre nouvellement inscrit */			
		MailType mailNotification = MailType.getMailTypeMemory(MailConstant.MAIL_INSCRIPTION_MBR_COMM,false); 
		String[] to = {PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique()).getEmail()};
		/* D�finition des adresses (exp�diteur et destinataire) */
		MailModula AEnvoyer = new MailModula();
		AEnvoyer.setTo(to);
		AEnvoyer.setFrom(sMailFromDefaut);
		 
		String sObjet = mailNotification.getObjetType();
		/* Parsing du contenu du mail */
		String contenuMail = mailNotification.getContenuType();
		contenuMail = Outils.replaceAll(contenuMail, "[nom_commission]" ,Commission.getCommission(membre.getIdCommission()).getNom());
		contenuMail = Outils.replaceAll(contenuMail, "[civilite_membre]", PersonnePhysique.getPersonnePhysique(membre.getIdPersonnePhysique()).getCivilite());
		/* D�finition du contenu du mail et de son objet */
		AEnvoyer.addMessage(HTMLEntities.unhtmlentitiesComplete(contenuMail));
		AEnvoyer.setSubject(HTMLEntities.unhtmlentitiesComplete(sObjet));
		AEnvoyer.send();
	}
	response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/commission/afficherCommission.jsp?iIdCommission=" + membre.getIdCommission()));
%> 