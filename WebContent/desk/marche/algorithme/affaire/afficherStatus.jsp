<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.*"%>
<%@ page import="modula.marche.*,modula.candidature.*" %>
<%
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);

	String sTitle = null;
	String sFormPrefix = "";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	boolean bShowForm = false;
	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdAffaire);
	Vector<Candidature> vCandidatures = Candidature.getAllCandidatureFromMarche(iIdAffaire);
	AvisAttribution oAvisAttribution = null;
	try
	{
		oAvisAttribution = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	} catch(Exception e){}
	
	Vector<AvisRectificatif> vAvisRectificatif = AvisRectificatif.getAllAvisRectificatif(iIdAffaire);

	sTitle = "Statuts de l'affaire ref."+marche.getReference(); 
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyle =  " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation =  " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle =  " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Marché", response.encodeURL("afficherStatus.jsp?iIdOnglet=0")) ); 
	vOnglets.add( new Onglet(1, false, "Lots", response.encodeURL("afficherStatus.jsp?iIdOnglet=1")) ); 
	vOnglets.add( new Onglet(2, false, "Candidatures", response.encodeURL("afficherStatus.jsp?iIdOnglet=2")) ); 
	vOnglets.add( new Onglet(3, false, "Avis Attribution", response.encodeURL("afficherStatus.jsp?iIdOnglet=3")) ); 
	if(sessionUserHabilitation.isHabilitate("IHM-DESK-AFF-RECT-5"))
		vOnglets.add( new Onglet(4, false, "Avis Rectificatifs", response.encodeURL("afficherStatus.jsp?iIdOnglet=4")) ); 

	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;

	String sHeadTitre = sTitle; 
	boolean bAfficherPoursuivreProcedure = false;
%>
<script src="<%= rootPath %>include/cacherDivision.js" type="text/javascript"></script>
<script src="<%= rootPath %>include/bascule.js" type="text/javascript"></script>
<script type="text/javascript">
function onAfterPageLoading()
{
	<%
	if(iIdOnglet == 2)
	{
		for(int iCandidature = 0;iCandidature < vCandidatures.size();iCandidature++)
		{
			Candidature candidature = vCandidatures.get(iCandidature);
	%>
	//cacher('div_<%= candidature.getIdCandidature() %>');
	<%
		}
	}
	%>
	
	<%
	if(iIdOnglet == 4)
	{
		for(int iRect = 0;iRect < vAvisRectificatif.size();iRect++)
		{
			AvisRectificatif avisRect = vAvisRectificatif.get(iRect);
	%>
	cacher('div_<%= avisRect.getIdAvisRectificatif() %>');
	<%
		}
	}
	%>
}
</script>
</head>
<body onload='onAfterPageLoading()'">
<%
if(sAction.equals("store") ) 
{
	bShowForm = true;
}
%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@ include file="/include/new_style/headerAffaireOnlyButtonDisplayAffaire.jspf" %>
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
					<table summary="none">
						<tr>
							<td align='right'>
							<input type="hidden" name="iIdAffaire" value="<%= iIdAffaire %>" />
<%
if(sAction.equals("store") )
{ %>
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
							<button type="button"  onclick='javascript:Redirect("<%= 
								response.encodeURL("afficherAttribution.jsp?iIdOnglet=" + iIdOnglet 
										+ "&amp;iIdAffaire=" + marche.getIdMarche()) %>")' >Retour</button>
<%
	}
}
else
{

%>
							<button type="button"  onclick="Redirect('<%=
								response.encodeURL("afficherStatus.jsp?iIdOnglet=" + iIdOnglet 
										+ "&amp;sAction=store"
										+ "&amp;iIdAffaire=" + marche.getIdMarche())%>') " >Modifier</button>

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
	
    CoinDatabaseWhereClause wcPP = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
    CoinDatabaseWhereClause wcOrganisation = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
    CoinDatabaseWhereClause wcCandidature = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);

    for(int iCand = 0;iCand<vCandidatures.size();iCand++ )
    {
    	Candidature oCandidature = vCandidatures.get(iCand);
    	wcCandidature.add(oCandidature.getId());
    	wcPP.add(oCandidature.getIdPersonnePhysique());
        wcOrganisation.add(oCandidature.getIdOrganisation());
    }
    
    Vector< PersonnePhysique> vPersonnePhysique 
	    = PersonnePhysique.getAllWithWhereClause(
	    		" WHERE " + wcPP.generateWhereClause("id_personne_physique"));

    Vector< Organisation> vOrganisation 
	    = Organisation.getAllWithWhereAndOrderByClauseStatic(
	            " WHERE " + wcOrganisation.generateWhereClause("id_organisation"),
	            "");

    /**
     * ICI ce n'est que pour un marche ...
     */
    Vector<MarcheLot > vMarcheLotAll
	    = MarcheLot.getAllLotsFromMarche(marche.getIdMarche());

    EnveloppeA enveloppeAAll = new EnveloppeA();
    Vector<EnveloppeA > vEnveloppeAAll
        = enveloppeAAll.getAllWithWhereAndOrderByClause(
            " WHERE " + wcCandidature.generateWhereClause("id_candidature"), 
            "");
    
    
    EnveloppeB enveloppeBAll = new EnveloppeB();
    Vector<EnveloppeB > vEnveloppeBAll
        = enveloppeBAll.getAllWithWhereAndOrderByClause(
            " WHERE " + wcCandidature.generateWhereClause("id_candidature"), 
            "");
    
    EnveloppeC enveloppeCAll = new EnveloppeC();
    Vector<EnveloppeC > vEnveloppeCAll
        = enveloppeCAll.getAllWithWhereAndOrderByClause(
            " WHERE " + wcCandidature.generateWhereClause("id_candidature"), 
            "");
    
	for(int iCand = 0;iCand<vCandidatures.size();iCand++ )
	{
		Candidature oCandidature = vCandidatures.get(iCand);
		//PersonnePhysique oCandidat = PersonnePhysique.getPersonnePhysique(oCandidature.getIdPersonnePhysique(), vPersonnePhysique);
		PersonnePhysique oCandidat = (PersonnePhysique)CoinDatabaseAbstractBean.getCoinDatabaseAbstractBeanFromId(oCandidature.getIdPersonnePhysique(), vPersonnePhysique);
		Organisation oOrganisation = Organisation.getOrganisation(oCandidature.getIdOrganisation(), vOrganisation);
		//Vector vEnveloppeA = EnveloppeA.getAllEnveloppeAFromCandidature(oCandidature.getIdCandidature());
		//Vector vEnveloppeB = EnveloppeB.getAllEnveloppeBFromCandidature(oCandidature.getIdCandidature());
		//Vector vEnveloppeC = EnveloppeC.getAllEnveloppeCFromCandidature(oCandidature.getIdCandidature());
		
		Vector vEnveloppeA = new Vector();
		for(EnveloppeA envA : vEnveloppeAAll)
		{
			if(envA.getIdCandidature() == oCandidature.getIdCandidature())
			{
				vEnveloppeA.add(envA);
			}
		}
		
	      
        Vector vEnveloppeB = new Vector();
        for(EnveloppeB envB : vEnveloppeBAll)
        {
            if(envB.getIdCandidature() == oCandidature.getIdCandidature())
            {
                vEnveloppeB.add(envB);
            }
        }
        
        
        Vector vEnveloppeC = new Vector();
        for(EnveloppeC envC : vEnveloppeCAll)
        {
            if(envC.getIdCandidature() == oCandidature.getIdCandidature())
            {
                vEnveloppeC.add(envC);
            }
        }
		%>
        <div>
		<p class="mention">
			<a class="mention" href="javascript:void(0);"  onclick="Element.toggle('divCandidature_<%= oCandidature.getIdCandidature() 
			%>');" >Statuts de la candidature de <%= oCandidat.getCivilitePrenomNom() 
			+ " société " + oOrganisation.getRaisonSociale() 
			+ " (" + oCandidature.getId() + ")"
			%></a>
			
			<a href="<%= response.encodeURL(
					rootPath + "desk/organisation/afficherCandidature.jsp?iIdMarche=" 
							+ marche.getId() 
							+ "&iIdPersonnePhysique=" + oCandidat.getId())
					%>" >Afficher la candidature</a>
		</p>
        </div>
		<div id="divCandidature_<%= oCandidature.getIdCandidature() %>" style="display: none;">
		<%
		sTitrePaveStatut = "Statuts de la candidature de "+oCandidat.getPrenomNom() ;
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
			
			sTitrePaveStatut = "Statuts de l'enveloppe A (id=" 
					+  oEnveloppeA.getId() + ") associée à la candidature ";
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
			

			%>
			<%@ include file="pave/paveStatusPiecesJointesA.jspf" %>
			<%

		}
		
		for( int iEnvB = 0 ; iEnvB < vEnveloppeB.size() ; iEnvB ++ )
		{
			EnveloppeB oEnveloppeB = (EnveloppeB)vEnveloppeB.get(iEnvB);
			MarcheLot oMarcheLot = MarcheLot.getMarcheLot(oEnveloppeB.getIdLot(), vMarcheLotAll);
			
			sTitrePaveStatut = "Statuts l'enveloppe B (id=" + oEnveloppeB.getId() 
					+ ") associée à la candidature du lot ref. "
				    + oMarcheLot.getReference() + " (idlot = " + oMarcheLot.getId() +  ")";
			
			vStatus = oEnveloppeB.getAllStatus();
			sFormPrefix = "enveloppeB_" + oEnveloppeB.getIdEnveloppe();
			if(sAction.equals("store") )
			{
			%><%@ include file="pave/paveStatusAffaireForm.jspf" %><% 
			}
			else 
			{
			%><%@ include file="pave/paveStatusAffaire.jspf" %><% 
			}
			%><%@ include file="pave/paveStatusPiecesJointesB.jspf" %><%
		}
		
		for( int iEnvC = 0 ; iEnvC < vEnveloppeC.size() ; iEnvC ++ )
		{
			EnveloppeC oEnveloppeC = (EnveloppeC)vEnveloppeC.get(iEnvC);
			MarcheLot oMarcheLot = MarcheLot.getMarcheLot(oEnveloppeC.getIdLot(), vMarcheLotAll);
			
			sTitrePaveStatut = "Statuts l'enveloppe C associée a la candidature du lot ref. "
			 +oMarcheLot.getReference();
			
			vStatus = oEnveloppeC.getAllStatus();
			sFormPrefix = "enveloppeC_" + oEnveloppeC.getIdEnveloppe();
			if(sAction.equals("store") )
			{
			%><%@ include file="pave/paveStatusAffaireForm.jspf" %><% 
			}
			else 
			{
			%><%@ include file="pave/paveStatusAffaire.jspf" %><% 
			}
			%><%@ include file="pave/paveStatusPiecesJointesC.jspf" %><%
		}
		%>
		</div>
		<%
	}
}
if( iIdOnglet == 3 )
{
	if(oAvisAttribution != null)
	{
		String sTitrePaveStatut = "Statuts de l'avis d'attribution"; 
		Vector vStatus = oAvisAttribution.getAllStatus();
		sFormPrefix = "";
	
		if(sAction.equals("store") )
		{
		%><%@ include file="pave/paveStatusAffaireForm.jspf" %><% 
		}
		else 
		{
		%><%@ include file="pave/paveStatusAffaire.jspf" %><% 
		}
	}
}
if( iIdOnglet == 4 )
{
	String sTitrePaveStatut = "";
	Vector vStatus = null;
	
	for(int iRect = 0;iRect < vAvisRectificatif.size();iRect++)
	{
		AvisRectificatif oAvisRectificatif = vAvisRectificatif.get(iRect);
		String sTypeAvis = "AAPC";
		if(oAvisRectificatif.getIdAvisRectificatifType() == AvisRectificatifType.TYPE_AATR)
			sTypeAvis = "AATR";
		
		sTitrePaveStatut = "Statuts de l'avis rectificatif de l'"+ sTypeAvis+ " du " 
			+CalendarUtil.getDateFormattee(oAvisRectificatif.getDateCreation());
		%>
		<p class="mention">
			<a class="mention" href="#" onclick="montrer_cacher('div_<%= 
				oAvisRectificatif.getIdAvisRectificatif() %>')" ><%= sTitrePaveStatut %></a>
		</p>
		<div id="div_<%= oAvisRectificatif.getIdAvisRectificatif() %>">
		<%
		vStatus = oAvisRectificatif.getAllStatus();
		sFormPrefix = "avis_rectificatif_" + oAvisRectificatif.getIdAvisRectificatif();

		if(sAction.equals("store") )
		{
		%><%@ include file="pave/paveStatusAffaireForm.jspf" %><% 
		}
		else 
		{
		%><%@ include file="pave/paveStatusAffaire.jspf" %><% 
		}
		%>
		</div>
		<%
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
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.util.CalendarUtil"%>

<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%></html>
