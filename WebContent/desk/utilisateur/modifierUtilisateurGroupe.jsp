
<%@ page import="org.coin.bean.*,org.coin.util.*,java.util.*" %>
<%

	int iIdUser ;
	String sAction;
	String sIdGroupesListe;

	iIdUser = Integer.parseInt( request.getParameter("iIdUser") );
	sAction = request.getParameter("sAction") ;
	sIdGroupesListe = request.getParameter("iIdGroupSelectionListe");
	Vector vIntegerList = Outils.parseIntegerList(sIdGroupesListe , "|");

	// partie Roles
	UserGroup.removeAllByIdUser(iIdUser);
	for(int i =0; i < vIntegerList.size(); i++)
	{
		int iIdGroup = ((Integer) vIntegerList.get(i)).intValue();
		UserGroup usergroup = new UserGroup(iIdUser, iIdGroup);
		usergroup.create();
	}
	response.sendRedirect(response.encodeRedirectURL("afficherUtilisateurGroupe.jsp?iIdUser=" + iIdUser));
	
%>
