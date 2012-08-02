<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.candidature.*,org.coin.fr.bean.*,java.sql.*,modula.*,org.coin.util.*,modula.commission.*,modula.marche.*,java.util.*,java.text.*,modula.algorithme.*"%>
<%
	final int iIdPersonnePhysique = Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdPersonnePhysique);
	String sTitle = "Dématérialiser la candidature de "+ personne.getCivilitePrenomNom() +" reçue au format papier - choisir le marché";

%>
<%@ include file="pave/searchEngineMarchesPubliesEtNonAttribuesEtNonCandidates.jspf" %> 
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">
<%@ include file="/include/paveSearchEngineForm.jspf" %>
<br />

<form action="<%=response.encodeURL("choisirMarche.jsp")%>" method="post" id="form1" name="form1" >
<input type="hidden" value="<%=iIdPersonnePhysique%>" name="iIdPersonnePhysique" />
<table class="pave" summary="none">
	<tr>
		<td class="pave_titre_gauche">Liste des marchés </td>
<%
	if(recherche.getNbResultats()>1){
%>
			<td class="pave_titre_droite"><%=recherche.getNbResultats() %> march&eacute;s</td>
<%
	}
	else{
		if(recherche.getNbResultats()==1){
%>
			<td class="pave_titre_droite">1 march&eacute;</td>
<%
		}
		else{
%>
			<td class="pave_titre_droite">Pas de march&eacute;</td>
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
	for (int i = 0; i < vMarches.size(); i++)
	{
		Marche marche = (Marche) vMarches.get(i);
		j = i % 2;
		Commission commission = Commission.getCommission(marche.getIdCommission()) ;
		Organisation organisation =  Organisation.getOrganisation(commission.getIdOrganisation()); 
%>
				<tr class="liste<%=j%>" onmouseover="className='liste_over'" onmouseout="className='liste<%=j%>'" onclick="Redirect('<%= response.encodeURL("afficherCandidature.jsp?iIdPersonnePhysique=" + iIdPersonnePhysique +"&amp;iIdMarche="+marche.getIdMarche()) %>')"> 
				<!--  onclick="#" -->
					<td><%= marche.getReference() %></td>
					<td><%= organisation.getRaisonSociale() + " / "  + commission.getNom() %></td>
					<td><%= marche.getObjet() %></td>
					<td>
					<%
						Vector<Validite> vValiditesEnveloppeB = Validite.getAllValiditeEnveloppeBFromAffaire(marche.getIdMarche());
						Validite oLastValiditeB = null;
						Timestamp tsDateCloture = null;
						if(vValiditesEnveloppeB != null)
						{
							if(vValiditesEnveloppeB.size() > 0)
							{
								oLastValiditeB = vValiditesEnveloppeB.lastElement();
								tsDateCloture = oLastValiditeB.getDateFin();
							}
						}
					if(tsDateCloture == null) 
					{%>
					<%="Indéfinie"%>
					<% 
					}
					else
					{%>
					<%= org.coin.util.CalendarUtil.getDateFormattee(tsDateCloture)%>
					<%}%>
					</td>
					<td>
					<%
						String sPassation = "";
				    	try
				    	{
				    		int iIdMarchePassation = AffaireProcedure.getAffaireProcedureMemory(marche.getIdAlgoAffaireProcedure()).getIdMarchePassation();
				    		sPassation = MarchePassation.getMarchePassationNameMemory(iIdMarchePassation);
				    	}
				    	catch(Exception e){}
					%>
					<%= (sPassation != null)? sPassation:"Indéfini"%>
					</td>
					<td>
						<a href="<%= response.encodeURL("afficherCandidature.jsp?iIdPersonnePhysique=" + iIdPersonnePhysique +"&amp;iIdMarche=" + marche.getIdMarche() ) %>">
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
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>