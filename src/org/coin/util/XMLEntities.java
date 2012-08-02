package org.coin.util;

import java.util.Hashtable;

public class XMLEntities {
	
	
	/**
	 * 
	 * n 1.1.7, the default encoding on Windows changed from 8859_1 to cp1252. In the new default encoding, 
	 * 32 characters from 128 to 159 are mapped to characters higher in the Unicode character set. For 
	 * instance, 128 is reserved for the Euro character which is 0x20AC in Unicode. Conversions between 
	 * bytes and chars result in changes in value of these reserved characters. This is the expected behavior.
	 * @see http://www.table-ascii.com/
	 * 
	 */
	private static final Object[][] xml_entities_table = {
		{ new Integer(38), new String("&amp;") },
		{ new Integer(128), new String("€") },
		{ new Integer(8364), new String("€") },
		};
	
	private static final Object[][] xml_entities_table_content_node = {
		{ new Integer(60), new String("&#60;") },
		{ new Integer(62), new String("&#62;") }
		};
	
	private static final Hashtable<Integer,String> xmlentities_map = new Hashtable<Integer,String>();
	private static final Hashtable<Integer,String> xmlentities_content_map = new Hashtable<Integer,String>();
	
	
	public XMLEntities() {
		initializeEntitiesTables();
		initializeEntitiesContentTables();
	}
	
	private static void initializeEntitiesTables() {
		Object[][] oEntitiesTable = xml_entities_table;
		// initialize html translation maps
		for (int i = 0; i < oEntitiesTable.length; ++i) {
			xmlentities_map.put(
					(Integer)oEntitiesTable[i][0],
					(String)oEntitiesTable[i][1]);
		}
	}
	
	private static void initializeEntitiesContentTables() {
		Object[][] oEntitiesTable = xml_entities_table_content_node;
		// initialize html translation maps
		for (int i = 0; i < oEntitiesTable.length; ++i) {
			xmlentities_content_map.put(
					(Integer)oEntitiesTable[i][0],
					(String)oEntitiesTable[i][1]);
		}
	}
	
	
	/**
	 * Convert special and extended characters into HTML entitities.
	 * @param str input string
	 * @return formatted string
	 */
	public static String cleanUpXMLEntities(String str,Hashtable<Integer,String> map ) {
		if (str == null) {
			return "";
		}
		//initialize html translation maps table the first time is called
		if (map.isEmpty()) {
			initializeEntitiesTables();
			initializeEntitiesContentTables();
		}
		
		StringBuffer buf = new StringBuffer(); //the otput string buffer
		for (int i = 0; i < str.length(); ++i) {
			char ch = str.charAt(i);
			//System.out.println(((int) ch)+" => "+ch+" ==> "+ xmlentities_map.get(new Integer(ch)));
			String entity = map.get(new Integer(ch)); //get equivalent windows entity
			if (entity == null) { //if entity has not been found
				buf.append(ch); //append the character as is
			} else {
				buf.append(entity); //append the html entity
			}
		}
		return buf.toString();
	}
	
	public static String cleanUpXMLEntities(String str) {
		return cleanUpXMLEntities(str, xmlentities_map);
	}
	
	public static String cleanUpXMLContentEntities(String str) {
		return cleanUpXMLEntities(str, xmlentities_content_map);
	}
	
	public static void main(String[] args) {
		//‚ƒ„…†‡ˆ‰Š‹Œ‘’“”•–—˜™š›œŸ«»
		System.out.println(cleanUpXMLEntities("héhé & C’est moi < > « cœur ! »… "));
	}
	
}