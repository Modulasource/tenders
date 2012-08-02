<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Une formation et un accompagnement adapté";
    String sPageUseCaseId = "IHM-PUBLI-3";  
%>
<%@ include file="/publisher_traitement/public/include/redirectOnLoad.jspf" %>
</head>
<body>
<%@ include file="/publisher_traitement/public/include/header.jspf" %>

<div class="post">
    <div class="post-title">
        <table class="fullWidth" cellpadding="0" cellspacing="0">
        <tr>
            <td>
                <strong style="color:#36C">Assistance</strong>
            </td>
            <td class="right">
                <strong style="color:#B00">&nbsp;</strong>
            </td>
        </tr>
        </table>
    </div>
  <br/>
  <div class="post-footer post-block" style="margin-top:0">
  <table class="fullWidth" cellpadding="5" >
	<tr>
		<td style="vertical-align:top">
		<div style="text-align:left;padding:5px">
		&nbsp;&nbsp;&nbsp;<span class="firstLetter">N</span>ous vous proposons un panel de formations complètes, pratiques et adaptées à votre structure afin de vous permettre d'acquérir toutes les compétences pour :<br />
<ul>
	<li>
utiliser vos certificats électroniques en toute sérénité, et dans de bonnes conditions de sécurité,
	</li>
	<li>
envoyer vos candidatures et offres sur les principales plateformes de dématérialisation de marchés,
	</li>
	<li>
effectuer toutes les télé déclarations aux différents organismes sociaux (TéléTVA, DUCS, etc)
	</li>
</ul>
Nos stages sont organisés en inter ou en intra entreprise en fonction de vos souhaits.<br />

Si vous en faites la demande, nous pouvons élaborer ensemble un programme de formation adapté à vos besoins particuliers.<br />

Nos formations peuvent être financées par l'OPCA de votre branche d'activité.<br /><br />

Informations, programmes et tarifs vous seront fournis par notre service commercial au 01 80 89 60 06
 (prix d'un appel local) ou en remplissant le formulaire ci-dessous : <br />
<%
	String sContactRedirection = "publisher_portail/public/pagesStatics/assistance/formations.jsp";
%>
<%@ include file="/publisher_traitement/public/pagesStatics/contact/pave/paveContactForm.jspf" %>
		</div>
		</td>
	</tr>
  </table>
</div>
</div>
<%@include file="/publisher_traitement/public/include/footer.jspf"%>
</body>
</html>