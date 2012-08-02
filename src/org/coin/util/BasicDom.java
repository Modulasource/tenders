/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
 ****************************************************************************/

package org.coin.util;

import java.io.*;
import java.sql.Timestamp;

import javax.xml.XMLConstants;
import javax.xml.parsers.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.sax.SAXSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.coin.security.PreventInjection;
import org.coin.util.CalendarUtil;
import org.w3c.dom.*;
import org.xml.sax.*;
import org.xml.sax.helpers.XMLReaderFactory;
import org.xml.sax.XMLReader;


public class BasicDom {


	public static final int TAG_TYPE_CLASSIC = 1;
	public static final int TAG_TYPE_CONTENT_TAGGED = 2;

	public static Document parseXmlFileWithException(String filename, boolean validating) 
	throws SAXException, IOException, ParserConfigurationException 
	{
		return parseXmlFileWithException(new File(filename), validating);
	}

	public static Document parseXmlFileWithException(File file, boolean validating) 
	throws SAXException, IOException, ParserConfigurationException 
	{

		// Create a builder factory
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setValidating(validating);

		// Create the builder and parse the file
		DocumentBuilder db = factory.newDocumentBuilder();
		db.setErrorHandler(new ErrorHandler() {
			public void fatalError(SAXParseException e) {
				System.out.println(e.getMessage());
			}

			public void error(SAXParseException e) {
				System.out.println(e.getMessage());
			}

			public void warning(SAXParseException e) {
				System.out.println(e.getMessage());
			}
		});
		Document doc = db.parse(file);

		return doc; 

	}

	// Parses an XML file and returns a DOM document.
	// If validating is true, the contents is validated against the DTD
	// specified in the file.
	public static Document parseXmlFile(String filename, boolean validating) {
		try {
			return parseXmlFileWithException(filename,validating);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Parses an XML file and returns a DOM document.
	// If validating is true, the contents is validated against the DTD
	// specified in the file.
	public static Document parseXmlStream(String sXmlStream, boolean validating) throws SAXException, IOException, ParserConfigurationException {
		// Create a builder factory
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		factory.setValidating(validating);
		// Create the builder and parse the file
		Document doc = factory.newDocumentBuilder().parse( new InputSource (new StringReader(sXmlStream) ));
		return doc;

	}


	public static Document parseAndValidateXmlStream(
			String sXmlStream, 
			String sXsdFileName,
			boolean bValidating) throws SAXException, IOException, ParserConfigurationException {
		// Create a builder factory
		DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		SchemaFactory sf = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		Schema xsd = sf.newSchema(new File(sXsdFileName));

		factory.setValidating(bValidating);
		factory.setNamespaceAware(true);
		factory.setSchema(xsd);
		//factory.setFeature("http://apache.org/xml/features/validation/schema", true);
		//factory.setFeature("http://xml.org/sax/features/validation", true);


		DocumentBuilder documentBuilder = factory.newDocumentBuilder();
		//documentBuilder.isetIgnoringLexicalInfo(true); // Skip comments, entity refs, etc.
		StringErrorHandler seh = null;
		if(bValidating) {
			seh = new StringErrorHandler();
			documentBuilder.setErrorHandler(seh);

		}

		// Create the builder and parse the file
		Document doc = documentBuilder.parse( new InputSource (new StringReader(sXmlStream) ));

		if(bValidating && !seh.sFullErrorMessage.equals(""))
		{
			throw new SAXException(seh.sFullErrorMessage);
		}
		return doc;

	}


	public static void  validateFile(String xmlFileName, String xsdFileName) {
		try {
			SchemaFactory sf = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			Schema xsd = sf.newSchema(new File(xsdFileName));

			DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
			dbf.setNamespaceAware(true);
			dbf.setSchema(xsd);

			DocumentBuilder db = dbf.newDocumentBuilder();
			db.parse(xmlFileName);

			System.out.println("\tCe document est valide.");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}



	/*
    	for a node like this
    	<....>xxxx</....>
    	extract xxxx
	 */
	public static String getElementValue(Node node)
	{
		Node n;
		if(node == null) return null;
		n = node.getFirstChild();
		return getNodeToText(n);
	}


	public static String getXML(Node node)
	{
		StringBuffer sb = new StringBuffer("");
		getXML(node, sb);

		return sb.toString();
	}

	public static String getNodeToText(Node node)
	{
		StringBuffer sb = new StringBuffer("");

		if(node == null) return null;

		int type = node.getNodeType();
		switch(type)
		{
		case Node.DOCUMENT_NODE:
		{
			// TODO : DK=> ? WARNING GRAVE !! c'est pas propre du tout !!!!!!!!!!!!!!!
			sb.append("<?xml version=\"1.0\" encoding=\"");
			sb.append("UTF-8");
			sb.append("\"?>\r\n");
			break;                  
		}//end of document
		case Node.ELEMENT_NODE:
		{
			sb.append("<");
			sb.append(node.getNodeName() );

			NamedNodeMap nnm = node.getAttributes();
			if(nnm != null )
			{
				int len = nnm.getLength() ;
				Attr attr;
				for ( int i = 0; i < len; i++ )
				{
					attr = (Attr)nnm.item(i);
					sb.append(" ");
					sb.append(attr.getNodeName());
					sb.append("=\"");
					sb.append(attr.getNodeValue());
					sb.append('"');

				}
			}
			sb.append('>');

			break;

		}//end of element
		case Node.ENTITY_REFERENCE_NODE:
		{

			sb.append('&');
			sb.append(node.getNodeName() );
			sb.append(';');

			break;

		}//end of entity
		case Node.CDATA_SECTION_NODE:
		{
			sb.append("<![CDATA[" );
			sb.append(node.getNodeValue());
			sb.append("]]>" );
			break;       

		}
		case Node.TEXT_NODE:
		{
			sb.append(node.getNodeValue());
			break;
		}
		case Node.PROCESSING_INSTRUCTION_NODE:
		{
			sb.append("<?");
			sb.append(node.getNodeName());

			String data = node.getNodeValue();
			if ( data != null && data.length() > 0 ) {
				sb.append(" ");
				sb.append(data);
			}
			sb.append("?>\r\n");
			break;

		}
		}//end of switch


		return sb.toString();

	}

	public static Node getNextSiblingElementNode(Node node)
	{
		for(Node child = node.getNextSibling(); child != null; child = child.getNextSibling())
		{
			if ( child.getNodeType() == Node.ELEMENT_NODE ) return child;
		}
		return null;
	}	

	public static Node getFirstChildElementNode(Node node)
	{
		for(Node child = node.getFirstChild(); child != null; child = child.getNextSibling())
		{
			if ( child.getNodeType() == Node.ELEMENT_NODE ) return child;
		}
		return null;
	}	

	public static void getXML(Node node, StringBuffer sb)
	{
		int type = node.getNodeType();

		sb.append(getNodeToText(node));

		//recurse
		for(Node child = node.getFirstChild(); child != null; child = child.getNextSibling())
		{
			getXML(child, sb);
		}

		//without this the ending tags will miss
		if ( type == Node.ELEMENT_NODE )
		{
			sb.append("</");
			sb.append(node.getNodeName());
			sb.append(">");
		}

	}

	/**
	 * @return retourne null si non trouvé
	 **/
	public static String findNodeByNodeNameAndGetElementValue (Node node, String sNodeName)
	{

		return getElementValue (
				findNodeByNodeName(node, sNodeName) );
	}

	/**
	 * A Utiliser pour les champs optionnels à remplir par des "" si le champ n'est pas trouvé
	 * @param node
	 * @param sNodeName
	 * @return
	 * @throws Exception
	 */
	public static String getChildNodeValueByNodeNameOptional(Node node, String sNodeName) 
	{
		try {
			return getElementValue(getChildNodeByNodeName(node, sNodeName));		
		} catch (Exception e) {

		}
		return "";
	} 

	public static String getChildNodeValueTextByNodeName(
			Node node, 
			String sNodeName) 
	throws SAXException
	{
		Node n = getChildNodeByNodeName(node, sNodeName).getFirstChild();
		return n.getNodeValue();
	}

	public static String getChildNodeValueByNodeName(Node node, String sNodeName) throws SAXException
	{
		return getElementValue(getChildNodeByNodeName(node, sNodeName));
	}
	
	public static String getChildNodeAttributeValueByAttributeName(Node node, String sAttributeName) throws SAXException
	{
		NamedNodeMap attr = node.getAttributes();
		return getNamedAttributeStringValueIso_8859_1(attr, sAttributeName);
	}

	public static double getChildNodeValueDoubleByNodeName(Node node, String sNodeName) throws SAXException
	{
		return Double.parseDouble(getChildNodeValueByNodeName(node, sNodeName));
	}

	public static Node getChildNodeByNodeName(Node node, String sNodeName) 
	throws SAXException 
	{
		Node n = getChildNodeByNodeNameOrNull(node, sNodeName);
		if(n == null) throw new SAXException("Element non trouvé : '" + sNodeName + "' à partir de '" + node.getNodeName() + "'" );

		return n;
	}
	
	/**
	 * 
	 * @param node
	 * @param sNodeName
	 * @return Renvoi une Exception si élément non trouvé.
	 * @throws SAXException 
	 * @throws Exception 
	 */
	public static Node getChildNodeByNodeNameOrNull(Node node, String sNodeName) 
	throws SAXException 

	{
		if(node == null)
		{
			throw new SAXException("Element non trouvé : '" + sNodeName + "' à partir d'un noeud NULL " );
		}
		for(Node child = getFirstChildElementNode(node); child != null; child = child.getNextSibling())
		{
			int type = child .getNodeType();

			if ( type == Node.ELEMENT_NODE )
			{
				if (sNodeName.equals(child .getNodeName()))
				{
					return child ;
				}	
			}
		}
		return null;

	}

	/**
	 * format yyyy-MM-dd HH:mm:ss
	 * 
	 * @param node
	 * @param sNodeName
	 * @return
	 * @throws SAXException
	 */
	public static Timestamp getChildNodeValueXmlDateStampByNodeName(Node node, String sNodeName) throws SAXException
	{
		String sValue = getChildNodeValueByNodeName(node, sNodeName);
		sValue = sValue.replaceAll("T", " ");
		return CalendarUtil.getConversionTimestamp(sValue , "yyyy-MM-dd HH:mm:ss");
	}
	
	/**
	 * format dd/MM/yyyy HH:mm:ss
	 * 
	 * @param node
	 * @param sNodeName
	 * @return
	 * @throws SAXException
	 */
	public static Timestamp getChildNodeValueXmlDateStampFrenchByNodeName(Node node, String sNodeName) throws SAXException
	{
		String sValue = getChildNodeValueByNodeName(node, sNodeName);
		sValue = sValue.replaceAll("T", " ");
		return CalendarUtil.getConversionTimestamp(sValue , "dd/MM/yyyy HH:mm:ss");
	}

	public static Node findNodeByNodeName(Node node, String sNodeName)
	{
		Node nodeFind = null;
		int type = node.getNodeType();

		if ( type == Node.ELEMENT_NODE )
		{
			if (sNodeName.equals(node.getNodeName()))
			{
				// le noeud a été trouvé 
				// on remonte l'arbre

				return node;
			}	
		}


		//recurse
		for(Node child = node.getFirstChild(); child != null; child = child.getNextSibling())
		{
			nodeFind = findNodeByNodeName(child , sNodeName);

			if(nodeFind != null)
			{
				// le noeud a été trouvé chez un prédécesseur
				// on remonte l'arbre
				return nodeFind;
			}

		}

		return nodeFind;
	}

	/**
	 * 
	 * si sNodeName = null alors on ne recherche qu'à partir du nom de l'attribut
	 * 
	 * @param node
	 * @param sNodeName
	 * @param sNodeAttributeName
	 * @param sNodeAttributeValue
	 * @return
	 */
	public static Node findNodeByNodeAttribute(
			Node node, 
			String sNodeName,
			String sNodeAttributeName,
			String sNodeAttributeValue)
	{
		Node nodeFind = null;
		int type = node.getNodeType();

		if ( type == Node.ELEMENT_NODE )
		{
			NamedNodeMap attribs = node.getAttributes();
			Node attrib = attribs.getNamedItem(sNodeAttributeName);
			
			if (sNodeName == null || sNodeName.equals(node.getNodeName())){
				if (attrib != null && attrib.getNodeValue().equals(sNodeAttributeValue))
				{
					// le noeud a été trouvé 
					// on remonte l'arbre

					return node;
				}	
			}
		}


		//recurse
		for(Node child = node.getFirstChild(); child != null; child = child.getNextSibling())
		{
			nodeFind = findNodeByNodeAttribute(child , sNodeName, sNodeAttributeName, sNodeAttributeValue);

			if(nodeFind != null)
			{
				// le noeud a été trouvé chez un prédécesseur
				// on remonte l'arbre
				return nodeFind;
			}

		}

		return nodeFind;
	}

	
	/**
	 * Permet de retrouver des chaines de caractères dans un texte puis de les remplacer
	 * par une autre chaine de caractères
	 * @param str - texte où chercher la chaine de caractère
	 * @param pattern - chaine à remplacer
	 * @param replace - chaine remplaçante
	 * @return le texte mis à niveau
	 */
	public static /*synchronized*/ String replaceAll(String str, String pattern, String replace) { 
		StringBuffer lSb = new StringBuffer(); 
		if ((str != null) && (pattern != null) && (pattern.length() > 0) && (replace != null)) { 
			int i = 0;  
			int j = str.indexOf(pattern, i); 
			int l = pattern.length(); 
			int m = str.length(); 
			if (j > -1) { 
				while (j > -1) {      
					if (i != j) { 
						lSb.append(str.substring(i, j));  
					} 
					lSb.append(replace);         
					i = j + l; 
					j = (i > m) ? -1 : str.indexOf(pattern, i); 
				} 
				if (i < m) { 
					lSb.append(str.substring(i)); 
				} 
			} 
			else { 
				lSb.append(str); 
			} 
		} 
		return lSb.toString(); 
	}


	public static void validate(String sXmlFile, String sXsdFile) { 

		try {

			XMLReader xerces = 
				XMLReaderFactory.createXMLReader("org.apache.xerces.parsers.SAXParser");

			xerces.setFeature("http://xml.org/sax/features/validation",true);
			xerces.setFeature("http://apache.org/xml/features/validation/schema", true);
			xerces.setFeature("http://apache.org/xml/features/validation/schema-full-checking",true);
			xerces.setFeature("http://apache.org/xml/features/standard-uri-conformant", true);

			xerces.setProperty(
					"http://apache.org/xml/properties/schema/external-schemaLocation",
			"http://my.example.org/ http://my.example.org/translation.xsd");
			xerces.setProperty(
					"http://apache.org/xml/properties/schema/external-schemaLocation",
			"http://my.example.org/ http://my.example.org/item.xsd");

			xerces.parse(sXmlFile);


		}catch (Exception e) {}

	}

	// Valable uniquement avec la version 1.5 du sdk.

	public static void revalidate(String sXmlFile, String sXsdFile) throws ParserConfigurationException, SAXException, IOException { 

		// parse an XML document into a DOM tree
		DocumentBuilder parser = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		Document document = parser.parse(new InputSource (new StringReader(sXmlFile) ));

		// create a SchemaFactory capable of understanding WXS schemas
		SchemaFactory factory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		factory.setErrorHandler(new ErrorHandler() {
			public void fatalError(SAXParseException e) {
				System.out
				.println("Erreur de validation XSD - Erreur fatal");
			}

			public void error(SAXParseException e) {
				System.out.println("Erreur de validation XSD - Erreur");
			}

			public void warning(SAXParseException e) {
				System.out.println("Erreur de validation XSD - Warning");
			}
		});

		// load a WXS schema, represented by a Schema instance

		System.out.println("totot0"); 
		InputSource sourceentree = new InputSource("c:\\_dev\\_sources\\modula_wtp\\JavaSource\\modula\\ws\\boamp\\schemas\\jo_boamp.xsd");
		System.out.println("totot1");
		SAXSource sourceXSD  = new SAXSource(sourceentree);

		Schema schema = factory.newSchema(sourceXSD);
		//  Schema schema = factory.newSchema(schemaFile);

		// create a Validator instance, which can be used to validate an instance document
		Validator validator = schema.newValidator();
		// validate the DOM tree
		try {
			validator.validate(new DOMSource(document)); 
		} catch (SAXException e) {
			System.out.println("instance document is invalid!");
		}

	}
	
	public static int getNamedAttributeIntValue(NamedNodeMap attribs, String sAttributeName)
	{
		return Integer.parseInt(getNamedAttributeStringValueIso_8859_1(attribs, sAttributeName));
	}	

	public static String getNamedAttributeStringValueIso_8859_1(NamedNodeMap attribs, String sAttributeName)
	{
		String sValue = "";
		Node attrib ;
		attrib =  attribs.getNamedItem(sAttributeName);

		if(attrib != null) sValue = attrib.getNodeValue();

		return sValue ;
	}

	public static String getNamedAttributeStringValueIso_8859_1ThrowException(NamedNodeMap attribs, String sAttributeName)
	{
		String sValue = "";
		Node attrib ;
		attrib =  attribs.getNamedItem(sAttributeName);

		if(attrib != null) sValue = attrib.getNodeValue();
		else throw new NullPointerException();

		return sValue ;
	}

	public static final String getXMLNode(String sNodeName,String sContent,int iTagType)
	{

		String sTag = "";
		switch (iTagType) {
		case BasicDom.TAG_TYPE_CLASSIC:
			sTag = "<" + sNodeName + ">" + sContent + "</" + sNodeName + ">\n";
			break;

		case BasicDom.TAG_TYPE_CONTENT_TAGGED:
			sTag = "<" + sNodeName + "><" + sContent + "/></" + sNodeName + ">\n";
			break;

		default:
			sTag = "<" + sNodeName + ">" + sContent + "</" + sNodeName + ">\n";
		break;
		}

		return PreventInjection.preventXML(sTag);
	}

}
