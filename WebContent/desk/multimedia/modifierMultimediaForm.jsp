<%@page import="java.util.Vector"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.ConnectionManager"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.bean.html.*,org.coin.fr.bean.*" %>
<%@include file="/include/new_style/headerDesk.jspf" %>
<%@include file="../organisation/pave/localizationObject.jspf" %>
<%
	String sLocalizationNameMultimedia = locBloc.getValue(37,"Multimédia");
	String sLocalizationNameFichier = locBloc.getValue(22,"Fichier");
	String sLocalizationNameCreation = locBloc.getValue(38,"Création physique sur le serveur");
	String sLocalizationNamesTitle = locBloc.getValue(39,"Modifier multimédia");
	String sLocalizationNamesTypeMedia = locBloc.getValue(40,"Type de média");
	
	String sTitle = sLocalizationNamesTitle;
	
%>
<script type="text/javascript">
<!--
mt.config.enableAutoRoundPave = false;

//-->
</script>
</head>
<body>
<div style="padding:15px">

<%
	int iIdMultimedia = 1;
	String sUrlRedirect ="afficherTousMultimedia.jsp?foo=1";

	int iIdMultimediaType = -1;
	try{iIdMultimediaType = Integer.parseInt(request.getParameter("iIdMultimediaType"));}
	catch (Exception e) { iIdMultimediaType = MultimediaType.TYPE_LOGO; }
	String sAction = HttpUtil.parseString("sAction", request, false, "create") ;


	if(request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect");
	}

	Multimedia multimedia = null;
	if("create".equals(sAction) )
	{
		multimedia = new Multimedia();
		multimedia.setAbstractBeanLocalization(sessionLanguage);
		multimedia.setIdReferenceObjet( Integer.parseInt(request.getParameter("iIdReferenceObjet")) );
		multimedia.setIdTypeObjet (Integer.parseInt(request.getParameter("iIdTypeObjet")) );
		multimedia.setIdMultimediaType(iIdMultimediaType );
		
	} else {
		iIdMultimedia = Integer.parseInt(request.getParameter("lId"));
		multimedia = Multimedia.getMultimedia(iIdMultimedia);
		multimedia.setAbstractBeanLocalization(sessionLanguage);
	}
	
	MultimediaType mt = new MultimediaType(multimedia.getIdMultimediaType());
	mt.setAbstractBeanLocalization(sessionLanguage);
	
	String sFilterIdType = Configuration.getConfigurationValueMemory("multimedia.type.filter.object."+request.getParameter("iIdTypeObjet"),"");
	String sWhereClause = "";
	if(!Outils.isNullOrBlank(sFilterIdType)){
		CoinDatabaseWhereClause cw = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
		cw.addArray(sFilterIdType,";");
		sWhereClause = "WHERE "+cw.generateWhereClause(mt.FIELD_ID_NAME);
	}
	
	boolean bIsPhysicalEnabled = Configuration.isEnabledMemory("multimedia.create.physical",true);
	
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = true;
	
	String sFormEncoding = null;
	String sFormUrl = null;
	if("create".equals(sAction) )
	{
		sFormUrl = response.encodeURL( "uploadMultimedia.jsp?sAction=" + sAction ) ;
		sFormEncoding = "enctype='multipart/form-data'";
		bIsPhysicalEnabled = true;
	} else {
		sFormUrl = response.encodeURL( "modifierMultimedia.jsp?sAction=" + sAction ) ;
		sFormEncoding = "";
		bIsPhysicalEnabled = false;
	}
%>
	<form action="<%= sFormUrl %>" method="post" <%= sFormEncoding %> >
		<input type="hidden" name="lId" value="<%= multimedia.getId() %>" />	
		<input type="hidden" name="iIdTypeObjet" value="<%= multimedia.getIdTypeObjet() %>" />	
		<input type="hidden" name="sUrlRedirect" value="<%= sUrlRedirect%>" />
		<input type="hidden" name="iIdReferenceObjet" value="<%= multimedia.getIdReferenceObjet() %>" />
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" colspan="2"><%= sLocalizationNameMultimedia %></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<%= hbFormulaire.getHtmlTrSelect(sLocalizationNamesTypeMedia+" :","iIdMultimediaType",mt,false,false,sWhereClause,"") %>
		<tr>
			<td class="pave_cellule_gauche" ><%= sLocalizationNameFichier %> : </td>
			<td class="pave_cellule_droite" >
<%
	if("create".equals(sAction) )
	{

%>
			<input type="file" name="sFilePath" size="35" />
<%
	} else {
%>
			<%= multimedia.getFileName() %>
<%		
	}
%>		
			
			</td>
		</tr> 

		<tr>
			<td class="pave_cellule_gauche" ><%= multimedia.getNameLabel() %> : </td>
			<td class="pave_cellule_droite" >
				<input type="text" name="sLibelle" size="35" value="<%= multimedia.getLibelle() %>"/>
			</td>
		</tr> 
<%
	if(bIsPhysicalEnabled){ 
%>
		<tr>
			<td class="pave_cellule_gauche" ><%= sLocalizationNameCreation %> : </td>
			<td class="pave_cellule_droite" style="vertical-align:middle">
				<input type="checkbox" name="bIsPhysique" value="1" />
			</td>
		</tr>
<%
	} 
%>
		<tr><td colspan="2" style="text-align:center"><button type="submit" ><%= localizeButton.getValueSave() %></button></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>

<%
	if("store".equals(sAction) )
	{
		Connection conn = ConnectionManager.getConnection();
		Vector<MultimediaParameter> vMultimediaParameter 
			= MultimediaParameter.getAllFromMultimedia(multimedia, conn);
%>
<script type="text/javascript">
function removeMultimediaParam(lIdMultimediaParam)
{
	if(confirm("Etes-vous sûr de vouloir supprimer ce paramètre ?"))
	{
		doUrl("<%= 
				response.encodeURL(
					rootPath + "desk/multimedia/modifierMultimedia.jsp"
					+ "?lId=" + multimedia.getId()
					+ "&sUrlRedirect=" + sUrlRedirect 
					+ "&sAction=removeParam"
					) %>"
					+ "&lIdMultimediaParam=" + lIdMultimediaParam);
	}
}

function createMultimediaParam()
{
	doUrl("<%= 
		response.encodeURL(
			rootPath + "desk/multimedia/modifierMultimedia.jsp"
			+ "?lId=" + multimedia.getId()
			+ "&sUrlRedirect=" + sUrlRedirect 
			+ "&sAction=createParam"
			) %>" );
	
}

</script>

	<br/>
	<table class="pave" >
		<tr>
			<td class="pave_titre_gauche" >Paramètres</td>
			<td class="pave_titre_droite" >
				<a href="javascript:void(0);"
				 onclick="createMultimediaParam();">Ajouter</a>
			</td>
		</tr>
<%		
		for (MultimediaParameter param : vMultimediaParameter)
		{
			
%>
		<tr>
			<td class="pave_cellule_gauche" >
				<input name="paramName_<%= param.getId() %>"  value="<%= param.getName() %>" />
			</td>
			<td class="pave_cellule_droite" >
				<input name="paramValue_<%= param.getId() %>"  value="<%= param.getValue() %>" />				

						<img src="<%=rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>" 
								style="cursor:pointer" 
								alt="<%= localizeButton.getValueDelete() %>" 
								title="<%= localizeButton.getValueDelete() %>" 
								onclick="javascript:removeMultimediaParam(<%= param.getId()  %>);"/>
			</td>
		</tr>

<%
		}
%>
	</table>
<%
		ConnectionManager.closeConnection(conn);
	}
%>
</form>
<div>
<%
	boolean bUpdateParentFrame = HttpUtil.parseBoolean("bUpdateParentFrame", request, false);

	if(bUpdateParentFrame)
	{
%>

<script type="text/javascript">
document.observe("dom:loaded", function() {
	//alert("<%= sUrlRedirect  %>");
	parent.redirectParentTabActive("<%= response.encodeURL(sUrlRedirect 
			+ "&iIdReferenceObjet=" + multimedia.getIdReferenceObjet() ) %>");
});
</script>
<%
	}
%>
</body>
</html>
