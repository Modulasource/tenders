<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@include file="/include/new_style/headerJspUtf8.jspf" %>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	GedFolder item = null;

	if(sAction.equals("create"))
	{
		item = new GedFolder();
		item.setFromForm(request, "");
		item.setIdReferenceObjectOwner(sessionUser.getIdIndividual());
		item.setIdTypeObjectOwner(ObjectType.PERSONNE_PHYSIQUE);
		item.create();
		
	} else if(sAction.equals("store"))
	{
		item = GedFolder.getGedFolder(HttpUtil.parseLong("lId", request));
		item.setFromForm(request, "");
		//item.setIdReferenceObjectOwner(sessionUser.getIdIndividual());
		//item.setIdTypeObjectOwner(ObjectType.PERSONNE_PHYSIQUE);
		item.store();
	}
	
	
	response.sendRedirect(
			response.encodeRedirectURL(
					//rootPath + "desk/dropnsign/document/displayAllFolder.jsp"
					rootPath + "desk/dropnsign/document/displayFolder.jsp"
						+ "?lId=" + item.getId()
					)
			);
%>