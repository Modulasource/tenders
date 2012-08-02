<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.export.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Afficher multimédia";
	String rootPath = request.getContextPath()+"/";
	boolean bDisplayAddButton = true;
	String sUrlRedirect = "afficherToutesPublicationsBoamp.jsp?foo=1" ;
	
	Vector<Publication> vPublications = Publication.getAllPublication();
%>
<%@ include file="../../include/headerDesk.jspf" %>
</head>
<body>
<% 
	if(bDisplayAddButton )
	{
%>
<a href="<%= response.encodeURL("modifierPublicationForm.jsp?sAction=create"
	+ "&amp;sUrlRedirect=" + sUrlRedirect ) %>" >Ajouter publication</a><br/>
<a href="<%= response.encodeURL("afficherTousPublicationType.jsp?"
	+ "sUrlRedirect=" + sUrlRedirect ) %>" >Afficher tout type de publication</a><br/>
<a href="<%= response.encodeURL("afficherTousPublicationxxx.jsp?"
	+ "sUrlRedirect=" + sUrlRedirect ) %>" >Afficher tout type de publication</a><br/><br/>
<%	}
	
	
	%>

<table class="pave" summary="none">
	<tr>
		<td>
<table  class="liste" summary="Les publications">
	<tr>
		<th>id</th>
		<th>type objet</th>
		<th>ref objet</th>
		<th>id export</th>
		<th>type</th>
		<th>ref externe</th>
		<th>num paru</th>
		<th>num annonce</th>
		<th>envoi</th>
		<th>publication</th>
		<th>creation</th>
		<th>modification</th>
		<th>&nbsp;</th>
	</tr>
	
	<%
	for (int i=0; i < vPublications.size();i++)
	{
		Publication publi = vPublications.get(i);
		int j = i % 2;
		
		String sTypeObjetName = "?";
		try {
			sTypeObjetName= modula.TypeObjetModula.getTypeObjetModulaName( publi.getIdTypeObjet());
		} catch (Exception e) {sTypeObjetName = "? =" + publi.getIdTypeObjet() ;}
		
		String sReferenceObjetName = 
			modula.TypeObjetModula.getIdObjetReferenceName(
					publi.getIdTypeObjet(), 
					publi.getIdReferenceObjet());

		
		String sUrlAfficherPublication 
			= response.encodeURL(
					rootPath 
					+ "desk/export/publication/afficherPublication.jsp?"
					+ "iIdPublication=" + publi.getIdPublication()
					+ "&amp;sUrlRedirect=" + sUrlRedirect);
		%>
	<tr class="liste<%=j%>"
		 onmouseover="className='liste_over'" 
		 onmouseout="className='liste<%=j%>'"
		 onclick="Redirect('<%= sUrlAfficherPublication	 %>')" >
		<td><%= publi.getIdPublication() %> </td>
		<td><%= sTypeObjetName %> </td>
		<td><%= sReferenceObjetName  %> </td>
		<td><%= publi.getIdExport() %> </td>
		<td><%= publi.getIdPublicationType() %> </td>
		<td><%= publi.getReferenceExterne() %> </td>
		<td><%= publi.getNumeroParution() %> </td>
		<td><%= publi.getNumeroAnnonce() %> </td>
		<td><%= org.coin.util.CalendarUtil.getDateFormattee(publi.getDateEnvoi())%></td>
		<td><%= org.coin.util.CalendarUtil.getDateFormattee(publi.getDatePublication())%></td>
		<td><%= org.coin.util.CalendarUtil.getDateFormattee(publi.getDateCreation())%></td>
		<td><%= org.coin.util.CalendarUtil.getDateFormattee(publi.getDateModification())%></td>
		<td style="text-align:right"><a href="<%= response.encodeURL( 
				sUrlAfficherPublication
				+ "&amp;sUrlRedirect=" + sUrlRedirect) 
			%>" >
			<img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT %>"  />
			</a>&nbsp;
			<a href="<%= response.encodeURL( 
			rootPath + "desk/export/modifierPublication.jsp?sAction=remove&amp;iIdExport="
			+ publi.getIdPublication()
			+ "&amp;sUrlRedirect=" + sUrlRedirect) %>" >
			<img src="<%=rootPath + modula.graphic.Icone.ICONE_SUPPRIMER %>"  /> 
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
</body>
</html>
