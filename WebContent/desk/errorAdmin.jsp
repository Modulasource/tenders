<%@ include file="/include/new_style/headerDesk.jspf" %>
<jsp:useBean id="sessionCommissionMembreHabilitation" scope="session" class="modula.commission.CommissionMembreHabilitation" />
<%@ include file="/desk/utilisateur/include/localization.jspf" %>
<%@ page import="java.util.*,org.coin.util.*,org.coin.bean.*,modula.commission.*" %>
<%
	String sTitle = locTitle.getValue(2,"Habilitations");
	Habilitation habLoc = new Habilitation();
	habLoc.setAbstractBeanLocalization(sessionLanguage);
%>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div id="fiche">
<%
	int idError = HttpUtil.parseInt("idError", request, -1);
	String sUseCase = request.getParameter("sUseCase");
	UseCase usecaseForbiden ;
	if(sUseCase != null)
	{
		try {
			usecaseForbiden = UseCase.getUseCaseMemory(sUseCase,sessionLanguage.getId());
		} catch(Exception e) {
			usecaseForbiden = new UseCase();
			usecaseForbiden.setName(e.getMessage());
		}
	}
	else
	{
		usecaseForbiden = new UseCase();
	}
	
	switch (idError)
	{
		case 1:	
				out.write("\t <h2> Pas de membre à affecter </h2>");
				break;
		case 2:
				out.write("\t <h2> Pas de commission à affecter </h2>");
				break;
		case 3:
				out.write("\t <h2> L'adresse du membre n'a pas été inscrite </h2>");
				out.write("\t <h2> Le membre n'est donc pas inscrit </h2>");
				break;
		case 4:
				out.write("\t <h2> Les informations personnelles du membre n'ont pas été inscrites </h2>");
				out.write("\t <h2> L'adresse email du membre est déjà utilisée.</h2>");
				out.write("\t <h2> Le membre n'est donc pas inscrit </h2>");
				break;
		case 5:
				out.write("\t <h2> Les login et mot de passe n'ont pu être inscrits </h2>");
				out.write("\t <h2> Le membre n'est donc pas inscrit </h2>");
				break;
		case 6:
				out.write("\t <h2> L'affectation du président n'a pu être faite pour des raisons techniques </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 7:
				out.write("\t <h2> L'affectation du secrétaire n'a pu être faite pour des raisons techniques </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 8:
				out.write("\t <h2> Un président existe déjà dans cette commission! </h2>");
				out.write("\t <strong> Nous vous rappelons qu'un président est unique dans une commission. </strong>");
				break;
		case 9:
				out.write("\t <h2> Un secrétaire existe déjà dans cette commission! </h2>");
				out.write("\t <strong> Nous vous rappelons qu'un secrétaire est unique dans une commission. </strong>");
				break;
		case 10:
				out.write("\t <h2> L'affectation du membre n'a pu être faite pour des raisons techniques </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 11:
				out.write("\t <h2> Ce membre existe déjà dans cette commission! </h2>");
				break;
		case 12:
				out.write("\t <h2> La commission n'a pu être inscrite pour des raisons inconnues </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 13:
				out.write("\t <h2> La commission n'a pu être modifiée pour des raisons inconnues </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 14:
				out.write("\t <h2> La commission n'a pu être supprimée pour des raisons inconnues </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 15:
				out.write("\t <h2> Le rôle du membre n'a pu être modifié pour des raisons inconnues </h2>");
				out.write("\t <h2> Recommencez à un autre moment </h2>");
				break;
		case 16:
				out.write("\t <h2> La commission est inconnue - Aucune action possible </h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 17:
				out.write("\t <h2> Le membre de commission est inconnu - Aucune action possible </h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 18:
				out.write("\t <h2> Le membre de commission n'a pu être supprimé pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 19:
				out.write("\t <h2> L'adresse du membre de la commission n'a pu être supprimé pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 20:
				out.write("\t <h2> Les login et mot de passe du membre de la commission n'ont pu être supprimés pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 21:
				out.write("\t <h2> Les informations personnelles du membre de la commission n'ont pu être supprimés pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 22:
				out.write("\t <h2> Les informations personnelles du membre de la commission n'ont pu être modifiées pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 23:
				out.write("\t <h2> L'adresse du membre de la commission n'a pu être modifiée pour des raisons inconnues</h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 24:
				out.write("\t <h2> Cette organisation est déjà inscrite dans la base </h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 25:
				out.write("\t <h2> L'adresse de l'organisation n'a pu être inscrite dans la base </h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 26:
				out.write("\t <h2> L'organisation n'a pu être inscrite dans la base </h2>");
				out.write("\t <h2> Reprenez la procédure depuis le début. </h2>");
				break;
		case 100:
				out.write("\t <h2> "+locMessage.getValue(1,"Vous n'etes pas habilité à effectuer cette action")+" : <br />"+ usecaseForbiden.getIdString()+" - "+usecaseForbiden.getName() + "</h2>");
				//+" - " + usecaseForbiden.getName()
				break;
		default: 
				out.write("\t <h2> Erreur inconnue </h2>");
				break;
	}


	Vector vUseCases = null;
	try {
		vUseCases = sessionUserHabilitation.getUseCases( );
		Collections.sort( vUseCases , new CoinDatabaseAbstractBeanComparator(CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_ID_ASCENDING));
	} catch (Exception e) {}
	
	if(vUseCases == null) {
		vUseCases = new Vector();
	}
%>
<br/>
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" ><%= locBloc.getValue(4,"Vos habilitations dans") %> <%= Theme.getDeskTitle() %></td>
			<td class="pave_titre_droite" ><%=vUseCases.size() %> <%= habLoc.getIdUseCaseLabel() %></td>
		</tr>
<%

	for (int j=0; j < vUseCases.size(); j++)
	{
		UseCase usecase = (UseCase) vUseCases.get(j);
		usecase.setAbstractBeanLocalization(sessionLanguage);
		%>
		<tr>
		  <td class="pave_cellule_gauche"><%=usecase.getIdString()  %></td>
		  <td class="pave_cellule_droite"><%= usecase.getName() %></td>
		</tr>
	<%
	}
	
	vUseCases = sessionCommissionMembreHabilitation.getUseCases( );
	if(vUseCases == null)
	{
		vUseCases = new Vector();
	}
	%>
	</table>
	<%if(!vUseCases.isEmpty()){ %>
	<br />
	<br />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" >Vos habilitations dans la commission active</td>
			<td class="pave_titre_droite" ><%=vUseCases.size() %> Cas</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
			<%
				String sNomCommission = "";
				try
				{
					sNomCommission = Commission.getNomCommission(sessionCommissionMembreHabilitation.getIdCommission());
				}
				catch(Exception e){}
			%>
			<%= sNomCommission	%>
			<%
			String sMembreRoleName = "";
			
			try {
				sMembreRoleName 
					= MembreRole.getMembreRoleName(sessionCommissionMembreHabilitation.getIdCommissionMembreRole()) ;
			}catch(Exception e){}
			%></td>
			<td class="pave_cellule_droite">en tant que <%= sMembreRoleName %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">&nbsp;</td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
<%
	for (int j=0; j < vUseCases.size(); j++)
	{
		UseCase usecase = (UseCase) vUseCases.get(j);
		%>
		<tr>
		  <td class="pave_cellule_gauche"><%=usecase.getIdString()  %></td>
		  <td class="pave_cellule_droite"><%= usecase.getName() %></td>
		</tr>
	<%
	}
	%>
	</table>
<%} %>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.util.Outils"%>

<%@page import="org.coin.db.CoinDatabaseAbstractBeanComparator"%></html>