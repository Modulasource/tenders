<%@page import="org.coin.security.HabilitationException"%>
<%@page import="modula.graphic.Onglet"%><%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.fr.bean.Delegation"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>
<%
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	long lIdPersonnePhysiqueOwnerForced = HttpUtil.parseLong("lIdPersonnePhysiqueOwnerForced",request,0);
	boolean bIsPopup = HttpUtil.parseBoolean("bIsPopup",request,false);
	
	String sUrlReturn = "displayAllDelegation.jsp";
	if(lIdPersonnePhysiqueOwnerForced>0){
		sUrlReturn = rootPath+"desk/organisation/afficherPersonnePhysique.jsp?"
				+ "iIdPersonnePhysique="+lIdPersonnePhysiqueOwnerForced
				+ "&iIdOnglet="+Onglet.ONGLET_PERSONNE_PHYSIQUE_DELEGATION;
	}
	Delegation item = new Delegation();
	
	if (sAction.equals("create"))
	{
		item = new Delegation();
		item.setFromForm(request, "");
		
		boolean bAuthorizeCreate = false;
		if(sessionUserHabilitation.isSuperUser() 
		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-3")
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-12") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-13") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
			bAuthorizeCreate = true;
		}
		if(!bAuthorizeCreate) throw new HabilitationException("IHM-DESK-PARAM-HAB-DELEG-3", sessionLanguage.getId());

		item.create();
		item.setFromFormObject(request,"delegation_object_");
	}

	if (sAction.equals("remove"))
	{
		item = Delegation.getDelegation(Long.parseLong(request.getParameter("lId")));
		
		boolean bAuthorizeDelete = false;
		if(sessionUserHabilitation.isSuperUser() 
		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-4")
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-10") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-11") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
			bAuthorizeDelete = true;
		}
		if(!bAuthorizeDelete) throw new HabilitationException("IHM-DESK-PARAM-HAB-DELEG-4", sessionLanguage.getId());

		
		item.removeWithObjectAttached();
	}
	
	if (sAction.equals("store"))
	{
		item = Delegation.getDelegation(Long.parseLong(request.getParameter("lId")));
		
		boolean bAuthorizeModify = false;
		if(sessionUserHabilitation.isSuperUser() 
		|| sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-5")
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-8") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueDelegate())
		|| (sessionUserHabilitation.isHabilitate("IHM-DESK-PARAM-HAB-DELEG-9") && sessionUser.getIdIndividual()==item.getIdPersonnePhysiqueOwner())){
			bAuthorizeModify = true;
		}
		if(!bAuthorizeModify) throw new HabilitationException("IHM-DESK-PARAM-HAB-DELEG-5", sessionLanguage.getId());
		
		item.setFromForm(request, "");
		item.store();			
		item.setFromFormObject(request,"delegation_object_");
	}
	
	if(!bIsPopup){
		response.sendRedirect(
			response.encodeRedirectURL(sUrlReturn));
	}
%>
<head>

<script type="text/javascript">
function closeModalFrame()
{
	parent.redirectParentTabActive('<%= response.encodeURL(sUrlReturn) %>');
			
	try {new parent.Control.Modal.close();}
	catch(e) { Control.Modal.close();}
}	
onPageLoad = function(){
	if(<%= bIsPopup %>){
    	closeModalFrame();
	}
}
</script>

</head>
<body>
</body>
</html>