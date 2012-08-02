
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveRenseignementsTitre = "Renseignements complémentaires";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveRenseignementsForm.jspf" %><br />
<%
	if(bUseBoamp17  && (bUseFormNS || bUseFormUE))
	{
		%><%@ include file="paveAccordCadreForm.jspf" %><br /><%	
	} 

	String sPaveRecompenseTitre = "Procédures particulières";
	sFormPrefix = "";
%><%@ include file="paveRecompenseForm.jspf" %><br /><%
	String sPavePiecesDemandeesTitre = "Liste des pièces demandées au candidat";
	sFormPrefix = "";
%>
<div style="display:none">
	<%@ include file="pavePiecesDemandeesForm.jspf" %>
</div>
<%
	if(bUseBoamp17 && (bUseFormMAPA))
	{
		%><%@ include file="paveIndexationForm.jspf" %><br /><%
	}
	if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
	{
		%><%@ include file="paveProcedureRecoursForm.jspf" %><br /><%	
	} 
	String sPaveAutresRenseignements = "Autres renseignements";
	sFormPrefix = "";
%><%@ include file="paveAutresRenseignementsForm.jspf" %>