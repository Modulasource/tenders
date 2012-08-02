<%@ include file="/include/new_style/beanSessionUser.jspf" %>
<%@ include file="../../pave/localizationObject.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	Connection conn = (Connection) request.getAttribute("conn");
	PersonnePhysique personne = (PersonnePhysique) request.getAttribute("personne");
	Organisation organisation = (Organisation) request.getAttribute("organisation");
	LocalizeButton localizeButton = (LocalizeButton) request.getAttribute("localizeButton");




	long lIdDN = Configuration.getLongValueMemory(
			"pki.certificate.dn.intermediate", 
			PkiConstant.DN_INTERMEDIATE_PARAPH);
%>
    
<%@page import="org.coin.bean.conf.Configuration"%>
<%@page import="org.coin.bean.pki.PkiConstant"%>

<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="modula.graphic.Icone"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.Organisation"%>
<%@page import="org.coin.localization.LocalizeButton"%>
<%@page import="modula.graphic.Onglet"%><div>
    <button type="button" onclick="parent.addParentTabForced('chargement ...','<%= 
    	response.encodeURL(
                rootPath + "desk/pki/certificate/modifyCertificateForm.jsp"
                + "?sAction=create"
                + "&lIdPersonnePhysique=" + personne.getId()
                + "&lIdPkiCertificateDnIssuer=" + lIdDN)
        %>');" ><%=locAddressBookButton.getValue(34,"Générer certificat") %></button>

    <button type="button" onclick="parent.addParentTabForced('chargement ...','<%= 
    	response.encodeURL(
                rootPath + "desk/pki/certificate/modifyCertificateUploadForm.jsp"
                + "?lIdIndividual=" + personne.getId())
        %>');" >Importer certificat (.P12 et .CRT)</button>



    <button type="button" onclick="doUrl('<%= 
        response.encodeURL(
                rootPath + "desk/organisation/modifierPersonnePhysique.jsp"
                + "?sAction=createCertificateAuto"
                + "&iIdPersonnePhysique=" + personne.getId()
                + "&lIdPkiCertificateDnIssuer=" + lIdDN
                + "&iIdOnglet=" + Onglet.ONGLET_PERSONNE_PHYSIQUE_CERTIFICATS)
        %>');" ><%=locAddressBookButton.getValue(35,"Générer certificat automatique")%></button>

     <table class="liste"  >
         <tr>
             <th><%= locBloc.getValue(22,"Fichier") %></th>
             <th><%= locBloc.getValue(23,"Type") %></th>
             <th style="width: 30 px;">&nbsp;</th>
         </tr>

<%
	Vector<PkiCertificate> vPkiCertificate = PkiCertificate.getAllFromIdPersonnePhysique(personne.getId());


	for(int i = 0 ; i < vPkiCertificate.size() ; i++)
	{
		PkiCertificate certificate = vPkiCertificate.get(i);
		PkiCertificateType certificateType 
		   = PkiCertificateType.getPkiCertificateType(
				  certificate.getIdPkiCertificateType()) ;
		int j = i % 2;
%>
         <tr class="liste<%=j%>" 
          onmouseover="className='liste_over'" 
          onmouseout="className='liste<%=j%>'" 
          > 
         <td ><%= certificate.getFilename() %></td>
         <td ><%= certificateType.getName() %> </td>
            <td >
<%
		if(sessionUserHabilitation.isSuperUser())
		{
%>
            <img src="<%= rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE  %>" 
               style="cursor: pointer;"
               onclick="parent.addParentTabForced('chargement ...','<%= 
                 response.encodeURL(
                		 rootPath + "desk/pki/certificate/displayCertificate.jsp"
                		 + "?lId=" + certificate.getId()) %>');" />     

            </td>
         </tr>
<%
		}
	}
%>

        </table>
    </div>
