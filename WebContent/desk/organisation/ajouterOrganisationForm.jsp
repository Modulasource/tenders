<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="mt.common.addressbook.AddressBookUtil"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@ include file="pave/localizationObject.jspf" %>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%
	String sFormPrefix = "";
	
	boolean bIsThemeModula = Theme.getTheme().equals ("modula");
	int iIdOrganisationType  = Integer.parseInt(request.getParameter(sFormPrefix+"iIdOrganisationType"));
    Connection conn = ConnectionManager.getConnection();
	
	Organisation organisation = new Organisation();
	organisation.setIdOrganisationType(iIdOrganisationType );
	organisation.setAbstractBeanLocalization(sessionLanguage);
	
	organisation.setIdObjectTypeOwner(HttpUtil.parseLong("lIdObjectTypeOwner", request, 0));
	organisation.setIdObjectReferenceOwner(HttpUtil.parseLong("lIdObjectReferenceOwner", request, 0));
	
	String sPageUseCaseId =  AddressBookHabilitation.getUseCaseForCreateOrganization(iIdOrganisationType);
    String sCreateUserAccount = "checked='checked'";
    String sCreateUserCertificate = "";
	boolean bAuthorizeCreateUserAccount = true;
	boolean bAuthorizeCreateIndividual = true;
	boolean bAuthorizeCreateUserCertificate = true;
	boolean bCheckDoublonRaisonSociale = true;
	
	if(Theme.getTheme().equalsIgnoreCase("veolia")){
		bAuthorizeCreateUserCertificate = false;
	}
	boolean bAddCommissionBloc = false;
	boolean bAddModelBloc = false;
	
	OrganisationType organisationType = OrganisationType.getOrganisationType(organisation.getIdOrganisationType() );
	organisationType.setAbstractBeanLocalization(sessionLanguage);
	
	switch(organisation.getIdOrganisationType() )
	{
	case OrganisationType.TYPE_ACHETEUR_PUBLIC : 
		bAddCommissionBloc = true;
		break;
	case OrganisationType.TYPE_CANDIDAT : 
		sCreateUserAccount = "";
		break;
    case OrganisationType.TYPE_EXTERNAL:
    	bAuthorizeCreateUserAccount = false;
    	bAuthorizeCreateIndividual = true;
    	sCreateUserAccount = "";
        break;
	}
	
	/** ----------- VFR -----------------------*/
	AddressBookUtil abu = AddressBookUtil.organizeOrganizationAdd(
			organisation,
			bAuthorizeCreateUserAccount,
			bAuthorizeCreateIndividual,
			sCreateUserAccount,
			bCheckDoublonRaisonSociale,
			bAddModelBloc);
	bAuthorizeCreateUserAccount = (Boolean)abu.get("bAuthorizeCreateUserAccount");
	bAuthorizeCreateIndividual = (Boolean)abu.get("bAuthorizeCreateIndividual");
	sCreateUserAccount = (String)abu.get("sCreateUserAccount");
	bCheckDoublonRaisonSociale = (Boolean)abu.get("bCheckDoublonRaisonSociale");
	bAddModelBloc = (Boolean)abu.get("bAddModelBloc");
	/** ----------------------------------------*/
	
	String sPavePersonnePhysiqueTitre = locTitle.getValue(4,"Gérant");
	String sPaveAjouterOrganisationTitre = locTitle.getValue(1,"Organisme") + " " + organisationType.getName(); 
	String sTitle = locTitle.getValue(3,"Inscription d'une organisation");
	String sLocalizedMessageEmailAllreadyUsed = locMessage.getValue(2,
		"Attention, l'adresse Email saisie ci-dessous est déjà enregistrée dans la base de données."
		+ " Il est possible que cette personne soit déjà inscrite.");
	String sLocalizedMessageEmailIsMandatory = locMessage.getValue(3,"L'adresse email est obligatoire si vous désirez créer un compte utilisateur");
	String sLocalizedMessageCreateAccount = locMessage.getValue(4,"Créer un compte utilisateur pour cette personne");
	String sLocalizedMessagePasswordAutomaticalyGenerated = locMessage.getValue(5,"Le mot de passe est généré automatiquement et envoyé au destinataire si le compte est activé");
	String sLocalizedMessageCreateManager = locMessage.getValue(6,"Ajouter le responsable de cet organisme");
	String sLocalizedMessageCreateCommission = "Ajouter une commission pour cet organisme";
    String sLocalizedMessageSynchronize = "Synchroniser avec " +  AddressBookWebService.getEngineType(conn);
    String sLocalizedMessageCreateCertificate = locMessage.getValue(59,
	"Créer un certificat pour cette personne");
    
    boolean bAuthorizeModifySynchronize = false;
    boolean bSynchronize = AddressBookWebService.isActivatedForOrganisationType(iIdOrganisationType, conn);

    if(sessionUserHabilitation.isSuperUser() && bSynchronize)
    	bAuthorizeModifySynchronize = true;
    
    
	PersonnePhysique personne = new PersonnePhysique();
	personne.setAbstractBeanLocalization(sessionLanguage);
	
	Adresse adresse = new Adresse();
	adresse.setAbstractBeanLocalization(sessionLanguage);
	Pays pays = new Pays();
	pays.setAbstractBeanLocalization(sessionLanguage);
	    
	PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual(), false, conn);
	Adresse adrUser = Adresse.getAdresse(personneUser.getIdAdresse(), false, conn);
	pays.setId(adrUser.getIdPays());
	
    boolean bIsEnabledLdapSync 
	= OrganisationParametre.isEnabled(
		organisation.getId(), 
		"user.account.creation.ldap.sync",
		conn);
    
	boolean bIsEnabledAlertEmail
	= OrganisationParametre.isEnabled(
		organisation.getId(), 
		"user.account.creation.alert.email",
		true,
		conn);
	
	String sSamAccountName = null;
    
	String sAdressFieldMode = Configuration.getConfigurationValueMemory("desk.organisation.creation.adresse.field","normal");
%>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script type="text/javascript">
<%@ include file="pave/ajouterOrganisation.jspf" %>

onPageLoad = function(){
    onAfterPageLoading();
	$("formulaire").onValidSubmit = function(){
		return checkForm();
	}
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br />
<%
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
%>
<div style="padding:15px">
<form action="<%=response.encodeURL("ajouterOrganisation.jsp")
	%>" method="post" name="formulaire" id="formulaire" class="validate-fields">
<input type="hidden" name="<%=sFormPrefix %>iIdOrganisationType" value="<%= 
	organisation.getIdOrganisationType() %>" />
<a name="ancreError"></a>
<div class="rouge" style="text-align:left" id="divError"></div>
<%@ include file="pave/paveAjouterOrganisationForm.jspf" %> 
<%
    if(bAddCommissionBloc)
    { 
%>
    <br />
    <div id="divCommission">
    <%@ include file="pave/paveAjouterCommissionForm.jspf" %> 
    </div>
<%
    } 
%>
<%
	if(bAuthorizeCreateIndividual)
	{ 
%>
	<br />
	<div id="divGerant">
	<%@ include file="pave/paveAjouterPersonnePhysiqueForm.jspf" %> 
	</div>
<%
	} 
%>
	<br />
	
	<div>
<%
	if(organisation.getIdObjectTypeOwner() > 0)
	{
		ObjectType ot = null;
		String sObjectNameOwner = "";
		try{
			ot = ObjectType.getObjectTypeMemory(
					organisation.getIdObjectTypeOwner() ) ;
			
			
			sObjectNameOwner  = ObjectType.getIdObjetReferenceName(
					organisation.getIdObjectTypeOwner(),
					organisation.getIdObjectReferenceOwner() );
			
			
		} catch (CoinDatabaseLoadException e) {
			ot = new ObjectType();
		}
%>
<input type="hidden"  name="lIdObjectTypeOwner" value="<%= organisation.getIdObjectTypeOwner() %>" />
<input type="hidden"  name="lIdObjectReferenceOwner" value="<%= organisation.getIdObjectReferenceOwner() %>" />

	Appartient à (owner) :
		<%= ot.getName() + " : " + sObjectNameOwner  %> <br/>
	créateur : <%= personneUser.getName() %>
<%		
	}
%>	
	</div>
	
	<div style="text-align:center">
		<button type='submit'><%= localizeButton.getValueSubmit() %></button>&nbsp;
		<button onclick="Redirect('<%= response.encodeURL(
				"afficherToutesOrganisations.jsp?iIdOrganisationType="+ organisation.getIdOrganisationType()) 
				%>')"><%= localizeButton.getValueCancel() %></button>
	</div>
</form>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>
</html>