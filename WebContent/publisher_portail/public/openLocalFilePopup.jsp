<%@ include file="/include/new_style/headerDesk.jspf" %>
<% 
    String sTitle = "Ouvrir un fichier en local";
	String sAbsoluteFile = request.getParameter("sAbsoluteFile");
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>

</head>
<body>

<div id="fiche">

<table class="pave" >
    <tr>
        <td class="pave_titre_gauche" colspan="2">
            Ouvrir un fichier en local
        </td>
    </tr>
    <tr>
        <td class="pave_cellule_gauche">
            Fichier à ouvrir :
        </td>
        <td class="pave_cellule_droite">
            <%= sAbsoluteFile %>
        </td>
    </tr>
    <tr>
        <td >&nbsp;
        </td>
    </tr>
    <tr>
        <td style="text-align:center;" colspan="2">
            <applet code="org.coin.applet.OpenLocalFile.class" width="70" height="20"
                    archive="<%= rootPath + "include/jar/SOpenLocalFile.jar" %>">
                <param name="sFilePath" value="<%= sAbsoluteFile %>" />
            </applet>
        </td>
    </tr>
</table>
</div>

</body>
</html>
    