<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="java.util.Vector"%>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.marche.MarchePassation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="modula.graphic.Icone"%>
<%
	Organisation organisation = (Organisation)request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton)request.getAttribute("localizeButton");

String rootPath = request.getContextPath() +"/";

	Vector<Marche> vMarches 
		= Marche.getAllMarcheFromIdOrganisation(
				organisation.getIdOrganisation(), " ORDER BY mar.reference ");
%>

<div>
<table class="pave" >
	<tr>
		<td>
			<table class="liste" >
				<tr>
					<th>Réference</th>
					<th>Objet</th>
					<th>Mode passation</th>
					<th>&nbsp;</th>
				</tr>
<%
		for(int i=0; i < vMarches.size(); i++)
		{
			int j = i % 2;
			Marche marche = vMarches.get(i);
			String sPassation = "";
			String sGlobalPassation = "";
			try
			{
				int iIdMarchePassation = modula.algorithme.AffaireProcedure.getAffaireProcedureMemory(
						marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
				MarchePassation mp = MarchePassation.getMarchePassationMemory(iIdMarchePassation);
				sGlobalPassation = mp.getLibelleGlobal();
				sPassation = mp.getLibelle();
			}
			catch(Exception e){}
		%>
	<tr class="liste<%=j%>">
		<td><%= marche.getReference()  %></td>
		<td><%= marche.getObjet() %> </td>
		<td><%= sPassation %></td>
		<td style="text-align:right;width:5%">
			<a href="<%= response.encodeURL(rootPath + "desk/marche/algorithme/affaire/afficherAffaire.jsp?iIdAffaire=" + marche.getIdMarche()) %>">
				<img src="<%=rootPath+Icone.ICONE_FICHIER_DEFAULT %>" alt="<%= localizeButton.getValueDisplay() %>" title="<%= localizeButton.getValueDisplay() %>"/>
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
</div>