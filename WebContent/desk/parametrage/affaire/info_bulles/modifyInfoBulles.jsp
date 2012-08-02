<%@page import="org.coin.util.InfosBulles"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
    String sAction = HttpUtil.parseStringBlank("sAction",request);
    InfosBulles item = null;

    if (sAction.equals("create"))
    {
        String sPageUseCaseId = "IHM-DESK-xxxx";
        item = new InfosBulles();
        item.setFromForm(request, "");
        item.create();
    }

    if (sAction.equals("store"))
    {
        String sPageUseCaseId = "IHM-xxxxx";
        long lId = HttpUtil.parseLong("lId",request);
        item = InfosBulles.getInfosBullesMemory(lId);
        item.setFromForm(request, "");
        item.store();
    }

    if (sAction.equals("remove"))
    {
        String sPageUseCaseId = "IHM-xxxxx";
        long lId = HttpUtil.parseLong("lId",request);
        item = InfosBulles.getInfosBullesMemory(lId);
        item.remove();
    }
       
    response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/affaire/info_bulles/displayAllInfoBulles.jsp"));
%>
