
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveCaracPrincipalesTitre = "Caractéristiques principales";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";
	String sSelected;
%>
<%@ include file="/desk/include/typeForm.jspf" %>
<%@ include file="paveCaracPrincipalesForm.jspf" %>
