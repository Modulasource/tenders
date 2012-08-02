<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,java.util.*, modula.marche.cpv.*,modula.graphic.*,java.sql.*" %>
<%
	String sTitle = "Recherche d'un descripteur";
	String schamp = request.getParameter("champ");

  	final int nbElements = 12;
	String tri="";
	String sRequest = "";
  	sRequest = "SELECT cpv_principal.id_cpv_principal, cpv_principal.libelle FROM cpv_principal WHERE 1=1 ";

	String sFrame = "";
	if (request.getParameter("sFrame") != null && !request.getParameter("sFrame").equalsIgnoreCase(""))
		sFrame = request.getParameter("sFrame");

	SearchEngine recherche = new SearchEngine(sRequest ,nbElements)
	{

		public Object getObjetFromResultSet(ResultSet rs) throws SQLException{
				CPVPrincipal cpv = new CPVPrincipal(rs.getString(1));
				cpv.setId(rs.getString(1));
				cpv.setName(rs.getString(2));
				return cpv;
		}
	
	};

	recherche.setCutSearchWithMaxElement(false);
	recherche.setParam("rechercherCPV.jsp","cpv_principal.id_cpv_principal"); 
	recherche.setExtraParamHeaderUrl("&amp;champ="+schamp+"&amp;sFrame="+sFrame);
	recherche.setFromFormPrevent(request, "");
	recherche.getAllResultObjects();

	recherche.addFieldName("cpv_principal.libelle" , "libelle" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("cpv_principal.id_cpv_principal" , "code" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vCPV = recherche.getCurrentPage();
	recherche.preventFromForm();
%>
<script type="text/javascript">
	function valider(numCPV)
	{	
		try{
			opener.parent<%= (sFrame.equalsIgnoreCase("")?"":"."+sFrame) %>.document.<%=schamp%>.value=numCPV;
			try{opener.parent<%= (sFrame.equalsIgnoreCase("")?"":"."+sFrame) %>.document.<%=schamp+"_txt"%>.value=numCPV;
			} catch(e) {}
		setTimeout("self.close();",500);
		}catch(e) {
			top.document.getElementById("<%= schamp%>").value=numCPV;
			alert(parent.window.name);
			alert(parent.parent.window.name);
			alert(parent.parent.parent.window.name);
			alert(parent.parent.parent.parent.window.name);
			//$("<%= schamp %>").value=numCPV;
			document.getElementById("<%= schamp%>").value=numCPV;
			parent.parent.document.getElementById("<%= schamp%>").value=numCPV;
			//parent<%= (sFrame.equalsIgnoreCase("")?"":"."+sFrame) %>.document.<%=schamp%>.value=numCPV;
			try{parent<%= (sFrame.equalsIgnoreCase("")?"":"."+sFrame) %>.document.<%=schamp+"_txt"%>.value=numCPV;
			} catch(e) {}
		}
	}
</script>
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<br />

<%@ include file="../../../../include/paveSearchEngineForm.jspf" %>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche"> Liste des descripteurs</td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%= recherche.getNbResultats()%> descripteurs</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 descripteur</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de descripteur</td>
<%
		}
	}
%>
  </tr>
  <tr>
    <td colspan="2"><button onclick="valider('')" >Effacer</button></td>
  </tr>
  <tr>
    <td colspan="2">
			<table class="liste" summary="none">
<%
	int j;
	for (int i = 0; i < vCPV.size(); i++)
	{
		try{
    	CPVPrincipal CPV = (CPVPrincipal) vCPV.get(i);
		j = i % 2;
%>
				<tr class="liste<%=j%>" 
					onclick = "javascript:valider('<%= CPV.getIdString()%>')" 
					onmouseover="className='liste_over'" onmouseout="className='liste<%=j%>'"> 
					<td style="width:20%"><%= CPV.getIdString() %></td>
					<td style="width:75%"><%= CPV.getName()%></td>
					<td style="width:5%;text-align:right">
						<a href="javascript:valider('<%= CPV.getIdString()%>')">
							<img src="<%=rootPath+Icone.ICONE_PLUS %>" title="Ajouter" alt="Ajouter"  />
						</a>
					</td>
				</tr>
<%
		}catch(Exception e){}
	}
%>
			</table>
		</td>
	</tr>
</table>
</div>
<%@ include file="../../../../../include/new_style/footerFiche.jspf" %>
</body>
</html>
