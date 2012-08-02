<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.bean.addressbook.IndividualLinkState"%>
<%@page import="org.coin.bean.addressbook.IndividualLinkType"%>
<%@page import="org.coin.bean.addressbook.IndividualLink"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="org.coin.bean.ObjectType"%>
<%@include file="/include/new_style/headerJspUtf8.jspf" %>
<%@include file="/include/new_style/beanSessionUser.jspf" %>
<%
	String rootPath = request.getContextPath() +"/";
	String sAction = HttpUtil.parseStringBlank("sAction", request);
	IndividualLink item = null;

	if(sAction.equals("create"))
	{
		String sLogin = HttpUtil.parseStringBlank("sLogin", request);
		try {
			User dest = User.getUserFromLogin(sLogin);

			item = new IndividualLink();
			item.setFromForm(request, "");
			item.setIdIndividualSource(sessionUser.getIdIndividual());
			item.setIdIndividualDestination(dest.getIdIndividual());
			item.setIdIndividualLinkType(IndividualLinkType.TYPE_NORMAL);
			item.setIdIndividualLinkState(IndividualLinkState.STATE_PENDING_CONFIRMATION);
			item.create();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	if(sAction.equals("accept"))
	{
		item = IndividualLink.getIndividualLink(HttpUtil.parseLong("lId", request));
		item.setIdIndividualLinkState(IndividualLinkState.STATE_ACCEPTED);
		item.store();
	}

	if(sAction.equals("refuse"))
	{
		item = IndividualLink.getIndividualLink(HttpUtil.parseLong("lId", request));
		item.setIdIndividualLinkState(IndividualLinkState.STATE_REFUSED);
		item.store();
	}

	
	if(sAction.equals("remove"))
	{
		item = IndividualLink.getIndividualLink(HttpUtil.parseLong("lId", request));
		item.remove();
	}

	response.sendRedirect(
			response.encodeRedirectURL(
					rootPath + "desk/dropnsign/link/displayAllIndividualLink.jsp"
					)
			);
%>