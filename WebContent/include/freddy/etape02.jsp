<%@ include file="/include/new_style/headerDesk.jspf" %>

<%
	String sTitle = "<h2>Nouveau document : Note</h2>";

%>
<link rel="stylesheet" type="text/css" href="<%= rootPath %>include/freddy/css/site.css" media="screen" />
</head>
<body>
<%@ include file="/include/new_style/headerFiche.jspf" %>
<div style="padding:15px">


<div class="contenu">
<!-- 
<h2>Nouveaux documents  : Note </h2>
 -->

<table width="670" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h3>Mise &agrave; jour  du circuit &nbsp;&nbsp;&nbsp;<span class="Style1">Non enregistr&eacute;</span></h3> </td>

	  <td align="right"><table width="130" border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td align="center"><img src="images/1_vert.png" alt="Etape 1" width="25" height="25" hspace="3" onclick="doUrl('etape01.jsp');" /></td>
          <td align="center"><img src="images/2_orange_gd.png" alt="Etape 2" width="56" height="56" hspace="3" /></td>
          <td align="center"><img src="images/3_rouge.png" alt="Etape3" width="25" height="25" hspace="3" /></td>
        </tr>
      </table></td>
    </tr>
</table>

<br />
<table style="border:#d8d2e1 solid 1px" width="700" border="0" cellspacing="0" cellpadding="0">
  <tr >
    <td  align="center">
	
	<table width="690" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:100px;">Destinataire</td>
         <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td > user2 user 2 </td>

 <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:23px;"><img src="images/ajouter.gif" alt="Ajouter" width="19" height="18" /></td>
      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>

  </tr>
  <tr style="background-color:#eee8e6">
    <td align="center"><table width="690" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:100px;">Numero d'ordre </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:150px;"> Nom </td>

      <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:40px;" >S/C</td>
		    <td style="width:1px; background-image:url(images/li_tab.png)"></td>
            <td align="center" style="width:40px;" >P.I.</td>
		    <td style="width:1px; background-image:url(images/li_tab.png)"></td>
            <td ></td>
        </tr>
    </table>

	</td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
    <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr >
    <td align="center"><table width="690" border="0" cellspacing="0" cellpadding="5">

      <tr>
        <td style="width:100px;">Signataire : </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td style="width:150px;"> user1 user1 </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:100px; background-image:url(images/signature.png); background-repeat:no-repeat" ></td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>

        <td ></td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:23px;"><span style="width:19px;"><img src="images/ajouter.gif" alt="Ajouter" width="19" height="18" /></span></td>
      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
    <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>

    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr style="background-color:#eee8e6">
    <td align="center"><table width="690" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:100px;">En copie : </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td > user2 user 2 </td>

        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td align="center" style="width:23px;"><img src="images/ajouter.gif" alt="Ajouter" width="19" height="18" /></td>
      </tr>
    </table>
	</td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>

  <tr>

    <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
  </tr>
</table>
<br />
<br />
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Enregistrer','','images/b_enregistrer_over.png',1)"><img src="images/b_enregistrer.png" name="Enregistrer" width="167" height="36" border="0" id="Enregistrer" /></a></td>
    <td style="width:200px" align="right"><a href="etape03.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Continuer','','images/b_continuer_over.png',1)"><img src="images/b_continuer.png" name="Continuer" width="132" height="53" border="0" id="Continuer" /></a></td>
  </tr>
</table>

</div>
</div>



</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
