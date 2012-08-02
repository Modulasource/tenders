<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="modula.marche.*,modula.candidature.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = null;
	String sFormPrefix = "";
	String sAction = "";
	int iIdOnglet = 0;
	boolean bShowForm = false;
	
	if (request.getParameter("sAction") != null)
	{
		sAction = request.getParameter("sAction");
	}

	try 
	{
		iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	} catch (Exception e) {}
	
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	Vector<Candidature> vCandidatures = Candidature.getAllCandidatureFromMarche(iIdAffaire);

	sTitle = "Statuts de l'affaire ref."+marche.getReference(); 
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector ();
	vOnglets.add( new Onglet(0, false, "Marché", response.encodeURL("afficherStatus.jsp?iIdOnglet=0")) ); 
	vOnglets.add( new Onglet(1, false, " ", response.encodeURL("afficherStatus.jsp?iIdOnglet=0")) ); 

	Onglet onglet = (Onglet ) vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;

%>
<script src="<%= rootPath %>include/cacherDivision.js" type="text/javascript"></script>
<script src="<%= rootPath %>include/bascule.js" type="text/javascript"></script>
<script type="text/javascript">
</script>

</head>
<body>
<%
if(sAction.equals("store") ) 
{
	bShowForm = true;
}
%>
<% String sHeadTitre = sTitle; %>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/desk/include/headerPetiteAnnonceOnlyButtonDisplayPA.jspf" %>
<br/>
<div class="tabFrame">
<div class="tabs">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><div <%= (onglet.bIsCurrent?"class=\"active\"":"") %>
				onclick="javascript:location.href='<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAffaire="+marche.getIdMarche()
					+"&amp;nonce=" + System.currentTimeMillis())%>';">
				<%= onglet.sLibelle %><%= sImageInCreation %></div>
			<%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
</div>
<div class="tabContent">
<%
if(bShowForm )
{ 
%>

					<form action="<%= response.encodeURL("modifierStatus.jsp") %>" method="post"  name="formulaire">
<%
}
%>
					<table s>
						<tr>
							<td align='right'>
<%
if(sAction.equals("store") )
{ %>
                    <input type="hidden" name="iIdAffaire" value="<%= marche.getIdMarche() %>" />
					<input type="hidden" name="sAction" value="<%= sAction %>" />
					<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet %>" />
<%
	if(bShowForm )
	{ 
%>
							<button type="submit" >Valider</button>
<% 	
	}
	else
	{
%>
							<button type="button" 
                    onclick='javascript:Redirect("<%= response.encodeURL(
                        	  "afficherAttribution.jsp?iIdOnglet=" + iIdOnglet 
                           + "&iIdAffaire=" + marche.getIdMarche()) %>")'
                            >Retour</button>
<%
	}
}
else
{

%>
							<button type="button" 
                     onclick="Redirect('<%= response.encodeURL(
                    		 "afficherStatus.jsp"
                    		   + "?iIdOnglet=" + iIdOnglet 
                    		   + "&iIdAffaire=" + marche.getIdMarche()
                               + "&sAction=store")%>') "
                            >Modifier</button>

<% 
}
	%>						</td>
						</tr>
					</table>
					<br />

<%
if( iIdOnglet == 0 )
{
	sFormPrefix = "";
	String sTitrePaveStatut = "Statuts du marché";
	Vector vStatus = marche.getAllStatus();

	if(sAction.equals("store") )
	{
	%>
	<%@ include file="pave/paveStatusAffaireForm.jspf" %>
	<% 
	}
	else 
	{
	%>
	<%@ include file="pave/paveStatusAffaire.jspf" %>
	<% 
	}
	
}
if( iIdOnglet == 1 )
{
	for(int iLots = 0;iLots<vLots.size();iLots++ )
	{
		MarcheLot lot = vLots.get(iLots);
		String sTitrePaveStatut = "Statuts du lot ref. "+lot.getReference();
		Vector vStatus = lot.getAllStatus();
		sFormPrefix = Integer.toString(lot.getIdMarcheLot());
	
		if(sAction.equals("store") )
		{
		%>
		<%@ include file="pave/paveStatusAffaireForm.jspf" %>
		<% 
		}
		else 
		{
		%>
		<%@ include file="pave/paveStatusAffaire.jspf" %>
		<% 
		}
	}
}
if( iIdOnglet == 2 )
{
	String sTitrePaveStatut = "";
	Vector vStatus = null;
	
	for(int iCand = 0;iCand<vCandidatures.size();iCand++ )
	{
		Candidature oCandidature = vCandidatures.get(iCand);
		PersonnePhysique oCandidat = PersonnePhysique.getPersonnePhysique(oCandidature.getIdPersonnePhysique());
		Vector vEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(oCandidature.getIdCandidature());
		Vector vEnveloppeB = EnveloppeB.getAllEnveloppeBFromCandidature(oCandidature.getIdCandidature());
		%>
		<p class="mention">Statuts de la candidature de <%= oCandidat.getCivilitePrenomNom() %></p>
		<%
		sTitrePaveStatut = "Statuts de la candidature de "+oCandidat.getCivilitePrenomNom();
		vStatus = oCandidature.getAllStatus();
		sFormPrefix = "candidature_" + oCandidature.getIdCandidature();

		if(sAction.equals("store") )
		{
		%>
		<%@ include file="pave/paveStatusAffaireForm.jspf" %>
		<% 
		}
		else 
		{
		%>
		<%@ include file="pave/paveStatusAffaire.jspf" %>
		<% 
		}
		
		for( int iEnvA = 0 ; iEnvA < vEnveloppeA.size() ; iEnvA ++ )
		{
			EnveloppeA oEnveloppeA = (EnveloppeA)vEnveloppeA.get(iEnvA);
			
			sTitrePaveStatut = "Statuts de l'enveloppe A associée à la candidature ";
			vStatus = oEnveloppeA.getAllStatus();
			sFormPrefix = "enveloppeA_" + oEnveloppeA.getIdEnveloppe();
			if(sAction.equals("store") )
			{
			%>
			<%@ include file="pave/paveStatusAffaireForm.jspf" %>
			<% 
			}
			else 
			{
			%>
			<%@ include file="pave/paveStatusAffaire.jspf" %>
			<% 
			}
		}
		
		for( int iEnvB = 0 ; iEnvB < vEnveloppeB.size() ; iEnvB ++ )
		{
			EnveloppeB oEnveloppeB = (EnveloppeB)vEnveloppeB.get(iEnvB);
			MarcheLot oMarcheLot = MarcheLot.getMarcheLot(oEnveloppeB.getIdLot());
			
			sTitrePaveStatut = "Statuts l'enveloppe B associée a la candidature du lot ref. "+oMarcheLot.getReference();
			vStatus = oEnveloppeB.getAllStatus();
			sFormPrefix = "enveloppeB_" + oEnveloppeB.getIdEnveloppe();
			if(sAction.equals("store") )
			{
			%>
			<%@ include file="pave/paveStatusAffaireForm.jspf" %>
			<% 
			}
			else 
			{
			%>
			<%@ include file="pave/paveStatusAffaire.jspf" %>
			<% 
			}
		}
	}
}

if(sAction.equals("store") )
{
%>
	<br />
<%
	if(bShowForm )
	{
%>
	</form>
<%
	}
}
%>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
