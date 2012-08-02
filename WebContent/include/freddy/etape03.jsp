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

<h2>Nouveaux documents  : Note </h2>

<table width="670" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><h3>Description  du circuit &nbsp;&nbsp;&nbsp;</h3> </td>
	  <td align="right"><table width="130" border="0" cellspacing="0" cellpadding="0">
        <tr>

          <td align="center"><img src="images/1_vert.png" alt="Etape 1" width="25" height="25" hspace="3" onclick="doUrl('etape01.jsp');" /></td>
          <td align="center"><img src="images/2_vert.png" alt="Etape 2" width="25" height="25" hspace="3" onclick="doUrl('etape02.jsp');" /></td>
          <td align="center"><img src="images/3_orange_gd.png" alt="Etape3" width="56" height="56" hspace="3" /></td>
        </tr>
      </table></td>
    </tr>
</table>

<br />
<table style="border:#d8d2e1 solid 1px" width="510" border="0" cellspacing="0" cellpadding="0">
  <tr >

    <td  align="left">
	
	<table width="500" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:160px;">Service emetteur </td>
         <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
          <select name="select">
            <option>Service 1 </option>

          </select>
       </td>
 </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="left"></td>

  </tr>
  <tr style="background-color:#eee8e6">
    <td align="left"><table width="500" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:160px;">Affaire suivie par  </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
        <input name="textfield" type="text" size="50" />

       </td>
      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
    <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>

  <tr >
    <td align="left"><table width="500" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:160px;">R&eacute;f&eacute;rence </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
        <input type="text" name="textfield2" />

        </td>
      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
    <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>

  <tr style="background-color:#eee8e6">
    <td align="left"><table width="500" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:160px;">*Date d'&eacute;mission (JJ/MM/AA) </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
        <input type="text" name="textfield3" />
    </td>

      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
    <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr>

    <td align="left"><table width="500" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:160px;">*Objet </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
          <textarea name="textfield3" cols="40" rows="2"></textarea>
    </td>
      </tr>

    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
      <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr style="background-color:#eee8e6">
    <td align="left"><table width="500" border="0" cellspacing="0" cellpadding="5">

      <tr>
        <td style="width:160px;">Attacher le document </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td >
        <input type="text" name="textfield3" />
        <label>
        <input type="submit" name="Submit"  id="submit" value="Parcourir" />
        </label>    </td>

      </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr>
    <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
  </tr>
</table>

<h4>Options générales : </h4>

<table style="border:#d8d2e1 solid 1px" width="700" border="0" cellspacing="0" cellpadding="0">
  <tr >
    <td  align="left"><table width="690" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:170px;">Tr&egrave;s tr&egrave;s urgent </td>
        <td style="width:20px;">
          <input type="checkbox" class="checkbox" name="checkbox" value="checkbox" />        </td>

        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td style="width:180px;">Pas de courriel du destinataire </td>
        <td style="width:20px;">
          <input type="checkbox" class="checkbox" name="checkbox" value="checkbox" />        </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
		 <td style="width:160px;">Confidentiel</td>
         <td style="width:20px;">

          <input type="checkbox" class="checkbox" name="checkbox" value="checkbox" />        </td>
        </tr>
    </table></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>
  <tr>
    <td style="height:1px; background-color:#d8d2e1;"></td>
    <td style="background-image:url(images/droit_form.png); width:3px;" align="left"></td>

  </tr>
  <tr >
    <td align="left"><table width="690" border="0" cellspacing="0" cellpadding="5">
      <tr>
        <td style="width:170px;">Suivi du circuit par messagerie </td>
        <td style="width:20px;"><input type="checkbox" class="checkbox" name="checkbox2" value="checkbox" />
        </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>

        <td style="width:180px;">Passage par la correctrice </td>
        <td style="width:20px;"><input type="checkbox" class="checkbox" name="checkbox2" value="checkbox" />
        </td>
        <td style="width:1px; background-image:url(images/li_tab.png)"></td>
        <td style="width:160px;">Dupliquer ce document </td>
        <td style="width:20px;"><input type="checkbox" class="checkbox" name="checkbox2" value="checkbox" /></td>
      </tr>
    </table></td>

    <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>
  </tr>

    <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
  </tr>
</table>

<h4>Pièces jointes : 
</h4>
<table width="700" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><table style="border:#d8d2e1 solid 1px" width="190" border="0" cellspacing="0" cellpadding="0">

      <tr >
        <td  align="left"><table width="180" border="0" cellspacing="0" cellpadding="8">
            <tr>
              <td align="right">Ajouter pi&egrave;ce jointe </td>
              <td><img src="images/ajouter.gif" alt="Ajouter" width="19" height="18" /></td>
            </tr>
        </table></td>
        <td style="background-image:url(images/droit_form.png); width:3px;" align="center"></td>

      </tr>
      <tr>
        <td style="background-image:url(images/bas_form.png); height:3px;" colspan="2" align="center"></td>
      </tr>
    </table></td>
    <td align="center"><a href="#" onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('Enregistrer en brouillon','','images/b_brouillon_over.png',1)"><img src="images/b_brouillon.png" name="Enregistrer en brouillon" width="167" height="36" border="0" id="Enregistrer en brouillon" /></a></td>
  </tr>
</table>
<br />
<br />

</div>
</div>




</div>
<%@ include file="/include/new_style/footerFiche.jspf" %>
</body>
</html>
