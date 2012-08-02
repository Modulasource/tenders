
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveRenseignementsTitre = "Renseignements compl&eacute;mentaires";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;

	
%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveRenseignements.jspf" %><br /><%
	if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
	{
		%><%@ include file="paveAccordCadre.jspf" %><br /><%
	} 

	String sPaveRecompenseTitre = "Procédures particulières";
	sFormPrefix = "";
%><%@ include file="paveRecompense.jspf" %><br /><%
	String sPavePiecesDemandeesTitre = "Liste des pièces demandées au candidat";
	sFormPrefix = "";
%>
<div style="display:none">
<%@ include file="pavePiecesDemandees.jspf" %>
</div>

<%

	if(bUseBoamp17 && (bUseFormMAPA))
	{
		%><%@ include file="paveIndexation.jspf" %><br /><%
	}
	if(bUseBoamp17 && (bUseFormNS || bUseFormUE))
	{
		%><%@ include file="paveProcedureRecours.jspf" %><br /><% 
	} 
	
	String sPaveAutresRenseignements = "Autres renseignements";
	sFormPrefix = "";
%>
<%@ include file="paveAutresRenseignements.jspf" %>