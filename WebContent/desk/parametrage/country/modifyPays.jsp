<%@page import="org.coin.bean.ObjectType"%>
<%@page import="org.coin.localization.Language"%>
<%@page import="org.coin.db.ObjectLocalization"%>
<%@page import="org.coin.fr.bean.Pays"%>

<%@ include file="../../../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String rootPath = request.getContextPath()+"/";

	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		Pays item = new Pays();
		item.setFromForm(request, "");
		item.create();
	}
	
	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-DESK-xxx";
		sessionUserHabilitation.isHabilitateException(sPageUseCaseId);
		Pays item = Pays.getPays(request.getParameter("sId"));
        item.setFromForm(request, "");
        item.store();           

        
    	ObjectLocalization olFr = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_FRENCH, ObjectType.PAYS ,item.getIdString());
    	ObjectLocalization olEn = ObjectLocalization.getOrNewObjectLocalization(Language.LANG_ENGLISH, ObjectType.PAYS ,item.getIdString());

    	olFr.setValue(request.getParameter("sLocalization_fr"));
    	olEn.setValue(request.getParameter("sLocalization_en"));
    	olEn.update();
    	olFr.update();
    	item.updateLocalization();

	}
	

	
	response.sendRedirect(
			response.encodeRedirectURL("displayAllPays.jsp"));
%>