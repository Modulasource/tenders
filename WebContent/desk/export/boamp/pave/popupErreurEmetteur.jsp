<%@ include file="/include/new_style/headerDesk.jspf" %>

<%@ page import="com.oreilly.servlet.multipart.*,modula.graphic.*" %>
<%
	String sTitle = "";
%>

</head>
<%@ include file="/include/new_style/headerFichePopUp.jspf" %>
<br/>
<div style="padding:15px">
<body>
<%
	String sMessTitle= "";
	String sMess = "L'adresse e-mail renseign�e sur votre profil ne correspond pas � celle enregistr�e sur le site du BOAMP.<br/>"
					+"Le march� ne peut donc pas �tre envoy� sur ce support.<br/>" 
					+"Veuillez contacter l'assistance Modula.<br/>"
					+"Hotline : 0892 23 02 41 (0.34&euro/min)";
	String sUrlIcone = Icone.ICONE_WARNING;
	
	String sURLRedirect = "";
%>

<br /><br />
<%@ include file="/include/message.jspf"  %>	
	<br />	
	<br />
	<button type="button" 
		onclick="closeModal()" >Fermer la fen�tre</button>
</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body >
</html>