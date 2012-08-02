<?xml version="1.0" encoding="iso-8859-1"?> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">

<%@ page import="org.coin.bean.*,java.util.*" %>
<%
int iIdRole = 1;
Role role = Role.getRole(iIdRole);

%>
<body>
<p>Role : <%= role.getName()%></p>
<%
	Vector vUseCases = Habilitation.getAllUseCase(1);
%>
<%@ include file="pave/paveListUseCase.jspf" %>
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>
