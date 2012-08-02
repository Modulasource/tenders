<%@ include file="/include/headerXML.jspf" %>

<%@ page import="org.coin.util.treeview.*,java.text.*,modula.algorithme.*,modula.*,modula.marche.*,java.util.*, modula.candidature.*, org.coin.util.*"%>
<%@ include file="/include/beanSessionUser.jspf" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	String rootPath = request.getContextPath()+"/";
	String sTitle = "Communication à la CAO sur l'affaire réf. " + marche.getReference();
%>
<%@ include file="/desk/include/headerDesk.jspf" %>
</head>
<body>
<% 
	String sHeadTitre = "Communication avec la CAO"; 
	boolean bAfficherPoursuivreProcedure = false;
%>
<%@ include file="../../include/headerAffaire.jspf" %>
<br />
<table height="100%">
	<tr>
    	<td style="vertical-align:top;height:100%">
    		<table class="pave" >
				<tr>
					<td class="pave_titre_gauche" colspan="2">
					Communication avec la CAO
					</td>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td class="pave_cellule_gauche">
					Sélectionner la communication :
					</td>
					<td class="pave_cellule_droite">
					<select name="selection" style="width: 370px" onchange="Redirect(this.value);">
						<option selected="selected">
						--- Communications disponibles ---
						</option>
						<option value="<%=response.encodeRedirectURL("prevenirMembresForm.jsp?sIdMarche="+marche.getIdMarche()) %>">
						Avertissement du lancement de l'affaire réf. <%= marche.getReference() %>
						</option>
<%
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-11") )
		{
%>
						<option value="<%=response.encodeRedirectURL("convoquerCommissionForm.jsp?sIdMarche="+marche.getIdMarche()) %>">
						Convocation de la commission pour délibération
						</option>
<%
		}
%>
					</select>
				</tr>
				<tr><td colspan="2">&nbsp;</td></tr>
			</table>
    	</td>
    </tr>
    <tr>
		<td style="vertical-align:bottom">
		<%@ include file="/desk/include/footerDesk.jspf" %>
		</td>
	</tr>
</table>
</body>
</html>