<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@page import="org.coin.autoform.component.*"%>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveProcedureTitre = "Procédure";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	AutoFormCptBlock afBlockTypeAvis = (AutoFormCptBlock) request.getAttribute("afBlockTypeAvis");
	AutoFormCptBlock afBlockProcedure = (AutoFormCptBlock) request.getAttribute("afBlockProcedure"); 
	AutoFormCptSelect afProcedureSimpleEnveloppe = (AutoFormCptSelect) request.getAttribute("afProcedureSimpleEnveloppe");
	String rootPath = request.getContextPath()+"/";
	boolean bIsRectification = Boolean.parseBoolean(request.getParameter("bIsRectification"));
	boolean bUseFormNS = Boolean.parseBoolean(request.getParameter("bUseFormNS"));
	boolean bUseFormUE = Boolean.parseBoolean(request.getParameter("bUseFormUE"));
	MarcheProcedure marProc = (MarcheProcedure) request.getAttribute("marProc");
		
	if(true && !bIsRectification)
	{
%>		<%@ include file="paveProcedureForm.jspf" %>
<%
	} else {
%>		<%@ include file="paveProcedure.jspf" %>
<%
	}
%>
<br/>
<%@ include file="paveMarcheFormeForm.jspf" %>
<%@page import="java.util.Vector"%>
<br />
<%
	sFormPrefix = "";
	String sPaveCriteresAttributionTitre = "Critères d'attribution";
	Vector vCritereTypes = CritereType.getAllCritereType();
%>
<%@ include file="paveCriteresAttributionsForm.jspf" %>
