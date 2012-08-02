package org.coin.util;

import java.util.Hashtable;

/**
 * Référence tous les caractères Word ou Windows incompatibles et les remplaces par des chaines 
 * de caractères ressemblants.
 * Plus d'infos sur http://www.cs.tut.fi/~jkorpela/www/windows-chars.html
 * @author François
 *
 */

public class WindowsEntities {
	
	private static final Object[][] windows_entities_table = {
		// 1) Liste des caractères détectables dans la couche Java
		// caractère [ ‚ ]
		{ new Integer(8218), new String(",") },
		// caractère [ ƒ ]
		{ new Integer(402), new String("f") },
		// caractère [ „ ]
		{ new Integer(8222), new String(",,") },
		// caractère [ … ]
		{ new Integer(8230), new String("...") },
		// caractère [ † ]
		{ new Integer(8224), new String("+") },
		// caractère [ ‡ ]
		{ new Integer(8225), new String("+") },
		// caractère [ ˆ ]
		{ new Integer(710), new String("^") },
		// caractère [ ‰ ]
		{ new Integer(8240), new String("%.") },
		// caractère [ Š ]
		{ new Integer(352), new String("S") },
		// caractère [ ‹ ]
		{ new Integer(8249), new String("<") },
		// caractère [ Œ ]
		{ new Integer(338), new String("OE") },
		// caractère [ ‘ ]
		{ new Integer(8216), new String("'") },
		// caractère [ ’ ]
		{ new Integer(8217), new String("'") },
		// caractère [ “ ]
		{ new Integer(8220), new String("\"") },
		// caractère [ ” ]
		{ new Integer(8221), new String("\"") },
		// caractère [ • ]
		{ new Integer(8226), new String(".") },
		// caractère [ – ]
		{ new Integer(8211), new String("-") },
		// caractère [ — ]
		{ new Integer(8212), new String("-") },
		// caractère [ ˜ ]
		{ new Integer(732), new String("~") },
		// caractère [ ™ ]
		{ new Integer(8482), new String("TM") },
		// caractère [ š ]
		{ new Integer(353), new String("s") },
		// caractère [ › ]
		{ new Integer(8250), new String(">") },
		// caractère [ œ ]
		{ new Integer(339), new String("oe") },
		// caractère [ Ÿ ]
		{ new Integer(376), new String("Y") },
		// caractère [ « ]
		{ new Integer(171), new String("\"") },
		// caractère [ » ]
		{ new Integer(187), new String("\"") },
		
		// 2) Liste des caractères détectables dans la couche JSP
		
		// caractère [ ‚ ]
		{ new Integer(130), new String(",") },
		// caractère [ ƒ ]
		{ new Integer(131), new String("f") },
		// caractère [ „ ]
		{ new Integer(132), new String(",,") },
		// caractère [ … ]
		{ new Integer(133), new String("...") },
		// caractère [ † ]
		{ new Integer(134), new String("+") },
		// caractère [ ‡ ]
		{ new Integer(135), new String("+") },
		// caractère [ ˆ ]
		{ new Integer(136), new String("^") },
		// caractère [ ‰ ]
		{ new Integer(137), new String("%.") },
		// caractère [ Š ]
		{ new Integer(138), new String("S") },
		// caractère [ ‹ ]
		{ new Integer(139), new String("<") },
		// caractère [ Œ ]
		{ new Integer(140), new String("OE") },
		// caractère [ ‘ ]
		{ new Integer(39), new String("'") },
		// caractère [ ’ ]
		{ new Integer(39), new String("'") },
		// caractère [ “ ]
		{ new Integer(34), new String("\"") },
		// caractère [ ” ]
		{ new Integer(34), new String("\"") },
		// caractère [ • ]
		{ new Integer(149), new String(".") },
		// caractère [ – ]
		{ new Integer(150), new String("-") },
		// caractère [ — ]
		{ new Integer(151), new String("-") },
		// caractère [ ˜ ]
		{ new Integer(152), new String("~") },
		// caractère [ ™ ]
		{ new Integer(153), new String("TM") },
		// caractère [ š ]
		{ new Integer(154), new String("s") },
		// caractère [ › ]
		{ new Integer(155), new String(">") },
		// caractère [ œ ]
		{ new Integer(156), new String("oe") },
		// caractère [ Ÿ ]
		{ new Integer(159), new String("Y") },
		// caractère [ « ]
		{ new Integer(171), new String("\"") },
		// caractère [ » ]
		{ new Integer(187), new String("\"") }
		};
	
	private static final Hashtable<Integer,String> windowsentities_map = new Hashtable<Integer,String>();
		
	
	public WindowsEntities() {
		initializeEntitiesTables();
	}
	
	private static void initializeEntitiesTables() {
		Object[][] oEntitiesTable = windows_entities_table;
		// initialize html translation maps
		for (int i = 0; i < oEntitiesTable.length; ++i) {
			windowsentities_map.put(
					(Integer)oEntitiesTable[i][0],
					(String)oEntitiesTable[i][1]);
		}
	}
	
	
	/**
	 * Convert special and extended characters into HTML entitities.
	 * @param str input string
	 * @return formatted string
	 */
	public static String cleanUpWindowsEntities(String str) {
		if (str == null) {
			return "";
		}
		//initialize html translation maps table the first time is called
		if (windowsentities_map.isEmpty()) {
			initializeEntitiesTables();
		}
		
		StringBuffer buf = new StringBuffer(); //the otput string buffer
		for (int i = 0; i < str.length(); ++i) {
			char ch = str.charAt(i);
			//System.out.println(((int) ch)+" => "+ch+" ==> "+windowsentities_map.get(new Integer(ch)));
			String entity = windowsentities_map.get(new Integer(ch)); //get equivalent windows entity
			if (entity == null) { //if entity has not been found
				buf.append(ch); //append the character as is
			} else {
				buf.append(entity); //append the html entity
			}
		}
		return buf.toString();
	}
	/*
	public static void main(String[] args) {
		//‚ƒ„…†‡ˆ‰Š‹Œ‘’“”•–—˜™š›œŸ«»
		//cleanUpWindowsEntities("C’est moi « cœur ! »… ");
	}
	*/
}