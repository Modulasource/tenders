<?xml version="1.0" encoding="ISO-8859-1"?>

<%@page import="modula.marche.*,org.coin.fr.bean.*,org.coin.fr.bean.export.*" %>
<%@page import="org.coin.util.JavascriptVersion"%>

<%
	// TODO : revoir laffichage des elements envoyés
	// TODO : ajouter date creation
	// TODO : la liste des éléments envoyées ne s'affiche plus (tableau vide) une fois que l'on a publié et envoyé les mails.
	
	String rootPath = request.getContextPath()+"/";
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire"));
	Marche marche = Marche.getMarche(iIdAffaire);
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	Export export = Export.getExport(iIdExport);
	int iIdPublicationType = Integer.parseInt(request.getParameter("iIdPublicationType"));
	int iIdAvisRectificatif =  HttpUtil.parseInt("iIdAvisRectificatif", request, -1);
	
	Organisation organisationPublication = Organisation.getOrganisation(export.getIdObjetReferenceDestination());
	int iIdOrganisationPublication = organisationPublication.getIdOrganisation();
	String sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");

	String sUrlTraitement = request.getParameter("sUrlTraitement");
	String sIdAffaire = request.getParameter("iIdAffaire");
	int iIdNextPhaseEtapes = HttpUtil.parseInt("iIdNextPhaseEtapes", request, -1);
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request, 0);
	int iIdTypeAvisToGenerate =  HttpUtil.parseInt("iIdTypeAvisToGenerate", request, -1);
	
	boolean bAllowSavePublication = true;

	AvisAttribution avisAttrib = null;
	boolean bPublicationAutomatique = true;
	try{
		avisAttrib = AvisAttribution.getAvisAttributionFromMarche(iIdAffaire);
	}catch(CoinDatabaseLoadException e){}
	
	bPublicationAutomatique = marche.isAAPCAutomatique(false);
	if(avisAttrib != null) bPublicationAutomatique = avisAttrib.isAATRAutomatique(false);


	AvisRectificatif avisRectificatif = null;
	try{
		avisRectificatif = AvisRectificatif.getAvisRectificatif(iIdAvisRectificatif);
		/**
		 * On traite le cas d'un AREC et non d'un AATR ou d'un AAPC
		 */
		if(avisRectificatif.getDescriptionType().equalsIgnoreCase("texte_libre")){
			bPublicationAutomatique = true;
		} else if(avisRectificatif.getDescriptionType().equalsIgnoreCase("piece_jointe")) {
			bPublicationAutomatique = false;
		}
	} catch (CoinDatabaseLoadException e ){
		avisRectificatif = new AvisRectificatif();
	}
	
	//if()

%>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<script type="text/javascript">
var rootPath = "<%= rootPath %>";</script>
<script type="text/javascript" src="<%=rootPath %>include/js/prototype.js?v=<%= JavascriptVersion.PROTOTYPE_JS %>" ></script>
<script type="text/javascript" src="<%=rootPath %>include/js/shadedborder.js"></script>
<script type="text/javascript" src="<%=rootPath %>include/js/run.js?v=<%= JavascriptVersion.RUN_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>include/fonctions.js?v=<%= JavascriptVersion.FONCTIONS_JS %>"></script>
<script type="text/javascript" src="<%= rootPath %>dwr/interface/HtmlPublication.js" ></script>
<script>
var iIdPublicationType = <%=iIdPublicationType%>;
var iIdAvisRectificatif = <%=iIdAvisRectificatif%>;
var webService_url = "<%=response.encodeURL(rootPath+"desk/PublicationXmlGenerator")%>";
var addPublication_url = "<%=response.encodeURL(rootPath+"desk/export/ajouterPublication.jsp")%>";
var getListePublicationsEnvoyees_url = "<%=response.encodeURL(rootPath+"desk/export/getPublicationsEnvoyeesSerialised.jsp")%>";
var iIdMarche = <%=iIdAffaire%>;
var iIdOrganisationPublication = <%=iIdOrganisationPublication%>;

var sUrlTraitement = "<%= sUrlTraitement %>";
var sIdAffaire = "<%= sIdAffaire %>";
var iIdNextPhaseEtapes = <%= iIdNextPhaseEtapes %>;
var sIsProcedureLineaire = "<%= sIsProcedureLineaire %>";
var iIdOnglet = <%= iIdOnglet %>;
var iIdTypeAvisToGenerate = <%= iIdTypeAvisToGenerate %>;
var iIdAvisRectificatif = <%= iIdAvisRectificatif %>;



function displayPublicationsEnvoyees(){
	
	var publicationsEnvoyees_dg = new mt.component.DataGrid('publicationsEnvoyees_dg');
	publicationsEnvoyees_dg.addStyle("width", "100%");
	publicationsEnvoyees_dg.setHeader(["date d'envoi", "état", "type d'avis","accusé","",""]);
	publicationsEnvoyees_dg.addRemoveOption();
	publicationsEnvoyees_dg.onBeforeRemove = function(index) {
		return confirm("Etes-vous sur de vouloir supprimer cette publication ?");
	}
	publicationsEnvoyees_dg.onRemove = function(index) {
		var pub = publicationEnvoyees[index];
		publicationEnvoyees.splice(index, 1);
		supprimerPublication(pub.id);
	}
	publicationEnvoyees.each(function(item){
		var loadPub = "";
		var openPub = "";
		
		if(item.statutFormatLibre=="false")
		{
			loadPub = "<a href=\"javascript:loadFicheStore("+item.id
				+")\"><img src=\"<%=response.encodeURL(rootPath+ "images/icons/24x24/refresh.png" )
				%>\" alt=\"Recharger cette publication\" title=\"Recharger cette publication\"  /></a>";
		}
			
		if(item.statutFormatLibre=="true")
		{
			openPub = "<a href=\"<%= rootPath %>"+item.url_format_libre
				+"\" target=\"_blank\"><img src=\"<%=response.encodeURL(rootPath+ "images/icons/24x24/document.png" 
				)%>\" alt=\"Afficher cette publication au format libre\" title=\"Afficher cette publication au format libre\"  /></a>";
		}
		else
		{
			openPub = "<a href=\""+item.url_pdf
				+"\" target=\"_blank\"><img src=\"<%=response.encodeURL(rootPath+ "images/icons/24x24/pdf.png" 
				)%>\" alt=\"Afficher cette publication au format PDF\" title=\"Afficher cette publication au format PDF\"  /></a>";
		}
		
			
		var pub = publicationsEnvoyees_dg.addItem(
			[	item.dateEnvoi,
				item.etat,
				item.typeAvis,
				item.accuse,
				loadPub+"&nbsp;"+openPub]);
				
		pub.node.id = item.id;
	});
	publicationsEnvoyees_dg.render();
}

function loadPublicationsEnvoyees() {
	function onLoad(r) {
		try{
			publicationEnvoyees = [];
			var root = r.responseXML.documentElement;	
			
			//alert(r.responseText); pour afficher les données brutes
			var nodes = root.getElementsByTagName("publication");
			for (var z=0; z<nodes.length; z++) {
				var publication = new Publication();
				publication.deserialize(nodes[z]);
				publicationEnvoyees.push(publication);
			}
			
			displayPublicationsEnvoyees();
			Element.hide($('feedbackSave_msg'));
		}catch(e1){alert(e1);}
	}
	try{
		Element.show($('feedbackSave_msg'));
		$('feedbackSave_msg').innerHTML = "Chargement des publications";
		$('feedbackSave_msg').innerHTML += "<br/><br/><img src=\"<%= rootPath %>images/loader_modula.gif\" />";
		new Ajax.Request(getListePublicationsEnvoyees_url, {method:'post', parameters:"iIdAffaire="+iIdMarche+"&iIdExport="+<%=iIdExport%>+"&nocache="+(new Date()), onComplete:onLoad});
	}catch(e){alert(e);}
}


var Bloc = function() {
	this.id = "";
	this.rows = 2;
	this.libelle = "";
	this.valeur = "";
	
	this.serialize = function() {
		var sXml = '<bloc id="'+this.id+'">\n'+
					'<libelle>'+this.libelle+'</libelle>\n'+
					'<value>'+this.valeur+'</value>\n'+
					'</bloc>\n';
		return sXml;
	}
	
	this.deserialize = function(node) {
		this.id = node.getAttribute("id");
		if (node.getAttribute("rows")!=""){
			this.rows = node.getAttribute("rows");
		}
		this.libelle = mt.dom.getValueByTagName(node, "libelle");
		this.valeur = mt.dom.getValueByTagName(node, "value");
        
	}
}

var Paragraphe = function() {
	this.name = "";
	this.valeur = "";	
	this.serialize = function() {
		return '<paragraphe name="'+this.name+'">'+this.valeur+'</paragraphe>\n';
	}	
	this.deserialize = function(node) {
		this.name = node.getAttribute("name");
		this.valeur = (node.firstChild) ? node.firstChild.nodeValue : "";
	}
}

var Publication = function() {
	this.id = "";
	this.dateEnvoi = "";
	this.etat = "";
	this.typeAvis = "";
	this.accuse = ""; 
	this.url_pdf = "";
	this.url_format_libre = "";
	this.statutFormatLibre = ""; 
		
	this.deserialize = function(node) {
		this.id = node.getAttribute("id");
		this.dateEnvoi = mt.dom.getValueByTagName(node, "dateEnvoi");
		this.etat = mt.dom.getValueByTagName(node, "publicationEtat");
		this.typeAvis = mt.dom.getValueByTagName(node, "publicationType");
		this.accuse = mt.dom.getValueByTagName(node, "accuse");
		this.url_pdf = mt.dom.getValueByTagName(node, "url_pdf");
		this.url_format_libre = mt.dom.getValueByTagName(node, "url_format_libre");
		this.statutFormatLibre = mt.dom.getValueByTagName(node, "statutFormatLibre");
	}
}

var blocs = [], paragraphes = [], publicationEnvoyees = [];
var bOnPageLoadConsummed=false;
onPageLoad = function() {
	if(bOnPageLoadConsummed)
		return ;
	/**
	 * C'est étrange il passe 2 fois dans la fonction au chargement de la page ...
	 */
	bOnPageLoadConsummed = true;

	loadPublicationsEnvoyees();

	this.supprimerPublication = function(idPublication) {
		function onLoad(r) {
			try{
				Element.hide($('feedbackSave_msg'));
				HtmlPublication.isOngletPoursuivreProcedure(sUrlTraitement,
						sIdAffaire,
						iIdNextPhaseEtapes,
						sIsProcedureLineaire,
						iIdOnglet,
						iIdTypeAvisToGenerate,
						iIdAvisRectificatif,
						function(result){
							var item = result.parseJSON();
							if(item.bShowBoutonPoursuivre){
								Element.show($("tabPoursuivre"));	
							}else{
								Element.hide($("tabPoursuivre"));	
							}
						}
				);
			}catch(e){alert(e);}
		}
		try{
			Element.show($('feedbackSave_msg'));
			$('feedbackSave_msg').innerHTML = "Suppression de la publication en cours"
			$('feedbackSave_msg').innerHTML += "<br/><br/><img src=\"<%= rootPath %>images/loader_modula.gif\" />";
			new Ajax.Request(getListePublicationsEnvoyees_url, {method:'post', parameters:"iIdAffaire="+iIdMarche+"&iIdExport="+<%=iIdExport%>+"&iIdPublication="+idPublication+"&nocache="+(new Date())+"&action=remove", onComplete:onLoad});
		}catch(e){alert(e);}
	}
	

<%
	/**
	 * il ne faut rien charger si c'est une publication libre
	 */

	 if(!bPublicationAutomatique)
	{	
%>

		$('saveDataPublicationLibre_btn').onclick = function() {
			$('feedbackSave_msg').innerHTML = "Enregistrement en cours, veuillez patienter";
			$('feedbackSave_msg').innerHTML += "<br/><br/><img src=\"<%= rootPath %>images/loader_modula.gif\" />";
			Element.show($('feedbackSave_msg'));
			function onSave(r) {
				try{
					var response = eval("("+r.responseText.trim()+")");	
					$('feedbackSave_msg').innerHTML = response.message;
					if(response.success){
						loadPublicationsEnvoyees();
					}
				}catch(e){alert("probleme de chargement des publications : "+e);}
			}
			new Ajax.Request(
					addPublication_url, 
					{method:'post', 
						parameters:"bPublicationLibre=true&nocache="+(new Date())
						+"&iIdAffaire="+<%= iIdAffaire%>
					    +"&iIdPublicationType="+iIdPublicationType
					    +"&iIdExport="+<%=iIdExport%>
					    +"&iIdAvisRectificatif="+iIdAvisRectificatif, 
					    onComplete:onSave});
		}

		if(true) return; 
<%
	}
%>

		

	var blocs_dg = new mt.component.DataGrid('blocs_dg');
	blocs_dg.addMoveOption();
	blocs_dg.addRemoveOption();

	function displayFiche() {
		$('page').style.display = "block";
		Element.hide($('feedback_msg'));
		Element.hide($('feedbackSave_msg'));
		var str = "";
		paragraphes.each(function(item){
			var sDisabledSousTitre = "";
			var val = item.valeur.replace(/\"/g,"&#34;");
			if(item.name=="soustitre") sDisabledSousTitre = "disabled='disabled'";
			str += '<div class="center" style="margin-bottom:2px;padding:2px;"><input type="input" value="'
				+val+'" class="center" style="width:100%"' +sDisabledSousTitre+ '/></div>';
		});
		$('paragraphes').innerHTML = str;
		//blocs_dg.setHeader(['Valeur']);
		
		blocs_dg.onBeforeRemove = function(index) {
			return (blocs[index].id!="") ? confirm("Etes-vous sur de vouloir supprimer ce paragraphe ?") : true;
		}
		blocs_dg.onRemove = function(index) {
			blocs.splice(index, 1);
		}
		blocs_dg.onMove = function(direction, index) {
			var tempSet = blocs[index+direction];
			blocs[index+direction] = blocs[index];
			blocs[index] = tempSet;
		}
		blocs.each(function(item){
			//blocs_dg.addItem([item.id, '<input type="input" value="'+item.libelle+'" style="width:500px"/><br/><textarea style="width:500px">'+item.valeur+'</textarea>']);
            blocs_dg.addItem(
					['Libellé:<br /><br />Contenu:', 
					'<input type="input" value="'+item.libelle
					+'" style="width:100%"/><br/><textarea style="width:100%" rows="'+item.rows
					+'">'+item.valeur+'</textarea>']);
		});
		
		blocs_dg.addStyle("width", "100%");
		blocs_dg.addStyle("border", "1px solid #7397B9");
		blocs_dg.setColumnStyle(0, {width:"50px"});
		blocs_dg.setColumnStyle(2, {width:"50px"});
		blocs_dg.render();
		
		$('addBloc_btn').onclick = function() {
			var bloc = new Bloc();
			blocs.push(bloc);
			//blocs_dg.addItem(['', '<input type="input" value="" style="width:200px"/><br/><textarea style="width:500px"></textarea>']);
			blocs_dg.addItem(
					['Libellé:<br /><br />Contenu:', 
					'<input type="input" value="" style="width:100%"/><br/><textarea style="width:100%" rows="2"></textarea>']);
		};
		
	}
	
	function onLoadFicheData(r) {
		paragraphes = [];
		blocs_dg.removeAll();
		var root = r.responseXML.documentElement;	
		var nodes = root.getElementsByTagName("paragraphe");			
		for (var z=0; z<nodes.length; z++) {
			var paragraphe = new Paragraphe();
			paragraphe.deserialize(nodes[z]);
			paragraphes.push(paragraphe);
		}			
		var nodes = root.getElementsByTagName("bloc");
		for (var z=0; z<nodes.length; z++) {
			var bloc = new Bloc();
			bloc.deserialize(nodes[z]);
			blocs.push(bloc);
		}
		displayFiche();
	}
	
	this.loadFicheData = function(
			idMarche,
			idPublicationType,
			idAvisRectificatif,
			idOrganisationPublication) 
	{
		new Ajax.Request(
				webService_url, 
			    {method:'post', 
					parameters:"iIdMarche="+idMarche
					+"&nocache="+(new Date())
					+"&iIdPublicationType="+idPublicationType
					+"&iIdAvisRectificatif="+idAvisRectificatif
					+"&iIdOrganisationPublication="+idOrganisationPublication, 
					onComplete:onLoadFicheData});
	}
	Element.hide($('feedbackSave_msg'));
	
	loadFicheData(iIdMarche,iIdPublicationType,iIdAvisRectificatif,iIdOrganisationPublication);
	
	this.loadFicheStore = function(idPublication) {
		Element.show($('feedbackSave_msg'));
		$('feedbackSave_msg').innerHTML = "Chargement de la publication en cours"
		$('feedbackSave_msg').innerHTML += "<br/><br/><img src=\"<%= rootPath %>images/loader_modula.gif\" />";
		new Ajax.Request(
				webService_url, {
				    method:'post', 
				    parameters:"lIdPublication="+idPublication
				    +"&nocache="+(new Date())
				    +"&sAction=loadPublication", onComplete:onLoadFicheData});
	}
	

	

	
	
	$('saveData_btn').onclick = function() {
		$('feedbackSave_msg').innerHTML = "Enregistrement en cours, veuillez patienter";
		$('feedbackSave_msg').innerHTML += "<br/><br/><img src=\"<%= rootPath %>images/loader_modula.gif\" />";
		Element.show($('feedbackSave_msg'));
		var xmlStr = '<marche>\n';
		var inputs = $('paragraphes').getElementsByTagName('input');
		paragraphes.each(function(item, index) {
			item.valeur = cleanUpWordCharacter(inputs[index].value);
			xmlStr += item.serialize();
		});
		xmlStr += '<blocs>\n';
		blocs_dg.dataSet.each(function(line, index){
			var bloc = blocs[index];
			bloc.libelle = cleanUpWordCharacter(line.cells[1].getElementsByTagName("input")[0].value.trim());
			bloc.valeur = cleanUpWordCharacter(line.cells[1].getElementsByTagName("textarea")[0].value.trim());

			//bloc.libelle =  cleanUpCharacter(bloc.libelle, function_js_aCharTable_Html);
			//bloc.valeur = cleanUpCharacter(bloc.valeur, function_js_aCharTable_Html);
            bloc.libelle =  htmlEntities(bloc.libelle,"encode");
            bloc.valeur = htmlEntities(bloc.valeur,"encode");
            //bloc.libelle =  htmlEntities(bloc.libelle,"json");
            //bloc.valeur = htmlEntities(bloc.valeur,"json");
			
			xmlStr += bloc.serialize();
		});
		
		xmlStr += '</blocs>\n';
		xmlStr += '</marche>';
		function onSave(r) {
			try{
				var response = eval("("+r.responseText.trim()+")");	
				$('feedbackSave_msg').innerHTML = response.message;
				if(response.success){
					HtmlPublication.isOngletPoursuivreProcedure(sUrlTraitement,
							sIdAffaire,
							iIdNextPhaseEtapes,
							sIsProcedureLineaire,
							iIdOnglet,
							iIdTypeAvisToGenerate,
							iIdAvisRectificatif,
							function(result){
								var item = result.parseJSON();
								if(item.bShowBoutonPoursuivre){
									Element.show($("tabPoursuivre"));	
								}else{
									Element.hide($("tabPoursuivre"));	
								}
								loadPublicationsEnvoyees();
							}
					);
				}
			}catch(e){alert("probleme de chargement des publications : "+e);}
		}
		new Ajax.Request(
				addPublication_url, 
					{method:'post', 
				    parameters:"sXml="+encodeURIComponent(xmlStr)+"&nocache="
				      +(new Date())+"&iIdAffaire="+<%=iIdAffaire%>
			          +"&iIdPublicationType="+iIdPublicationType
			          +"&iIdExport="+<%=iIdExport%>, onComplete:onSave});
	}
}

</script>
</head>
<body style="text-align:left">
<%

	/**
	 * il ne faut pas afficher les boutons ni les paragraphes si c'est une publication libre
	 */
	if(bPublicationAutomatique)
	{
	
		if((sIsProcedureLineaire!=null)
		&&(!sIsProcedureLineaire.equalsIgnoreCase("null"))
		&&(!sIsProcedureLineaire.equalsIgnoreCase("rectificatif")))
		{
			boolean bIsAffaireValidee = marche.isAffaireValidee(false);
			if(avisAttrib != null)	bIsAffaireValidee = avisAttrib.isValide(false);
			
			%>
			<%@include file="../../../export/pave/paveActions.jspf" %>
			<br />
		<%
		}

%>
	<div id="feedback_msg" class="center" style="margin-top:30px">Génération de la publication, veuillez patienter<br/><br/><img src="<%= rootPath %>images/loader_modula.gif" /></div>
	<div id="page" class="hide">
		<div class="sectionFrame" style="border:1px solid #7397B9">
			<div id="paragraphes"></div>
			<div id="blocs_dg"></div>
			<div class="center" style="margin-top:4px">
				<button id="addBloc_btn" type="button" style="margin-top:4px">Ajouter un paragraphe</button>
			</div>	
		</div>
		<div class="center" style="margin-top:16px">
			<button id="saveData_btn" type="button" class="button" >Enregistrer cette publication</button>
		</div>	
	</div>
<%
	} 
	else
	{
%>

	<div class="blockBorder"><span>Publication format libre</span>
	<table style="margin-top:20px;width:100%;" >
		<tr>
			<td class="top">
		<% 	
		
		String sPublicationType = "";
		int	iIdReferenceObject = 0;
		int	iIdTypeObject = 0;
		String sNomFichierFormatLibre = "";
			
		switch(iIdPublicationType){
		case PublicationType.TYPE_AAPC: 
			sPublicationType = "AAPC";
			sNomFichierFormatLibre = marche.getNomAAPC();
			iIdReferenceObject = marche.getIdMarche() ;
			iIdTypeObject = TypeObjetModula.AAPC ;
			break;
		case PublicationType.TYPE_AATR: 
			sPublicationType = "AATR";
			sNomFichierFormatLibre = avisAttrib.getNomAATR();
			iIdReferenceObject = marche.getIdMarche() ;
			iIdTypeObject = TypeObjetModula.AATR ;
			break;
		case PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AAPC: 
			sPublicationType = "avis rectificatif de l'AAPC";
		case PublicationType.TYPE_AVIS_RECTIFICATIF_DE_AATR: 
			if(sPublicationType.equals("")) sPublicationType = "avis rectificatif de l'AATR";

			
			sNomFichierFormatLibre = avisRectificatif.getPieceJointeNom();
			iIdReferenceObject = avisRectificatif.getIdAvisRectificatif() ;
			iIdTypeObject = TypeObjetModula.AVIS_RECTIFICATIF ;
			break;
		}
		
		%>
			Fichier qui sera envoyé pour publication au journal en tant qu'<%= sPublicationType %> : 
		<%
			if (!Outils.isNullOrBlank( sNomFichierFormatLibre ))
			{
				String sUrlFichierFormatLibre = "desk/DownloadFileDesk?"
						+ DownloadFile.getSecureTransactionStringFullJspPage(
								request, 
								iIdReferenceObject, 
								iIdTypeObject );
						
				sUrlFichierFormatLibre = response.encodeURL(rootPath+ sUrlFichierFormatLibre);
				%>
				<a href='<%= sUrlFichierFormatLibre %>'><%= sNomFichierFormatLibre %></a>
				<%		
			}
			else
			{
				bAllowSavePublication = false;
				%><span class="rouge">pas de document associé</span><%
			}	
			
	 %>
			 </td>
		</tr>
		<tr>
			<td class="bottom"></td>
		</tr>
	</table>
	<div >
	</div>
	</div>
	<div class="center" style="margin-top:16px">
		<button id="saveDataPublicationLibre_btn" type="button" 
			class="button" <%= bAllowSavePublication?"":" disabled='disabeld' " 
			%> >Enregistrer cette publication</button>
	</div>	

	<br/>
<%
	}
%>	
	<div id="feedbackSave_msg" class="center" style="margin-top:15px">Enregistrement en cours, veuillez patienter<br/><br/><img src="<%= rootPath %>images/loader_modula.gif" /></div>
	<table style="margin-top:20px;width:100%;" id="dataGrid">
		<tr>
			<td id="debug1" class="top"> </td>
			<td id="debug2" class="top"> </td>
		</tr>
	</table>

	<br/>


	<div class="blockBorder"><span>Eléments Envoyés</span></div>
	<div id="publicationsEnvoyees_dg"></div>
</body>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.servlet.DownloadFile"%>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.util.Outils"%>
</html>