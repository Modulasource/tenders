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

<div style="text-align:right" >
	<input type="button" onclick="Redirect('<%= 
		response.encodeURL(
			rootPath + "desk/marche/algorithme/affaire/afficherAffaire.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;iIdOnglet=" + Onglet.ONGLET_AFFAIRE_PARAMETRES 
			+ "&amp;sActionParam=store" 
			+ "&amp;nonce=" + System.currentTimeMillis() ) 
	%>')" value="Modifier les paramètres" />
	
	<input type="button" onclick="Redirect('<%= 
		response.encodeURL(
			rootPath + "desk/marche/algorithme/affaire/modifierMarcheParametre.jsp?"
			+ "iIdAffaire=" + marche.getIdMarche() 
			+ "&amp;sAction=create" 
			+ "&amp;nonce=" + System.currentTimeMillis() ) 
	%>')" value="Ajouter un paramètre" />
</div>
<br />
<table class="pave" >
	<tr>
		<td>
			<table  class="liste" >
				<tr>
					<th>Nom</th>
					<th>Valeur</th>
					<th>&nbsp;</th>
				</tr>
			
			<%
		
		for(int i = 0;i < vParams.size() ; i++)
		{
			int j = i % 2;
	
			MarcheParametre param = vParams.get(i);
			String sUrlSupprimer 
				= rootPath + "desk/marche/algorithme/affaire/modifierMarcheParametre.jsp?"
				+ "sAction=remove&amp;iIdMarcheParametre=" + param.getIdMarcheParametre() ;
			 %>
				<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 > 
					<td><%= param.getName() %></td>
					<td><%= param.getValue() %></td>
					<td style="text-align:right">
						<a href="<%= response.encodeURL(sUrlSupprimer) %>" >
						<img src="<%=rootPath + modula.graphic.Icone.ICONE_SUPPRIMER %>" alt="Supprimer" title="Supprimer"/> 
						</a>
					</td>		
				</tr>
		<%
		}
		 %>	
			</table>
		</td>
	</tr>
</table>
