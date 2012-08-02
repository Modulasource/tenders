<%@page import="org.coin.bean.conf.Configuration"%>
<%@ page import="modula.graphic.*,java.sql.*,org.coin.fr.bean.*,modula.candidature.*,org.coin.util.*,java.util.*,modula.algorithme.*, modula.*, modula.marche.*,modula.candidature.*, modula.marche.cpv.*,modula.commission.*, org.coin.util.treeview.*,java.text.*" %>
<%@ include file="/desk/include/beanSessionUser.jspf" %>
<%@ include file="/desk/include/useBoamp17.jspf" %>
<%
    String sPaveProcedureTitre = "Procédure";
    String sFormPrefix = "";
    Marche marche = (Marche) request.getAttribute("marche");
    String rootPath = request.getContextPath()+"/"; 
    boolean bIsRectification = Boolean.parseBoolean(request.getParameter("bIsRectification"));
    String sAction = request.getParameter("sAction");
%>

<div><%
if(sAction.equals("store"))        
{
    out.write( modula.marche.graphic.OngletAapcJoue.getHtml(marche, true)); 
} else {
    out.write( modula.marche.graphic.OngletAapcJoue.getHtml(marche, false)); 
}
%>

<br/>
Attention les formulaires 4, 7, 8, 9, et 11 sont des formulaires en PDF, téléchargeablent ci-dessous.<br/>
<i>Modula propose de télécharger le formulaire PDF correspondant à votre 
demande de publication. Ce formulaire est spécialement conçu pour une utilisation par les services de la 
Direction des Journaux Officiels et ne peut pas convenir à un envoi direct au JOUE.</i> 


<table class="pave" >
<tr>
    <td>
        <table  class="liste" >
            <tr>
                <th>Formulaire</th>
                <th>Document</th>
            </tr>
            <tr class="liste0" > 
                <td>Formulaire 4</td>
                <td>
                    <a href="http://boamp.journal-officiel.gouv.fr/PDF_FORM/formulaire_UE_04_v1.pdf" target="_blank">
                    <img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                        alt="télécharger" title="télécharger"/>
                        Formulaire 4 - Avis périodique indicatif - Secteurs spéciaux  
                    </a>
                </td>       
            </tr>
            <tr class="liste1" > 
                <td>Formulaire 7</td>
                <td>
                    <a href="http://boamp.journal-officiel.gouv.fr/PDF_FORM/formulaire_UE_07_v1.pdf" target="_blank">
                    <img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                        alt="télécharger" title="télécharger"/>
                        Formulaire 7 - Système de qualification - Secteurs spéciaux 
                    </a>
                </td>       
            </tr>
            <tr class="liste0" > 
                <td>Formulaire 8</td>
                <td>
                    <a href="http://boamp.journal-officiel.gouv.fr/PDF_FORM/formulaire_UE_08_v1.pdf" target="_blank">
                    <img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                        alt="télécharger" title="télécharger"/>
                        Formulaire 8 - Avis sur un profil d'acheteur  
                    </a>
                </td>       
            </tr>
            <tr class="liste1" > 
                <td>Formulaire 9</td>
                <td>
                    <a href="http://boamp.journal-officiel.gouv.fr/PDF_FORM/formulaire_UE_09_v1.pdf" target="_blank">
                    <img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                        alt="télécharger" title="télécharger"/>
                        Formulaire 9 - Avis de Marché simplifié dans le cadre d'un système d'acquisition dynamique  
                    </a>
                </td>       
            </tr>
            <tr class="liste0" > 
                <td>Formulaire 11</td>
                <td>
                    <a href="http://boamp.journal-officiel.gouv.fr/PDF_FORM/formulaire_UE_11_v1.pdf" target="_blank">
                    <img src="<%=rootPath + modula.graphic.Icone.ICONE_FICHIER_DEFAULT_NEW_STYLE %>" 
                        alt="télécharger" title="télécharger"/>
                       Formulaire 11 - Avis de Marché - Marchés passés par un concessionnaire qui n'est pas un pouvoir adjucateur 
                    </a>
                </td>       
            </tr>
        </table>
    </td>
</tr>
</table>

</div><%



%>