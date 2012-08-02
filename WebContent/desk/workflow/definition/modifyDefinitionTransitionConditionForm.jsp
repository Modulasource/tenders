<%@ include file="../../../include/headerXML.jspf" %>

<%@ page import="org.coin.db.CoinDatabaseAbstractBeanHtmlUtil"%>
<%@ page import="org.coin.bean.*,java.util.*,mt.paraph.graphic.*" %>
<%@ page import="org.coin.bean.workflow.*"%>
<%@ page import="org.coin.bean.organigram.*"%>
<%@ page import="org.coin.fr.bean.Organisation"%>
<%@ include file="../../include/beanSessionUser.jspf" %>
<%
  long lIdDefinitionTransition;
  long lIdObjectType = -1;
  long lIdOrganisation = -1;
  long lIdOrganigram = -1;
  long lIdOrganigramNode = -1;
  long lIdDefinitionTransitionCondition;
  String sAction;
  String sTitle ;
  DefinitionTransitionCondition item;

  sAction = request.getParameter("sAction") ;
  String rootPath = request.getContextPath()+"/";

  if(sAction.equals("store"))
  {
    lIdDefinitionTransitionCondition = Integer.parseInt( request.getParameter("lIdDefinitionTransitionCondition") );
    sTitle = "Modifier une definition de transition";
    item = DefinitionTransitionCondition.getDefinitionTransitionCondition(lIdDefinitionTransitionCondition);
  }
  else
  {
    lIdDefinitionTransition = Integer.parseInt( request.getParameter("lIdDefinitionTransition") );
    lIdDefinitionTransitionCondition = -1;
    sTitle = "Ajouter une definition de transition";
    item = new DefinitionTransitionCondition();
    item.setIdDefinitionTransition(lIdDefinitionTransition);
  }


  try {
	  lIdObjectType = Long.parseLong( request.getParameter("lIdObjectType") );
  } catch (Exception e) { }


  try {
	  lIdOrganisation = Long.parseLong( request.getParameter("lIdOrganisation") );
  } catch (Exception e) { }


  try {
	  lIdOrganigram = Long.parseLong( request.getParameter("lIdOrganigram") );
  } catch (Exception e) { }



  // pour le store
  	if(sAction.equals("store"))
	{
  		if(item.getIdTypeObject() == ObjectType.ORGANIGRAM_NODE)
  		{
  			lIdObjectType = item.getIdTypeObject();

  			try {
	  			OrganigramNode node = OrganigramNode.getOrganigramNode(item.getIdReferenceObject());
	  			lIdOrganigramNode = node.getId();

	  			Organigram nigram = Organigram.getOrganigram(node.getIdOrganigram());
	  			lIdOrganigram = nigram.getId();
	  			lIdOrganisation = nigram.getIdReferenceObject();
  			} catch (Exception e ) {}
  		}

	}



  Vector vObjectTypeGlobal =  ObjectType.getAllObjectType();
  Vector vObjectType =  new Vector<ObjectType>();

  for (int i=0; i < vObjectTypeGlobal.size(); i++)
  {
    ObjectType objtype = (ObjectType) vObjectTypeGlobal.get(i);

    switch ( (int) objtype.getId() )
    {
    case ObjectType.ORGANISATION :
    case ObjectType.PERSONNE_PHYSIQUE :
    // TODO : on traite pas ces cas pour le moment
    //case ObjectType.OBJECT_GROUP  :
    //case ObjectType.ORGANISATION_SERVICE :
    case ObjectType.ORGANIGRAM_NODE  :
    case ObjectType.WORKFLOW_TIMER :
      vObjectType.add(objtype);
      break;
    }
  }


%>
<%@ include file="../../include/headerDesk.jspf" %>
<script type="text/javascript" src="<%= rootPath %>include/bascule.js" ></script>
<script type="text/javascript" >

function chooseObjectType()
{
	var lIdObjectType = document.getElementById('lIdTypeObject').value;
	var sUrl = "<%=
		response.encodeURL(
			"modifyDefinitionTransitionConditionForm.jsp?"
			+ "sAction=" + sAction
			+ "&lIdDefinitionTransition=" + item.getIdDefinitionTransistion()
			+ "&lIdObjectType=")  %>" + lIdObjectType ;

	Redirect(sUrl);

}


function chooseOrganisation()
{
	var lIdObjectType = document.getElementById('lIdTypeObject').value;
	var lIdOrganisation = document.getElementById('lIdOrganisation').value;

	var sUrl = "<%=
		response.encodeURL(
			"modifyDefinitionTransitionConditionForm.jsp?"
			+ "sAction=" + sAction
			+ "&lIdDefinitionTransition=" + item.getIdDefinitionTransistion()
			+ "&lIdObjectType=")  %>" + lIdObjectType
			+ "&lIdOrganisation=" + lIdOrganisation;

	Redirect(sUrl);

}



function chooseOrganigram()
{
	var lIdObjectType = document.getElementById('lIdTypeObject').value;
	var lIdOrganisation = document.getElementById('lIdOrganisation').value;
	var lIdOrganigram = document.getElementById('lIdOrganigram').value;

	var sUrl = "<%=
		response.encodeURL(
			"modifyDefinitionTransitionConditionForm.jsp?"
			+ "sAction=" + sAction
			+ "&lIdDefinitionTransition=" + item.getIdDefinitionTransistion()
			+ "&lIdObjectType=")  %>" + lIdObjectType
			+ "&lIdOrganisation=" + lIdOrganisation
			+ "&lIdOrganigram=" + lIdOrganigram;

	Redirect(sUrl);

}

function chooseOrganigramNode()
{
	var lIdOrganigramNode = document.getElementById('lIdOrganigramNode').value;
	var lIdReferenceObject = document.getElementById('lIdReferenceObject');
	lIdReferenceObject.value = lIdOrganigramNode;
}


</script>

</head>
<body>
<form name="formulaire" action="<%= response.encodeRedirectURL("modifyDefinitionTransitionCondition.jsp") %>" method="post" >
  <input type="hidden" name="lIdDefinitionTransitionCondition" value="<%=item.getId() %>" />
  <input type="hidden" name="lIdDefinitionTransition" value="<%=item.getIdDefinitionTransistion() %>" />
  <input type="hidden" name="lIdDefinitionTransitionConditionClass" value="<%=item.getIdDefinitionTransitionConditionClass() %>" />
  <input type="hidden" name="sAction" value="<%=sAction %>" />

  <%@ include file="../../include/headerFiche.jspf" %>
  <div id="fiche">

  <div class="sectionTitle"><div>Définition de la condition de transition <%= item.getId() %></div></div>
  <div class="sectionFrame">
    <table class="formLayout" cellspacing="3">
      <tr>
        <td class="label" >Nom :</td>
        <td class="frame"><input type="input" name="sName" value="<%= item.getName()%>" size="60" /></td>
      </tr>
      <tr>
        <td class="label" >Type objet :</td>
        <td class="frame">
<%
	if(lIdObjectType == -1)
	{
%>
      <%=	CoinDatabaseAbstractBeanHtmlUtil
          .getHtmlSelect("lIdTypeObject", 1, vObjectType, item.getIdTypeObject(), "", true, false)

      %>
      <input type="button"
      	value="OK"
    	onclick="chooseObjectType()" />
  <%
  	}
	else
	{
		ObjectType objectType = (ObjectType)ObjectType.getCoinDatabaseAbstractBeanFromId(lIdObjectType,vObjectType);
		%><%= objectType.getName()  %>
      <input type="hidden" id="lIdTypeObject" name="lIdTypeObject"
      	value="<%= lIdObjectType %>" />
<%	}
%>        </td>
      </tr>
<%
	if(lIdObjectType == ObjectType.ORGANIGRAM_NODE)
	{
		  Vector vOrganisation =  Organisation.getAllOrganisations();

%>
      <tr>
        <td class="label" >Organisation :</td>
        <td class="frame">
<%
		if(lIdOrganisation == -1)
		{
%>
      <%=	CoinDatabaseAbstractBeanHtmlUtil
          .getHtmlSelect("lIdOrganisation", 1, vOrganisation, lIdOrganisation, "", true, false)

      %>
      <input type="button"
      	value="OK"
    	onclick="chooseOrganisation()" />
  <%
	  	}
		else
		{
			Organisation organisation
				= (Organisation)Organisation
					.getCoinDatabaseAbstractBeanFromId(lIdOrganisation,vOrganisation);
		%><%= organisation.getName()  %>
      <input type="hidden" id="lIdOrganisation" name="lIdOrganisation"
      	value="<%= lIdOrganisation %>" />
<%		}
%>        </td>
      </tr>
<%	}

	if(lIdOrganisation != -1)
	{
		Vector vOrganigram =  Organigram.getAllStatic();
%>     <tr>
        <td class="label" >Organigramme :</td>
        <td class="frame">
<%
		if(lIdOrganigram == -1)
		{
%>
      <%=	CoinDatabaseAbstractBeanHtmlUtil
          .getHtmlSelect("lIdOrganigram", 1, vOrganigram, lIdOrganigram, "", true, false)

      %>
      <input type="button"
      	value="OK"
    	onclick="chooseOrganigram()" />
  <%
	  	}
		else
		{
			Organigram organigram = (Organigram)
				Organigram.getCoinDatabaseAbstractBeanFromId(lIdOrganigram,vOrganigram);
			Vector vOrganigramNode =  OrganigramNode.getAllFromIdOrganigram(lIdOrganigram);
		%><%= organigram.getName()  %>
      <input type="hidden" id="lIdOrganigram" name="lIdOrganigram"
      	value="<%= lIdOrganigram %>" />
		</td>
      </tr>
      <tr>
        <td class="label" >Poste :</td>
        <td class="frame">
      <%=	CoinDatabaseAbstractBeanHtmlUtil
          .getHtmlSelect("lIdOrganigramNode", 1, vOrganigramNode, lIdOrganigramNode, "", true, false)

      %>
      <input type="button"
      	value="OK"
    	onclick="chooseOrganigramNode()" />
<%
		}
%>
        </td>
      </tr>
<%
	} %>
	  <tr>
        <td class="label" >Référence :</td>
        <td class="frame"><input type="input" name="lIdReferenceObject" id="lIdReferenceObject" value="<%=
          item.getIdReferenceObject()%>" size="60" /></td>
      </tr>
    </table>
  </div>
  <br />

  <div class="sectionFrame">

    <!-- Les boutons -->
    <div id="fiche_footer">
      <input type="submit" value="<%=sTitle %>"  />
      <input type="button" value="Supprimer" onclick="javascript:Redirect('<%=
        response.encodeRedirectURL(
            "modifyDefinitionTransitionCondition.jsp?sAction=remove&lIdDefinitionTransitionCondition="
            + item.getId()
            )
        %>')" />
      <input type="button" value="Annuler" onclick="javascript:Redirect('<%=
        response.encodeRedirectURL(
            "displayDefinitionTransition.jsp?lIdDefinitionTransition="
            + item.getIdDefinitionTransistion() )
        %>')" />
    </div>
  </div>
</div>
<%@ include file="../../include/footerFiche.jspf" %>
</form>
</body>
</html>