<%@ include file="/desk/include/useBoamp17.jspf" %>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="modula.marche.Marche"%>
<%@page import="modula.marche.correspondant.CorrespondantMarche"%>
<%@page import="org.coin.fr.bean.OrganisationType"%>
<%@page import="modula.marche.MarcheLot"%>
<%@page import="modula.commission.Commission"%>
<%@page import="org.coin.autoform.component.*"%>
<%@page import="modula.marche.joue.MarcheJoueInfo"%>
<%@page import="mt.modula.html.HtmlTabCorrespondant"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueFonction"%>
<%@page import="mt.modula.html.HtmlTabCorrespondantItem"%>
<div>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	Marche marche = (Marche) request.getAttribute("marche");

	HtmlTabCorrespondant tabCorrespondant = new HtmlTabCorrespondant(
			marche,
			bUseBoamp17,
			request,
			response
			);
	tabCorrespondant.addAllCorrespondantMarche();
	
	if(sAction.equals("store") )
	{
	%>
	<p class="mention">
	Les champs noms et adresses seront renseignés avec l'adresse fournie lors de votre inscription. Si des &eacute;l&eacute;ments, 
	notamment dans les adresses compl&eacute;mentaires, sont diff&eacute;rents de l'adresse officielle, il vous suffit de les modifier.
	</p>
	<%= tabCorrespondant.displayAllCorrespondantForm() %>
	<% }else { %>
	<%= tabCorrespondant.displayAllCorrespondant() %>
	<%
    }
%>
</div>