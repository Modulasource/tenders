<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "Formulaire de contact";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>
<%
	PersonnePhysique pp = null;
	try {
		pp = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
	} catch (Exception e) {
		pp = new PersonnePhysique();
	}

	
	/**
	
	What are the Servlets Equivalents of CGI for commonly requested variables?

    SERVER_NAME         request.getServerName();
    SERVER_SOFTWARE     request.getServletContext().getServerInfo();
    SERVER_PROTOCOL     request.getProtocol();
    SERVER_PORT         request.getServerPort()
    REQUEST_METHOD      request.getMethod()
    PATH_INFO           request.getPathInfo()
    PATH_TRANSLATED     request.getPathTranslated()
    SCRI-PT_NAME         request.getServletPath()
    DOCUMENT_ROOT       request.getRealPath("/")
    QUERY_STRING        request.getQueryString()
    REMOTE_HOST         request.getRemoteHost()
    REMOTE_ADDR         request.getRemoteAddr()
    AUTH_TYPE           request.getAuthType()
    REMOTE_USER         request.getRemoteUser()
    CONTENT_TYPE        request.getContentType()
    CONTENT_LENGTH      request.getContentLength()
    HTTP_ACCEPT         request.getHeader("Accept")
    HTTP_USER_AGENT     request.getHeader("User-Agent")
    HTTP_REFERER        request.getHeader("Referer")
	
	*/
	
	String sRequestUrl = request.getRequestURL().toString();
    String sUserAgentReport = request.getHeader("User-Agent");
    String sAccept = request.getHeader("Accept");
    String sReferer = request.getHeader("Referer");
    String sRemoteHost = request.getRemoteHost();
    String sRemoteAddr = request.getRemoteAddr();
    String sPathInfo = request.getPathInfo();

    
    String[] sarrSignalementType = new String [] {
    		"Mot de passe oublié",
    		"Impossible de s'incrire",
    		"Impossible de se connecter",
    		"Je n'arrive pas à télécharger le DCE",
    		"Je n'arrive pas à candidater",
    		"Je ne trouve pas un marché dématérialisé sur la plateforme",
            "Je n'arrive pas à m'inscrire à la veille de marchés",
            "Mon certificat électronique ne fonctionne pas",
            "Mon certificat électronique n'est pas reconnu",
            "Comment répondre électroniquement ?",
            "Autre"
    };
    
%>
<form name="formulaire" action="<%= response.encodeURL("report.jsp" ) %>" method='post' >

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Formulaire en ligne</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
	<table class="fullWidth" >
        <tr>
            <td class="pave_cellule_gauche">Signalement :</td>
            <td class="pave_cellule_droite">
                <select name="sSignalementType" >
<%
    for(int i =0; i < sarrSignalementType.length; i++)
    {
    	String sSignalementType =  sarrSignalementType[i];
%>
<option value="<%= sSignalementType %>" ><%= sSignalementType %></option>
<%    	
    }

%>
                </select>
            </td>
        </tr>
		<tr>
			<td class="pave_cellule_gauche">Nom :</td>
			<td class="pave_cellule_droite">
    			<input type="text" size="40" name="sNom" value="<%= pp.getPrenomNom()  %>" /> 
			</td>
		</tr>
        <tr>
            <td class="pave_cellule_gauche">Téléphone :</td>
            <td class="pave_cellule_droite">
                <input type="text" size="40" name="sTelephone" value="<%= pp.getTel() + " " + pp.getTelPortable()  %>" /> 
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">Email :</td>
            <td class="pave_cellule_droite">
                <input type="text" size="40" name="sEmail" value="<%= pp.getEmail()  %>" /> 
            </td>
        </tr>
        <tr>
            <td class="pave_cellule_gauche">Référence ou objet du marché concerné (le cas échéant) : </td>
            <td class="pave_cellule_droite">
                <input type="text" size="40" name="sReferenceMarche" />
            </td>
        </tr>
		<tr>
			<td class="pave_cellule_gauche">Description :</td>
			<td class="pave_cellule_droite">
				<textarea rows="5" cols="60" name="sDescription"></textarea>
			</td>
		</tr>
        <tr>
            <td class="pave_cellule_gauche">Navigateur :</td>
            <td class="pave_cellule_droite">
                <input type="hidden"  name="sUserAgent" value="<%= sUserAgentReport %>" /> <%= sUserAgentReport %><br/>
                <input type="hidden"  name="sAccept" value="<%= sAccept %>" /> <%= sAccept %><br/>
                <input type="hidden"  name="sReferer" value="<%= sReferer %>" /> <%= sReferer %><br/>
                <input type="hidden"  name="sRequestUrl" value="<%= sRequestUrl %>" /> <%= sRequestUrl %><br/>
                <input type="hidden"  name="sRemoteAddr" value="<%= sRemoteAddr %>" /> <%= sRemoteAddr %><br/>
                <input type="hidden"  name="sRemoteHost" value="<%= sRemoteHost %>" /> <%= sRemoteHost %><br/>
                <input type="hidden"  name="sPathInfo" value="<%= sPathInfo %>" /> <%= sPathInfo %><br/>
            </td>
        </tr>
	</table>
 </div>
    <div style="text-align:center;">
    <button type="submit">Envoyer</button>
    </div>
    <br/>
 </div>



</form>
<%@ include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>