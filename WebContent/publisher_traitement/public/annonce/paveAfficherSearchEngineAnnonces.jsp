<%@ page import="modula.*,modula.graphic.*,java.util.*,org.coin.fr.bean.*" %>
<%@ include file="/publisher_traitement/public/include/beanSessionUser.jspf" %>
<%@ include file="/publisher_traitement/public/include/beanCandidat.jspf" %> 
<%@ include file="/include/publisherType.jspf"%>  
<%
	boolean bSearchEngineHabilitation = Configuration.isEnabledMemory("publisher.portail.annonce.searchengine.habilitation",false); 


	String rootPath = request.getContextPath()+"/";
	String sTitle = "";
	String sUrlRedirect = request.getRequestURI();
	String sType_avis = request.getParameter("sType_avis");
	String sFormPrefix = request.getParameter("sFormPrefix");
	String sIdMarcheType = request.getParameter("sIdMarcheType");
	String filtreType = request.getParameter("filtreType");
	String filtre = request.getParameter("filtre");
    String sIdDepartement = request.getParameter("iIdDepartement");
    String sType_annonce = request.getParameter("type_annonce");
    String sIsAnnonceDemat = request.getParameter("sIsAnnonceDemat");
    String sIsAnnonceDce = request.getParameter("sIsAnnonceDce");   
    String sIsOnlyUnreadedAnnonceChecked = request.getParameter("sIsOnlyUnreadedAnnonceChecked");
    String sIdGroupCompetence = request.getParameter("iIdGroupCompetence");
    String sSEOperatorValue = HttpUtil.parseString("sSEOperatorValue",request,"AND") ;
    int iMaxElementPerPage = HttpUtil.parseInt("se_iMaxElementPerPage",request,5) ;
    boolean bDisplayMapAnnounce = HttpUtil.parseBoolean("se_bDisplayMapAnnounce", request , false);
   
	//type_annonce=MG
%>
<%@page import="org.coin.util.HttpUtil"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfGroup"%>
<%@page import="mt.modula.affaire.cpf.CodeCpfSwitcher"%>
<%@page import="org.json.JSONArray"%>
<%@page import="mt.modula.affaire.DepartementAffaire"%>
<%@page import="org.coin.bean.conf.Configuration"%>
<script type="text/javascript"> 
<%@ include file="/desk/marche/algorithme/affaire/pave/paveTypeMarcheJavascriptDuProduitCartesien.jspf" %>
</script>
<script type="text/javascript" > 
Event.observe(window, 'load', function(){
	init1(); /* remplir la liste des Types de marché */	
	<%
	if (!sIdMarcheType.equalsIgnoreCase("")){
	%>
	selectOptionById("iIdMarcheType", <%=sIdMarcheType%>);
	<%
	}
	%>
});
</script>
<style>
<!--
select {
    border: 1px solid #36C;
    font-family:Tahoma,Arial;
    font-size:11px;
    padding:1px;
}
option {
	
}
input {
    font-size:11px;
    padding:2px;
    font-family:Tahoma,Arial;
}
button {
	font-size:11px;
    font-family:Tahoma,Arial;
}
-->
</style>

<form method="post" name="formulaire" action="<%=response.encodeURL(sUrlRedirect  )%>" id="seForm" >
<input type="hidden" name="bDisplaySearchEngine" value="false" />
<input type="hidden" name="bLaunchSearch" value="true" />
<input type="hidden" name="sActionMarchePersonneItem" id="sActionMarchePersonneItem" value="" />
<input type="hidden" name="sMarchePersonneItemListMarche" id="sMarchePersonneItemListMarche" value="" />
<input type="hidden" name="sMarchePersonneItemListMarcheAll" id="sMarchePersonneItemListMarcheAll" value="" />

<div id="engineBox" class="sb__" style="text-align:left;padding:3px;font-family:Tahoma,Arial;font-size:11px;width:400px;margin:0 auto;border: 1px solid #AFCCFD">

 	
	<div style="background-color:#FAFAFA">

	<div style="padding: 6px 4px 4px 4px;text-align:center;background-color:#EFF5FF;">
		<select name="type_avis" style="width:250px" >									
			<option value="tout" <% if(sType_avis.equals("tout")){%> selected='selected'<%}%>>Tous les avis</option>
			<option value="aapc" <% if(sType_avis.equals("aapc")){%> selected='selected'<%}%>>Les avis d'appel public à la concurrence</option>
			<option value="tout_sauf_aatr" <% if(sType_avis.equals("tout_sauf_aatr")){%> selected='selected'<%}%>>Tous les avis sans les AATR</option>
			<option value="aa" <% if(sType_avis.equals("aa")){%> selected='selected'<%}%>>Les avis d'attribution</option>
			<option value="ar" <% if(sType_avis.equals("ar")){%> selected='selected'<%}%>>Les avis rectificatifs</option>
			<option value="ra" <% if(sType_avis.equals("ra")){%> selected='selected'<%}%>>Les avis récapitulatifs</option>
		</select>
	</div>
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF">  
        <select name="<%=sFormPrefix %>iIdMarcheType" style="width:250px" >
            <%
            String sLibelleWithCode ="";
            try {
                sLibelleWithCode 
                    = MarcheType.getLibelleWithCodeTypeMemory(Integer.parseInt(sIdMarcheType));
            } catch (Exception e) { }
            
            if (!sIdMarcheType.equalsIgnoreCase("")){
            %>
                <option value="">Tous des types de marché</option>
                <option selected="selected" value="<%=sIdMarcheType%>">
                <%=sLibelleWithCode%>
                </option>
            <%
                }
                else{ 
            %>
            <option selected="selected" value="">Tous les types de marché</option>
            <%
                }
            %>
        </select>
    </div>
<%
		CodeCpfSwitcher cpfSwitcher = null;
		JSONArray jaGroupCPF =  null;
		try{
		    cpfSwitcher = new CodeCpfSwitcher(
		            ObjectType.PERSONNE_PHYSIQUE,
		            candidat.getIdPersonnePhysique());
		    jaGroupCPF = cpfSwitcher.getGroupCPFSelectedList();
		} catch (Exception e ) {}
		
		if(jaGroupCPF == null) jaGroupCPF = CodeCpfGroup.getJSONArray() ;
		
		/**
		 * super user can see everything
		 */
		if( sessionUserHabilitation != null && sessionUserHabilitation.isSuperUser())
		{
			jaGroupCPF = CodeCpfGroup.getJSONArray() ;
		}

%>    
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF">  
       <select name="<%=sFormPrefix %>iIdDepartement" style="width:250px">
                <option value="" selected="selected">Dans tous les départements</option>
<%
            

            Vector vDepartement = null;
			if(Configuration.isEnabled("publisher.portail.search.engine.filter.departement", true)){
	            vDepartement = DepartementAffaire.getAllDepartementFromMarchesEnLigne();
			} else {
				vDepartement = Departement.getAllStaticMemory();
			}
            Vector<PersonnePhysiqueParametre> vParamsPP = null;
            Vector<Departement> vDeptSelected   = null;
            
            if(bSearchEngineHabilitation ) {
            	vParamsPP 
                = PersonnePhysiqueParametre.getAllFromIdPersonnePhysique(candidat.getId());
            }
			
            for(int i=0;i<vDepartement.size();i++)
            {
                Departement departement = (Departement) vDepartement.get(i);
                boolean bDisplayDepartement = true;
                
                /**
                 * super user can see everything
                 */
                if(( sessionUserHabilitation != null && !sessionUserHabilitation.isSuperUser())
                && bSearchEngineHabilitation) {
	                try{
	                	  
	                	  vDeptSelected   
	                	    = VeilleMarcheAbonnes.getAllDepartement(candidat.getId(), vParamsPP,vDepartement);
	                	   
	                      bDisplayDepartement = VeilleMarcheAbonnes.isDepartementInList(
                                  departement.getIdString(),
                                  vDeptSelected);
	                	  

	                } catch (Exception e){
	                	e.printStackTrace();
	                }
                } else {
                	bDisplayDepartement = true;
                }
                
                if(bDisplayDepartement)
                {
%>
                <option value="<%=  departement.getIdString()%>" 
                <%= departement.getIdString().equals(sIdDepartement )?" selected='selected'":"" %>  >
                <%=departement.getName()%>
                </option>
<%
	            }
	                
            }
                
            if(bSearchEngineHabilitation)
            {
            	vDeptSelected   
                = VeilleMarcheAbonnes.getAllDepartement(candidat.getId(), vParamsPP,vDepartement);
            } else {
            	vDeptSelected = vDepartement;
            }
           
                   
%>
        </select>
    </div>
    <div id="divGroupCompetence" style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF">  
       <select name="<%=sFormPrefix %>iIdGroupCompetence" id="<%=sFormPrefix %>iIdGroupCompetence" style="width:250px">
                <script>
                var select = $("<%=sFormPrefix %>iIdGroupCompetence");
                mt.html.setSuperCombo(select);
                var jsonGroup = <%= jaGroupCPF %>;
                if(jsonGroup.length>0){
                    jsonGroup.splice(0, 0, {data:0, value:"Tous les groupes de compétence"});
                    select.populate(jsonGroup,"<%= sIdGroupCompetence %>");
                }else{
                    Element.hide("divGroupCompetence");
                }
                </script>
       </select>
    </div>
    <div style="background-color:#EFF5FF;padding:4px;text-align:center;border-top:1px solid #FFF">
	    <div style="padding: 2px">  
	       <select name="filtreType" style="width:250px">
                <option value="marche.ALL_REF" <%if (filtreType.equalsIgnoreCase("marche.ALL_REF")){
                    %>selected="selected"<%}%> >dont le marché</option> 
	            <option value="marche.reference" <%if (filtreType.equalsIgnoreCase("marche.reference")){
	                %>selected="selected"<%}%> >dont la référence du marché</option> 
 	            <option value="organisation.raison_sociale" <%
	                if (filtreType.equalsIgnoreCase("organisation.raison_sociale")){
	                %>selected="selected"<%}%> >dont l'acheteur public</option>
	        </select>
	    </div>
	    <div style="padding: 0 2px 2px 2px">
	        contient :  <input type="text" name="filtre" value="<%= 
	            (filtre != null 
	            && !filtre.equalsIgnoreCase("") 
	            && !filtre.equalsIgnoreCase("null"))?filtre:"" 
	            %>" size="30" />
	    </div>
<%
	String sSEOperatorValueSelectedAnd = " checked='checked' ";
	String sSEOperatorValueSelectedOr = "";

	if(sSEOperatorValue.equals("OR")){
	    sSEOperatorValueSelectedAnd = "";
	    sSEOperatorValueSelectedOr = " checked='checked' ";
	}

%>	    
        <div style="padding: 0 2px 2px 2px">
            <input type="radio" name="sSEOperatorValue" value="AND" <%= sSEOperatorValueSelectedAnd %>/> tous les mots
            <input type="radio" name="sSEOperatorValue" value="OR" <%= sSEOperatorValueSelectedOr %>/> un des mots
        </div>	    
	    
	    
	</div>
    
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF">  
       entre <input type="text" class="dataType-date" name="se_tsStartDate" value="<%= 
            HttpUtil.parseStringBlank("se_tsStartDate",request) %>" /> 
        et le <input type="text" class="dataType-date" name="se_tsEndDate" value="<%= 
            HttpUtil.parseStringBlank("se_tsEndDate",request) %>" />
    </div>    
<%
	String sIsAnnonceDematChecked = "";

	if("demat".equals(sIsAnnonceDemat))
	{
		sIsAnnonceDematChecked  = " checked='checked' "; 
	}
%>    
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
       <label for="onlyDemat">
       		<input id="onlyDemat" type="checkbox" name="sIsAnnonceDemat" <%= sIsAnnonceDematChecked 
       		%> value="demat" />&nbsp;&nbsp;Afficher uniquement les marchés dématérialisés
       </label>
    </div>
<%
	/**
	 * Bug #2250, to not perform a SQL UNION
	 * cf. bug #2156, #2284 
	 */
	if( (cpfSwitcher != null && cpfSwitcher.vGroupSelected != null && cpfSwitcher.vGroupSelected.size() > 0)
	|| (sessionUserHabilitation != null && sessionUserHabilitation.isSuperUser())
	|| (Configuration.isTrueMemory("publisher.search.engine.display.checkbox.only.dce", false) && sessionUser.isLogged))
	{
	    String sIsAnnonceDceChecked = "";
	
	    if("dce".equals(sIsAnnonceDce))
	    {
	    	sIsAnnonceDceChecked  = " checked='checked' "; 
	    }
%>      
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
       <label for="onlyDce">
            <input id="onlyDce" type="checkbox" name="sIsAnnonceDce" <%= sIsAnnonceDceChecked 
            %> value="dce" />&nbsp;&nbsp;Afficher tous les marchés avec un DCE disponible
       </label>
    </div>
<%
	}

	String sIsOnlyUnreadedAnnonceCheckedStyleTrue = " checked='checked' "; 
	String sIsOnlyUnreadedAnnonceCheckedStyleFalse = ""; 
	if(sessionUser.isLogged )
	{
		if("false".equals(sIsOnlyUnreadedAnnonceChecked))
	    {
			sIsOnlyUnreadedAnnonceCheckedStyleTrue  = ""; 
			sIsOnlyUnreadedAnnonceCheckedStyleFalse  =  " checked='checked' "; 
	    }
%>     
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
            <label for="onlyReadedAnnonce">
            <input id="onlyReadedAnnonce" type="radio" name="sIsOnlyUnreadedAnnonceChecked" <%= 
            	sIsOnlyUnreadedAnnonceCheckedStyleTrue 
            %> value="true" />&nbsp;&nbsp;Afficher uniquement les annonces non lues<br/>
            </label>
            <label for="allAnnonce">
            <input id="allAnnonce" type="radio" name="sIsOnlyUnreadedAnnonceChecked" <%=
            	sIsOnlyUnreadedAnnonceCheckedStyleFalse 
            %> value="false" />&nbsp;&nbsp;Afficher les annonces lues et non lues<br/>
            </label>
    
<!--        
            <input id="onlyReadedAnnonce" type="checkbox" name="sIsOnlyUnreadedAnnonceChecked" <%= sIsOnlyUnreadedAnnonceChecked 
            %> value="true" />&nbsp;&nbsp;Afficher uniquement les annonces non lues
            </label>
 -->

    </div>
<%
	}

if("MG".equals(sType_annonce))
{
%>
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
       <label for="onlyMG">
            <input id="onlyMG" type="checkbox" checked="checked" name="sType_annonce" value="MG" />&nbsp;&nbsp;Afficher uniquement les marchés groupés
       </label>
    </div>
<%
}

if(Configuration.isEnabledMemory("publisher.portail.announce.geoloc") )
{
%>
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
        <label for="se_bDisplayMapAnnounce">
    		<input type="checkbox" name="se_bDisplayMapAnnounce" id="se_bDisplayMapAnnounce" <%= 
    			bDisplayMapAnnounce?" checked='checked'":"" %> /> Afficher les résultats sur la carte
    	</label>
	</div>
<%
}
%>
    <div style="padding: 4px;text-align:center;background-color:#EFF5FF;border-top:1px solid #FFF"> 
		<select name="se_iMaxElementPerPage">
			<option value="5" <%= iMaxElementPerPage==5?"selected='selected'":""  %> >5</option>
			<option value="10" <%= iMaxElementPerPage==10?"selected='selected'":""  %> >10</option>
			<option value="20" <%= iMaxElementPerPage==20?"selected='selected'":""  %> >20</option>
			<option value="50" <%= iMaxElementPerPage==50?"selected='selected'":""  %> >50</option>
		</select> annonces par page
	</div>


    <div align="center" style="padding:5px;background-color:#EEE;border-top:1px solid #FFF">

	    <button type="submit" id="btnSubmitSearchEngine">Afficher les résultats</button>
	</div>
	
	</div>
	
</div>

<!-- 
<style>
#engineBox .sb-inner {background:#FFF;}
#engineBox .sb-border {background:#AFCCFD;}
</style>
<script>RUZEE.ShadedBorder.create({corner:7, border:2}).render($('engineBox'));</script>
 -->
 
 
</form>