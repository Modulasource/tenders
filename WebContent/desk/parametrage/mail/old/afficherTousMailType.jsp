<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*,modula.graphic.*,modula.*,org.coin.util.*, org.coin.bean.*,java.util.*, modula.journal.*"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
	String sTitle = "Liste des mails types";
	String rootPath = request.getContextPath()+"/";

  final int nbElements = Integer.parseInt(getServletContext().getInitParameter("nbElementsListe"));

  SearchEngine recherche 
  		= new SearchEngine(
  			  "SELECT DISTINCT id_mail_type "
  			+ "\n FROM mail_type "
  			+ "WHERE id_mail_type = id_mail_type ",nbElements);
  			
 	recherche.setParam("afficherTousMailType.jsp","id_mail_type"); 
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	
	recherche.load();

 	Vector vRecherche = recherche.getAllResults();
	recherche.addFieldName("id_mail_type" , "Id" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("libelle" , "Libellé" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("objet_type" , "Objet" , SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);

	Vector vTypeEvenements = recherche.getCurrentPage();
	recherche.preventFromForm();
	String sPageUseCaseId = "IHM-DESK-xxx";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<div class="titre_page"><%= sTitle %></div>
<%@ include file="../../../include/paveSearchEngineForm.jspf" %>
<table class="menu" cellspacing="2" summary="Menu">
	<tr>
		<th>
		<a href="<%= response.encodeURL( rootPath + "desk/parametrage/mail/modifierMailTypeForm.jsp?sAction=create") %>">
		<img src="<%= rootPath+Icone.ICONE_PLUS%>"  
		alt="Ajouter un mail type" title="Ajouter un mail type" 
		onmouseover="this.src='<%= rootPath+Icone.ICONE_PLUS_OVER%>'" 
		onmouseout="this.src='<%= rootPath+Icone.ICONE_PLUS%>'" />
		</a>
		</th>
		
		<td>&nbsp;</td>
	</tr>
</table>
<br />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des mails types</td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%=recherche.getNbResultats() %> mails types</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 mail type</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de mail type</td>
<%
		}
	}
%>
	</tr>
	<tr>
		<td colspan="2">
			<table class="liste" summary="none">
				<%= recherche.getHeaderFields(response, rootPath) %>				
<%
	int j;
	for (int i = 0; i < vTypeEvenements.size(); i++)
	{
		MailType oMailType = MailType.getMailTypeMemory(Integer.parseInt((String) vTypeEvenements.get(i)));
		//oTypeEvenement.load(Integer.parseInt((String) vTypeEvenements.get(i)));
		j = i % 2;
		String sUrlDisplay = "afficherMailType.jsp?iIdMailType=" + oMailType.getIdMailType();
		
%>
				<tr class="liste<%=j%>" 
					onmouseover="className='liste_over'" 
					onmouseout="className='liste<%=j%>'" 
					onclick="Redirect('<%= response.encodeURL(sUrlDisplay) %>')"> 
				<td><%= oMailType.getIdMailType() %></td>
				<td><%= oMailType.getLibelle() %></td>
				<td><%= oMailType.getObjetType() %></td>
				<td>
					<a href="<%= response.encodeURL(sUrlDisplay ) %>">
						<img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>" width="21" height="21"  alt="Afficher" title="Afficher"/>
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
<%@ include file="../../include/footerDesk.jspf"%>
</body>
</html>