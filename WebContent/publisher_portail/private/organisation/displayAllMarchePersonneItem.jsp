<%@ include file="/include/new_style/headerPublisher.jspf" %>
<%@ page import="org.coin.db.ConnectionManager"%>
<%@ page import="java.sql.*" %>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="mt.modula.affaire.AffaireValiditeArray"%>
<%@page import="modula.algorithme.AffaireProcedure"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="mt.modula.affaire.personne.MarchePersonneItem"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%
    String sTitle = "";
    String sPageUseCaseId = "IHM-PUBLI-2";
    String sFormPrefix = "";

    Connection connListeCandidatureTotal = ConnectionManager.getConnection();
    CoinDatabaseWhereClause wcAllIdMarche = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
    
    Vector<MarchePersonneItem> vMarchePersonneItem = MarchePersonneItem.getAllStatic();
    for (int i = 0; i < vMarchePersonneItem.size(); i++)
    {
    	MarchePersonneItem marchePersonneItem = vMarchePersonneItem.get(i);
        wcAllIdMarche.add(marchePersonneItem.getIdMarche());
    }
    
   
    AffaireValiditeArray ava = new AffaireValiditeArray(wcAllIdMarche);
    ava.init(connListeCandidatureTotal);
    
%>
<script type="text/javascript">
function removeMarchePersonneItem( lId )
{
    if(confirm("Etes-vous sûr de vouloir supprimer cette sélection ?"))
    {

        doUrl('<%= response.encodeURL("modifyMarchePersonneItem.jsp?sAction=remove&lId=") %>' + lId);
    }
}

function modifyMarchePersonneItemType( lId , lIdType)
{
    doUrl('<%= response.encodeURL("modifyMarchePersonneItem.jsp?sAction=modifyType&lId=") %>' + lId 
    	    + "&lIdMarchePersonneItemType=" + lIdType);
}

</script>
</head>
<body>   
<%@ include file="/publisher_traitement/public/include/header.jspf" %>


<div style="padding:10px 25px 25px 25px">
    <div class="roundCorners_ boardBox">
        <div class="boardContent">
                 
                 
                 
                        
            <div class="boardPanel">
                 <div class="title">Liste des annonces lues
                 </div>
                 <div class="panelContent">

<table style="width:100%" >
    <tr>
        <th width="20%" >Référence</th>
        <th width="30%" >Désignation</th>
        <th width="15%" >Date de publication</th>
        <th width="15%" >Date de clôture</th>
        <th width="15%" >&nbsp;</th>
        <th width="5%" >&nbsp;</th>
    </tr>


<%
for (int i = 0; i < vMarchePersonneItem.size(); i++)
{
    int j = i%2;
    MarchePersonneItem mpItem = vMarchePersonneItem.get(i);
     
    if(mpItem.getIdMarchePersonneItemType() != MarchePersonneItemType.TYPE_READED)
    {
    	continue;
    }
    
    Marche marche = Marche.getMarche((int)mpItem.getIdMarche(), ava.vMarcheTotal);
    
    
    boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
    int iIdOngletRedirect = Onglet.ONGLET_CANDIDATURE;
    if(!bIsContainsCandidatureManagement)
        iIdOngletRedirect = Onglet.ONGLET_DCE;
    
    ava.computeDate(marche);
    String sDateCloture = ava.getDateClotureMarche(marche);
    String sDatePublication = CalendarUtil.getDateCourte(ava.tsDatePublication);
    
%>
<tr >
   <td style="font-weight:bold"><%= marche.getReference() %></td>
    <td><%= marche.getObjet() %></td>
    <td><%= sDatePublication %></td>
    <td><%= sDateCloture %></td>

        <td>
<%@ include file="/publisher_traitement/public/annonce/pave/paveOpenDetailAnnonce.jspf" %>
        </td>
        <td>
            <img alt="mettre en favori" title="mettre en favori" 
                src="<%= rootPath + "images/icons/favorites.png"
                %>" onclick="modifyMarchePersonneItemType(<%= mpItem.getId() %>,<%=
                	MarchePersonneItemType.TYPE_INTERESTING %>);"
                style="cursor: pointer" />
            <img alt="mettre à la corbeille" title="mettre à la corbeille" 
                src="<%= rootPath + "images/icons/trash.png"
                %>" onclick="modifyMarchePersonneItemType(<%= mpItem.getId() %>, <%=
                	MarchePersonneItemType.TYPE_NOT_INTERESTING %>);"
                style="cursor: pointer" />
        </td>
        
    </tr>
<%
}

%>


</table>
                 
                 
                 </div>
             </div>
                        
                        
                        
                        
                        
                        
            <div class="boardPanel">
                 <div class="title">Liste des annonces favorites
                 </div>
                 <div class="panelContent">

<table style="width:100%" >
    <tr>
        <th width="20%" >Référence</th>
        <th width="30%" >Désignation</th>
        <th width="15%" >Date de publication</th>
        <th width="15%" >Date de clôture</th>
        <th width="15%" >&nbsp;</th>
        <th width="5%" >&nbsp;</th>
    </tr>


<%
for (int i = 0; i < vMarchePersonneItem.size(); i++)
{
    int j = i%2;
    MarchePersonneItem mpItem = vMarchePersonneItem.get(i);
    if(mpItem.getIdMarchePersonneItemType() != MarchePersonneItemType.TYPE_INTERESTING)
    {
        continue;
    }

    Marche marche = Marche.getMarche((int)mpItem.getIdMarche(), ava.vMarcheTotal);
    boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
    int iIdOngletRedirect = Onglet.ONGLET_CANDIDATURE;
    if(!bIsContainsCandidatureManagement)
        iIdOngletRedirect = Onglet.ONGLET_DCE;
    
    ava.computeDate(marche);
    String sDateCloture = ava.getDateClotureMarche(marche);
    String sDatePublication = CalendarUtil.getDateCourte(ava.tsDatePublication);

%>
<tr >
   <td style="font-weight:bold"><%= marche.getReference() %></td>
    <td><%= marche.getObjet() %></td>
    <td><%= sDatePublication %></td>
    <td><%= sDateCloture %></td>
        <td>
<%@ include file="/publisher_traitement/public/annonce/pave/paveOpenDetailAnnonce.jspf" %>
        </td>
        <td>
            <img alt="remettre à lu" title="remettre à lu" 
                src="<%= rootPath + "images/icons/eye.gif"
                %>" onclick="modifyMarchePersonneItemType(<%= mpItem.getId() %>, <%=
                    MarchePersonneItemType.TYPE_READED %>);"
                style="cursor: pointer" />
            <img alt="supprimer de la sélection" title="supprimer de la sélection" 
             src="<%= rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE 
                %>" onclick="removeMarchePersonneItem(<%= mpItem.getId() %>);"
                style="cursor: pointer" />
        </td>
        
    </tr>
<%
}

%>


</table>
                 
                 
                 </div>
             </div>

                         
            <div class="boardPanel">
                 <div class="title"
                    style="cursor: pointer;"
                    onclick="Element.toggle('listAnnonceTrashed');" >Liste des annonces à la corbeille
                 </div>
                 <div class="panelContent" 
                    id="listAnnonceTrashed"
                    style="display: none;">

<table style="width:100%" >
    <tr>
        <th width="20%" >Référence</th>
        <th width="30%" >Désignation</th>
        <th width="15%" >Date de publication</th>
        <th width="15%" >Date de clôture</th>
        <th width="15%" >&nbsp;</th>
        <th width="5%" >&nbsp;</th>
    </tr>


<%
for (int i = 0; i < vMarchePersonneItem.size(); i++)
{
    int j = i%2;
    MarchePersonneItem mpItem = vMarchePersonneItem.get(i);
    if(mpItem.getIdMarchePersonneItemType() != MarchePersonneItemType.TYPE_NOT_INTERESTING)
    {
        continue;
    }

    Marche marche = Marche.getMarche((int)mpItem.getIdMarche(), ava.vMarcheTotal);
    boolean bIsContainsCandidatureManagement = AffaireProcedure.isContainsCandidatureManagement(marche.getIdAlgoAffaireProcedure());
    int iIdOngletRedirect = Onglet.ONGLET_CANDIDATURE;
    if(!bIsContainsCandidatureManagement)
        iIdOngletRedirect = Onglet.ONGLET_DCE;
    
    ava.computeDate(marche);
    String sDateCloture = ava.getDateClotureMarche(marche);
    String sDatePublication = CalendarUtil.getDateCourte(ava.tsDatePublication);

%>
<tr >
   <td style="font-weight:bold"><%= marche.getReference() %></td>
    <td><%= marche.getObjet() %></td>
    <td><%= sDatePublication %></td>
    <td><%= sDateCloture %></td>
        <td>
<%@ include file="/publisher_traitement/public/annonce/pave/paveOpenDetailAnnonce.jspf" %>
        </td>
        <td>
            <img alt="remettre à lu" title="remettre à lu" 
                src="<%= rootPath + "images/icons/eye.gif"
                %>" onclick="modifyMarchePersonneItemType(<%= mpItem.getId() %>, <%=
                    MarchePersonneItemType.TYPE_READED %>);"
                style="cursor: pointer" />
            <img alt="supprimer de la sélection" title="supprimer de la sélection" 
                src="<%= rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE 
                %>" onclick="removeMarchePersonneItem(<%= mpItem.getId() %>);"
                style="cursor: pointer" />
        </td>
        
    </tr>
<%
}

%>


</table>
                 
                 
                 </div>
             </div>
        </div>
    </div>
</div>

<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>

<%@page import="mt.modula.affaire.personne.MarchePersonneItemType"%></html>
