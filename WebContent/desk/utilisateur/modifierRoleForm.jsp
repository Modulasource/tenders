<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,modula.graphic.*" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.bean.conf.Treeview"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.util.*"%>
<%@ include file="include/localization.jspf" %>
<%
	String sIdUser ;
	String sSelected ;
	String sTitle  = "";
	boolean bShowForm = false;
	int iTabMax = 101;	
	
	String sAction =  request.getParameter("sAction") ;
	if(request.getParameter("sAction") == null) sAction="";
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet",request, 0);
	
	if(sAction.equals("store"))
	{
		bShowForm = true;
	}
	int iIdRole = Integer.parseInt( request.getParameter("iIdRole") );
	Role role = Role.getRole(iIdRole);
	sTitle = "Rôle " + role .getName();

	
	Vector<UseCase> vUseCasesRole = Habilitation.getAllUseCase((int)role.getId());
	Vector<Habilitation> vHabCU = Habilitation.getAllFromRoleMemory(role.getId());
	Vector<String> vAllUseCasePrefix = new Vector<String> (iTabMax );
	vAllUseCasePrefix.setSize(iTabMax);

	String sUrlTab = response.encodeURL( "modifierRoleForm.jsp?iIdRole="+iIdRole
			+"&nonce=" + System.currentTimeMillis() + "&iIdOnglet=");
	
	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Menu", sUrlTab + 0) ); 
	vOnglets.add( new Onglet(1, false, "Organisation", sUrlTab + 1) ); 
	vAllUseCasePrefix.set(1, new String ("IHM-DESK-ORG-;IHM-DESK-PERS-")); 

	Onglet tab = new Onglet(2, false, "Affaire", sUrlTab + 2, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.affaire.show", true))
	{
		vAllUseCasePrefix.set(2, new String ("IHM-DESK-AFF-;IHM-DESK-COM-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 

	
	tab = new Onglet(3, false, "Petite annonce", sUrlTab + 3, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.petiteannonce.show", true))
	{
		vAllUseCasePrefix.set(3, new String ("IHM-DESK-PA-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 

	
	tab = new Onglet(4, false, "Publisher", sUrlTab + 4, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.publisher.show", true))
	{
		vAllUseCasePrefix.set(4, new String ("IHM-PUBLI-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 
	
	vOnglets.add( new Onglet(5, false, "Administration", sUrlTab + 5) ); 
	vAllUseCasePrefix.set(5, new String ("IHM-DESK-PARAM-HAB-;IHM-DESK-PARAM-TV-")); 

	vOnglets.add( new Onglet(6, false, "Paramétrage", sUrlTab + 6) ); 
	vAllUseCasePrefix.set(6, new String ("IHM-DESK-PARAM-ORG-;IHM-DESK-PARAM-AFF-;IHM-DESK-PARAM-MAIL-")); 

	vOnglets.add( new Onglet(7, false, "Journal", sUrlTab + 7) ); 
	vAllUseCasePrefix.set(7, new String ("IHM-DESK-JOU-")); 

	
	tab = new Onglet(8, false, "FAQ", sUrlTab + 8, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.faq.show", true))
	{
		vAllUseCasePrefix.set(8, new String ("IHM-DESK-FAQ-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 

	tab = new Onglet(9, false, "GED", sUrlTab + 9, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.ged.show", true))
	{
		vAllUseCasePrefix.set(9, new String ("IHM-DESK-GED-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 
	
	tab = new Onglet(10, false, "Aide Rédactionnelle", sUrlTab + 10, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.aideredac.show", true))
	{
		vAllUseCasePrefix.set(10, new String ("IHM-DESK-AR-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 
	
	
	tab = new Onglet(11, false, "Vehicle", sUrlTab + 11, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.vehicle.show", false))
	{
		vAllUseCasePrefix.set(11, new String ("IHM-DESK-VEHICLE-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 
	

	tab = new Onglet(12, false, "Contract", sUrlTab + 12, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.contract.show", false))
	{
		vAllUseCasePrefix.set(12, new String ("IHM-DESK-CONTRACT-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 

	tab = new Onglet(13, false, "Planification", sUrlTab + 13, true) ;
	if(Configuration.isTrueMemory("desk.param.habilitation.role.tab.planification.show", false))
	{
		vAllUseCasePrefix.set(13, new String ("IHM-DESK-PLANIFICATION-")); 
		tab.bHidden = false;
	}
	vOnglets.add(tab  ); 
	
	int iTabOthers = vOnglets.size();// + 1;
	
	vOnglets.add( new Onglet(iTabOthers , false, "Autres", sUrlTab + iTabOthers ) ); 
	//vOnglets.setSize(34);
		
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;
	
	String sUseCaseWhereClause  = "";
	String sUseCasePrefix = "" ;
	String sUseCase = "";
	Vector vUseCasesAll = null;

	String sUseCaseAR = "";
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;

%>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<%@page import="org.coin.bean.html.Tab"%>
<br/>
<div style="padding:15px">

<script type="text/javascript" src="<%=rootPath %>include/bascule.js" ></script>
<script type="text/javascript" >
	
function checkForm()
{
	var form = document.formulaire;
	
<%

if(iIdOnglet  > 0 && iIdOnglet < iTabOthers )
{
	String sPrefixes = vAllUseCasePrefix.get(iIdOnglet  );
	String[] arr = sPrefixes.split(";");
	for (int iPrefix = 0; iPrefix  < arr.length ; iPrefix ++)
	{
		String sPref = arr[iPrefix];
		sPref = Outils.replaceAll(sPref,"-","_");
		%>
	Visualise(form.<%= sPref%>iIdUseCaseSelection,form.<%= sPref%>iIdUseCaseSelectionListe);
		<%
	}
}
	
if(iIdOnglet == iTabOthers )
{
%>
	Visualise(form._OTHER_iIdUseCaseSelection,form._OTHER_iIdUseCaseSelectionListe);
	Visualise(form._OTHER_iIdUseCase,form._OTHER_UNSELECTED_iIdUseCaseSelectionListe);
<%
}

%>
} // end checkForm()
</script>
</head>
<body>
<br/>
<%
Vector<BarBouton> vBarBoutons = new Vector<BarBouton>();

if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
{
		vBarBoutons.add( 
			new BarBouton(0 ,
				 "Supprimer le rôle", 
				 response.encodeURL("modifierRole.jsp?sAction=remove&amp;iIdRole=" + role.getId()), 
				 rootPath+ Icone.ICONE_SUPPRIMER , 
				 "" , 
				 "" , 
				 "return confirm('Etes vous sûr de vouloir supprimer ce rôle ?');" ,
				 true) );
}

if( sessionUserHabilitation.isHabilitate("IHM-DESK-xxx") )
{
		vBarBoutons.add( 
			new BarBouton(0 ,
				 "Modifier la treeview du rôle", 
				 response.encodeURL("modifierRoleTreeviewForm.jsp?iIdRole=" + role.getId()), 
				 rootPath+"images/icones/modifier_small.gif" , 
				 "" , 
				 "" , 
				 "" ,
				 true) );
}

%>
<%@ include file="../../../../include/paveBarButtons.jspf" %>
<br />
<div class="tabFrame">
<%= Onglet.getAllTabsHtmlDesk(vOnglets) %>
<div class="tabContent">
<%
if(bShowForm )
{
%>
				<form name="formulaire" action="<%= response.encodeRedirectURL("modifierRole.jsp") %>" method="post" onSubmit="return checkForm();" >
				<input type="hidden" name="iIdRole" value="<%=role.getId() %>" />
				<input type="hidden" name="sAction" value="<%=sAction %>" />
				<input type="hidden" name="iIdOnglet" value="<%=iIdOnglet %>" />
				<table id="formulaire_principal" width='100%' >
					<tr>
						<td style="text-align : right" >
							<button type="submit" >Valider</button>
						</td>
					</tr>
				</table>
<%
} else {
%>
				<table name="formulaire_principal" width='100%' >
					<tr>
						<td style="text-align : right" >
							<button type="button" onclick="javascript:Redirect('<%= 
								response.encodeRedirectURL("modifierRoleForm.jsp?iIdRole=" + iIdRole 
										+ "&amp;iIdOnglet="+iIdOnglet+"&amp;sAction=store" ) %>')" >Modifier</button>
						</td>
					</tr>
				</table>
<%}
%>
			
	<br />
<% if(iIdOnglet == 0)
	{
		Treeview treeview = null;
		try {
			treeview = Treeview.getTreeview(role.getIdTreeview());
		}catch (CoinDatabaseLoadException e) {
			treeview = new Treeview();
		}

		if(sAction.equals("store") )
 		{
			hbFormulaire.bIsForm = true;
 		%>
	<%@ include file="pave/paveRoleNameForm.jspf" %>
	<br />
	<%@ include file="pave/paveUseCaseForm.jspf" %>
	<br />
	<%@ include file="pave/paveTreeviewNodeRole.jspf" %>  
<%
		} else {
 %>	
	<%@ include file="pave/paveRoleName.jspf" %>
	<br />
	<%@ include file="pave/paveUseCase.jspf" %>
	<br />
	<%@ include file="pave/paveTreeviewNodeRole.jspf" %>

<%	
		}
	}


	if(iIdOnglet  > 0 && iIdOnglet < iTabOthers )
	{
		String sPrefixes = vAllUseCasePrefix.get(iIdOnglet  );
		String[] arr = sPrefixes.split(";");
		for (int iPrefix = 0; iPrefix < arr.length ; iPrefix++)
		{
			String sPref = arr[iPrefix];
			sUseCasePrefix = Outils.replaceAll(sPref , "-", "_");
			sUseCase = sPref ;
			vUseCasesAll = UseCase.getAllUseCaseWithPrefixMemory(sUseCase);
			if(sAction.equals("store") )
			{
				%>
				<%@ include file="pave/paveBalanceUseCase.jspf" %>
				<br />
			<%
			} else {
			%>
				<%@ include file="pave/pavePrefixUseCase.jspf" %>
				<br />
			<%
			}
		}
	}

	if (iIdOnglet == iTabOthers )
	{
		// Le reste 
		sUseCaseWhereClause = " WHERE ";
		boolean bIsFirstInWhereClause = true;
		
		for(int iTabTemp = 0; iTabTemp < iTabMax; iTabTemp++)
		{
			String sPrefixes = vAllUseCasePrefix.get(iTabTemp);
			if(sPrefixes==null) continue;
			
			String[] arr = sPrefixes.split(";");
			
			for (int iPrefix = 0; iPrefix < arr.length ; iPrefix++)
			{
				String sPref = arr[iPrefix];
				if(bIsFirstInWhereClause) {
					bIsFirstInWhereClause = false;
				} else {
					sUseCaseWhereClause += " AND ";
				}
				
				sUseCaseWhereClause += " id_use_case NOT LIKE '"+ Outils.addLikeSlashes(sPref) + "%' ";
			}
		}
		sUseCasePrefix = "_OTHER_" ;
		sUseCase = "" ;
		
		vUseCasesAll = UseCase.getAllUseCaseWithWhereAndOrderByClauses(sUseCaseWhereClause , "");
			
		if(sAction.equals("store") )
 		{
 		%>
			<%@ include file="pave/paveBalanceUseCase.jspf" %>
			<input type="hidden" name="_OTHER_UNSELECTED_iIdUseCaseSelectionListe" />
			<br />
		<%
		} else {
		%>
			<%@ include file="pave/pavePrefixUseCase.jspf" %>
			<br />
		<%
		}
	}
	%>
	<br />

<%
	if(bShowForm )
	{

%>
				<table name="formulaire_principal" width='100%' >
					<tr>
						<td style="text-align : right" >
							<button type="submit" >Valider</button>
						</td>
					</tr>
				</table>
		</form>
<%
	} 
%>
</div>
</div>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</body>
</ht<%@page import="org.coin.util.Outils"%>
ml>
