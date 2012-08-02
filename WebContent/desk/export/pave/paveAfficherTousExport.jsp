<%@ page import="org.coin.fr.bean.*,java.io.*,org.coin.fr.bean.export.*, java.util.*" %>
<%
	int iIdObjetReferenceSource = -1;
	int iIdTypeObjetSource = -1;
	String sUrlRedirect = "afficherTousExport.jsp?foo=1" ;
	String rootPath = request.getContextPath()+"/";
	boolean bDisplaySourceReference = true;
	Vector<Export> vExports ;
	
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect") ;
	}
	
	if (request.getParameter("bDisplaySourceReference") != null)
	{
		if(request.getParameter("bDisplaySourceReference").equals("false"))
		{
			bDisplaySourceReference = false;
		} 
	}

	try{
		iIdObjetReferenceSource = Integer.parseInt(request.getParameter("iIdObjetReferenceSource"));
		iIdTypeObjetSource = Integer.parseInt(request.getParameter("iIdTypeObjetSource"));
		
		vExports = Export.getAllExportFromSource (iIdObjetReferenceSource , iIdTypeObjetSource);
		
	}catch(Exception e)	{
		// tous !
		vExports = Export.getAllExport ();
	}


 %>
<%@page import="modula.graphic.Icone"%>
<%@page import="modula.TypeObjetModula"%>
<%@page import="org.coin.util.CalendarUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<script type="text/javascript">
<!--
function removeExport(id)
{
	if(!confirm("Etes vous sûr de vouloir supprimer cet export ?"))
		return false;

	var url = "<%= response.encodeURL( 
			rootPath + "desk/export/modifierExport.jsp?sAction=remove&iIdExport=") %>"
			+ id + "&sUrlRedirect=<%= sUrlRedirect%>";

	//alert(url);
	Redirect(url);
	return true;
}
//-->
</script>
<div id="search">
<div class="searchTitle">
	<div id="infosSearchLeft" style="float:left">Transferts</div>
	<div id="infosSearchRight" style="float:right;text-align:right;margin-bottom:10px;">
	   <button 
       type="button" 
       onclick="javascript:Redirect('<%= response.encodeURL( 
       rootPath + "desk/export/modifierExportForm.jsp?sAction=create"
       + "&amp;iIdTypeObjetSource=" + iIdTypeObjetSource
       + "&amp;iIdObjetReferenceSource=" + iIdObjetReferenceSource 
       + "&amp;sUrlRedirect=" + sUrlRedirect ) %>')" >Ajouter un transfert</button>
	</div>
	<div style="clear:both"></div>
</div>
</div>
<table class="dataGrid fullWidth" cellspacing="1">
	<tbody>
		<tr class="header">
			<td class="cell">mode</td>
			<td class="cell">libellé</td>
			<% 
			if(bDisplaySourceReference)
			{
			%>
			<td class="cell">type scource</td>
			<td class="cell">ref source</td>
			<%}%>
			<td class="cell">Sens</td>
			<td class="cell">type dest</td>
			<td class="cell">ref dest</td>
			<td class="cell">date modif</td>
			<td class="cell">&nbsp;</td>
		</tr>
	<%
	for (int i=0; i < vExports.size();i++)
	{
		Export export = vExports.get(i);
		int j = i % 2;
		
		String sTypeObjetSourceName = "indéfini";
		try{sTypeObjetSourceName = ObjectType.getObjectTypeMemory( export.getIdTypeObjetSource()).getName();}
		catch(Exception e){};
		
		String sTypeObjetDestinationName = "indéfini";
		try{sTypeObjetDestinationName = ObjectType.getObjectTypeMemory( export.getIdTypeObjetDestination()).getName();}
		catch(Exception e){}
		
		String sObjetReferenceSourceName = "?";
		try{
			sObjetReferenceSourceName = 
				TypeObjetModula.getIdObjetReferenceName(
					export.getIdTypeObjetSource(), 
					export.getIdObjetReferenceSource());
		}catch (Exception e) {}
		
		String sObjetReferenceDestinationName = "?";
		
		try{
			sObjetReferenceDestinationName =
				TypeObjetModula.getIdObjetReferenceName(
					export.getIdTypeObjetDestination(), 
					export.getIdObjetReferenceDestination());
		}catch (Exception e) {}
		
		String sExportModeName = "";
		try {
			sExportModeName= ExportMode.getExportModeNameMemory(export.getIdExportMode());
		} catch (Exception e) {
			sExportModeName = "indéfini !! : id type=" + export.getIdExportMode();
		}
		
		String sExportSensImage = "";
		String sExportSensImageTag ;
		if(export.getIdExportSens() == 1)
		{
			sExportSensImage = Icone.ICONE_GAUCHE;
			sExportSensImageTag = "<img src='" + rootPath + sExportSensImage+ "' width='10' alt='sens du transfert' /> (Export)";
		}
		else
		{
			sExportSensImage = Icone.ICONE_DROITE;
			sExportSensImageTag = "<img src='" + rootPath + sExportSensImage+ "' width='10' alt='sens du transfert' /> (Import)";
		}
		
		%>
	<tr class="line<%=j%>" >
		<td class="cell"><%= sExportModeName  %> </td>
		<td class="cell"><%= export.getName() %> </td>
<%
	if(bDisplaySourceReference)
	{
%>		<td class="cell"><%= sTypeObjetSourceName %></td>
		<td class="cell"><%= sObjetReferenceSourceName  %></td>
<%	} %>
		<td class="cell"><%= sExportSensImageTag %></td>
		<td class="cell"><%= sTypeObjetDestinationName %></td>
		<td class="cell"><%= sObjetReferenceDestinationName  %></td>
		<td class="cell">
		<%= CalendarUtil.getDateFormattee(export.getDateModification())%>
		</td>
		<td class="cell"><a href="<%= response.encodeURL( 
			rootPath + "desk/export/afficherExport.jsp?iIdExport=" + export.getIdExport() 
			+ "&amp;sUrlRedirect=" + sUrlRedirect) 
			%>" >
			<img style="cursor:pointer" src="<%=rootPath + Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" alt="Voir" title="Voir" />
			</a>&nbsp;
			<img style="cursor:pointer" onclick="javascript:removeExport(<%= export.getIdExport() %>)" 
			src="<%=rootPath + Icone.ICONE_SUPPRIMER_NEW_STYLE %>" alt="Supprimer" title="Supprimer" /> 
		</td>
	</tr>	
		<%
	}

%>
</tbody>
</table>