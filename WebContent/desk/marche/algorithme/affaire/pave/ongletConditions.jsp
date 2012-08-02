
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveConditionsTitre = "Conditions relatives au march&eacute;";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;
	
	MarcheConditionRelative mcr = null;
	try {
		mcr =  MarcheConditionRelative.getMarcheConditionRelativeFromIdMarche(marche.getId());
	}catch (CoinDatabaseLoadException e ) {
		mcr = new MarcheConditionRelative();
	}
	
	MarcheJoueInfo joueInfo = MarcheJoueInfo.getOrNewMarcheJoueInfoFromIdMarche(marche
			.getIdMarche(), true);

%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveConditions.jspf" %>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>

<%@page import="modula.marche.joue.MarcheJoueInfo"%><br />
<%
String sPaveLangueTitre = "Langues";
sFormPrefix = "";
%>
<%@ include file="paveLangues.jspf" %>
<br/>
<%@ include file="paveConditionParticipation.jspf" %>
<%if(bUseBoamp17 && (bUseFormNS || bUseFormUE)){ %>
<br/>
<%@ include file="paveConditionParticipationSystemeQualification.jspf" %>
<%} %>
<br/>
<%@ include file="paveNombreCandidat.jspf" %>

<%
	String sPaveJustificationTitre = "Justifications";
	if(bUseBoamp17)
	{
		boolean bIsFormPaveJustification = false;
%>
<br/>
<%@ include file="paveJustificationForm.jspf" %>
<%
	}
%>