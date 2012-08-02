<?xml version="1.0" encoding="iso-8859-1"?> 
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr" lang="fr">

<%@ page import="org.coin.bean.*,java.util.*" %>
<%
int iIdRole ;
int iIdUser = 1;

User user = User.getUser(iIdUser);
Vector vGroup = UserGroup.getAllGroup(iIdUser);
Group group = (Group) vGroup.firstElement();

%>
<body>
<p>User : <%= user.getLogin()%></p>
<p>du Groupe : <%= group.getName()%></p> 
<table border="1" >
<tr>
<td>Rôle</td>
<td>Libellé</td>
<td>C.U.</td>
<%

Vector vRoles = GroupRole.getAllRole((int)group.getId());

for (int i=0; i < vRoles.size(); i++)
{
	Role role = (Role) vRoles.get(i);
	Vector vUseCases = Habilitation.getAllUseCase((int)role.getId() );
%><tr>
    <td><%=role.getId()  %></td>
    <td><%=role.getName()  %></td>
    <td>
<%@ include file="pave/paveListUseCase.jspf" %>
    </td>
  </tr>
<%
}
%>
</table>
<%@ include file="../include/footerDesk.jspf" %>
</body>
</html>
