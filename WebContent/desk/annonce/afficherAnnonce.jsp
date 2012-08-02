<%@ include file="../../include/headerXML.jspf" %>

<%@ page import="org.coin.fr.bean.annonce.*,modula.graphic.*,java.util.*,org.coin.fr.bean.*,modula.*,modula.commission.*,org.coin.util.*,modula.marche.*" %>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sTitle = "Parution";
	String rootPath = request.getContextPath()+"/";

	boolean bReadOnly = true;
	String sFormPrefix = "";

	int iIdAnnonce = -1;
	try{
		iIdAnnonce = Integer.parseInt(request.getParameter("iIdAnnonce"));
	} catch (Exception e)
	{
		try {
			iIdAnnonce = Integer.parseInt(request.getParameter("iIdReferenceObjet"));
		} catch (Exception ee) 
		{
			iIdAnnonce = Integer.parseInt(request.getParameter("iIdObjetReferenceSource"));
		}
	}
	
	String sAction = request.getParameter("sAction");
	if(sAction == null) sAction = "";
	
	Annonce annonce = Annonce.getAnnonce(iIdAnnonce);
	int iIdOnglet = 0;
	
	try {
		iIdOnglet = Integer.parseInt(request.getParameter("iIdOnglet"));
	} catch (Exception e){}
	
	// TODO 
	String sPageUseCaseId = "IHM-DESK-ANN-xxx";
	
	Onglet.sNotCurrentTabStyle = " class='onglet_non_selectionne' "; 
	Onglet.sCurrentTabStyle = " class='onglet_selectionne' ";
	Onglet.sNotCurrentTabStyleInCreation = " class='onglet_non_selectionne' ";
	Onglet.sCurrentTabStyleInCreation = " class='onglet_selectionne' ";
	Onglet.sEnddingTabStyle = " class='onglet_vide_dernier' ";

	Vector<Onglet> vOnglets = new Vector<Onglet>();
	vOnglets.add( new Onglet(0, false, "Réference", "afficherAnnonce.jsp?iIdOnglet=0") ); 
	vOnglets.add( new Onglet(1, false, "Parution en cours", "afficherAnnonce.jsp?iIdOnglet=1") ); 
	vOnglets.add( new Onglet(2, false, "Parution", "afficherAnnonce.jsp?iIdOnglet=2") ); 
	vOnglets.add( new Onglet(3, false, "Adresse", "afficherAnnonce.jsp?iIdOnglet=3") ); 
	vOnglets.add( new Onglet(4, false, "Syncho", "afficherAnnonce.jsp?iIdOnglet=4") ); 
	
	Onglet onglet = vOnglets.get(iIdOnglet);
	onglet.bIsCurrent = true;

	
	// TODO : include file="../include/checkHabilitationPage.jspf"

%>
<%@ include file="../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript">
function checkForm()
{
	var form = document.formulaire;
	return true;
}
</script>
</head>
<body >
	<div class="titre_page"><%= sTitle  %></div>
	<table summary="none">
			<tr style="width:100%">
	<%
	for (int i = 0; i < vOnglets.size(); i++) 
	{
		onglet = vOnglets.get(i);
		if(!onglet.bHidden)
		try {
			String sImageInCreation = "" ;
			String sOnClick = "";
			
			
			%><td style="vertical-align:middle" <%= onglet.getStyle(true) %> >
				<a href="<%= response.encodeURL(onglet.sTargetUrl 
					+"&amp;iIdAnnonce="+annonce.getIdAnnonce()
					+"&amp;nonce=" + System.currentTimeMillis())%>"
				onclick="<%= sOnClick %>"><%= onglet.sLibelle %></a><%= sImageInCreation %>
			</td><%	
		} 
		catch (Exception e) {
			e.printStackTrace();
		}
	}
	%>
			<td <%= Onglet.sEnddingTabStyle %> >&nbsp;&nbsp;&nbsp;</td>
		</tr>
		<tr>
			<td class="onglet_corps" colspan='<%= vOnglets.size() + 1 %>' >
			<table width="90%" summary="none">
				<tr>
					<td class="onglet_marge" >&nbsp;</td>
					<td style='width : 90% ; text-align : center ; ' >
					<br />
<%
	boolean bDisplayFormButton = true;
	boolean bDisplayButtonModify = true;
	
	if( bDisplayButtonModify)
	{
	%>
	<div align="right" >
	<input 
		type="button" 
		value="Modifier" 
		onclick="<%= response.encodeURL(
			"Redirect('afficherAnnonce.jsp?iIdAnnonce=" + annonce.getIdAnnonce()) 
			+ "&amp;iIdOnglet=" + iIdOnglet 
			+ "&amp;sAction=store" %>');" />
	</div>
	<br/>
<%
	}
	
	if( bDisplayFormButton)
	{
%>
	<form action="<%= response.encodeURL("modifierAnnonce.jsp")%>" method="post" name="formulaire" onsubmit="return checkForm();">
	<div align="right" >
	<input type="hidden" name="sAction" value="store" />
	<input type="hidden" name="iIdOnglet" value="<%= iIdOnglet  %>" />
	<input type="hidden" name="iIdAnnonce" value="<%= annonce.getIdAnnonce() %>" />
	
	<input type="submit" value="Valider" />
	</div>
	<br/>
<%
	}

	if(iIdOnglet == 0)
	{
%>
	<%@ include file="pave/paveAnnonceReference.jspf" %>
	<br />
<%
	}
	
	if( bDisplayFormButton)
	{
	%>
	</form>
	<%
	}
	%>


  					</td>
					<td class="onglet_marge" >&nbsp;</td>
				</tr>
				<tr>
					<td class="onglet_bas" colspan="<%= vOnglets.size() + 2 %>" >
					&nbsp;</td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>