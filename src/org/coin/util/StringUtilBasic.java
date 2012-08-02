package org.coin.util;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * basic class without using additionnal lib (mandatory for applet like JavaLibInstallationApplet.java
 */
public class StringUtilBasic {
	
    private static final Vector<String> getAccentuatedCharMap(){
        Vector<String> Result = new Vector<String>();
        String car  = null;
       
        car = new String("A");
        Result.add( car );            /* '\u00C0'   �   alt-0192  */ 
        Result.add( car );            /* '\u00C1'   �   alt-0193  */
        Result.add( car );            /* '\u00C2'   �   alt-0194  */
        Result.add( car );            /* '\u00C3'   �   alt-0195  */
        Result.add( car );            /* '\u00C4'   �   alt-0196  */
        Result.add( car );            /* '\u00C5'   �   alt-0197  */
        car = new String("AE");
        Result.add( car );            /* '\u00C6'   �   alt-0198  */
        car = new String("C");
        Result.add( car );            /* '\u00C7'   �   alt-0199  */
        car = new String("E");
        Result.add( car );            /* '\u00C8'   �   alt-0200  */
        Result.add( car );            /* '\u00C9'   �   alt-0201  */
        Result.add( car );            /* '\u00CA'   �   alt-0202  */
        Result.add( car );            /* '\u00CB'   �   alt-0203  */
        car = new String("I");
        Result.add( car );            /* '\u00CC'   �   alt-0204  */
        Result.add( car );            /* '\u00CD'   �   alt-0205  */
        Result.add( car );            /* '\u00CE'   �   alt-0206  */
        Result.add( car );            /* '\u00CF'   �   alt-0207  */
        car = new String("D");
        Result.add( car );            /* '\u00D0'   �   alt-0208  */
        car = new String("N");
        Result.add( car );            /* '\u00D1'   �   alt-0209  */
        car = new String("O");
        Result.add( car );            /* '\u00D2'   �   alt-0210  */
        Result.add( car );            /* '\u00D3'   �   alt-0211  */
        Result.add( car );            /* '\u00D4'   �   alt-0212  */
        Result.add( car );            /* '\u00D5'   �   alt-0213  */
        Result.add( car );            /* '\u00D6'   �   alt-0214  */
        car = new String("*");
        Result.add( car );            /* '\u00D7'   �   alt-0215  */
        car = new String("0");
        Result.add( car );            /* '\u00D8'   �   alt-0216  */
        car = new String("U");
        Result.add( car );            /* '\u00D9'   �   alt-0217  */
        Result.add( car );            /* '\u00DA'   �   alt-0218  */
        Result.add( car );            /* '\u00DB'   �   alt-0219  */
        Result.add( car );            /* '\u00DC'   �   alt-0220  */
        car = new String("Y");
        Result.add( car );            /* '\u00DD'   �   alt-0221  */
        car = new String("�");
        Result.add( car );            /* '\u00DE'   �   alt-0222  */
        car = new String("B");
        Result.add( car );            /* '\u00DF'   �   alt-0223  */
        car = new String("a");
        Result.add( car );            /* '\u00E0'   �   alt-0224  */
        Result.add( car );            /* '\u00E1'   �   alt-0225  */
        Result.add( car );            /* '\u00E2'   �   alt-0226  */
        Result.add( car );            /* '\u00E3'   �   alt-0227  */
        Result.add( car );            /* '\u00E4'   �   alt-0228  */
        Result.add( car );            /* '\u00E5'   �   alt-0229  */
        car = new String("ae");
        Result.add( car );            /* '\u00E6'   �   alt-0230  */
        car = new String("c");
        Result.add( car );            /* '\u00E7'   �   alt-0231  */
        car = new String("e");
        Result.add( car );            /* '\u00E8'   �   alt-0232  */
        Result.add( car );            /* '\u00E9'   �   alt-0233  */
        Result.add( car );            /* '\u00EA'   �   alt-0234  */
        Result.add( car );            /* '\u00EB'   �   alt-0235  */
        car = new String("i");
        Result.add( car );            /* '\u00EC'   �   alt-0236  */
        Result.add( car );            /* '\u00ED'   �   alt-0237  */
        Result.add( car );            /* '\u00EE'   �   alt-0238  */
        Result.add( car );            /* '\u00EF'   �   alt-0239  */
        car = new String("d");
        Result.add( car );            /* '\u00F0'   �   alt-0240  */
        car = new String("n");
        Result.add( car );            /* '\u00F1'   �   alt-0241  */
        car = new String("o");
        Result.add( car );            /* '\u00F2'   �   alt-0242  */
        Result.add( car );            /* '\u00F3'   �   alt-0243  */
        Result.add( car );            /* '\u00F4'   �   alt-0244  */
        Result.add( car );            /* '\u00F5'   �   alt-0245  */
        Result.add( car );            /* '\u00F6'   �   alt-0246  */
        car = new String("/");
        Result.add( car );            /* '\u00F7'   �   alt-0247  */
        car = new String("0");
        Result.add( car );            /* '\u00F8'   �   alt-0248  */
        car = new String("u");
        Result.add( car );            /* '\u00F9'   �   alt-0249  */
        Result.add( car );            /* '\u00FA'   �   alt-0250  */
        Result.add( car );            /* '\u00FB'   �   alt-0251  */
        Result.add( car );            /* '\u00FC'   �   alt-0252  */
        car = new String("y");
        Result.add( car );            /* '\u00FD'   �   alt-0253  */
        car = new String("�");
        Result.add( car );            /* '\u00FE'   �   alt-0254  */
        car = new String("y");
        Result.add( car );            /* '\u00FF'   �   alt-0255  */
        Result.add( car );            /* '\u00FF'       alt-0255  */
       
        return Result;
     }

    public static final String stripAccents(
 		   String sText)
    {
    	return stripAccents(sText, false);
    }	
    /**
     * 
     * @param sText
     * @return a String without accentuated characters
     */
   public static final String stripAccents(
		   String sText,
		   boolean bForceAscii)
   {
	   int iMinCharAccent = 192; // First accent char index
	   int iMaxCharAccent = 255; // Last accent char index
	   Vector<String> vMap = getAccentuatedCharMap();
	   StringBuffer sResult = new StringBuffer(sText);
	   for(int i=0;i<sResult.length();i++){
		   int iCharValue = sText.charAt(i);
		   if (iCharValue >= iMinCharAccent 
			&& iCharValue <= iMaxCharAccent) 
		   {
			   sResult.replace(i, i+1, (String) vMap.get(iCharValue-iMinCharAccent));
		   }
		   
		   if(bForceAscii && iCharValue > iMaxCharAccent)
		   {
			   sResult.replace(i, i+1, "_");
		   }
	   }
	   return sResult.toString();
   }

	
	/**
	 * Permet de retrouver des chaines de caract�res dans un texte puis de les remplacer
	 * par une autre chaine de caract�res
	 * @param str - texte o� chercher la chaine de caract�re
	 * @param pattern - chaine � remplacer
	 * @param replace - chaine rempla�ante
	 * @return le texte mis � niveau
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
	
	public static String reverseString(String source) {
		int i, len = source.length();
		StringBuffer dest = new StringBuffer(len);

		for (i = (len - 1); i >= 0; i--)
			dest.append(source.charAt(i));
		return dest.toString();
	}


	public static float round (float fValeur){
		  return ((float)Math.round((double)fValeur*100)/100); 
	}
	
	public static float round (float fValeur, int precision){
		  return ((float)Math.round((double)fValeur*(100*precision))/(100*precision)); 
	}
	
    public static final boolean equalsZero(String sValue)
    {
    	if((int)Float.parseFloat(sValue) == 0)
    		return true;
    	
    	return false;
    }


    
    


    public static final boolean equalsString(
        	String sItemA,
        	String sItemB)
    {
    	if(sItemA == null && sItemB == null){
    		return true;
    	}
    	
    	return sItemA.equals(sItemB);
    }

    public static final boolean equalsTimestamp(
    	Timestamp tsItemA,
    	Timestamp tsItemB)
    {
    	boolean bEquals = true; 
    	if(tsItemA == null && tsItemB == null){
    		return true;
    	}
    	
    	if(tsItemA != null && tsItemB != null){
			if(!tsItemA.equals(tsItemB)) bEquals = false;
		} else {
			bEquals = false;
		}
    	
    	return bEquals;
    }

    
    public static final boolean isNullOrBlank(String sValue)
    {
    	if( sValue == null || sValue.equalsIgnoreCase("") || sValue.equalsIgnoreCase("null") || sValue.equalsIgnoreCase("undefined"))
    		return true;
    	
    	return false;
    }

    public static final boolean isNullOrOnlyBlank(String sValue)
    {
    	sValue = removeAllSpaces(sValue);
    	return isNullOrBlank(sValue);
    }
    
    public static final boolean isNullOrBlank(Object oValue)
    {
    	return isNullOrBlank(oValue+"");
    }
    
    public static String removeAllSpaces(String s){
    	s = replaceAll(s, " ", "");
    	s = replaceAll(s, "&nbsp;", "");
    	
    	/* on recree la chaine en ne prenant pas en compte ces espaces */
    	String returnString = "";
    	for(int i=0; i<s.length(); i++){
    		char c = s.charAt(i);
    		switch( c ){
    		case 32 :
    		case 160 :
    			returnString += ""; 
    			break;
    		default:
    			returnString += String.valueOf(c);
    			break;
    		}
    	}
    	
    	return returnString;
    }

    
    public static final boolean isNull(String sValue)
    {
    	if( sValue == null || sValue.equalsIgnoreCase("null") || sValue.equalsIgnoreCase("undefined"))
    		return true;
    	
    	return false;
    }
    
    public static final boolean isInteger(Object oValue)
    {
    	boolean bIsNumber = false;
    	try{
    		String sValue = ""+oValue;
    		Integer.parseInt(sValue);
    		bIsNumber = true;
    	}catch(Exception e){bIsNumber = false;}
    	return bIsNumber;
    }
    
    public static final boolean isIntegerPositive(Object oValue)
    {
    	boolean bIsNumber = false;
    	try{
    		String sValue = ""+oValue;
    		int iValue = Integer.parseInt(sValue);
    		if(iValue>0) 
    			bIsNumber = true;
    	}catch(Exception e){bIsNumber = false;}
    	return bIsNumber;
    }
    
    public static final boolean isIntegerZero(Object oValue)
    {
    	boolean bIsNumber = false;
    	try{
    		String sValue = ""+oValue;
    		int iValue = Integer.parseInt(sValue);
    		if(iValue == 0) 
    			bIsNumber = true;
    	}catch(Exception e){bIsNumber = false;}
    	return bIsNumber;
    }
  
    public static final String getStringNotNullNeant(String sValue)
    {
    	return getString(sValue, "N�ant");
    }
    
    public static final String getStringNotNull(String sValue)
    {
    	return getString(sValue, "");
    }
    
    public static final String getString(String sValue, String sReplaceNull)
    {
    	return sValue==null?sReplaceNull:sValue;
    }
    
    
    
    public static final String getTextBetweenOptional(String sText, String sStart, String sEnd)
    {
    	return getTextBetweenOptional(sText, sStart, sEnd, 0);
    }
    
    public static final String getTextBetweenOptional(
    		String sText, 
    		String sStart, 
    		String sEnd,
    		int iStartIndex)
    {
    	if(sText == null ) return ""; 
    	
    	int iStart =  sText.indexOf(sStart, iStartIndex);
    	int iEnd =  sText.indexOf(sEnd, iStart);
    	try {
    		return sText.substring(iStart+ sStart.length(), iEnd);
    	} catch (Exception e) {
			return "";
		}
    }
    
    public static final Vector<String> getAllTextBetweenOptional(String sText, String sStart, String sEnd)
    {
    	Vector<String> vSearch = new Vector<String>();
		Pattern CRLF = Pattern.compile(sStart+"(.*?)"+sEnd);
		Matcher m = CRLF.matcher(sText);
		
		while (m.find()) 
		{
			vSearch.add(m.group());
		}
		return vSearch;
    }

    public static final String getTextBetweenOptionalNewLine(String sText, String sStart){
    	return  getTextBetweenOptional(sText, sStart, "\n");
    	
    }

	public static String toString(String[] arr) 
	{
		return toString(arr, "\"");
	}
	
	public static String toString(String[] arr, String sDelimiter) {
		String str = "["; 
		boolean bFirst = true;
		for (String s : arr) {
			if (bFirst)
			{
				bFirst = false;
			} else {
				str += ",";
			}
			
			str += sDelimiter + s + sDelimiter;
		}
		str += "]";
		return str;
	}

	public static String toString(
			long[] arr) 
	{
		return toString(arr, true);
	}
	
	public static String toString(
			long[] arr,
			boolean bUseDelimiter) 
	{
		String str = "["; 
		boolean bFirst = true;
		for (long l : arr) {
			if (bFirst)
			{
				bFirst = false;
			} else {
				str += ",";
			}
			
			str += bUseDelimiter?("\"" + l + "\"") : "" + l;
		}
		str += "]";
		return str;
	}

	public static String toString(
			Long[] arr,
			boolean bUseDelimiter) 
	{
		return toString(arr, bUseDelimiter, true);
	}
	
	public static String toString(
			Long[] arr,
			boolean bUseDelimiter,
			boolean bUseBraket) 
	{
		String str = null;
		if(bUseBraket) str = "[";
		else str = "";
		boolean bFirst = true;
		for (long l : arr) {
			if (bFirst)
			{
				bFirst = false;
			} else {
				str += ",";
			}
			
			str += bUseDelimiter?("\"" + l + "\"") : "" + l;
		}
		if(bUseBraket) str += "]";
		return str;
	}

	

	public static long[] toArray(ArrayList<Long> sarr) {
		long[] l = new long[sarr.size()];
		for (int i=0;i<sarr.size();i++) {
			l[i] = sarr.get(i);
		}
		return l;
	}

	
	/**
	 * convert a String [x,y,..,z] to an array of long
	 * 
	 * @param sarr
	 * @return
	 */
	public static long[] toArray(String sarr) 
	{
		return toArray(sarr, true);
	}
	
	public static long[] toArray(
			String sarr,
			boolean bUseBraket) 
	{
		/**
		 * remove brakets
		 */
		if(Outils.isNullOrBlank(sarr)) return new long[0];
		String  s = sarr;
		if(bUseBraket) s = sarr.substring(1, sarr.length() - 1);
		String[] sa = s.split(",");
		long[] la = new long[sa.length] ;
		int i = 0;
		for (String sl : sa) {
			la[i] = Long.parseLong(sl);
			i++;
		}
		return la;
	}
	
	public static float[] toArrayFloat(
			String sarr,
			boolean bUseBraket) 
	{
		/**
		 * remove brakets
		 */
		String  s = sarr;
		if(bUseBraket) s = sarr.substring(1, sarr.length() - 1);
		String[] sa = s.split(",");
		float[] la = new float[sa.length] ;
		int i = 0;
		for (String sl : sa) {
			la[i] = Float.parseFloat(sl);
			i++;
		}
		return la;
	}
	
	public static String[] toArrayString(String sarr) {
		/**
		 * remove brakets
		 */
		String  s = sarr.substring(1, sarr.length() - 1);
		String[] sa = s.split(",");
		String[] la = new String[sa.length] ;
		int i = 0;
		for (String sl : sa) {
			/**
			 * remode delimiter "" or ''
			 */
			la[i] = sl.substring(1, sl.length() - 1);;
			i++;
		}
		return la;
	}
	
	public static String[] toArrayString(ArrayList<String> al) {
		String[] sl = new String[al.size()];
		for (int i=0;i<al.size();i++) {
			sl[i] = al.get(i);
		}
		return sl;
	}



	public static String toString(ArrayList<String> al) {
		String str = "["; 
		boolean bFirst = true;
		for (String s : al) {
			if (bFirst)
			{
				bFirst = false;
			} else {
				str += ",";
			}
			
			str += "\"" + Outils.addSlashes(s) + "\"";
		}
		str += "]";
		return str;
	}


	public static ArrayList<String> toArrayList(String[] sarr) {
		ArrayList<String> al = new ArrayList<String>();
		for (String s : sarr) {
			al.add(s);
		}
		return al;
	}
	
	public static ArrayList<String> toArrayList(long[] sarr) {
		ArrayList<String> al = new ArrayList<String>();
		for (long s : sarr) {
			al.add("" + s);
		}
		
		return al;
	}
	
	public static ArrayList<Long> toArrayListLong(long[] sarr) {
		ArrayList<Long> al = new ArrayList<Long>();
		for (long s : sarr) {
			al.add(s);
		}
		
		return al;
	}

	public static boolean contains(
			long a,
			long[] list)
	{
		for (long b : list) {
			if(a == b) return true;
		}
		return false;
	}
	
	/*
	 * Permet d'ajouter des antislashes devant les apostrophes
	 * dans une chaine de caract�res.
	 * Fonction utile pour les SGBD
	 */
	public static String addSlashes(String sChaine){
		if (sChaine==null) return null;
		sChaine = replaceAll(sChaine, "\\", "\\\\");
		sChaine = replaceAll(sChaine, "\'", "\\\'");
		sChaine = replaceAll(sChaine, "\"", "\\\"");
		sChaine = replaceAll(sChaine, "&#039;", "\\\'");
		return sChaine;
	}
	
	/*
	 * Permet d'ajouter des antislashes pour les clauses like
	 * dans une chaine de caract�res.
	 * Fonction utile pour les SGBD
	 */
	public static String addLikeSlashes(String sChaine){
		return addSlashes(addSlashes(sChaine));
	}

}
