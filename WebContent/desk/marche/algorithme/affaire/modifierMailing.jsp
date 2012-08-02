<%@ include file="../../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.fr.bean.mail.*" %>
<%
	int iIdMailing = Integer.parseInt( request.getParameter("iIdMailing") );
	
	String sAction = request.getParameter("sAction") ;
	Mailing mailing = null;
	String sUrlTarget = "";
	sUrlTarget = response.encodeRedirectURL("afficherMailing.jsp?iIdMailing=" + iIdMailing
		+ "&nonce=" + System.currentTimeMillis());

	if(sAction.equals("remove"))
	{
		mailing = Mailing.getMailing(iIdMailing);
		//mailing.remove();
		// TODO : il faut supprimer aussi les mails destinataires.
		sUrlTarget = response.encodeRedirectURL("afficherToutesPublications.jsp?iIdAffaire=" + mailing.getIdObjetReference()
			+ "&nonce=" + System.currentTimeMillis());
	
	
	}
	
	if(sAction.equals("create"))
	{
		mailing = new Mailing();
		mailing.setFromForm(request, "");
		MailType mt = MailType.getMailTypeMemory(mailing.getIdMailType());
		mailing.setMailObjet( mt.getObjetType() );
		mailing.setMailCorps( mt.getContenuType() );
		mailing.create();
		sUrlTarget = response.encodeRedirectURL("afficherMailing.jsp?iIdMailing=" + mailing.getIdMailing()
			+ "&nonce=" + System.currentTimeMillis());
	
	}
	
	if(sAction.equals("store"))
	{
		mailing = Mailing.getMailing(iIdMailing);
		mailing.setFromForm(request, "");
		mailing.store();
		sUrlTarget = response.encodeRedirectURL("afficherMailing.jsp?iIdMailing=" + iIdMailing
			+ "&nonce=" + System.currentTimeMillis());
	}

	if(sAction.equals("modifierMailType"))
	{
		int iIdMailType = Integer.parseInt( request.getParameter("iIdMailType") );
		
		mailing = Mailing.getMailing(iIdMailing);
		MailType mt = MailType.getMailTypeMemory(iIdMailType );
		mailing.setIdMailType( iIdMailType );
		mailing.setMailObjet( mt.getObjetType() );
		mailing.setMailCorps( mt.getContenuType() );
		mailing.store();

		sUrlTarget = response.encodeRedirectURL("modifierMailingForm.jsp?sAction=store&iIdMailing=" + iIdMailing
			+ "&nonce=" + System.currentTimeMillis());
	
	}
		
	 
	response.sendRedirect( sUrlTarget );
%>
