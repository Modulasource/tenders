<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../pave/localizationObject.jspf" %>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.OrganisationParametre"%>
<%

	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	int iIdOnglet = HttpUtil.parseInt("iIdOnglet", request);
	String sAction = (String) request.getAttribute("sAction");
	DisplayOrganizationHabilitation doh = (DisplayOrganizationHabilitation) request.getAttribute("doh");
	HtmlBeanTableTrPave hbFormulaire = (HtmlBeanTableTrPave)request.getAttribute("hbFormulaire");
	Vector<Onglet> vOnglets = (Vector<Onglet>) request.getAttribute("vOnglets");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");

	Onglet ongletInfoPub = Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_INFORMATION_PUBLICATION );
	Onglet ongletTransf =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_EXPORTS );
    Onglet ongletParam =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_PARAMETRES );
    Onglet ongletCharteGraph =  Onglet.getOnglet(vOnglets,Onglet.ONGLET_ORGANISATION_CHARTE_GRAPHIQUE ); 


	String sFormPrefix = "";
    
    
	boolean bDisplayFormButton = false;
	String sUrlRedirect = rootPath + "desk/organisation/afficherOrganisation.jsp?iIdOnglet="+iIdOnglet;  
    Vector<OrganisationParametre> vParams = OrganisationParametre.getAllFromIdOrganisation(organisation.getIdOrganisation());
    if(sAction.equals("store"))
    {
        if(ongletInfoPub!=null && !ongletInfoPub.bHidden)
        {
%><%@ include file="../pave/paveOrganisationInfoPublicationsForm.jspf" %>

<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.bean.html.HtmlBeanTableTrPave"%>
<%@page import="mt.common.addressbook.habilitation.DisplayOrganizationHabilitation"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="org.coin.fr.bean.Pays"%>
<%@page import="org.coin.localization.LocalizeButton"%><br/><%		
		}
        
        if(ongletCharteGraph!=null && !ongletCharteGraph.bHidden){
%><%@ include file="../pave/ongletOrganisationCharteGraphiqueForm.jspf" %><%
		}
    }
    else
    {
        if(ongletInfoPub!=null && !ongletInfoPub.bHidden){
%><%@ include file="../pave/paveOrganisationInfoPublications.jspf" %><br/><%
		}
        
        if(ongletCharteGraph!=null && !ongletCharteGraph.bHidden){
%><%@ include file="../pave/ongletOrganisationCharteGraphique.jspf" %><%
		}
    }
    
    
    if(ongletCharteGraph!=null && !ongletCharteGraph.bHidden){

%>
		<br>
        <jsp:include page="/desk/multimedia/pave/paveAfficherTousMultimedia.jsp" flush="true" >
                <jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
                <jsp:param name="iIdReferenceObjet" value="<%=  organisation.getIdOrganisation() %>" /> 
                <jsp:param name="iIdTypeObjet" value="<%= ObjectType.ORGANISATION %>" /> 
        </jsp:include>
        <%
        }
        /**
         * Ne pas afficher pour le moment car il n'a d'export de prévu dans la V1
         */
        if(ongletTransf!=null && !ongletTransf.bHidden){
        %>
		<br />
        <jsp:include page="/desk/export/pave/paveAfficherTousExport.jsp" flush="true" >
                <jsp:param name="bDisplaySourceReference" value="false" /> 
                <jsp:param name="sUrlRedirect" value="<%= sUrlRedirect %>" /> 
                <jsp:param name="iIdObjetReferenceSource" value="<%= organisation.getIdOrganisation() %>" /> 
                <jsp:param name="iIdTypeObjetSource" value="<%= ObjectType.ORGANISATION %>" /> 
        </jsp:include>
        <%} %>
        <br />
        </form>
<%

	if(ongletParam!=null && !ongletParam.bHidden){
%>
<jsp:include page="../bloc/blocDisplayOrganizationParameter.jsp">
<jsp:param value="<%= iIdOnglet %>" name="iIdOnglet" />
</jsp:include>
<%	        
	}
%>