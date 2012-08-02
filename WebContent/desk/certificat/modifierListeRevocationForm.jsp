<%@ include file="../../include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Liste de Révocation";
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");

	ListeRevocation liste = null;
	
	if(sAction.equals("create"))
	{
		sTitle = "Ajout d'une liste de révocation";
		liste = new ListeRevocation();
	}
	
	if(sAction.equals("store"))
	{
		sTitle = "Modification d'une liste de révocation";
		if(request.getParameter("iIdListeRevocation") != null)
		{
			int iIdListeRevocation = Integer.parseInt(request.getParameter("iIdListeRevocation"));
			liste = ListeRevocation.getListeRevocationMemory(iIdListeRevocation);
		}
	}
 %>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
</head>
<body onload="cacher('divDetails')">
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<br/>
<form name="revocation" action="<%= response.encodeURL("modifierListeRevocation.jsp?sAction="+sAction+"&iIdListeRevocation="+liste.getId()) %>" method="post" enctype="multipart/form-data" >
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2"><%= sTitle %></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Autorit&eacute; de certification racine : </td>
		<td class="pave_cellule_droite">
			<select name="iIdAC" style="width:330px">
			<%
				Vector<AutoriteCertificationRacine> vAC = AutoriteCertificationRacine.getAllStaticMemory();
				for(AutoriteCertificationRacine AC : vAC)
				{
					String sSelected = "";
					if(liste.getIdAutoriteCertificationRacine() == AC.getId())
						sSelected = "selected='selected'";
					%>
					<option <%= sSelected %> value="<%= AC.getId() %>"><%=AC.getFilename()%></option>
					<%
				}
			%>
			</select>
		</td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Libelle : </td>
		<td class="pave_cellule_droite"><input size="50" type="text" name="libelle" value="<%= liste.getLibelle() %>" /></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">URL download : </td>
		<td class="pave_cellule_droite"><input size="100" type="text" name="url" value="<%= liste.getURLDownload() %>"/></td>
	</tr>
	<tr>
		<td class="pave_cellule_gauche">Liste de r&eacute;vocation (.crl) : </td>
		<td class="pave_cellule_droite"><input size="100" type="file" name="sFilePath" /></td>
	</tr>
	<%
	if(sAction.equals("store"))
	{
	%>
	<tr>
		<td class="pave_cellule_gauche" colspan="2" style="text-align:left;"><a href="javascript:montrer_cacher('divDetails')">Voir les certificats r&eacute;voqu&eacute;s</a></td>
	</tr>
	<tr id="divDetails" style="width:50%">
		<td colspan="2">
		<%
		Set listeCert = null;
		try
		{
			liste.getCRL().getRevokedCertificates();
		}
		catch(Exception e){}
		if(listeCert != null)
		{
			for (Iterator it=listeCert.iterator(); it.hasNext(); ) 
			{
	       		X509CRLEntry crlEntry = (X509CRLEntry)it.next();
			%>
			<table class="pave" summary="none">
				<tr>
					<td class="pave_titre_gauche" colspan="2">Certificat</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche">Num de serie : </td>
					<td class="pave_cellule_droite"><%= crlEntry.getSerialNumber() %>
					</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche">Date de r&eacute;vocation : </td>
					<td class="pave_cellule_droite"><%= crlEntry.getRevocationDate() %>
					</td>
				</tr>
				<tr>
					<td class="pave_cellule_gauche">encoded : </td>
					<td class="pave_cellule_droite"><%= CertificateUtil.getHexaStringValue(crlEntry.getEncoded()) %>
					</td>
				</tr>
			</table>
			<br />
			<%
			}
		}
		%>
		</td>
	</tr>
	<%
	}
	%>
</table>
<br />
<input type="hidden" name="iIdListeRevocation" value="<%= liste.getId() %>" />
<input type="hidden" name="sAction" value="<%= sAction %>" />
<input type="submit"/>
<%
if(sAction.equals("store"))
{
%>
<button type="button" onclick="Redirect('<%= 
	response.encodeURL("modifierListeRevocation.jsp?sAction=remove&iIdListeRevocation="+liste.getId() ) 
	%>')" >Supprimer</button>
<%
}
%>
<button type="button" onclick="Redirect('<%=
	response.encodeURL("afficherToutesListeRevocation.jsp" ) 
	%>')" >Annuler</button>
</form>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.security.CertificateUtil"%>
</html>
