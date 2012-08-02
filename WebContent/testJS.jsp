<?xml version="1.0" encoding="ISO-8859-1" ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.coin.fr.bean.export.PublicationSpqr"%>
<%@page import="org.coin.fr.bean.export.PublicationType"%>
<%@page import="org.coin.fr.bean.export.PublicationEtat"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.fr.bean.export.Export"%>
<%@page import="modula.marche.Marche"%>
<%@page import="org.coin.fr.bean.Organisation"%>


<%@page import="org.coin.util.JavascriptVersion"%><html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1" />
<title>Insert title here</title>
<script type="text/javascript" src="include/js/prototype.js?v=<%= JavascriptVersion.PROTOTYPE_JS %>" ></script>
<script type="text/javascript" src="include/fonctions.js?v=<%= JavascriptVersion.FONCTIONS_JS %>" ></script>
<script type="text/javascript" src="include/date.js" ></script>
</head>
<body>
<input type="text"  onkeyup="javascript:checkHourMinuteWithSpanPromt(this, 'info_hm');" value="17:30" />
<input type="text"  onkeyup="javascript:checkDateWithSpanPromt(this, 'info_date');" value="11/12/2006" />
<span id="info_date" ></span>
<span id="info_hm" ></span>
<%
/*
publication.setIdTypeObjet(ObjectType.AFFAIRE);
publication.setIdReferenceObjet(marche.getIdMarche());
publication.setIdExport(exportAFF.getIdExport());
publication.setIdPublicationType(PublicationType.TYPE_PETITE_ANNONCE);
publication.setIdPublicationEtat(PublicationEtat.ETAT_A_ENVOYER);
*/


	//TestPublication.main(null);


	/*Vector vPublicationSpqr =PublicationSpqr.getAllPublicationSpqrFromIdTypeAndRefObjectAndTypeAndEtat(
			ObjectType.AFFAIRE,
			12752,
			PublicationType.TYPE_PETITE_ANNONCE,
			PublicationEtat.ETAT_A_ENVOYER);
*/

	Vector vPublicationSpqr =PublicationSpqr.getAllPublicationSpqrFromIdTypeObjectAndTypeAndEtat(
		ObjectType.AFFAIRE,
		PublicationType.TYPE_PETITE_ANNONCE,
		PublicationEtat.ETAT_A_ENVOYER);
	
%>

vPublicationSpqr size = <%= vPublicationSpqr.size() %> 

<br/>
<br/>

<%
	for(int i=0; i<vPublicationSpqr.size(); i++)
	{
		PublicationSpqr pub = (PublicationSpqr)vPublicationSpqr.get(i);
		Marche marche = Marche.getMarche(pub.getIdReferenceObjet());
		
		Export export = Export.getExport(pub.getIdExport());
		Organisation orgPublication = Organisation.getOrganisation(export.getIdObjetReferenceDestination()); 
		
		try {
			//pub.publish();
		} catch (Exception e) {
			%><%= e.getMessage() %><% 
		}
		%>
		i=<%= i %> Marché : <%= marche.getReference() + " - " + marche.getObjet() %><br/>
<!--  	Export : <%= export.getId()
		+ " - " + export.getIdObjetReferenceSource() 
		+ " - " + export.getIdObjetReferenceDestination() %><br/>
-->		Organisme Publication : <%= orgPublication.getRaisonSociale() %><br/>
		<% 
	}

%>
</body>
</html>