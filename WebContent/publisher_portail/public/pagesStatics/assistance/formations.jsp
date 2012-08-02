<%@ include file="/include/new_style/headerPublisher.jspf" %>

<%@page import="modula.graphic.Icone"%>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %>
<%
	String sTitle = "Une formation et un accompagnement adapt�";
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
		&nbsp;&nbsp;&nbsp;<span class="firstLetter">N</span>ous vous proposons un panel de formations compl�tes, pratiques et adapt�es � votre structure afin de vous permettre d'acqu�rir toutes les comp�tences pour :<br />
<ul>
	<li>
utiliser vos certificats �lectroniques en toute s�r�nit�, et dans de bonnes conditions de s�curit�,
	</li>
	<li>
envoyer vos candidatures et offres sur les principales plateformes de d�mat�rialisation de march�s,
	</li>
	<li>
effectuer toutes les t�l� d�clarations aux diff�rents organismes sociaux (T�l�TVA, DUCS, etc)
	</li>
</ul>
Nos stages sont organis�s en inter ou en intra entreprise en fonction de vos souhaits.<br />

Si vous en faites la demande, nous pouvons �laborer ensemble un programme de formation adapt� � vos besoins particuliers.<br />

Nos formations peuvent �tre financ�es par l'OPCA de votre branche d'activit�.<br /><br />

Informations, programmes et tarifs vous seront fournis par notre service commercial au 01 80 89 60 06
 (prix d'un appel local) ou en remplissant le formulaire ci-dessous�: <br />
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