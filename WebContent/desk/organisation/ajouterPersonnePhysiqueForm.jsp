<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ include file="pave/localizationObject.jspf" %>
<%@page import="org.coin.util.HTMLEntities"%>
<%@page import="mt.modula.JavascriptVersionModula"%>
<%@page import="org.coin.bean.ws.AddressBookWebService"%>
<%@page import="org.coin.bean.ws.OrganisationWebService"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="mt.common.addressbook.ldap.AddressBookLdapConnector"%>
<%@page import="javax.naming.directory.SearchResult"%>
<%@page import="javax.naming.NamingEnumeration"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%
	boolean bIsThemeModula = Theme.getTheme().equals ("modula");

	int iIdOrganisation = -1;
	Organisation organisation = null;
	iIdOrganisation = Integer.parseInt(request.getParameter("iIdOrganisation"));
	organisation = Organisation.getOrganisation( iIdOrganisation );	
	
	PersonnePhysique personActor = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	String sPageUseCaseId = AddressBookHabilitation.getUseCaseForCreateIndividual(organisation, personActor);
	String sCreateAccountUseCaseId = AddressBookHabilitation.getUseCaseForCreateUserAccount(organisation, personActor);


	String sCreateUserAccount = "checked='checked'";
	String sCreateUserCertificate = "";
	switch(organisation.getIdOrganisationType() )
	{
	case OrganisationType.TYPE_CANDIDAT :
		sCreateUserAccount = "";
		break;
	}
	
	sessionUserHabilitation.isHabilitateException(sPageUseCaseId );
	
	String sTitle = locTitle.getValue(2, "Ajout d'une personne à l'organisation")+" ";
	String sPavePersonnePhysiqueTitre = locBloc.getValue(8,"Personne");
	String sLocalizedMessageEmailAllreadyUsed 
		= locMessage.getValue(2, 
			"Attention, l'adresse Email saisie ci-dessous est déjà enregistrée dans la base de données."
			+ " Il est possible que cette personne soit déjà inscrite.");

	String sLocalizedMessageEmailIsMandatory = locMessage.getValue(3, 
			"L'adresse email est obligatoire si vous désirez créer un compte utilisateur");
	
	String sLocalizedMessageCreateAccount = locMessage.getValue(4,
			"Créer un compte utilisateur pour cette personne");
	
	String sLocalizedMessageCreateCertificate = locMessage.getValue(59,
	"Créer un certificat pour cette personne");
	
	String sLocalizedMessagePasswordAutomaticalyGenerated = locMessage.getValue(5,
			"Le mot de passe est généré automatiquement et envoyé au destinataire si le compte est activé");
	
	
	
	sTitle = sTitle + organisation.getRaisonSociale();
	
	boolean bAuthorizeCreateUserAccount = true;
	boolean bAuthorizeCreateUserCertificate = true;
	if(Theme.getTheme().equalsIgnoreCase("veolia")){
		bAuthorizeCreateUserCertificate = false;
	}
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	
	PersonnePhysique personne = new PersonnePhysique();
	personne.setAbstractBeanLocalization(sessionLanguage);

    boolean bIsOrganisationSync = false;
    Connection conn = ConnectionManager.getConnection();
    session.setAttribute("conn", conn);
    
    if(AddressBookWebService.isActivated( conn))
    {
        OrganisationWebService wsOrga = AddressBookWebService.newInstanceOrganisationWebService(conn);
    
        if(wsOrga.isSynchronized(organisation, conn)){
        	bIsOrganisationSync  = true;
        }
    }
    
    String sLdapAccountName = HttpUtil.parseStringBlank("sLdapAccountName", request);
    String sSearchFilterValue = HttpUtil.parseStringBlank("sSearchFilterValue", request);
 	/**
 	 * bug #4266
 	 */
    sLdapAccountName = HTMLEntities.unhtmlentities(sLdapAccountName);
    sSearchFilterValue = HTMLEntities.unhtmlentities(sSearchFilterValue);
    
    String sSamAccountName = null;
    
    String sFormPrefix = "";
    
    boolean bIsEnabledLdapSync 
    	= OrganisationParametre.isEnabled(
    		organisation.getId(), 
    		"user.account.creation.ldap.sync",
    		false,
    		conn);
   

	boolean bIsEnabledAlertEmail
		= OrganisationParametre.isEnabled(
			organisation.getId(), 
			"user.account.creation.alert.email",
			true,
			conn);
	 


    
    AddressBookLdapConnector ldapConn = null;
    if(bIsEnabledLdapSync)
    {
		ldapConn = new AddressBookLdapConnector(organisation);
		ldapConn .init(conn);
		//ldapConn.searchFilter += "(cn=David KELLER)";
		if(!sSearchFilterValue.equals(""))
		{
			ldapConn.searchFilter 
				= 
				"(|"
				+ "(cn=*" + sSearchFilterValue + "*)"
				+ "(ou=*" + sSearchFilterValue + "*)"
				+ ")"
				;
		}
		
    }
    
    

%>
<script type="text/javascript" src="<%= rootPath %>include/verification.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/redirection.js" ></script>
<script type="text/javascript" src="<%= rootPath %>include/cacherDivision.js" ></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/CheckAjaxVerifField.js"></script>
<script type="text/javascript" src="<%= rootPath %>include/AjaxVerifField.js?v=<%= JavascriptVersionModula.VERIF_FIELD %>" ></script>
<script type="text/javascript" src="<%=rootPath %>dwr/interface/PersonnePhysique.js"></script>
<%@ include file="pave/ajouterPersonnePhysique.jspf" %>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">


	<a name="ancreError"></a>
	<div class="rouge" style="text-align:left" id="divError"></div>

<%
	if(bIsEnabledLdapSync)
	{

%>
<script type="text/javascript">
function loadLdapAccount()
{
	doUrl("<%= 
		response.encodeURL(
				rootPath + "desk/organisation/ajouterPersonnePhysiqueForm.jsp"
				+ "?iIdOrganisation=" + organisation.getId()
				+ "&nonce=" + System.currentTimeMillis() ) %>"
		+ "&sLdapAccountName=" + $("sLdapAccountName").value
		+ "&sSearchFilterValue=" + $("sSearchFilterValue").value
		);
}
</script>

<table>
	<tr>
		<td>
			Choisissez un utilisateur dans l'annuaire	
		</td>
		<td>
	<b><%= ldapConn.searchBase %> : </b><%= ldapConn.searchFilter %><br/>	
	<input name="sSearchFilterValue"  
		id="sSearchFilterValue" 
		value="<%= sSearchFilterValue %>" 
		style="width: 250px" />
	<button type="button" onclick="loadLdapAccount()" >OK</button> <br/>
	<select name="sLdapAccountName"
		 id="sLdapAccountName" 
		 onchange="loadLdapAccount()" 
		 size="5" 
		 style="width: 300px">
<%
	String sDumpAllParamValue = "";
	
		if(!sSearchFilterValue.equals(""))
		{
			NamingEnumeration<SearchResult> answer = ldapConn.search();
			while (answer.hasMoreElements()) {
				SearchResult sr = (SearchResult)answer.next();
				String sAccountSelected = "";
				ldapConn.currentSearchResult = sr;
				if(sLdapAccountName != null 
				&& !sLdapAccountName.equals("")
				&& sLdapAccountName.equals(sr.getName()))
				{
					sAccountSelected = " selected='selected' ";
					personne.setPrenom(ldapConn.getAttributeValueStringBlank("givenName"));
					personne.setNom(ldapConn.getAttributeValueStringBlank("sn"));
					personne.setEmail(ldapConn.getAttributeValueStringBlank("mail"));
					personne.setPoste(ldapConn.getAttributeValueStringBlank("telephoneNumber"));
					personne.setTel(ldapConn.getAttributeValueStringBlank("telephoneNumber"));
					String sFonction = ldapConn.getAttributeValueStringBlank("title");
					String sDecription = ldapConn.getAttributeValueStringBlank("description");
					if(!sDecription.equals("")){
						sFonction += " / " + sDecription;
					}
					personne.setFonction(sFonction);
					personne.setTelPortable(ldapConn.getAttributeValueStringBlank("mobile"));
					sSamAccountName = ldapConn.getAttributeValueStringBlank("sAMAccountName");
					sDumpAllParamValue = ldapConn.getAllAttributeValueString(" ","<br/>\n");
				}
			
	%>
			<option <%= sAccountSelected %> ><%= sr.getName() %></option>
	<%		
			}	
		}

%>
	</select>
	
	<br />
	<a href="javascript:void(0);" onclick="Element.toggle('dumpAllParamValue')">Dump</a> <br/>
	<div id="dumpAllParamValue" style="display: none;height: 200px; overflow: auto;" >
	<%= sDumpAllParamValue  %>
	</div>
	
		</td>
	</tr>
	
	
	
	
</table>

<%
	}
%>

<script type="text/javascript">
function checkAndSubmitForm()
{
	var bChecked = checkForm();
	if(bChecked){
		$("formulaire").submit();
	}
}

</script>

	<br/>	
<form action="<%=response.encodeURL("ajouterPersonnePhysique.jsp")
	%>" method="post" name="formulaire" id="formulaire" onsubmit="return checkForm();">
	<input type="hidden" name="iIdOrganisation" value="<%= organisation.getIdOrganisation() %>" />	
	<input type="hidden" name="sLdapAccountName" value="<%= sLdapAccountName %>" />	

	
	<%@ include file="pave/paveAjouterPersonnePhysiqueForm.jspf" %>
	<br />
<%= bIsOrganisationSync?"Organisation synchro":""
%>	
	
	<div style="text-align:center">
		<button type="button" onclick="javascript:checkAndSubmitForm();" ><%= 
			localizeButton.getValueSubmit() %></button>
		&nbsp;
		<button type="reset" name="RAZ" onclick="Redirect('<%=
			response.encodeURL(
					"afficherOrganisation.jsp?iIdOrganisation=" 
					+ organisation.getIdOrganisation() ) %>')" ><%= localizeButton.getValueCancel() %></button>
	</div>
	</form>
</div>
<%
	ConnectionManager.closeConnection(conn);
%>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>