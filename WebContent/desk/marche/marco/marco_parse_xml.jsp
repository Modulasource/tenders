<%@ page import="java.sql.*, modula.ws.marco.*,org.w3c.dom.*,org.coin.util.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Parsing XML</title>
<meta http-equiv="Content-Type" content="text/html" charset="iso-8859-1">
<link rel="stylesheet" href="tests/administration/include/admin.css">
</head>
<body>
<%
	String s;
	String sOperationName;
	String sDataXml = "";
	MarcoAffaire aff = null;
	Document doc;
	Node nodeData;
	
	s = request.getParameter("xml_request") ;

	doc = BasicDom.parseXmlStream(s, false);
	if (doc != null)
	{
		sDataXml = BasicDom.getXML(doc) ;
		sDataXml= org.coin.util.Outils.getTextToHtml(sDataXml);
		
		nodeData = BasicDom.getFirstChildElementNode(doc);
		
		//on crée le premier objet AppelOffre
		aff = new MarcoAffaire(BasicDom.getFirstChildElementNode(nodeData));
	}
%>
</PRE>
<TABLE border="1" >
  <TR>
	<TD>Marché (Affaire)</TD>
	<TD>Code origine :
	<B><%= aff.sCodeOrigine %></B>
	Numéro de l'affaire :
	<B><%= aff.sNumeroAffaire %></B></TD>
  </TR>
  <TR>
	<TD>&nbsp;</TD>
	<TD>
	<%@ include file="pave/marco_affaire.jspf" %>
	</TD>
  </TR>
  <TR>
	<TD>&nbsp;</TD>
	<TD>
	<TABLE>
	  <TR>
        <TD>Liste des dossiers </TD>
	  </TR>
	  <TR>
        <TD><% for (int i=0; i < aff.dossiers.length ; i++)
        		{
					MarcoDossier dossier = aff.dossiers[i]; %>
        <%@ include file="pave/marco_dossier.jspf" %>
        <%		}
        %></TD>
	  </TR>
	</TABLE>
	</TD>
  </TR>
</TABLE>
<%@ include file="../../include/footerDesk.jspf" %>
</body>
</html>
