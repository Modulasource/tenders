<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="modula.graphic.*,org.coin.fr.bean.security.*,org.coin.security.token.*,java.security.cert.*,java.io.*,modula.candidature.*, java.util.*" %>
<%
	String sTitle = "Listes de Révocation";
 %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
	<div class="fullWidth">
	<%
		Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();
		if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
		{
			vBarBoutons.add( 
				new BarBouton(0 , 
					"Ajouter une liste de révocation",
					response.encodeURL(rootPath + "desk/certificat/modifierListeRevocationForm.jsp?sAction=create" ), 
					rootPath+"images/icons/36x36/crl_add.png", 
					"" , 
					"" , 
					"" ,
					true) );
			vBarBoutons.add( 
					new BarBouton(0 , 
						"Tester une liste de révocation",
						response.encodeURL(rootPath + "desk/certificat/testerCRLForm.jsp" ), 
						rootPath+"images/icons/36x36/crl_test.png", 
						"" , 
						"" , 
						"" ,
						true) );
		}
%>
<%= BarBouton.getAllButtonHtmlDesk(vBarBoutons) %>
	</div>
</div>
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
	menuBorder.render($('menuBorder'));
});
</script>
<br/>
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche" colspan="2">Listes de r&eacute;vocation</td>
	</tr>
	<tr>
		<td colspan="2">

			<table class="liste" summary="none">
				<tr>
					<th >Libelle</th>
					<th >URL</th>
					<th >AC</th>
				</tr>
				<%
					Vector<ListeRevocation> vlisteRevocation = ListeRevocation.getAllStaticMemory();
				
					for(int i=0 ; i< vlisteRevocation.size(); i++)
					{	
						int	j = i % 2;
						ListeRevocation liste = vlisteRevocation.get(i);
						AutoriteCertificationRacine CA = AutoriteCertificationRacine.getAutoriteCertificationRacineMemory(liste.getIdAutoriteCertificationRacine());
				%>
					<tr class="liste<%=j%>" 
					 onmouseover="className='liste_over'" 
					 onmouseout="className='liste<%=j%>'" 
					 onclick="Redirect('<%= response.encodeRedirectURL("modifierListeRevocationForm.jsp?sAction=store&iIdListeRevocation=" + liste.getId() ) %>')"> 
					<td style="text-align:left;width:30%" ><%= liste.getLibelle() %></td>
					<td style="text-align:left;width:20%" ><%= liste.getURLDownload() %></td>
					<td style="text-align:left;width:10%" ><%= CA.getFilename() %></td>
				</tr>
				<%		
				}
				%>
			</table>
		</td>
	</tr>
</table>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
