<?xml version="1.0" encoding="UTF-8" ?>
<%@ page contentType="text/xml;charset=UTF-8" %>

<%@page import="org.coin.bean.UserHabilitation"%>
<%@page import="org.coin.util.HttpUtil"%>
<%@ page import="modula.*"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<% 
	int iIdRootNode = HttpUtil.parseInt("iIdRootNode",request,1);
	int iIdUserDelegate = HttpUtil.parseInt("iIdUserDelegate",request,0);
	boolean bIsDelegate = HttpUtil.parseBoolean("isDelegate",request,false);
	boolean bUseLocalization = Configuration.isEnabledMemory("server.localization",false);

	String sXmlMenu = "";
	
	try{
		UserHabilitation habil = sessionUserHabilitation;
		if(bIsDelegate && iIdUserDelegate>0){
			habil = new UserHabilitation(iIdUserDelegate);
		}
	    sXmlMenu = TreeviewNoeud.getXmlMenu(
	            iIdRootNode, 
	            habil, 
	            request.getContextPath()+"/", 
	            response ,
	            false,
	            bUseLocalization ,
	            (int)sessionLanguage.getId()); 
	}catch (Exception e) {
		e.printStackTrace();
	}

%>
<%= sXmlMenu %>