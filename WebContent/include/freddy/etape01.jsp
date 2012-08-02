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
    <td><h3>Choix du circuit</h3></td>
	  <td align="right"><table width="130" border="0" cellspacing="0" cellpadding="0">
        <tr>

          <td align="center"><img src="images/1_orange_gd.png" alt="Etape 1" width="56" height="56" hspace="3" /></td>
          <td align="center"><img src="images/2_rouge.png" alt="Etape 2" width="25" height="25" hspace="3" /></td>
          <td align="center"><img src="images/3_rouge.png" alt="Etape3" width="25" height="25" hspace="3" /></td>
        </tr>
      </table></td>
    </tr>
</table>

<br />
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>

    <td><table style="border:#d8d2e1 solid 1px" width="180" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td align="center">
          <table style="margin-top:10px; margin-bottom:10px;" width="170" border="0" cellspacing="0" cellpadding="5">
          <tr>
            <td align="right"><label>
              <input type="radio" class="radiobutton" name="radiobutton" value="radiobutton" />
            </label></td>
            <td align="left">Organigramme</td>

          </tr>
          <tr>
            <td align="right"><input type="radio" class="radiobutton" name="radiobutton" value="radiobutton" /></td>
            <td align="left">Diffusion aux services </td>
          </tr>
        </table>
           </td>
			 <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>

      </tr>
      <tr>
        <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
		 </tr>
    </table></td>
    <td align="right">
	<table style="border:#d8d2e1 solid 1px" width="480" border="0" cellspacing="0" cellpadding="0">
      <tr >
        <td  align="center"><table style="margin-top:5px; margin-bottom:5px" width="470" border="0" cellspacing="0" cellpadding="5">

          <tr>
            <td align="left" style="width:120px">Service destinataire </td>
            <td align="left">
              <select name="select">
                <option>Direction des moyens techniques et de la s&eacute;curit&eacute;</option>
              </select>           </td>
          </tr>

        </table></td>
        <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
      </tr>
	  <tr><td style="height:1px; background-color:#d8d2e1;"></td>
	   <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td></tr>
      <tr>
        <td align="center">
		<table style="margin-top:5px; margin-bottom:5px"width="470" border="0" cellspacing="0" cellpadding="5">
          <tr>

            <td align="left" style="width:120px">Destinataire </td>
            <td align="left"><select name="select2">
              <option>Bailly G&eacute;rard</option>
                        </select></td>
          </tr>
        </table></td>
        <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>

      </tr>
      <tr>
        <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
      </tr>
    </table></td>
  </tr>
</table>

<br />
<br />
<table width="700" border="0" cellspacing="0" cellpadding="0">

  <tr>
    <td align="right"><a href="etape02.jsp" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Continuer','','images/b_continuer_over.png',1)"><img src="images/b_continuer.png" name="Continuer" width="132" height="53" border="0" id="Continuer" /></a></td>
  </tr>
</table>
</div>
</div>

</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
