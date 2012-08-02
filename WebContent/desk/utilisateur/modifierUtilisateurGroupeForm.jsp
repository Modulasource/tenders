<%@ include file="../../../../include/new_style/headerDesk.jspf" %>
<%@ include file="include/localization.jspf" %>
<%@ page import="org.coin.bean.*,org.coin.fr.bean.*,java.util.*" %>
<%
	int iIdUser ;
	String sIdUser ;
	String sSelected ;

	iIdUser = Integer.parseInt( request.getParameter("iIdUser") );

	User user = User.getUser(iIdUser);
	user.setAbstractBeanLocalization(sessionLanguage);
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
	personne.setAbstractBeanLocalization(sessionLanguage);
	
	Vector vAllGroup = Group.getAllGroup();
	Vector vGroup = UserGroup.getAllGroup(iIdUser);
	String sGroupeName ;
	String sAction = "store";

	String sTitle = locTitle.getValue(4,"Modifier les droits d'un utilisateur"); 
%>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script> 
</head>
<body>
<%@ include file="../../../../../include/new_style/headerFiche.jspf" %>
<br/>
<div style="padding:15px">

<form name="formulaire" action="<%= response.encodeURL("modifierUtilisateurGroupe.jsp") %>" method="post" >
	<input type="hidden" name="iIdUser" value="<%=user.getIdUser() %>" />
	<input type="hidden" name="sAction" value="<%= sAction %>" />
	<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche" colspan="2"><%= locBloc.getValue(1,"Utilisateur") %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><%= user.getLoginLabel() %> :</td>
			<td class="pave_cellule_droite"><%= user.getLogin()%></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><%= user.getIdIndividualLabel() %> :</td>
			<td class="pave_cellule_droite"><%= personne.getPrenom() + " " + personne.getNom() %></td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche"><%= locTab.getValue(1,"Groupes") %> : </td>
			<td class="pave_cellule_droite">&nbsp;</td>
		</tr>
		<tr>
			<td class="pave_cellule_gauche">
				<select name="iIdGroup" size="15" style="width:350px" multiple="multiple" >
<%
  for (int i=0 ; i < vAllGroup.size(); i++)
  {
		Group groupe = (Group) vAllGroup.get(i);
		groupe.setAbstractBeanLocalization(sessionLanguage);
		boolean bDisplayGroup = true;
		for (int j=0; j < vGroup.size(); j++)
		{
			Group groupeTmp = (Group) vGroup.get(j);
		
			if(groupe.getId() == groupeTmp.getId())
			{
				bDisplayGroup = false;
			}
		}
		if(bDisplayGroup )
		{
			out.write("<option value='"+ groupe.getId() +"'>" + groupe.getName() + "</option>");
		}
	}
		  %>
                </select>
                
			</td >
			<td >
				<table cellpadding="0">
					<tr>
						<td style="width:100px;text-align:center">
							<a href="javascript:DeplacerTous(document.formulaire.iIdGroupSelection,document.formulaire.iIdGroup)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_GAUCHE%>"  
								alt="<%= localizeButton.getValueDelete() %>" /></a>
							<a href="javascript:DeplacerTous(document.formulaire.iIdGroup,document.formulaire.iIdGroupSelection)" >
								<img src="<%= rootPath + modula.graphic.Icone.ICONE_DROITE%>"  
								alt="<%= localizeButton.getValueAdd() %>" /></a> 
						</td>
						<td>
							<select name="iIdGroupSelection" size="15" style="width:350px" multiple="multiple" >
<%

	for (int i=0; i < vGroup.size(); i++)
	{
		Group groupe = (Group) vGroup.get(i);
		out.write("<option value='"+ groupe.getId() +"'>" + groupe.getName() + "</option>");
	}
		  %>
		                    </select>
							<input type="hidden" name="iIdGroupSelectionListe" />
						</td>
					</tr>
				</table>
                
		  </td>
		</tr>
	</table>
	<br />
	<%
	String sUrlCancel = "afficherTousUtilisateur.jsp";
	if (sAction.equals("store"))
	{
		sUrlCancel = "afficherUtilisateurGroupe.jsp?iIdUser=" + iIdUser;
	}
	 %>
	 <div id="fiche_footer">
	<button type="submit" onclick="javascript:Visualise(document.formulaire.iIdGroupSelection,document.formulaire.iIdGroupSelectionListe);"  ><%= localizeButton.getValueModify() %></button>
	<button type="button" onclick="javascript:Redirect('<%=response.encodeURL(sUrlCancel)
	%>')" ><%= localizeButton.getValueCancel() %></button>
	</div>
</form>
</div>
<%@ include file="../../../../include/new_style/footerFiche.jspf" %>

</body>
</html>
