<%@ page contentType="text/xml;charset=iso-8859-1" %><?xml version="1.0" encoding="iso-8859-1"?>
<%@page import="modula.marche.*,org.coin.util.*" %>
<% 

	// TODO : on ne peut venir que d'une page du publisher ou portail
	// créer un filtre pour ne pas se faire piquer les annonces

	String sDesc = "";
	try{
		int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
		Marche marche = Marche.getMarche(iIdAffaire);
		try {
			if(!marche.getPetiteAnnonceTexteLibre().equalsIgnoreCase(""))
			{
				sDesc = Outils.replaceAll(marche.getPetiteAnnonceTexteLibre(),"\n","<br/>");
				sDesc = Outils.replaceAll(sDesc,"¤","&euro;");
				sDesc = Outils.replaceAll(sDesc,"?","'");
			}
			else{
				sDesc = "Pas de complément d'annonce";
			}
		} catch (Exception e1) {e1.printStackTrace();}
	}catch(Exception e){
		try{
			AvisAttribution aAvis = AvisAttribution.getAvisAttribution(Integer.parseInt(request.getParameter("iIdAATR")));
			Marche marche = Marche.getMarche(aAvis.getIdMarche());
			try {
				if(!aAvis.getPetiteAnnonceTexteLibre().equalsIgnoreCase(""))
				{
					sDesc = Outils.replaceAll(marche.getPetiteAnnonceTexteLibre(),"\n","<br/>");
					sDesc = Outils.replaceAll(sDesc,"¤","&euro;");
					sDesc = Outils.replaceAll(sDesc,"?","'");
				}
				else
				{
					sDesc = "Pas de complément d'annonce";
				}
			} catch (Exception e3) {}
		}catch(Exception e2){}
	}
%>
<%= sDesc.replaceAll("\n", "<br/>") %>
