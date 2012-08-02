
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
	Marche marche = Marche.getMarche(Integer.parseInt( request.getParameter("iIdAffaire") ));
	String rootPath = request.getContextPath()+"/";

if (marche.getIdMarcheSynchro() == modula.marche.MarcheSynchro.MARCO ){
	MarcheSynchroMarco msMarco = new MarcheSynchroMarco();
	msMarco.setIdExport(MarcheSynchroMarco.getIdExportWithIdMarche(marche.getIdMarche()));
	msMarco.load();
	String sTypeExportLibelle = modula.marche.MarcheSynchro.getMarcheSynchroLibelle(marche.getIdMarcheSynchro());
%>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Transfert de type <%=sTypeExportLibelle %></td> 
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Référence de l'affaire <%=sTypeExportLibelle  %> : </td>
		<td class="pave_cellule_droite"><%=msMarco.getReferenceAffaire()%></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Référence du dossier : </td>
		<td class="pave_cellule_droite"><%=msMarco.getReferenceDossier()%></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Référence de l'organisation : </td>
		<td class="pave_cellule_droite"><%=msMarco.getReferenceOrganisation()%></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td> 
	</tr>
</table>
<%
	}
%>