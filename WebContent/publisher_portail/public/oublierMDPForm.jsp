<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@ page import="org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
    String sTitle = "Oubli du mot de passe ?" ;
	String sPageUseCaseId = "IHM-PUBLI-3";	
%>
<script type="text/javascript">
<!--

onPageLoad = function() {

<%
	if(session.getAttribute("sMessageErreur") != null
	&& !((String)session.getAttribute("sMessageErreur")).equalsIgnoreCase(""))
	{
%>
    try{ showLoginBox(); } catch (e) {}
<%
	}
%>
}



function checkForm()
{
    var item = $("sMailPersonne");
    
    if (isNull(item.value))
    {
        alert("Veuillez donner votre adresse email");
        item.focus();
        return false;
    }
    
    if (!isMail(item.value))
    {
        alert("La syntaxe de l'adresse email fournie est incorrecte");
        item.focus();
        return false; 
    }
    
    return true;
}

//-->
</script>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %><br />

<form action="<%= response.encodeURL(rootPath+"publisher_traitement/public/oublierMDP.jsp")%>" method="post" 
    enctype="application/x-www-form-urlencoded" name="formulaire" onSubmit="return checkForm()">
    
<div style="padding:20px;text-align:center">
    <div class="post" >
        <div class="post-title" >Oubli du mot de passe</div>
        <div class="post-header post-block">
	        Entrez l'adresse e-mail de votre compte, nous vous enverrons votre mot de passe.
	        <br/>
            <input type="text" name="sMailPersonne" id="sMailPersonne" size="60" maxlength="255" />
            <br/>      
            <br/>      
            <button type="submit" >Envoyer</button>
        </div>  
    </div>
</div>    
    
<div >
	&nbsp;
	
</div>
	
</form>


<%@include file="../public/include/footer.jspf"%>
</body>
</html>