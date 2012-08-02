<%@ include file="/include/new_style/headerDesk.jspf" %>
<%@ page import="org.coin.bean.*,java.util.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.bean.html.*"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.db.*"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.fr.bean.OrganisationService"%>
<%@page import="mt.paraph.folder.ParaphFolderEntity"%>
<%@page import="java.sql.Connection"%>
<%@page import="mt.paraph.folder.ParaphFolder"%>
<%
	long lIdOrganigramNode ;
	String sAction;
	String sTitle ;
	OrganigramNode item;

	sAction = request.getParameter("sAction") ;
	String sStateActivated = "";
	String sStateDeactivated = "";
	String sStateArchived = "";

	if(sAction.equals("store"))
	{
		lIdOrganigramNode = Integer.parseInt( request.getParameter("lIdOrganigramNode") );
		sTitle = "Modifier poste";
		item = OrganigramNode.getOrganigramNode(lIdOrganigramNode );
		long lOnState = item.getIdOrganigramNodeState();
		
		switch ((int)lOnState){
		
			case OrganigramNodeState.STATE_ACTIVATED:
				sStateActivated = " checked='checked'  ";	
				break;
			case OrganigramNodeState.STATE_DEACTIVATED:
				sStateDeactivated = " checked='checked'  ";	
				break;
			case OrganigramNodeState.STATE_ARCHIVED:
				sStateArchived = " checked='checked'  ";	
				break;
		
		}
	}
	else
	{
		lIdOrganigramNode = -1;
		sTitle = "Ajouter un poste";
		item = new OrganigramNode();
		long lIdOrganigram = Integer.parseInt( request.getParameter("lIdOrganigram") );
		item.setIdOrganigram(lIdOrganigram );
		item.setIdTypeObject(ObjectType.PERSONNE_PHYSIQUE);
		
		sStateActivated = " checked='checked'  ";
	}

	Organigram organigram = Organigram.getOrganigram(item.getIdOrganigram());
	Vector vNode = OrganigramNode.getAllFromIdOrganigram( item.getIdOrganigram() );
	// TODO : à voir pour chaque entreprise ?
	//Vector vPoste = OrganigramNodeType.getAllStatic();
	Vector vPoste = OrganigramNodeType.getAllWithWhereAndOrderByClauseStatic(
			"",
            "ORDER BY name");

	if(organigram.getIdTypeObject() != ObjectType.ORGANISATION_SERVICE)
	{
		throw new CoinDatabaseLoadException("ObjetType not ObjectType.ORGANISATION_SERVICE" ,"");
	}

	//OrganigramNode onService = OrganigramNode.getOrganigramNode(organigram .getIdReferenceObject());
	OrganisationService service = OrganisationService.getOrganisationService(organigram.getIdReferenceObject());
	Vector<PersonnePhysique> vPersonne = PersonnePhysique.getAllFromIdOrganisation( (int) service.getIdOrganisation());

	OrganigramNode.computeName(vNode, vPersonne, vPoste, false);
	//OrganigramNode.computeName(vNode, vPersonne);
	for(PersonnePhysique person : vPersonne)
	{
		person.iGetNameType = PersonnePhysique.GET_NAME_TYPE_FIRST_NAME_LAST_NAME;
	}
    Collections.sort( vPersonne, 
    		new CoinDatabaseAbstractBeanComparator(
    				CoinDatabaseAbstractBeanComparator.ORDERBY_LEXICOGRAPHIC_NAME_ASCENDING));


	Organigram oo = Organigram.getOrganigramFromObject(
			ObjectType.ORGANISATION,
			service.getIdOrganisation(),
			ObjectType.ORGANISATION_SERVICE	);

	OrganigramNode
		nn =  OrganigramNode.getOrganigramNode(
				oo.getId(),
				ObjectType.ORGANISATION_SERVICE,
				service.getId()	);

	lIdOrganigramNode = nn.getId();

	Connection conn = ConnectionManager.getConnection();
	request.setAttribute("conn", conn);
	
	Vector<ParaphFolderEntity> vPFE
	 	= ParaphFolderEntity.getAllFromObject(
			ObjectType.ORGANIGRAM_NODE,
			item.getId(),
			false,
			conn);
	
	
	Vector<GedFolderEntity> vGFE
	 	= GedFolderEntity.getAllFromObject(
			ObjectType.ORGANIGRAM_NODE,
			item.getId(),
			false,
			conn);
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	hbFormulaire.sCssClassCaption = "label";
	hbFormulaire.sCssClassField = "frame";
%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script  type="text/javascript"> 
function removeNode()
{

    if(confirm("Etes-vous sûr de vouloir supprimer ce poste ?" ))
    {

        Redirect('<%=
                response.encodeRedirectURL(
                        "modifyOrganisationServiceOrganigramNode.jsp?sAction=remove&lIdOrganigramNode="
                        + item.getId()
                        )
                %>');
    }
}

</script>
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeRedirectURL("modifyOrganisationServiceOrganigramNode.jsp") %>" method="post" >

	<input type="hidden" name="lIdOrganigram" value="<%=item.getIdOrganigram() %>" />
	<input type="hidden" name="lIdOrganigramNode" value="<%=item.getId() %>" />
	<input type="hidden" name="lIdTypeObject" value="<%=item.getIdTypeObject() %>" />
	<input type="hidden" name="sAction" value="<%=sAction %>" />
	<input type="hidden" name="sName" value="<%= item.getName()%>"  />
	<input type="hidden" name="sDescription" value="<%= item.getDescription()%>" />
	<input type="hidden" name="lPosX" value="<%= item.getPosX()%>" />
	<input type="hidden" name="lPosY" value="<%= item.getPosY()%>" />


	<div id="fiche">

	<div class="sectionTitle"><div>Poste <%= item.getId() %></div></div>
	<div class="sectionFrame">
		<table class="formLayout" cellspacing="3">
			<tr>
				<td class="label" >Responsable :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeParent", 1, vNode, item.getIdOrganigramNodeParent(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Poste :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdOrganigramNodeType", 1, vPoste, item.getIdOrganigramNodeType(), "", true, false)

			%>
				</td>
			</tr>
			<tr>
				<td class="label" >Personne :</td>
				<td class="frame">
			<%=	CoinDatabaseAbstractBeanHtmlUtil
					.getHtmlSelect("lIdReferenceObject", 1, (Vector)vPersonne, item.getIdReferenceObject(), "", true, false)

			%>
				</td>
			</tr>
			<%= hbFormulaire.getHtmlTrInput("Reference externe :", "sExternalReference", item.getExternalReference() , "size=40" ) %>
			<tr>
				<td class="label" >State</td>
				<td class="pave_cellule_droite" >
					<input type="radio" name="lIdOrganigramNodeState" value="<%= OrganigramNodeState.STATE_ACTIVATED %>" <%= sStateActivated %> /> Activated
					<input type="radio" name="lIdOrganigramNodeState" value="<%= OrganigramNodeState.STATE_DEACTIVATED %>" <%= sStateDeactivated %> /> Deactivated
					<input type="radio" name="lIdOrganigramNodeState" value="<%= OrganigramNodeState.STATE_ARCHIVED %>" <%= sStateArchived %> /> Archived
					
				</td>
			</tr>
		</table>
	</div>
	<br />
	</div>
</div>

		<!-- Les boutons -->
		<div id="fiche_footer">
			<button type="submit"  ><%=sTitle %></button>

			<button type="button" onclick="javascript:Redirect('<%=
				response.encodeRedirectURL(
						"displayOrganisationService.jsp?lIdOrganigramNode="
						+ lIdOrganigramNode
						+ "&iIdOnglet="+Onglet.ONGLET_SERVICE_MEMBRES
						+ "&nonce=" + System.currentTimeMillis())
				%>')" >Annuler</button>

<%
	if(sAction.equals("store"))
	{
		if(vPFE.size() == 0 && vGFE.size() == 0 )
		{
%>
			<button type="button" onclick="javascript:removeNode()" >Supprimer</button>
<%
		} else {
%>
			<button type="button" disabled="disabled" >Suppression impossible</button>
			<br/>
<div style="text-align: left;">
<b>Liste des dossiers de parapheur liés (<%= vPFE.size() %> dossiers) : </b>
<%
			int iMaxPF = 30;
			for(ParaphFolderEntity entity : vPFE )
			{
				iMaxPF --;
				if(iMaxPF == 0) {
%>
...
<%					
					return ;
				}
				ParaphFolder pf  = ParaphFolder.getParaphFolder(entity.getIdParaphFolder(), false, conn);
%>
<a href="javascript:void(0);" onclick="parent.addParentTabForced('', '<%=
		response.encodeURL(rootPath + "desk/paraph/folder/displayParaphFolder.jsp"
					+ "?lId=" + pf.getId() ) %>')"><%= pf.getName() %></a> 
<%
 			}
%>
</div>
<div style="text-align: left;">
<b>Liste des dossiers de GED liés (<%= vGFE.size() %> dossiers) : </b>
<%
			iMaxPF = 30;
			for(GedFolderEntity entity : vGFE )
			{
				iMaxPF --;
				if(iMaxPF == 0) {
%>
...
<%					
					return ;
				}
				GedFolder pf  = GedFolder.getGedFolder(entity.getIdGedFolder(), false, conn);
%>
<a href="javascript:void(0);" onclick="parent.addParentTabForced('', '<%=
		response.encodeURL(rootPath + "desk/ged/folder/displayGedFolder.jsp"
					+ "?lId=" + pf.getId() ) %>')"><%= pf.getName() %></a> 
<%
 			}
%>
</div>
<%
		
		}
	}
%>

		</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>

</form>
</body>

<%@page import="org.coin.bean.ged.GedFolderEntity"%>
<%@page import="org.coin.bean.ged.GedFolder"%></html>
<%
	ConnectionManager.closeConnection(conn);

%>