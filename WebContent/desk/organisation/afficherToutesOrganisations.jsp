<%@page import="mt.common.addressbook.AddressBookUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@ page import="org.coin.security.*,org.coin.db.*,org.coin.util.*,org.coin.fr.bean.*,java.util.*,java.sql.*,org.coin.autoform.*" %>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="mt.common.addressbook.habilitation.AddressBookHabilitation"%>
<%@page import="mt.common.addressbook.AddressBookOwner"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.bean.boamp.BoampCPF"%>
<%@page import="org.coin.bean.boamp.BoampCPFItem"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.util.SearchEngine"%>
<%@ include file="pave/localizationObject.jspf" %>
<%
	String sTitle = "";
	boolean bAfficheCpfInfo = true;
	boolean bAfficheRefExt = true;
	boolean bUseCountryCriteria = false;

	boolean bUseUnderTypeFilter = false;
	JSONArray jsonUnderType = new JSONArray();
	String sUnderTypeFilterName = "";
	String sUnderTypeFilterRequest = "";
	String sUnderTypeFilterTable = "";
	String sUnderTypeFilterJoin = "";

	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);

	Organisation orgCtx = new Organisation();
	orgCtx.setAbstractBeanLocalization(sessionLanguage.getId());
	Adresse adrCtx = new Adresse();
	adrCtx.setAbstractBeanLocalization(sessionLanguage.getId());

	String sSelectPart = "org.raison_sociale as raisonSociale,"
			+ "org.mail_organisation as mail,"
			+ "org.siret as numSiret," + "org.telephone as tel,"
			+ "adr.id_pays as pays,"
			+ "org.reference_externe as refExt";
	String sGroupPart = "org.raison_sociale,"
			+ "org.mail_organisation," + "org.siret,"
			+ "org.telephone," + "adr.id_pays,"
			+ "org.reference_externe";

	int iIdOrganisationType = -1;
	if (request.getParameter("iIdOrganisationType") != null) {
		iIdOrganisationType = Integer.parseInt(request
				.getParameter("iIdOrganisationType"));
	} else {
		throw new Exception(
				"iIdOrganisationType n'est pas renseignée dans l'URL : \n"
						+ request.getRequestURL()
						+ "?"
						+ request.getQueryString()
						+ "\n Vérifiez bien que l'URL contient iIdOrganisationType et non id_type_organisation");
	}
	String sPageUseCaseId = AddressBookHabilitation
			.getUseCaseForDisplayAllOrganization(iIdOrganisationType);
	String sUseCaseIdBoutonAjouterOrganisation = AddressBookHabilitation
			.getUseCaseForCreateOrganization(iIdOrganisationType);
	String sAddItem = localizeButton.getValueAdd();
	switch (iIdOrganisationType) {
	case OrganisationType.TYPE_ACHETEUR_PUBLIC:
		sTitle = locTitle.getValue(7, "Les Licences");
		sAddItem = locAddressBookButton.getValue(19, sAddItem);
		break;
	case OrganisationType.TYPE_CANDIDAT:
		sTitle = locTitle.getValue(8,
				"Carnet d'adresses des entreprises");
		sAddItem = locAddressBookButton.getValue(20, sAddItem);
		break;
	case OrganisationType.TYPE_CONSULTANT:
		sTitle = locTitle.getValue(9,
				"Carnet d'adresses des consultants");
		sAddItem = locAddressBookButton.getValue(21, sAddItem);
		break;
	case OrganisationType.TYPE_PUBLICATION:
		sTitle = locTitle.getValue(10, "Titres de publication");
		sAddItem = locAddressBookButton.getValue(22, sAddItem);
		break;
	case OrganisationType.TYPE_ADMINISTRATEUR:
		sTitle = locTitle.getValue(11, "Organisation système");
		sAddItem = locAddressBookButton.getValue(23, sAddItem);
		break;
	case OrganisationType.TYPE_ANNONCEUR:
		sTitle = locTitle.getValue(12, "Organisation annonceur");
		sAddItem = locAddressBookButton.getValue(24, sAddItem);
		break;
	case OrganisationType.TYPE_EXTERNAL:
		// TODO localization
		//sTitle = locTitle.getValue(17,"External company");
		//sAddItem = locAddressBookButton.getValue(29,sAddItem);
		sTitle = "Externe";
		sAddItem = "Ajouter";
		break;
	case OrganisationType.TYPE_EXTERNAL_CASUAL:
		// TODO localization
		//sTitle = locTitle.getValue(17,"External company");
		//sAddItem = locAddressBookButton.getValue(29,sAddItem);
		sTitle = "Externe occasionel";
		sAddItem = "Ajouter";
		break;
	}

	/** --------VFR------------ */
	AddressBookUtil abu = AddressBookUtil
			.organizeOrganizationSearchEngine(
					iIdOrganisationType,
					bAfficheCpfInfo, 
					bAfficheRefExt,
					bUseCountryCriteria, 
					bUseUnderTypeFilter,
					sessionLanguage, 
					sUnderTypeFilterName,
					sUnderTypeFilterRequest, 
					jsonUnderType,
					sessionUserHabilitation, 
					sUnderTypeFilterTable,
					sUnderTypeFilterJoin, 
					locTitle, 
					sTitle,
					locAddressBookButton, 
					sAddItem);
	
	bAfficheCpfInfo = (Boolean)abu.get("bAfficheCpfInfo");
	bAfficheRefExt = (Boolean)abu.get("bAfficheRefExt");
	bUseCountryCriteria = (Boolean)abu.get("bUseCountryCriteria");
	bUseUnderTypeFilter = (Boolean)abu.get("bUseUnderTypeFilter");
	sUnderTypeFilterName = (String)abu.get("sUnderTypeFilterName");
	sUnderTypeFilterRequest = (String)abu.get("sUnderTypeFilterRequest");
	sUnderTypeFilterTable = (String)abu.get("sUnderTypeFilterTable");
	sUnderTypeFilterJoin = (String)abu.get("sUnderTypeFilterJoin");
	sTitle = (String)abu.get("sTitle");
	sAddItem = (String)abu.get("sAddItem");
	jsonUnderType = (JSONArray) abu.get("jsonUnderType");
	/** --------------------------- */
	
	JSONArray jsonCountry = new JSONArray();
	if (bUseCountryCriteria) {
		jsonCountry = Pays.getJSONArray(true, sessionLanguage.getId(),
				true);
	}

	JSONArray jsonCPF = new JSONArray();
	JSONArray jsonCodeNaf = new JSONArray();

	System.out.println("bAfficheCpfInfo:" + bAfficheCpfInfo);
	if (bAfficheCpfInfo) {
		sSelectPart += ","
				+ CoinDatabaseUtil.getSqlConcatFunction("cn.code_naf",
						"cn.libelle", ". ")
				+ " as codeNaf,"
				+ CoinDatabaseUtil.getSqlGroupConcatFunction(
						CoinDatabaseUtil.getSqlConcatFunction(
								"cpf.code_boamp", "cpf.libelle", ". "),
						"cpfName", "; ");

		jsonCPF = BoampCPF.getJSONArray();
		jsonCodeNaf = CodeNaf.getJSONArray();

	}

	OrganisationType orgType = OrganisationType
			.getOrganisationType(iIdOrganisationType);
	orgType.setAbstractBeanLocalization(sessionLanguage);

	String sRestrictionClause = " org.id_organisation = -1 ";
	boolean bRestrictionClauseAdded = false;
	PersonnePhysique personne = PersonnePhysique
			.getPersonnePhysique(sessionUser.getIdIndividual());

	if (!sessionUserHabilitation.isHabilitate(sPageUseCaseId)) {
		// on teste s'il a le droit de voir la sienne
		if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-7")) {
			sRestrictionClause = " ( org.id_organisation = "
					+ personne.getIdOrganisation();
			bRestrictionClauseAdded = true;
		}

		// on teste s'il a le droit de voir celles qu'il a créé
		if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-13")) {
			sRestrictionClause += " OR org.id_createur = "
					+ personne.getIdPersonnePhysique();
			bRestrictionClauseAdded = true;
		}

		// on teste s'il a le droit de voir de facon hierarchique
		if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-BU-6")) {

			CoinDatabaseWhereClause wc = OrganisationGroupPersonnePhysique
					.getWhereClauseIdOrganisationHerarchical(personne
							.getId());

			if (wc.listItems.size() > 0) {
				sRestrictionClause += " OR org.id_organisation in "
						+ wc.generateArrayClause();
				bRestrictionClauseAdded = true;
			}
		}

		sRestrictionClause += " OR "
				+ AddressBookOwner.getWhereClauseOwnerRestriction(
						sessionUser, "org.", true, conn);
		bRestrictionClauseAdded = true;

		if (bRestrictionClauseAdded) {
			sRestrictionClause += ") ";
		} else {
			sRestrictionClause = " org.id_organisation = -1 ";
		}

	} else {
		// pas de restriction
		sRestrictionClause = "";
	}
	sRestrictionClause = Outils.stripNl(sRestrictionClause);
%>
<%@page import="org.coin.bean.Group"%>
<script type="text/javascript" src="<%=rootPath%>dwr/interface/AutoFormSearchEngine.js"></script>
<script type="text/javascript">
var jsonCPF = <%=jsonCPF%>;
var jsonCodeNaf = <%=jsonCodeNaf%>;
var mySearch = new mt.component.SearchEngine("search","search_dg","search_dg_pagination","infosSearchLeft","infosSearchRight","searchAdvancedFunction");

mySearch.lineBackgroundBis = "<%=Theme.getLineBackgroundBis()%>";
mySearch.sIdInTable = "id_organisation";
mySearch.sMainTable = "organisation";
mySearch.sMainAliasTable = "org";
mySearch.sLabelElement = "<%=locTitle.getValue(1, "Organisme")%>";
mySearch.sLabelPlurialElement = "<%=locTitle.getValue(18, "Organismes")%>";
mySearch.bKindFemaleElement = false;
mySearch.uniqueSort = true;
mySearch.addLineCursor = true;
mySearch.paginationIconPrefix = "<%=Theme.getIconPrefix()%>";
mySearch.headerIconPrefix = "<%=Theme.getIconPrefix()%>";
mySearch.lineBackgroundHover = "#EDD0D1";
mySearch.setGroupByClause("org.id_organisation, <%=sGroupPart%>");
mySearch.sSelectPart ="<%=SecureString.getSessionSecureString(sSelectPart,
									session)%>";
	

mySearch.addOtherTable("adresse adr", "org.id_adresse = adr.id_adresse");
if(<%=bAfficheCpfInfo%>) {
	mySearch.addOtherTableWithLeftJoin("code_naf cn", "org.id_code_naf = cn.id_code_naf");
	mySearch.addOtherTableWithLeftJoin("boamp_cpf_item cpfItem", "org.id_organisation = cpfItem.id_reference_objet AND cpfItem.id_type_objet=<%=ObjectType.ORGANISATION%>");
	mySearch.addOtherTableWithLeftJoin("boamp_cpf cpf", "cpfItem.id_boamp_cpf = cpf.id_boamp_cpf");
}
if(<%=bUseUnderTypeFilter%>){
	mySearch.addOtherTableWithLeftJoin("<%=sUnderTypeFilterTable%>", "<%=sUnderTypeFilterJoin%>");
}
mySearch.addHeader("<%=orgCtx.getRaisonSocialeLabel()%>",["raisonSociale"],"raisonSociale","asc");
mySearch.addHeader("<%=orgCtx.getMailOrganisationLabel()%>",["mail"],"mail");
mySearch.addHeader("<%=orgCtx.getSiretLabel()%>",["numSiret"],"numSiret");
mySearch.addHeader("<%=orgCtx.getTelephoneLabel()%>",["tel"],"tel");
mySearch.addHeader("<%=adrCtx.getIdPaysLabel()%>",["pays"],"pays");
if(<%=bAfficheCpfInfo%>) {
	mySearch.addHeader("Compétences",["cpfName"],"cpf.libelle");
	mySearch.addHeader("<%=orgCtx.getIdCodeNafLabel()%>",["codeNaf"],"cn.libelle");
}
if(<%=bAfficheRefExt%>) mySearch.addHeader("Ref. ext.",["refExt"],"refExt");

mySearch.onLoad = function(){
	
	Element.hide('searchLoader');
	if (mySearch.iTotalCountCriterias>0) Element.show('search_dg');
}

mySearch.onSelect = function(item,line){
    location.href = "<%=response
									.encodeURL("afficherOrganisation.jsp?iIdOrganisation="
											+ orgCtx.getIdOrganisation())%>"+item[this.sIdInTable];
}

mySearch.onBeforeSearch = function(){
	mySearch.addFilter(["org.id_organisation_type"], ["<%=iIdOrganisationType%>"], false);
	<%if (!Outils.isNullOrBlank(sRestrictionClause)) {%>
		mySearch.addFilter(["<%=sRestrictionClause%>"], [""], false, "FREE");
	<%}%>
	
	Element.hide('search_dg');
	Element.show('searchLoader');

	/** COUNTRY */
	if(<%=bUseCountryCriteria%>){
		var country = $('countrySelect').value;
	    if (country!=0) {
	        mySearch.addFilter(["adr.id_pays"],[country],false);
	    }
	}
	/** DEPOT TYPE */
	if(<%=bUseUnderTypeFilter%>){
		var underType = $('underTypeSelect').value;
		if(underType>0) mySearch.addFilter(["<%=sUnderTypeFilterRequest%>"+underType], [""], false, "FREE");
	}

	var input = $('keyword').value;
	var selectCpf = $('cpfSelect').value;
	var selectCodeNaf = $('codeNafSelect').value;
	
	if (isNotNull(input)
		|| (isNotNull(selectCpf) && selectCpf > 0)
		|| (isNotNull(selectCodeNaf) && selectCodeNaf > 0)) {
        switch($('keywordSelect').value) {
        
            case "0":
	            mySearch.addFilter(["org.raison_sociale"],[input],true);
	            break;
            
            case "1":
	            mySearch.addFilter(["org.mail_organisation"],[input],true);
	            break;

            case "2":
                mySearch.addFilter(["org.siret"],[input],true);
                break;

            case "3":
                mySearch.addFilter(["org.telephone"],[input],true);
                break;
                
            case "100":
                if(selectCpf > 0) {
                	mySearch.addFilter(["cpf.id_boamp_cpf"],[selectCpf],false);
                } else {
                	mySearch.addFilter(["cpf.libelle", "cpf.code_boamp"],[input],true);
                }
                break;

            case "200":
            	if(selectCodeNaf > 0) {
            		mySearch.addFilter(["cn.id_code_naf"],[selectCodeNaf],false);
                } else {
                	mySearch.addFilter(["cn.libelle", "cn.code_naf"],[input],true);
                }
                break;

            case "4":
                mySearch.addFilter(["org.reference_externe"],[input],true);
                break;
        }
    }

}

onPageLoad = function() {

	
	
	mt.html.setSuperCombo($('cpfSelect'));
	mt.html.setSuperCombo($('codeNafSelect'));
	

	if(<%=bUseCountryCriteria%>){
		var jsonCountry = <%=jsonCountry%>;
		Element.show("countryTd");
		mt.html.setSuperCombo($('countrySelect'));
	    jsonCountry.splice(0, 0, {data:0, value:"<%=adrCtx.getIdPaysLabel()%>"});
		$('countrySelect').populate(jsonCountry);
	}

	if(<%=bUseUnderTypeFilter%>){
		var jsonUnderType = <%=jsonUnderType%>;
		if(jsonUnderType.length>0) {
			Element.show("underTypeTd");
			mt.html.setSuperCombo($('underTypeSelect'));
			if(jsonUnderType.length>1) jsonUnderType.splice(0, 0, {lId:0, sName:"<%=sUnderTypeFilterName%>"});
			$('underTypeSelect').populate(jsonUnderType,0,"lId","sName");
		}
	}

	
	var jsonSelect = new Array();
	jsonSelect.push({value:"<%=orgCtx.getRaisonSocialeLabel()%>", data:0});
	jsonSelect.push({value:"<%=orgCtx.getMailOrganisationLabel()%>", data:1});
	jsonSelect.push({value:"<%=orgCtx.getSiretLabel()%>", data:2});
	jsonSelect.push({value:"<%=orgCtx.getTelephoneLabel()%>", data:3});
	if(<%=bAfficheCpfInfo%>){
		jsonSelect.push({value:"Compétences", data:100});
		jsonSelect.push({value:"<%=orgCtx.getIdCodeNafLabel()%>", data:200});
	}
	if(<%=bAfficheRefExt%>) jsonSelect.push({value:"Ref. ext.", data:4});

	$('keywordSelect').populate(jsonSelect);
	

	jsonCPF.splice(0, 0, {data:0, value:"<%=localizeButton.getValue(24, "All")%>"});
	$('cpfSelect').populate(jsonCPF);
	jsonCodeNaf.splice(0, 0, {data:0, value:"<%=localizeButton.getValue(24, "All")%>"});
	$('codeNafSelect').populate(jsonCodeNaf);
	$('keywordSelect').onchange = function() {
		Element.hide('cpfSelect');
		Element.hide('codeNafSelect');
		if(this.value == 100){
			Element.show('cpfSelect');
		}
		if(this.value == 200){
			Element.show('codeNafSelect');
		}
	}
	$('keyword').onkeyup = function() {
		if($('cpfSelect').length > 0 && $('codeNafSelect').length > 0) {
			$('cpfSelect').setSelectedValue(0);
			$('codeNafSelect').setSelectedValue(0);
		}
	}
	
	$('keywordSelect').onchange();
	$('keyword').onkeyup();


	setTimeout(function(){
		$('keyword').focus();
	}, 1000);
	
	$('searchButton').onclick = function() {mySearch.search();}
	
	mySearch.search();
	
}
</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<%
	if (sessionUserHabilitation
			.isHabilitate(sUseCaseIdBoutonAjouterOrganisation)) {
%>	
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:2px 20px 0 20px;">
	<div class="fullWidth">
		<span style="vertical-align:middle;padding:0 5px 0 5px;">
			<a href="<%=response
										.encodeURL("ajouterOrganisationForm.jsp?iIdOrganisationType="
												+ iIdOrganisationType)%>">
			<img src="../../images/icons/36x36/home_add.png" 
				alt="<%=sAddItem%>" 
				title="<%=sAddItem%>" />
			</a>
		</span>
	</div>
</div>
<br/>
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
	menuBorder.render($('menuBorder'));
});
</script>
<%
	}
%>
<div id="search" style="padding:15px">
	<div style="position:relative">
		<div class="searchBlock">
			<div style="padding:2px">
				<table class="formLayout">
					<tr>
						<td class="label"><%=SearchEngine.getLocalizedLabel(SearchEngine.LABEL_SEARCH,
							sessionLanguage.getId())%> : </td>
					    <td class="value"><select id="keywordSelect"></select></td>
					    <td class="label"><%=SearchEngine.getLocalizedLabel(
							SearchEngine.LABEL_CONTAINS, sessionLanguage
									.getId())%> : </td>
					    <td class="value"><input id="keyword" type="text" /></td>
					    <td class="value" id="countryTd" style="display:none"><select id="countrySelect"></select></td>
					    <td class="value" id="underTypeTd" style="display:none"><select id="underTypeSelect"></select></td>
					    <td class="value"><select id="cpfSelect" style="width:300px"></select></td>
					    <td class="value"><select id="codeNafSelect" style="width:300px"></select></td>
					</tr>
				</table>
			</div>
		</div>
        <button style="position:absolute;right:4px;bottom:4px" id="searchButton"><%=SearchEngine.getLocalizedLabel(
							SearchEngine.LABEL_SEARCH_BUT, sessionLanguage
									.getId())%></button>
	</div>
	<br/>
	<div class="searchTitle">
		<div id="infosSearchLeft" style="float:left"></div>
		<div id="infosSearchRight" style="float:right;text-align:right;"></div>
		<div style="clear:both"></div>
	</div>
	<div id="searchLoader" style="text-align:center;"><img src="<%=rootPath%>images/loading/ajax-loader.gif" alt="<%=localizeButton.getValueLoading("Chargement...")%>" title="<%=localizeButton.getValueLoading("Chargement...")%>"/></div>
	<div id="search_dg" style="margin-top:5px"></div>
	<div id="search_dg_pagination" style="margin-top:10px" class="center"></div>
	<br/>
	<div id="searchAdvancedFunction" style="display:none;margin-top:5px"></div>
</div>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
<%
	ConnectionManager.closeConnection(conn);
%>

</html>
