package org.coin.util;

import java.util.Hashtable;

/**
 * R�f�rence tous les caract�res Word ou Windows incompatibles et les remplaces par des chaines 
 * de caract�res ressemblants.
 * Plus d'infos sur http://www.cs.tut.fi/~jkorpela/www/windows-chars.html
 * @author Fran�ois
 *
 */

public class WindowsEntities {
	
	private static final Object[][] windows_entities_table = {
		// 1) Liste des caract�res d�tectables dans la couche Java
		// caract�re [ � ]
		{ new Integer(8218), new String(",") },
		// caract�re [ � ]
		{ new Integer(402), new String("f") },
		// caract�re [ � ]
		{ new Integer(8222), new String(",,") },
		// caract�re [ � ]
		{ new Integer(8230), new String("...") },
		// caract�re [ � ]
		{ new Integer(8224), new String("+") },
		// caract�re [ � ]
		{ new Integer(8225), new String("+") },
		// caract�re [ � ]
		{ new Integer(710), new String("^") },
		// caract�re [ � ]
		{ new Integer(8240), new String("%.") },
		// caract�re [ � ]
		{ new Integer(352), new String("S") },
		// caract�re [ � ]
		{ new Integer(8249), new String("<") },
		// caract�re [ � ]
		{ new Integer(338), new String("OE") },
		// caract�re [ � ]
		{ new Integer(8216), new String("'") },
		// caract�re [ � ]
		{ new Integer(8217), new String("'") },
		// caract�re [ � ]
		{ new Integer(8220), new String("\"") },
		// caract�re [ � ]
		{ new Integer(8221), new String("\"") },
		// caract�re [ � ]
		{ new Integer(8226), new String(".") },
		// caract�re [ � ]
		{ new Integer(8211), new String("-") },
		// caract�re [ � ]
		{ new Integer(8212), new String("-") },
		// caract�re [ � ]
		{ new Integer(732), new String("~") },
		// caract�re [ � ]
		{ new Integer(8482), new String("TM") },
		// caract�re [ � ]
		{ new Integer(353), new String("s") },
		// caract�re [ � ]
		{ new Integer(8250), new String(">") },
		// caract�re [ � ]
		{ new Integer(339), new String("oe") },
		// caract�re [ � ]
		{ new Integer(376), new String("Y") },
		// caract�re [ � ]
		{ new Integer(171), new String("\"") },
		// caract�re [ � ]
		{ new Integer(187), new String("\"") },
		
		// 2) Liste des caract�res d�tectables dans la couche JSP
		
		// caract�re [ � ]
		{ new Integer(130), new String(",") },
		// caract�re [ � ]
		{ new Integer(131), new String("f") },
		// caract�re [ � ]
		{ new Integer(132), new String(",,") },
		// caract�re [ � ]
		{ new Integer(133), new String("...") },
		// caract�re [ � ]
		{ new Integer(134), new String("+") },
		// caract�re [ � ]
		{ new Integer(135), new String("+") },
		// caract�re [ � ]
		{ new Integer(136), new String("^") },
		// caract�re [ � ]
		{ new Integer(137), new String("%.") },
		// caract�re [ � ]
		{ new Integer(138), new String("S") },
		// caract�re [ � ]
		{ new Integer(139), new String("<") },
		// caract�re [ � ]
		{ new Integer(140), new String("OE") },
		// caract�re [ � ]
		{ new Integer(39), new String("'") },
		// caract�re [ � ]
		{ new Integer(39), new String("'") },
		// caract�re [ � ]
		{ new Integer(34), new String("\"") },
		// caract�re [ � ]
		{ new Integer(34), new String("\"") },
		// caract�re [ � ]
		{ new Integer(149), new String(".") },
		// caract�re [ � ]
		{ new Integer(150), new String("-") },
		// caract�re [ � ]
		{ new Integer(151), new String("-") },
		// caract�re [ � ]
		{ new Integer(152), new String("~") },
		// caract�re [ � ]
		{ new Integer(153), new String("TM") },
		// caract�re [ � ]
		{ new Integer(154), new String("s") },
		// caract�re [ � ]
		{ new Integer(155), new String(">") },
		// caract�re [ � ]
		{ new Integer(156), new String("oe") },
		// caract�re [ � ]
		{ new Integer(159), new String("Y") },
		// caract�re [ � ]
		{ new Integer(171), new String("\"") },
		// caract�re [ � ]
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
		//��������������������������
		//cleanUpWindowsEntities("C�est moi � c�ur ! �� ");
	}
	*/
}