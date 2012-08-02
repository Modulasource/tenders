<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
	String sPaveProcedureTitre = "Procédure";
	String sFormPrefix = "";
	Marche marche = (Marche) request.getAttribute("marche");
	String rootPath = request.getContextPath()+"/";	
	Vector<MarcheParametre> vParams = (Vector<MarcheParametre>) request.getAttribute("vParams");
%>

<form action="<%= response.encodeURL( "modifierMarcheParametre.jsp?sAction=store" ) %>" method="post" >
<div style="text-align:right" >
	<input type="submit" value="Modifier" />
	<input type="button" onclick="Redirect('<%= 
		response.encodeURL(
			rootPath + "desk/marche/algorithme/affaire/afficherAffaire.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + Onglet.ONGLET_AFFAIRE_PARAMETRES
			+ "&amp;nonce=" + System.currentTimeMillis() ) 
	%>')" value="Annuler" />
</div>
<br />
<input type="hidden" name="iParamSize" value="<%= vParams.size() %>" />
<input type="hidden" name="iIdAffaire" value="<%= marche.getIdMarche()  %>" />

<table class="pave" summary="Paramètres">
	<tr>
		<td>
			<table class="liste" summary="Paramètres">
				<tr>
					<th>Nom</th>
					<th>Valeur</th>
				</tr>
			<%
		
		for(int i = 0;i < vParams.size() ; i++)
		{
			int j = i % 2;
			MarcheParametre param = vParams.get(i);
			 %>
				<tr class="liste<%=j%>"
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" >
					<td>
						<input type="hidden" name="param_<%= i %>" value="<%= param.getIdMarcheParametre() %>" />
						<input type="text" name="paramName_<%= i %>" value="<%= param.getName() %>" style="width:100%" />
					</td>
					<td>
						<input type="text" name="paramValue_<%= i %>" value="<%= param.getValue() %>" style="width:100%" />
					</td>
				</tr>
		<%
		}
		 %>	
			</table>
		</td>
	</tr>
</table>
<br />
</form>
