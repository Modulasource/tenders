
<%@page import="mt.modula.affaire.cpf.CodeCpfGroupItem"%>
<%@page import="org.coin.bean.GroupRole"%>
<%@page import="org.coin.util.Outils"%>
<%@page import="java.util.Vector"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="org.coin.util.HttpUtil"%><%@ include file="/include/new_style/headerDesk.jspf" %>
<%@page import="modula.marche.MarchePieceJointeType"%>
<%@page import="org.coin.db.CoinDatabaseAbstractBean"%>

<%@ page import="org.coin.bean.conf.*"%>

<%
	String sAction = HttpUtil.parseStringBlank("sAction",request);
	CodeCpfGroup item = null;

	String sIdBoampCPFSelectionList = request.getParameter("lIdBoampCPFSelectionList");
	Vector<Integer> vIntegerList = Outils.parseIntegerList(sIdBoampCPFSelectionList, "|");
	
	if (sAction.equals("create"))
	{
		String sPageUseCaseId = "IHM-DESK-xxxx";
		item = new CodeCpfGroup();
		item.setFromForm(request, "");
		item.create();
	}

	if (sAction.equals("store"))
	{
		String sPageUseCaseId = "IHM-xxxxx";
		long lId = HttpUtil.parseLong("lId",request);
		item = CodeCpfGroup.getCodeCpfGroupMemory(lId,true);
		item.setFromForm(request, "");
		item.store();
	}

	CodeCpfGroupItem.removeAllFromGroup(item.getId());
	for(int iCPF : vIntegerList)
	{
		CodeCpfGroupItem cpfItem = new CodeCpfGroupItem();
		cpfItem.setIdBoampCpf(iCPF);
		cpfItem.setIdCodeCpfGroup(item.getId());
		cpfItem.create();
	}
	
	response.sendRedirect(response.encodeRedirectURL(rootPath+"desk/parametrage/affaire/cpf/displayAllCPFGroup.jsp"));
%>
