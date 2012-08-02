<%@page import="org.coin.bean.addressbook.IndividualAction"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.bean.ged.GedFolder"%>
<%@include file="/include/new_style/headerJspUtf8.jspf" %>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	IndividualAction item = null;

	if(sAction.equals("setState"))
	{
		item = IndividualAction.getIndividualAction(HttpUtil.parseLong( "lId", request));
		item.setIdIndividualActionState(HttpUtil.parseLong( "lIdIndividualActionState", request));
		item.store();
	} 
	
	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath + "desk/dropnsign/action/displayAllIndividualAction.jsp"
					)
			);
%>