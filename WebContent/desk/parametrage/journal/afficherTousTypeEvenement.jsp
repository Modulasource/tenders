<%@ include file="../../../include/new_style/headerDesk.jspf" %>

<%@page import="java.sql.*"%>
<%@ page import="modula.*,org.coin.util.*,org.coin.bean.*,java.util.*,modula.journal.*"%>
<%
	String sTitle = "Liste des types d'évenements";
	final int nbElements = 10;
	TypeEvenement item = new TypeEvenement();

	SearchEngine recherche = new SearchEngine("SELECT "
			+ item.getSelectFieldsName("tevt.")
			+ ", tevt.id_type_evenement "
			+ "\n FROM type_evenement tevt WHERE 1=1", nbElements) {
	
		public Object getObjetFromResultSet(ResultSet rs)
		throws SQLException {
			TypeEvenement item = new TypeEvenement();
			item.setFromResultSet(rs);
			item.setId(rs.getInt(item.SELECT_FIELDS_NAME_SIZE + 1));
			return item;
		}

	};

	recherche.setParam("afficherTousTypeEvenement.jsp", "tevt.libelle");
	recherche.setExtraParamHeaderUrl("");
	recherche.setFromFormPrevent(request, "");
	recherche.setUseCountQuery(true);
	
	recherche.setTriFull("");
	recherche.getAllResultObjects();

	//	recherche.load();

	Vector vRecherche = recherche.getAllResults();
	recherche.addFieldName("tevt.libelle", "Libellé",
			SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("tobj.libelle", "Objet",
			SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("tevt.id_use_case", "Cas d'utilisation",
			SearchEngineArrayHeaderItem.FIELD_TYPE_STRING);
	recherche.addFieldName("tevt.horodatage", "Horodatage",
			SearchEngineArrayHeaderItem.FIELD_TYPE_NONE);

	Vector vTypeEvenements = recherche.getCurrentPage();
	recherche.preventFromForm();
	String sPageUseCaseId = "IHM-DESK-JOU-005";
%>
<%@ include file="../../include/checkHabilitationPage.jspf" %>
</head>
<body>
<%@ include file="../../../include/new_style/headerFiche.jspf" %>
<div id="search" style="padding:15px">
<div id="menuBorder" class="sb" style="padding:3px 10px 3px 10px;margin:0 20px 0 20px;">
    <div class="fullWidth">
        <span style="vertical-align:middle;padding:0 5px 0 5px;">
            <a href="<%= response.encodeURL( rootPath + "desk/parametrage/journal/modifierTypeEvenementForm.jsp?sAction=create") %>">
	        <img src="<%= rootPath+Icone.ICONE_PLUS%>"  
	        alt="Ajouter un type d'événement" title="Ajouter un type d'événement" 
	        onmouseover="this.src='<%= rootPath+Icone.ICONE_PLUS_OVER%>'" 
	        onmouseout="this.src='<%= rootPath+Icone.ICONE_PLUS%>'" />
	        </a>
        </span>
    </div>
</div>
<br />
<script>
var menuBorder = RUZEE.ShadedBorder.create({corner:4, border:1});
Event.observe(window, 'load', function(){
    menuBorder.render($('menuBorder'));
});
</script>
<%@ include file="../../../include/paveSearchEngineForm.jspf" %>
<div class="searchTitle">
    <div id="infosSearchLeft" style="float:left">Liste des types d'&eacute;v&eacute;nements</div>
    <div id="infosSearchRight" style="float:right;text-align:right;">
    <%if(recherche.getNbResultats()>1){%>
    <%=recherche.getNbResultats() %> types d'&eacute;v&eacute;nements
    <%}else{if(recherche.getNbResultats()==1){%>
    1 type d'&eacute;v&eacute;nements
    <%} else{%>
    Pas de type d'&eacute;v&eacute;nements
    <%  }}%>
    </div>
    <div style="clear:both"></div>
</div>
<div id="search_dg" style="width:100%;margin-top: 5px;">
<table class="dataGrid fullWidth" cellspacing="1">
    <tbody>
        <%= recherche.getHeaderFieldsNewStyle(response, rootPath) %>			
        <%
			int j;
			for (int i = 0; i < vTypeEvenements.size(); i++) {
				TypeEvenement oTypeEvenement = (TypeEvenement) vTypeEvenements.get(i);
				
				j = i % 2;

				if (oTypeEvenement == null)
					continue;

				String sUrlDisplay = "afficherTypeEvenement.jsp?sAction=load&amp;iIdTypeEvenement="
				+ oTypeEvenement.getIdTypeEvenement();
				
				String sTypeObjetModula = "";
				try{
					sTypeObjetModula = ObjectType.getObjectTypeMemory(oTypeEvenement
							.getIdTypeObjet()).getName();	
				}catch (Exception e) {
					if(oTypeEvenement.getIdTypeObjet()==0){
						sTypeObjetModula = "Système";
					}else{
						   sTypeObjetModula = "inconnu ? = " + oTypeEvenement.getIdTypeObjet();
					}
				}
						
				%>
				<tr class="line<%=j%>" 
			            onmouseover="className='liste_over'" 
			            onmouseout="className='line<%=j%>'"
			            style="cursor:pointer;"
			            onclick="Redirect('<%= response.encodeURL(sUrlDisplay) %>')"> 
			    <td class="cell" style="width:30%"><%=oTypeEvenement.getLibelle()%></td>
			    <td class="cell" style="width:30%"><%=sTypeObjetModula %></td>
			    <td class="cell" style="width:25%"><%=oTypeEvenement.getIdUseCase()%></td>
			    <td class="cell" style="width:25%"><%=oTypeEvenement.isHorodatage() ? "Oui" : ""%></td>
			    <td class="cell" style="text-align:right;width:5%">
			        <img src="<%=rootPath+modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE%>" alt="<%= localizeButton.getValueDisplay() %>" title="<%= localizeButton.getValueDisplay() %>"/>
			    </td>
			</tr>
		<%
		}
		%>
    </tbody>
</table>
</div>
</div>
<%@ include file="../../../include/new_style/footerFiche.jspf" %>
</body>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
</html>