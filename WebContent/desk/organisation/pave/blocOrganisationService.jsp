<%@page import="org.coin.bean.organigram.*"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.*"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.db.AbstractBeanArray"%>            
<%@page import="modula.graphic.Icone"%>
<%@page import="java.sql.Connection"%>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	Organigram organigram = (Organigram ) request.getAttribute("organigram");
    boolean bDisplayOrganigramNode = HttpUtil.parseBoolean("bDisplayOrganigramNode", request, false);

	Vector<OrganigramNode> vOrganigramNode
	    = OrganigramNode.getAllFromIdOrganigram(
	            organigram.getId());
	
	Vector vPersonnePhysique = PersonnePhysique.getAllFromIdOrganisation( (int)organigram .getIdReferenceObject());
    Vector vPoste = OrganigramNodeType.getAllStatic();

	Vector<PkiCertificate> vPkiCertificate = PkiCertificate.getAllStatic(conn);
	Vector<Multimedia> vMultimedia = Multimedia.getAllStatic(conn);
	Vector<UserGroup> vUserGroup = UserGroup.getAllStatic(conn);
	
	CoinDatabaseWhereClause wcPP = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
	for(PersonnePhysique pp : (Vector<PersonnePhysique>) vPersonnePhysique)
	{
		wcPP.add(pp.getId());
	}
	User usrAll = new User();
	Vector<User> vUser 
		= usrAll.getAllWithWhereAndOrderByClause(
			"WHERE " + wcPP.generateWhereClause("id_individual"), 
			"", 
			conn);
	
	
	Vector<OrganisationService> vOrganisationService
	    = OrganisationService.getAllFromIdOrganisation(organisation.getId());
	
	
	OrganigramNode.computeName(vOrganigramNode, vOrganisationService);
	
	AbstractBeanArray aba = OrganigramNode.generateAbstractBeanArray( vOrganigramNode);
	

	


	request.setAttribute("vPkiCertificate",vPkiCertificate);
	request.setAttribute("vMultimedia",vMultimedia);
	request.setAttribute("vUser",vUser);
	request.setAttribute("vUserGroup",vUserGroup);
	
%>
    



<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.UserGroup"%>
<table class="dataGrid fullWidth">
                        <tr class="header">
<%

    for (int i =0; i <= aba.iMaxColumn ; i++)
    {

%>                          <td style="width: 30 px;" >Rang <%= i %></td>
<%
    }
%>
                            <td style="width: 65%;">&nbsp;</td>
                            <td style="width: 30 px;"> &nbsp;</td>
                        </tr>

<%


        for (int i =0; i <= aba.iMaxRow ; i++)
        {
            int k = i % 2;
            OrganigramNode onTmp = null;
            String sUrlDisplay = "";
            for (int j =0; j <= aba.iMaxColumn ; j++)
            {
                onTmp = (OrganigramNode) aba.table[i][j] ;
                if(onTmp != null)
                {
                    sUrlDisplay =
                        "onclick=\"Redirect('"
                        + response.encodeURL( rootPath
                            + "desk/organisation/groupe/displayOrganisationService.jsp?lIdOrganigramNode="
                            + onTmp.getId() )
                        + "')\"" ;
                    break;
                }
            }



            %>
                    <tr class="liste<%=k %>"
                        onmouseover="className='liste_over'"
                        onmouseout="className='liste<%=k %>'"
                         >

            <%
            
             
            boolean bOrganigramNodeFound = false;
            for (int j =0; j <= aba.iMaxColumn  ; j++)
            {
                OrganigramNode os = (OrganigramNode) aba.table[i][j] ;
                
                if(os != null)
                {
                    String sOrganigramNode = "";

%>
                    <td colspan="<%= (aba.iMaxColumn + 2) - j %>" >

<div style="font-weight: bold;cursor: pointer;" onclick="Element.toggle('os_<%= os.getId() %>')">
	<%= os.getName() %>
</div>
					<div id="os_<%= os.getId() %>">
<%
	if(bDisplayOrganigramNode ) 
	{
		request.setAttribute("vPersonnePhysique" , vPersonnePhysique);
		request.setAttribute("vPoste" , vPoste);
		request.setAttribute("os" , os);
		
%>
<jsp:include page="blocOrganizationServiceNodeArray.jsp"></jsp:include>					
<%
	}
%>
					</div>

                    </td>
<%
                    
                    bOrganigramNodeFound = true;
                }
                else
                {
                	if(!bOrganigramNodeFound)
                	{
                    %><td>&nbsp</td>
                    <%
                	}
                }

            }
            %>

                        <td>
                            <img  style='cursor : pointer;' src="<%= rootPath
                            + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" <%= sUrlDisplay %> /> 
                        </td>
                    </tr>
            <%
        }
        %>
                    </table>

        
<%
    Vector vOrganigramNodeUnplaced = aba.getUnplacedBean((Vector)vOrganigramNode);

    if(vOrganigramNodeUnplaced.size() > 0)
    {
%>
        services à placer dans l'organigramme : <br/>
<%
        for (int i = 0; i < vOrganigramNodeUnplaced.size(); i++) {
            OrganigramNode nodeTmp = (OrganigramNode) vOrganigramNodeUnplaced.get(i) ;
            
            String sUrlDisplay =
                "onclick=\"Redirect('"
                + response.encodeURL( rootPath
                    + "desk/organisation/groupe/displayOrganisationService.jsp?lIdOrganigramNode="
                    + nodeTmp.getId() )
                + "')\"" ;
            
            %>
            <button type="button" <%= sUrlDisplay %> ><%= nodeTmp.getName() %></button><br/>

<%
            
        }
    }
%>
    </div>        
        