<%@page import="java.util.Vector"%>
<%@ page import="org.coin.fr.bean.export.*" %>
<% 
	String rootPath = request.getContextPath()+"/";
	int iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	String sIsProcedureLineaire = request.getParameter("sIsProcedureLineaire");
	int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
	int iIdAffaire = Integer.parseInt(request.getParameter("iIdAffaire")); 

	String sUrlRedirect = rootPath 
		+"desk/export/publication/afficherPublicationBoamp.jsp?iIdPublicationBoamp="
			+request.getParameter("iIdPublicationBoamp")
			+"&iIdOnglet="+iIdOnglet
			+"&sIsProcedureLineaire="+sIsProcedureLineaire
			+"&iIdExport="+iIdExport
			+"&iIdAffaire="+iIdAffaire
			+"#ancreHP";
		
	PublicationBoamp publi 
		= PublicationBoamp.getPublicationBoamp(
				Integer.parseInt(request.getParameter("iIdPublicationBoamp")));

		
	Vector vStatus = publi.getAllStatuts();
	
	for(int i=0;i<vStatus.size();i++)
	{
		Vector vStatut = (Vector)vStatus.get(i);
		int iIdStatut = Integer.parseInt((String)vStatut.firstElement());
		
		int iStatutValeur = Integer.parseInt(request.getParameter("PublicationBoampStatut_" + "selectStatut" + iIdStatut));

		publi.setStatut(iIdStatut,iStatutValeur);
	}
	publi.store();

	response.sendRedirect( response.encodeRedirectURL(sUrlRedirect)) ;
	
%>