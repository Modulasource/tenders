<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.net.*,modula.marche.*,modula.algorithme.*,modula.*,org.coin.util.treeview.*,java.util.*,java.text.*" %>
<%@page import="org.coin.fr.bean.export.PublicationBoamp"%>
<%@page import="modula.ws.boamp.ServeurFichiersXMLBoamp"%>
<%@page import="modula.ws.boamp.suivi.ListSuivi"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);


	String sTitle = "Authentification de l'intégrité de l'avis d'attribution";
	String sPageUseCaseId = "IHM-DESK-AATR-1";
	int iIdFormulaireJoue = -1;
	int iIdPublicationTypeToSend = PublicationType.TYPE_AATR;
	String sUrlReturnToSend ="aatr";
	
%><%@ include file="../pave/checkForm.jspf" %><%
	BOAMPProperties boampProperties = null;
	Export export = null;
	boolean bSendPublicationBoampTest = false;
	boolean bAllowValidateAvis= false;
	try{
		export = PublicationBoamp.getExportBoampFormMarche((int)marche.getId());
		PublicationBoamp publicationBoampTest = null;
		if(export != null)
		{
		 	/** 
		 	 * Ici il faut tester que la publication AATR de test a bien été publiée ou en 
		 	 * instance de publication
		 	 */
			
		 //	Vector<PublicationBoamp> vPublicationBoamp 
		 //		= PublicationBoamp.getAllPublicationBoampWithTestAatrFromAffaire(marche.getIdMarche());
		 	
            int iIdPublicationType = MarcheJoueFormulaire.getFirstIdPublicationType(marche, PublicationType.TYPE_AATR);
            Vector<PublicationBoamp> vPublicationBoamp 
                = PublicationBoamp.getAllPublicationBoampWithTestFromAffaire(
                        marche.getIdMarche(), iIdPublicationType);
           
           if(iIdPublicationType != PublicationType.TYPE_AATR)
           {
        	   iIdFormulaireJoue = iIdPublicationType - 1000;
               iIdPublicationTypeToSend = PublicationType.TYPE_JOUE_FORM;
           }
            %><%@ include file="../pave/checkBoamp.jspf" %><%
		}
	}catch(Exception e){}
	
	
	String sActionForm = response.encodeURL(rootPath 
			+ sUrlTraitement) ;
	
	if(!sAction.contains("iIdAffaire="))
	{
		sActionForm += "?iIdAffaire=" + marche.getIdMarche();

	}
	
	String sURLRedirect = "desk/marche/algorithme/affaire/afficherAttribution.jsp?iIdAffaire=" + marche.getIdMarche() ;
%>
<%@ include file="../pave/paveButtonValidation.jspf" %>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>

<%@page import="modula.marche.joue.MarcheJoueFormulaire"%></html>