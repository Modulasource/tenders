<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*,java.net.*,modula.marche.*,modula.algorithme.*,modula.*,org.coin.util.treeview.*,java.util.*,java.text.*" %>
<%@ page import="modula.marche.joue.MarcheJoueFormulaire"%>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = "Authentification de l'intégrité de l'affaire";
	String sPageUseCaseId = "IHM-DESK-AFF-CRE-6"; 
    int iIdPublicationTypeToSend = PublicationType.TYPE_AAPC;
    int iIdFormulaireJoue = -1;
	String sUrlReturnToSend ="aapc";

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
		 	 * Ici il faut tester que la publication AAPC de test a bien été publiée ou en 
		 	 * instance de publication
		 	 */
		 	 int iIdPublicationType = MarcheJoueFormulaire.getFirstIdPublicationType(marche, PublicationType.TYPE_AAPC);
		 	 Vector<PublicationBoamp> vPublicationBoamp 
		         = PublicationBoamp.getAllPublicationBoampWithTestFromAffaire(
		                 marche.getIdMarche(), iIdPublicationType);
		 	
		 	 
		 	if(iIdPublicationType != PublicationType.TYPE_AAPC)
		 	{
		 		iIdFormulaireJoue = iIdPublicationType - 1000;
	            iIdPublicationTypeToSend = PublicationType.TYPE_JOUE_FORM;
		 	}
            %><%@ include file="../pave/checkBoamp.jspf" %><%
		}
	}catch(Exception e){}
	
	String sActionForm = response.encodeURL("validerAffaireParPresident.jsp?iIdAffaire=" + marche.getIdMarche() ) ;
	String sURLRedirect = "desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire=" + marche.getIdMarche() ;
%>
<%@ include file="../pave/paveButtonValidation.jspf" %>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>