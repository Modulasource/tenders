/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 14 avril 2004
 *
 */
package org.coin.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URL;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;
import java.util.NoSuchElementException;
import java.util.StringTokenizer;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.naming.NamingException;

import org.coin.bean.accountancy.Currency;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseLoadException;
import org.w3c.dom.Document;

import com.sun.org.apache.xml.internal.serialize.OutputFormat;
import com.sun.org.apache.xml.internal.serialize.XMLSerializer;

public abstract class Outils extends StringUtilBasic implements Serializable {
		
	private static final long serialVersionUID = 2L;
	
	public static final String[] sConverionEntierLiterralFeminin = {"Première","Deuxième","Troisième","Quatrième","Cinquième","Sixième","Septième","Huitième","Neuvième","Dixième"};

	
    
    
    public static String getStackToString(Exception e) {
    	try {
    		StringWriter sw = new StringWriter();
    		PrintWriter pw = new PrintWriter(sw);
    		e.printStackTrace(pw);
    		return sw.toString() ;
    	}
    	catch(Exception e2) {
    		return "err : " + e2.getMessage();
    	}
    }

    
    public static final String getTextToHtml(String sText){
    	
    	if(sText == null) return "";
    	sText = sText.replaceAll("<", "&lt;");
    	sText = sText.replaceAll(">", "&gt;");
	 	sText = sText.replaceAll("\n", "<br/>\n");
    	return sText;
     }
    
        public static String normaliserFichierXML(String sXML){
    	
    	StringBuffer sbXMLNormalise = new StringBuffer();
    	String sXMLNormalise = "";
    	
    	
    	for (int i=0 ; i < sXML.length() ; i++){
    		char c = sXML.charAt(i);
    		switch (c) {
    			case '&': sbXMLNormalise.append("&amp;"); break;
    			case '\'': sbXMLNormalise.append("&apos;"); break;
    			case '\"': sbXMLNormalise.append("&quot;"); break;
    			case '>': sbXMLNormalise.append("&gt;"); break;
    			case '<': sbXMLNormalise.append("&lt;"); break;
    			case '€': sbXMLNormalise.append("euro(s)"); break;
    			default : sbXMLNormalise.append(c);
    		}
    	}
    	
     	sXMLNormalise = sbXMLNormalise.toString();
       	sXMLNormalise = org.coin.util.BasicDom.replaceAll(sXMLNormalise, "’", "'");
       	sXMLNormalise = org.coin.util.BasicDom.replaceAll(sXMLNormalise, "&#146;", "'");
       	sXMLNormalise = org.coin.util.BasicDom.replaceAll(sXMLNormalise, "&#8217;", "'");
       	
    	return sXMLNormalise;
    }
  
     public static final String getHtmlToText(String sText){
    	sText = sText.replaceAll("&lt;","<");
    	sText = sText.replaceAll("&gt;",">");
    	return sText;
     }
    
    public static final String getXmlStringIndent(Document doc) throws IOException{
        StringWriter stringWriter = new  StringWriter();
        OutputFormat format =  new OutputFormat(doc);
        format.setIndenting(true);
        format.setIndent(4);
        XMLSerializer serializer = new XMLSerializer(stringWriter,format);
        serializer.serialize(doc);
        return ""+stringWriter;
    }
    
    public static final String getXmlStringIndentToHtml(Document doc) throws IOException{
        StringWriter stringWriter = new  StringWriter();
        OutputFormat format =  new OutputFormat(doc);
        format.setIndenting(true);
        format.setIndent(4);
        XMLSerializer serializer = new XMLSerializer(stringWriter,format);
        serializer.serialize(doc);
        return Outils.replaceAll(getTextToHtml(""+stringWriter),"  ","&nbsp;&nbsp;");
    }

    public static boolean isEmailValideOld(String sChaine){
    	String sExpReg = "^[a-zA-Z]+[a-zA-Z0-9\\._-]*[a-zA-Z0-9]@[a-zA-Z]+"
            + "[a-zA-Z0-9\\._-]*[a-zA-Z0-9]+\\.[a-zA-Z]{2,4}$";
    	boolean bOk = false;
    	if(sChaine.matches(sExpReg)) bOk = true;
    	return bOk;
    }
    
    public static boolean isEmailValide(String sEmailAddress){
    	try {
    		// a null string is invalid
    	    if ( sEmailAddress == null )
    	      return false;

    	    // a string without a "@" is an invalid email address
    	    if ( sEmailAddress.indexOf("@") < 0 )
    	      return false;

    	    // a string without a "."  is an invalid email address
    	    if ( sEmailAddress.indexOf(".") < 0 )
    	      return false;

    		
			//InternetAddress emailAddr = new InternetAddress(sEmailAddress);
			return true;
		} catch (Exception e) {
			//e.printStackTrace();
			return false;
		}
    }
    
    public static String getCamelString(
    		String s) 
    {
    	String[] splits = s.split("_");
    	String newName = new String();
    	
    	for (String item : splits) {
    		newName += item.toUpperCase().substring(0,1)
    			+item.substring(1,item.length());
		}

    	return newName;
    }

    
    public static boolean verifierMajusculeSeulementDebutMots(String sPhrase){
    	boolean bOk = true;
    	String sExpReg = "[A-Z]";
    	for(int i=0;i<sPhrase.length();i++){
    		String sTemp = sPhrase.substring(i,i<sPhrase.length()?i+1:i);
    		if((sTemp.matches(sExpReg))){ //La lettre est une majuscule
    			if(i!=0){
    				String sLettrePrecedente = sPhrase.substring(i-1,i);
    				if((!sLettrePrecedente.equalsIgnoreCase(" "))&&(!sLettrePrecedente.equalsIgnoreCase(".")))
    						bOk = false;
    			}
    		}
    	}	
    	return bOk;
    }
    
	public static final int estNombre(String sNombre){
		int iNombre = -1 ;
		
		try {
			iNombre = Integer.parseInt(sNombre) ;
			return iNombre ;
		} 
		catch (Exception e) {
			iNombre = 0 ;
			return iNombre ;
		}
	}
	
	public static final int estPositif(int nombre){
		int iNombre = -1 ;
		if (nombre >= 0){
			iNombre = nombre ;
		} else {
			iNombre = 0 ;
		}
		return iNombre ;
	}
	/**
	 * Retourne la chaine tronquée selon la taille indiquée
	 * @param sChaineATronquer - chaîne à tronquer
	 * @param iTaille - taille de la chaîne 
	 * @return la chaîne tronquée
	 */
	public static final String tronquerChaine(String sChaineATronquer, int iTaille) {
		String sChaineCourte;
		
		if(iTaille < 3 ){
			sChaineCourte = "...";
			return sChaineCourte;
		}
		
		if(sChaineATronquer.length() > (iTaille - 3) ){
			sChaineCourte = sChaineATronquer.substring(0, iTaille - 3) + "...";
		}else{
			sChaineCourte = sChaineATronquer;
		}
		
		return sChaineCourte;
	}
	
	
	public static final String truncate2Ways(String sChaineATronquer, int iTaille) {
		String sChaineCourte;
		
		if(iTaille < 3 ){
			sChaineCourte = "...";
			return sChaineCourte;
		}
		
		if(sChaineATronquer.length() > (iTaille - 3) ){
			
			sChaineCourte = sChaineATronquer.substring(0, (iTaille/2) - 3) + " ... ";
			sChaineCourte += sChaineATronquer.substring(
					sChaineATronquer.length() - (iTaille/2) , 
					sChaineATronquer.length());
		
		}else{
			sChaineCourte = sChaineATronquer;
		}
		
		return sChaineCourte;
	}
	/**
	 * 
	 * @param sString
	 * @param iNumberWords
	 * @return
	 */
	public static final String getFirstWords(String sString, int iNumberWords) {
		String [] sTab = sString.split("\\b");
		if (sTab.length<=iNumberWords) return sString;
		sString = "";
		for (int i=0;i<iNumberWords;i++){
			sString += sTab[i]+"";
		}
		return sString+"...";
	}
	/**
	 * Truncate the string without cutting words
	 * @param sString - string to cut
	 * @param iLength - max length 
	 * @return truncated string
	 */
	public static final String truncatePerWords(String sString, int iLength) {
		if (sString.length()<=iLength) return sString;	
		sString = sString.substring(0, iLength);
		String [] sTab = sString.split("\\b");
		if (sTab.length<=1) return "...";
		return getFirstWords(sString, sTab.length-1);
	}
	/**
	 * Retourne les N premiers mots de la chaine
	 * @param sChaine - chaîne contenant les mots
	 * @param iNombreMot - le nombre mot
	 * @return la chaîne avec les N premiers mots.
	 */
	@Deprecated
	public static final String getNPremiersMotsFromChaine(String sChaine, int iNombreMot) {
		String [] sTab = sChaine.split(" ");
		if (sTab.length<=iNombreMot) return sChaine;
		sChaine = "";
		for (int i=0;i<iNombreMot;i++){
			sChaine += sTab[i]+" ";
		}
		return sChaine+"...";
	}
	
	/**
	 * Use truncatePerWords instead
	 * @param sChaineATronquer
	 * @param iTaille
	 * @return
	 */
	@Deprecated
	public static final String tronquerChaineParMot(String sString, int iLength) {
		if (sString.length()<=iLength) return sString;	
		sString = sString.substring(0, iLength);
		String [] sTab = sString.split(" ");
		if (sTab.length<=1) return "...";
		return getNPremiersMotsFromChaine(sString, sTab.length-1);
	}
	
	/**
	 * Renvoie un objet Date à partir d'une chaine représentant une date
	 * @param sSource - chaine au format jj/mm/aaaa
	 * @return un objet Date (java.sql)
	 */
	public static final Date recupererDate(String sSource) {
		int jour = Integer.parseInt(sSource.substring(0, 2));
		int mois = Integer.parseInt(sSource.substring(3, 5));
		int annee = Integer.parseInt(sSource.substring(6, 10));
		
		Calendar calendrier = Calendar.getInstance();
		calendrier.set( annee,
				mois - 1,
				jour,
				0, /* Heure 0 */
				0, /* Minute 0 */
				0 /* Seconde 0 */
		);
		Date date = new Date(calendrier.getTimeInMillis());
		return date;
	}
	/**
	 * Retourne un objet Timestamp à partir d'un string représentant une date
	 * @param sSource - date au format jj/mm/aaaa
	 * @return un objet Timestamp prêt au stockage dans la base de données
	 */
	public static final Timestamp recupererTimestamp(String sSource) {
		int jour = Integer.parseInt(sSource.substring(0,2));
		int mois = Integer.parseInt(sSource.substring(3,5));
		int annee = Integer.parseInt(sSource.substring(6, 10));
		
		Calendar calendrier = Calendar.getInstance();
		calendrier.set( annee,
				mois - 1,
				jour,
				0, /* Heure 0 */
				0, /* Minute 0 */
				0 /* Seconde 0 */
		);
		Timestamp timestamp = new Timestamp(calendrier.getTimeInMillis());
		
		return timestamp;
	}
	
	public static /*synchronized*/ String replaceNewLineOrTab(
			String str, String sReplace) 
	{
		str = Outils.replaceAll(str , "\n", " ");
		str = Outils.replaceAll(str , "\t", " ");
		str = Outils.replaceAll(str , "\r", " ");
		return str;
	}

	
	/**
	 * Récupérer une chaine d'entier séparés, et la parser en un tableau d'entiers
	 * @param chaineAParser - comme son nom l'indique
	 * @param separateur - comme son nom l'indique
	 * @return un tableau d'entier ou null si une erreur s'est produite ou si la longueur du tableau est <= 0
	 */
	public static final int[] parserChaineVersEntier(String chaineAParser, String separateur) {
		if (chaineAParser.indexOf(separateur) == -1)
			return null;
		if (chaineAParser.length() <= 0)
			return null;
		if (chaineAParser.equalsIgnoreCase(""))
			return null;
		StringTokenizer tokens = new StringTokenizer(chaineAParser, separateur);
		int[] resultat = new int[tokens.countTokens()];
		int i = 0;
		
		try {
			while (tokens.hasMoreElements()) {
				resultat[i] = Integer.parseInt(tokens.nextToken());
				i++;
			}
			
			if (resultat.length <= 0)
				return null;
			
			return resultat;
		}
		catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * Récupérer une chaine d'entier séparés, et la parser en un vecteur d'entiers
	 * @param chaineAParser - comme son nom l'indique
	 * @param separateur - comme son nom l'indique
	 * @return un tableau d'entier ou null si une erreur s'est produite ou si la longueur du tableau est <= 0
	 */
	public static final Vector<String> parserChaineVersVectorEntiers(String chaineAParser, String separateur) {
		if (chaineAParser.indexOf(separateur) == -1)
			return null;
		if (chaineAParser.length() <= 0)
			return null;
		if (chaineAParser.equalsIgnoreCase(""))
			return null;
		StringTokenizer tokens = new StringTokenizer(chaineAParser, separateur);
		Vector<String> vresultat = new Vector<String>();
		try {
			while (tokens.hasMoreElements()) {
			    vresultat.addElement(""+Integer.parseInt(tokens.nextToken()));
			}
			
			if (vresultat.size() <= 0)
				return null;
			
			return vresultat;
		}
		catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	/**
	 * Méthode parsant une chaine en un tableau de chaine
	 * @param chaineAParser - chaine à parser
	 * @param separateur - séparateur
	 * @return un tableau de String[] ou null si le parsing échoue
	 */
	public static final String[] parserChaineVersString(String chaineAParser, String separateur) {
		if(chaineAParser == null) return null;
		if (chaineAParser.indexOf(separateur) == -1)
			return null;
		if (chaineAParser.length() <= 0)
			return null;
		if (chaineAParser.equalsIgnoreCase(""))
			return null;
		StringTokenizer tokens = new StringTokenizer(chaineAParser, separateur);
		String[] resultat = new String[tokens.countTokens()];
		int i = 0;
		
		try {
			while (tokens.hasMoreElements()) {
				resultat[i] = tokens.nextToken();
				i++;
			}
			
			if (resultat.length <= 0)
				return null;
			
			return resultat;
		}
		catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * Récupère les objets correspondants aux identifiants trouvés dans la chaine 
	 * @param sIntegerList - contient les identifiants des objets 
	 * @param sDelimiter - délimiteur entre chaque identifiant (exemple "|")
	 * @return un Vector
	 */
	public static Vector<Integer>  parseIntegerList(String sIntegerList, String sDelimiter) {
		StringTokenizer tokenizer = new StringTokenizer(sIntegerList, sDelimiter);
		int i = 0;
		Vector<Integer> vIntegerList = new Vector<Integer>();
		try {
			while (tokenizer.hasMoreTokens()) {
				i++;
				vIntegerList.add(new Integer(tokenizer.nextToken()));
			}
			
			return vIntegerList ;
		}
		catch (NoSuchElementException e) {
			System.out.println("Erreur " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	 * Récupère les objets correspondants aux identifiants trouvés dans la chaine 
	 * @param sIntegerList - contient les identifiants des objets 
	 * @param sDelimiter - délimiteur entre chaque identifiant (exemple "|")
	 * @return un Vector
	 */
	public static Vector<String> parseStringList(String sIntegerList, String sDelimiter) {
		StringTokenizer tokenizer = new StringTokenizer(sIntegerList, sDelimiter);
		int i = 0;
		Vector<String> vIntegerList = new Vector<String>();
		try {
			while (tokenizer.hasMoreTokens()) {
				i++;
				vIntegerList.add(new String(tokenizer.nextToken()));
			}
			
			return vIntegerList ;
		}
		catch (NoSuchElementException e) {
			System.out.println("Erreur " + e.getMessage());
			e.printStackTrace();
			return null;
		}
	}
	
	public static final void getFileOnConsole(InputStream file) {
		try {
			BufferedReader in = new BufferedReader(new InputStreamReader(file));
			String line;
			
			while ((line = in.readLine()) != null) {
				System.out.println(line);
			}
			//in.close();
		}
		catch (IOException e) {
			System.out.println("Outils.java - Erreur dans la methode getFileOnConsole()");
			e.printStackTrace();
		}
	}
	
	/** Remplace dans une chaine sTexte, 
	 * la liste des caractères ou expressions régulières contenu dans le vector vPattern 
	 * par la liste des caractères contenu dans le vector vReplace 
	 * 
	 * Précondition : les 2 vectors doivent être de taille identiques.
	 */	
	public static String replaceAllWithVectors(String sTexte, Vector<String> vPattern, Vector<String> vReplace){
		if (vPattern.size()==vReplace.size()){
			if (vPattern.size()==0){
				return sTexte;
			}
			Pattern CRLF = Pattern.compile(vPattern.firstElement());
			Matcher m = CRLF.matcher(sTexte);
			if (m.find()) {
			  sTexte = m.replaceAll(vReplace.firstElement());
			}
			vPattern.removeElementAt(0);
			vReplace.removeElementAt(0);
			return replaceAllWithVectors(sTexte, vPattern, vReplace); 
		}
		System.out.println("Erreur dans Outils.replaceAllWithVectors : les Vectors en entrée sont de tailles différentes.");
		return sTexte;
	}
	

   /** use "stripAccents" instead
    **/
   @Deprecated 
   public static final java.lang.String sansAccent(String chaine) { 
      return stripAccents(chaine);
  }
   
	/**
	 * Encode une chaine de caractères comme une URL
	 * Ex : 2005-04-19T10:18:34+01:00 devient 2005%2D04%2D19T10%3A18%3A34%2B01
	 * @param String
	 * @return
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws CoinDatabaseLoadException 
	 */
	public static final String encodeURL(String sData) throws UnsupportedEncodingException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return URLEncoder.encode(sData, Configuration.getConfigurationValueMemory("server.url.encoding"));
	}
	
	public static final String decodeURL(String sData) throws UnsupportedEncodingException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException{
		return URLDecoder.decode(sData, Configuration.getConfigurationValueMemory("server.url.encoding"));
	}
	
	/**
	 * Renvoi la chaine en chaine visible en HTML, en "" si null
	 * 
	 * @param sXML
	 * @return
	 */
    public static final String convertXmlToHtmlOptional(String sXML){
    	
    	if(sXML == null) return ""; 
    	StringBuffer sbXMLNormalise = new StringBuffer();
    	String sXMLNormalise = "";
    	
    	
    	for (int i=0 ; i < sXML.length() ; i++){
    		char c = sXML.charAt(i);
    		switch (c) {
    			case '&': sbXMLNormalise.append("&amp;"); break;
    			case '\n': sbXMLNormalise.append("<br/>\n"); break;
    			case '\"': sbXMLNormalise.append("&quot;"); break;
    			case '>': sbXMLNormalise.append("&gt;"); break;
    			case '<': sbXMLNormalise.append("&lt;"); break;
    			default : sbXMLNormalise.append(c);
    		}
    	}
    	
    	sXMLNormalise = sbXMLNormalise.toString();
    	
    	return sXMLNormalise;
    }

	public static String encodeUtf8(String sData){
		if (sData==null) return "";
		try {
			//sData = new String(sData.getBytes("utf-8"));
			byte [] hibytes = sData.getBytes("utf-8");
			sData = new String(hibytes, "iso-8859-1");
		}
		catch(Exception e){
			System.out.println("Exception =" + e);
		}
		return sData ; 
	}
	public static String encodeUtf815(String sData){
		if (sData==null) return "";
		try {
			//sData = new String(sData.getBytes("utf-8"));
			byte [] hibytes = sData.getBytes("utf-8");
			sData = new String(hibytes, "iso-8859-15");
		}
		catch(Exception e){
			System.out.println("Exception =" + e);
		}
		return sData ; 
	}
	
	public static String decodeUtf8(String sData){
		if (sData==null) return "";
		try {
			byte [] hibytes = sData.getBytes("iso-8859-1");
			sData = new String(hibytes, "utf-8");
		}
		catch(Exception e)
		{
			System.out.println("Exception =" + e);
		}
		return sData ; 
	}
	
	public static String decodeUtf815(String sData){
		if (sData==null) return "";
		try {
			byte [] hibytes = sData.getBytes("iso-8859-15");
			sData = new String(hibytes, "utf-8");
		}
		catch(Exception e)
		{
			System.out.println("Exception =" + e);
		}
		return sData ; 
	}
	
	/**
	 * Clean a String from characters not good for an URL (#, %, etc). Example of use: A Servlet call.
	 * More characters should be added in order to be neccesary.
	 * @param sText
	 * @return replaced String ready to be used in URL
	 */
	public static String replaceURLCharacters(String sText){
		
		String sResult = "";
		
		sResult = replaceAll(sText, "%", "");
		sResult = replaceAll(sResult, "#", "");
		sResult = addSlashes(sResult);
		
		return sResult;	
	}
	

	/**
	 * Permet remplacer des retours à la ligne \n par des <br />
	 * @param texte - texte à traiter
	 * @return le texte mis à niveau
	 */
	public static String replaceNltoBr(String texte){
		Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r)");
		Matcher m = CRLF.matcher(texte);
		if (m.find()) {
		  return m.replaceAll("<br />");
		}
		return texte;
	}
	/**
	 * Permet de supprimer les \n
	 * @param sString - texte à traiter
	 * @return le texte mis à niveau
	 */
	public static String stripNl(String sString){
		return stripNl(sString, "");
	}
	public static String stripNl(String sString, String sSeparator){
		Pattern CRLF = Pattern.compile("(\r\n|\r|\n|\n\r)");
		Matcher m = CRLF.matcher(sString);
		if (m.find()) {
		  return m.replaceAll(sSeparator);
		}
		return sString;
	}
	
	public static String getStringForJavascriptFonction(String sTexte){
		return addSlashes(stripNl(sTexte));
	}
	/*
	 * Permet de supprimer les antislashes devant les apostrophes d'une chaine de caractères.
	 * => Réciproque de addSlashes
	 * Fonction utile pour les SGBD
	 */
	public static String stripSlashes(String sChaine){
		if (sChaine==null) return null;
		sChaine = replaceAll(sChaine, "\\\\", "\\");
		sChaine = replaceAll(sChaine, "\\\'", "\'");
		sChaine = replaceAll(sChaine, "\\\"", "\"");
		return sChaine;
	}
	
	public static String replaceDoubleCoteSlashes(String sChaine){
		if (sChaine==null) return null;
		sChaine = replaceAll(sChaine, "\"", "\'");
		sChaine = replaceAll(sChaine, "\'", "\\\'");
		return sChaine;
	}
	
	/**
	 * Traite les textes pour le format Quark Tag
	 */
	public static String traiterChaineForQuark(String sTexte){
		Vector<String> vPattern = new Vector<String>();
		Vector<String> vReplace = new Vector<String>();
		// Remplacement
		vPattern.add("\\\\"); vReplace.add("_antislashes_");
		
		vPattern.add("(<)"); vReplace.add("<\\\\<>");
		vPattern.add("(\r\n|\r|\n|\n\r)"); vReplace.add("<\\\\n>");
		vPattern.add("(@)"); vReplace.add("<\\\\@>");
		
		vPattern.add("_antislashes_"); vReplace.add("<\\\\\\\\>");
		
		return replaceAllWithVectors(sTexte, vPattern, vReplace);
	}
	
	public static String lireFichierTexte(File file) throws IOException {
		BufferedReader lecteurAvecBuffer = null;
		String sLignes = "";
		String sLigne = "";

		try {
			lecteurAvecBuffer = new BufferedReader(new FileReader(file));
		} catch (FileNotFoundException exc) {
			System.out.println("Erreur d'ouverture");
			return null;
		}
		while ((sLigne=lecteurAvecBuffer.readLine())!= null) {
			sLignes += sLigne+"\n";
		}
		lecteurAvecBuffer.close();
		return sLignes;
	}
	public static void ecrireFichierTexte(File file, String sContenu) throws IOException {
		try {
			FileWriter fw = new FileWriter(file);
			fw.write(sContenu);
			fw.close();
		} catch (FileNotFoundException exc) {
			System.out.println("Erreur d'ouverture");
		}
	}
	
	public static String lireFichierTexte(String sNomFichier) throws IOException {
		File file = new File(sNomFichier);
		return lireFichierTexte(file);
	}
	public static void ecrireFichierTexte(String sNomFichier, String sContenu) throws IOException {
		File file = new File(sNomFichier);
		ecrireFichierTexte(file,sContenu);
	}
	
	/*
	 * Retourne une chaine avec les caractères spéciaux de Word remplacés
	 */
	public static String cleanWordCharacters(String sChaine){
		System.out.println("’");
		sChaine = replaceAll(sChaine, "œ", "oe");
  		sChaine = replaceAll(sChaine, "’", "'");
  		sChaine = replaceAll(sChaine, "\u2019", "'");
		return sChaine;
	}
	
	public static String cleanHTMLCharacters(String sChaine){
		sChaine = replaceAll(sChaine, "&nbsp;", "");
  		sChaine = replaceAll(sChaine, "<br/>", "");
  		sChaine = replaceAll(sChaine, "<br />", "");
		return sChaine;
	}
	
	public static String replaceHTMLCharacters(String sChaine){
		sChaine = replaceAll(sChaine, "&nbsp;", " ");
  		sChaine = replaceAll(sChaine, "<br/>", " ");
  		sChaine = replaceAll(sChaine, "<br />", " ");
		return sChaine;
	}
	
	public static String cleanWordList(String sWordList){
		String sChaine = sWordList.trim().toLowerCase();
		sChaine = replaceAll(sChaine, "\'", " ");
		sChaine = replaceAll(sChaine, "\\", " ");
	    sChaine = replaceAll(sChaine, "'", " ");
	    sChaine = replaceAll(sChaine, "\"", " ");
	    String[] sarrWordList = sChaine.split(" ");
	    sChaine = "";
	    for(String str : sarrWordList )
	    {
	        if(str.length() > 2)
	        {
	        	sChaine += str + " ";
	        }
	    }
	    sChaine = sChaine.trim();
		return sChaine;
	}
	
	public static String cleanWordCharacters2(String s)
	{
		if(s==null) return "";

		StringBuffer buf=new StringBuffer();
		for(int j = 0; j < s.length(); j++)
		{       
			char c = s.charAt(j);

			int a = c;
			if (c < '\200')
				buf.append(c);
			else
			{
				if (a == 150) // long hyphen
					buf.append('-');
				else if (a == 145 || a == 146) // curly apostrophe
					buf.append('\'');
				else if (a == 147 || a == 148) // curly quotes
					buf.append("\"");
				else 
					buf.append(c);
			}
		}
		
		return(buf.toString());
	}
	
	public static String join(String token, Vector<String> strings) {
	    StringBuffer sb = new StringBuffer();
	    
	    if(strings.size() == 0)
	    	return "";
	    	
	    for (int x=0; x<(strings.size()-1); x++) {
	        sb.append(strings.get(x));
	        sb.append(token);
	    }
	    sb.append(strings.get(strings.size()-1));
	    return(sb.toString());
	}
	
	 
	public static String arrondir(double a, int n){ 
		int p = (int)Math.pow(10, n); 
		a *= p; 
		a = (int)(a+.5); 
		a /= p; 
		String nb = ""+a;
		DecimalFormat format = new DecimalFormat("0.00");
		nb = format.format(a);
		nb = nb.replaceAll(",", ".");
		return nb;
	} 	

	/******* TRAITEMENT DES CARACTERES ASCII *******/
   /**
    * Get description of a character
    * @param c      character to describe
    * @return string destribing character, or &nbsp; if none available.
    */
	public static String getDescriptionFromChar( char c ){
		if ( 'A' <= c && c <= 'Z' ){
			return "upper case " + String.valueOf(c);
		}else if ( 'a' <= c && c <= 'z' ){
			return "lower case " + String.valueOf(c);
		}else if ( '0' <= c && c <= '9' ){
			return "digit " + String.valueOf(c);
		}else switch ( c ){
			case 0: return "NUL <b>nul</b>";
			case 1: return "SOH <b>s</b>tart <b>o</b>f <b>h</b>eader";
			case 2: return "STX <b>s</b>tart of <b>t</b>e<b>x</b>t";
			case 3: return "ETX <b>e</b>nd of <b>t</b>e<b>x</b>t";
			case 4: return "EOT <b>e</b>nd <b>o</b>f <b>t</b>ransmission";
			case 5: return "ENQ <b>e</b><b>nq</b>uiry";
			case 6: return "ACK <b>ack</b>nowledege";
			case 7: return "BEL <b>bel</b>l";
			case 8: return "BS <b>b</b>ack<b>s</b>pace [\\b]";
			case 9: return "HT <b>h</b>orizonal <b>t</b>ab [\\t]";
			case 10: return "LF <b>l</b>ine <b>f</b>eed [\\n]";
			case 11: return "VT <b>v</b>ertical <b>t</b>ab";
			case 12: return "FF <b>f</b>orm <b>f</b>eed [\\f]";
			case 13: return "CR <b>c</b>arriage <b>r</b>eturn [\\r]";
			case 14: return "SO <b>s</b>hift <b>o</b>ut";
			case 15: return "SI <b>s</b>hift <b>i</b>n";
			case 16: return "DLE <b>d</b>ata <b>l</b>ink <b>e</b>scape";
            case 17: return "DC1 <b>d</b>evice <b>c</b>ontrol <b>1</b>,"
               +" XON resume transmission";
            case 18: return "DC2 <b>d</b>evice <b>c</b>ontrol <b>2</b>";
            case 19: return "DC3 <b>d</b>evice <b>c</b>ontrol <b>3</b>,"
               + " XOFF pause transmission";
            case 20: return "DC4 <b>d</b>evice <b>c</b>ontrol <b>4</b>";
            case 21: return "NAK <b>n</b>egative <b>a</b>c<b>k</b>nowledge";
            case 22: return "SYN <b>syn</b>chronise";
            case 23: return "ETB <b>e</b>nd <b>t</b>ext <b>b</b>lock";
            case 24: return "CAN <b>can</b>cel";
            case 25: return "EM <b>e</b>nd <b>m</b>essage";
            case 26: return "SUB <b>sub</b>stitute";
            case 27: return "ESC <b>esc</b>ape";
            case 28: return "FS <b>f</b>ile <b>s</b>eparator";
            case 29: return "GS <b>g</b>roup <b>s</b>eparator";
            case 30: return "RS <b>r</b>ecord <b>s</b>eparator";
            case 31: return "US <b>u</b>nit <b>s</b>eparator";
            case 32: return "space";
            case 33: return "bang, exclamation";
            case 34: return "quote";
            case 35: return "sharp, number sign";
            case 36: return "dollar sign";
            case 37: return "percent";
            case 38: return "ampersand";
            case 39: return "apostrophe";
            case 40: return "left parenthesis";
            case 41: return "right parenthesis";
            case 42: return "star, asterisk";
            case 43: return "plus";
            case 44: return "comma";
            case 45: return "minus";
            case 46: return "period";
            case 47: return "slash, <b>not backslash!</b>";
            case 58: return "colon";
            case 59: return "semicolon";
            case 60: return "less than";
            case 61: return "equals";
            case 62: return "greater than";
            case 63: return "question mark";
            case 64: return "at sign";
            case 91: return "left square bracket";
            case 92: return "backslash, <b>not slash!</b>";
            case 93: return "right square bracket";
            case 94: return "hat, circumflex";
            case 95: return "underscore";
            case 96: return "grave, rhymes with have";
            case 123: return "left curly brace";
            case 124: return "vertical bar";
            case 125: return "right curly brace";
            case 126: return "tilde";
            case 127: return "DEL <b>del</b>ete";
               // the following are OCTAL because that'show PostScript
				// specifies them
               // &xxx; codes are for Latin-1
            case 0241: return "PostScript " + "(&iexcl;) exclamdown";
            case 0242: return "PostScript " + "(&cent;) cent";
            case 0243: return "PostScript " + "(&pound;) sterling";
            case 0244: return "PostScript " + "(/) fraction";
            case 0245: return "PostScript " + "(&yen;) yen";
            case 0246: return "PostScript " + "(&#131;) florin";
            case 0247: return "PostScript " + "(&sect;) section";
            case 0250: return "PostScript " + "(&curren;) currency";
            case 0251: return "PostScript " + "(') quotesingle";
            case 0252: return "PostScript " + "(&#147;) quotedblleft";
            case 0253: return "PostScript " + "(&laquo;) guillemotleft";
            case 0254: return "PostScript " + "(&lt;) guilsinglleft";
            case 0255: return "PostScript " + "(&gt;) guilsinglright";
            case 0256: return "PostScript " + "fi ligature";
            case 0257: return "PostScript " + "fl ligature;";
            case 0261: return "PostScript " + "(&#150;) endash";
            case 0262: return "PostScript " + "(&#134;) dagger";
            case 0263: return "PostScript " + "(&middot;) periodcentered";
            case 0266: return "PostScript " + "(&para;) paragraph";
            case 0267: return "PostScript " + "(&#149;) bullet";
            case 0270: return "PostScript " + "(,) quotesinglbase";
            case 0271: return "PostScript " + "(&#132;) quotedblbase";
            case 0272: return "PostScript " + "(&#148;) quotedblright";
            case 0273: return "PostScript " + "(&raquo;) guillemotright";
            case 0274: return "PostScript " + "(&#133;) ellipsis";
            case 0275: return "PostScript " + "(&#137;) perthousand";
            case 0277: return "PostScript " + "(&iquest;) questiondown";
            case 0301: return "PostScript " + "(`) grave";
            case 0302: return "PostScript " + "(&acute;) acute";
            case 0303: return "PostScript " + "(^) circumflex";
            case 0304: return "PostScript " + "(~) tilde";
            case 0305: return "PostScript " + "(&macr;) macron, overbar accent";
            case 0306: return "PostScript " + "(<sup>u</sup>) breve, flattened u-shaped accent";
            case 0307: return "PostScript " + "(&#183;) dotaccent";
            case 0310: return "PostScript " + "(&uml;) dieresis";
            case 0312: return "PostScript " + "(&#176;) ring";
            case 0313: return "PostScript " + "(&cedil;) cedilla";
            case 0315: return "PostScript " + "(&#148;) hungarumlaut";
            case 0316: return "PostScript " + "(,) ogonek, reverse comma";
            case 0317: return "PostScript " + "(<sup>v</sup>) caron, flattened v-shaped accent";
            case 0320: return "PostScript " + "(&#151;) emdash";
            case 0341: return "PostScript " + "(&AElig;) AE";
            case 0343: return "PostScript " + "(&ordf;) ordfeminine";
            case 0350: return "PostScript " + "(L/) Lslash, L with / overstrike";
            case 0351: return "PostScript " + "(&Oslash;) Oslash";
            case 0352: return "PostScript " + "(&#140;) OE";
            case 0353: return "PostScript " + "(&ordm;) ordmasculine";
            case 0361: return "PostScript " + "(&aelig;) ae";
            case 0365: return "PostScript " + "(1) dotlessi, i without dot";
            case 0370: return "PostScript " + "(l/) l with / overstrike";
            case 0371: return "PostScript " + "(&oslash;) oslash";
            case 0372: return "PostScript " + "(&#156;) oe";
            case 0373: return "PostScript " + "(&szlig;) germandbls";
            default: return "&nbsp;";
		}
	}
   /**
    * how you display this character in HTML
    * @param c      the character you want to render
    * @return html for rendering the character
    */
	public static String getHTMLRenderFromChar ( char c ){
		if ( c < 32 ){
			/* control char */
			return "^" + (char)(c+64);
		}else if ( c > 126 ){
			/* high ascii */
			return "&#" + Integer.toString(c) + ";";
		}else{
			switch ( c ){
	            case 32: return "&nbsp;";
	            case 38: return "&amp;";
	            case 34: return "&quot;";
	            case 60: return "&lt;";
	            case 62: return "&gt;";
	               /* ordinary char */
	            default: return String.valueOf(c);
			}
		}
	}
	
	public static String getParameterValue(String sQuery, String sKey)
	{
		String[] keyValuePairs = sQuery.split("&");
		
		for (int k = 0; k < keyValuePairs.length; k++)
		{
			if (keyValuePairs[k].startsWith(sKey + "=") )
			{
				String[] thePair = keyValuePairs[k].split("=");
				return thePair[1] ;
			}
		}
		return null;
	}
	
	public static String getSizeInMegaBytes(float fSize)
	{
		BigDecimal bdTaille = new BigDecimal(fSize);
		BigDecimal bdDiv = new BigDecimal(1024*1024);
    	bdTaille = bdTaille.divide(bdDiv,2,2);
    	Float fTaillePJ = bdTaille.floatValue();
    	return fTaillePJ + " Mo" ;
	}
	
	public static String getFormatedValue(
			double dValue,
			String sFormat)
	{
		DecimalFormat df = new DecimalFormat(sFormat);
		return df.format(dValue) ;
	}
	
	public static String getFormatedValue(double dValue)
	{
		DecimalFormat df = new DecimalFormat("#.00");
		return df.format(dValue) ;
	}
	
	public static String getFormatedCurrencyValueRounded(float fValue, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		fValue = round(fValue);
		return getFormatedCurrencyValue(fValue,sIdCurrency);
	}
	
	
	public static String getFormatedCurrencyValue(double dValue, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		String sNumber = getFormatedNumberValue(dValue);
		if(!isNullOrBlank(sIdCurrency)){
			sNumber += Currency.getCurrencyMemory(sIdCurrency).getInitials();
		} 
		return sNumber;
	}
	
	public static String getFormatedCurrencyIntValueUnicode(double dValue, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		String sNumber = getFormatedIntValue(dValue);
		return getFormatedCurrencyStringValueUnicode(sNumber, sIdCurrency);
	}
	
	public static String getFormatedCurrencyFloatValueUnicode(double dValue, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		String sNumber = getFormatedFloatValue(dValue);
		return getFormatedCurrencyStringValueUnicode(sNumber, sIdCurrency);
	}
	
	public static String getFormatedCurrencyValueUnicode(double dValue, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return getFormatedCurrencyFloatValueUnicode(dValue,sIdCurrency);
	}
	
	public static String getFormatedCurrencyStringValueUnicode(String sNumber, String sIdCurrency) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		if(!isNullOrBlank(sIdCurrency)){
			Currency curr = Currency.getCurrencyMemory(sIdCurrency);
			if(!isNullOrBlank(curr.getUnicode())){
				sNumber+="&#x"+curr.getUnicode()+";";
			}else{
				sNumber+=curr.getInitials();
			}
		} 
		return sNumber;
	}
	
	public static String getFormatedIntValue(double dValue)
	{
		DecimalFormatSymbols dfs = new DecimalFormatSymbols(); 
		dfs.setGroupingSeparator(' '); 
		dfs.setDecimalSeparator(','); 
		return getFormatedIntValue("", dfs, dValue);
	}
	
	public static String getFormatedIntValue(String sPattern, DecimalFormatSymbols dfs, double dValue)
	{
		DecimalFormat df = new DecimalFormat(sPattern,dfs);
		df.setGroupingSize(3);
		
		return df.format(dValue) ;
	}
	
	public static String getFormatedFloatValue(double dValue)
	{
		DecimalFormat df = new DecimalFormat("###,##0.00");
		return df.format(dValue) ;
	}
	
	public static String getFormatedNumberValue(double dValue)
	{
		DecimalFormat df = new DecimalFormat("###,##0.00");
		return df.format(dValue) ;
	}
	
	public static String getFormatedNumberValueRounded(float fValue)
	{
		fValue = round(fValue);
		return getFormatedNumberValue(fValue);
	}
	
	public static String getFormatedFloatValueRounded(float fValue)
	{
		fValue = round(fValue);
		return getFormatedNumberValue(fValue);
	}
	
	public static String getFormatedValueNeant(double dValue)
	{
		if(dValue == 0) return "";
		DecimalFormat df = new DecimalFormat("#.00");
		return df.format(dValue) ;
	}
	
	public static String getUsFormatedValueNeant(double dValue)
	{
		// Spécification du DecimalFormatSymbols
		// par défaut le Locale utilisé est le FR et le retour n'est pas celui attendu : "#.00" va donner "#,00"
		// Autres exemples :
		//		###,###.###      123,456.789     en_US
		//		###,###.###      123.456,789     de_DE
		//		###,###.###      123 456,789     fr_FR
		// http://download.oracle.com/javase/tutorial/i18n/format/decimalFormat.html
		if(dValue == 0) return "";
		DecimalFormat df = new DecimalFormat("#.00", new DecimalFormatSymbols(Locale.US));
		return df.format(dValue) ;
	}
	
    public static String getExtensionFromFilename(String sFilename){
        Pattern p = Pattern.compile("\\.([^\\.]*$)", Pattern.CASE_INSENSITIVE);
        Matcher m = p.matcher(sFilename.toLowerCase().trim());
        if (m.find() && m.groupCount()>0) return m.group(1);
        return "";
    }
    
    
    
	/*
	public static String linkify(
			String sText, 
			String sTargetOption)
	{
	    //String r = "http(s)?://([\\w+?\\.\\w+])+([a-zA-Z0-9\\~\\!\\@\\#\\$\\%\\^\\&amp;\\*\\(\\)_\\-\\=\\+\\\\\\/\\?\\.\\:\\;\\'\\,]*)?";
	    String r = "http(s)?://([\\w+?\\.\\w+])+([a-zA-Z0-9\\~\\!\\@\\#\\$\\%\\^\\&amp;\\*\\(\\)_\\-\\=\\+\\\\\\/\\?\\.\\:\\;\\'\\,]*([a-zA-Z]))?";
	    Pattern pattern = Pattern.compile(r, Pattern.DOTALL | Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
	    Matcher matcher = pattern.matcher(sText);
	    return matcher.replaceAll("<a href=\"$0\" " + sTargetOption + " >$0</a>"); // group 0 is the whole expression
	}
    */
    /**
     * Transform all the URLs in a text to an <a href tag
     * You can add target and inner tag and you'll get : 
     * <a href="catched_URL" target="sTargetOption">sInnerTag</a>
     * @param sText
     * @param sTargetOption
     * @param sInnerTag
     * @return
     */
	public static String linkifyURLs(String sText, String sTargetOption, String sInnerTag){
		Pattern p = Pattern.compile("(\\w+)\\:\\/\\/([^\\s^\\<]*)([\\w#?\\/&=])([\\.\\,\\;\\:\\!\\?\\'\\s\\<\\(\\)$])?", Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		if (!sTargetOption.equals("")) sTargetOption = " target=\""+sTargetOption+"\"";
		if (sInnerTag.equals("")) sInnerTag = "$1://$2$3";
		return m.replaceAll("<a href=\"$1://$2$3\""+sTargetOption+">"+sInnerTag+"</a>$4");
	}
	/**
     * Transform all the URLs in a text to an <a href tag
     * You can add target and inner tag and you'll get : 
     * <a href="catched_URL" target="sTargetOption">catched_URL</a>
	 * @param sText
	 * @param sTargetOption
	 * @return
	 */
	public static String linkifyURLs(String sText, String sTargetOption){
		return linkifyURLs(sText, sTargetOption, "");
	}
	
    /**
     * Transform all the Mails in a text to an <a href tag
     * You can add inner tag and you'll get : 
     * <a href="mailto:catched_Mail">sInnerTag</a>
     * @param sText
     * @param sTargetOption
     * @param sInnerTag
     * @return
     */
	public static String linkifyMails(String sText, String sInnerTag){
		Pattern p = Pattern.compile("([_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)+)", Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		if (sInnerTag.equals("")) sInnerTag = "$1";
		return m.replaceAll("<a href=\"mailto:$1\">"+sInnerTag+"</a>");
	}
	public static String linkify(String sText, String sTargetOption, String sInnerTag){
		return linkifyMails(linkifyURLs(sText, sTargetOption, sInnerTag), sInnerTag);
	}
	public static String linkify(String sText, String sTargetOption){
		return linkify(sText, sTargetOption, "");
	}
	
	/**
     * Method return Message Parametrized
     * {0},...{10},...,{i}
     * @param sMessage
     * @param vParam      
     * @return
     */
	public static String getParametrizedMessage(String sMessage,Vector <String> vParam){
		Vector <String> vParameter = vParam;		
		String sAuxMessage = sMessage;		
		int iSize = vParameter.size();		
		int i=0;
		while(i < iSize){			
			sAuxMessage = sAuxMessage.replace("{"+String.valueOf(i).toString()+"}", vParameter.get(i));			
			i++;
		}	
		
		return sAuxMessage;
	}
	public static String stripPunctuation(String sText){
		Pattern p = Pattern.compile("\\p{Punct}", Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		return m.replaceAll(" ");
	}
	public static String stripMultiSpaces(String sText){
		Pattern p = Pattern.compile("\\p{Space}{2,}", Pattern.UNIX_LINES | Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		return m.replaceAll(" ");
	}
	
	/*
	 * Methods for URLRewriting works : 
	 */
	
	/**
	 * 
	 * @param sText
	 * @param iMaxChar : Number of characters maxi
	 * @param iMinWordSizeFilter : Filter the shorter words
	 * @return a truncated text with iMaxChar characters limit
	 * example : 
	 *  getNoTruncatedWord("This is a great day today", 15, 0) give : "This is a great" ==> no more 15 chars
	 *  getNoTruncatedWord("This is a great day today", 15, 2) give : "This great day" ==> no more 15 chars and no word less 2 chars
	 */
	public static String getNoTruncatedWord(String sText, int iMaxChar, int iMinWordSizeFilter){
		String [] aText = sText.split("\\b");
		
		// In case of a long String, we truncate it
		if (aText.length<2)  return sText.substring(0, iMaxChar);
		
		// Application of word size limit filter
		if (iMinWordSizeFilter>0){
			StringBuffer sbFilter = new StringBuffer();
			for (int i=0;i<aText.length;i++){
				if (aText[i].length()>iMinWordSizeFilter){
					if (sbFilter.length()>0) sbFilter.append(" ");
					sbFilter.append(aText[i]);
				}
			}
			sText = sbFilter.toString();
			aText = sText.split("\\b");
		}
		
		// In case of String is shorter than the limit
		if (sText.length()<=iMaxChar) iMaxChar = sText.length();
		
		// Counting sum of char
		int iNumWord=0, iCount = 0;
		StringBuffer sbResult = new StringBuffer();
		do{
			iCount += aText[iNumWord].length()+1;
			if (sbResult.length()>0) sbResult.append(" ");
			sbResult.append(aText[iNumWord++]);
		}while(iCount<=iMaxChar);
		
		//if (sbResult.toString().length()>iMaxChar) return (sbResult.toString().substring(0, iMaxChar)); 
		return sbResult.toString();
	}
	public static String getKeywordsForURL(String sKeyword, int iMaxChar, int iMinWordSizeFilter){
		return stripMultiSpaces(getNoTruncatedWord(stripPunctuation(stripAccents(sKeyword)).trim().toLowerCase(), iMaxChar, iMinWordSizeFilter)).replace(" ", "-");
	}
	public static String stripHTMLTags(String sText){
		Pattern p = Pattern.compile("<[^>]*>", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		return m.replaceAll(" ");
	}
	/**
	 * 
	 * @param arrStr a String[]
	 * @param sDelimiter
	 * @return all the elements from String[] separate by sDelimiter
	 */
	public static String implode(String[] arrStr, String sDelimiter) {
		StringBuffer sb = new StringBuffer();
		for(int i =0; i < arrStr.length; i++){
			if (i>0) sb.append(sDelimiter);
			sb.append(arrStr[i]);
		}
		return sb.toString();
	}
	/**
	 * 
	 * @param vString
	 * @param sDelimiter
	 * @return all the elements from vString separate by sDelimiter
	 */
	public static String implode(Vector<String> vString, String sDelimiter) {
		StringBuffer sb = new StringBuffer();
		for(int i =0; i < vString.size(); i++){
			if (i>0) sb.append(sDelimiter);
			sb.append(vString.get(i));
		}
		return sb.toString();
	}

	
	public static long[] reverseArrayLong(long[] larr)
	{
		long[] larrAux = new long[larr.length];
		int i = 0;
		int j = 0;
		for(i=larr.length-1; i>=0; i--)
		{
			larrAux[j] = larr[i];
			j++;
		}
		
		return larrAux;
	}


	

	/**
	 * 
	 * @param sURL
	 * @return get text source from an URL
	 */
	public static String getContentFromURL(String sURL){
		String sContent = "";
		InputStreamReader in = null;
		try{URL url = new  URL (sURL);
		in = new InputStreamReader(url.openStream());
		}catch (Exception e) {}
		if (in!=null){
			try {
				int c = in.read();
				while (c != -1) {
					sContent += (char)c;
					c = in.read();
				}
			} catch (IOException e) {}
		}
		return sContent;
	}
	/**
	 * Search a String in a text and return true if it's found. 
	 * @param sText
	 * @param sKeyword
	 * @return
	 */
	public static boolean isInString(String sText, String sKeyword){
		if (sKeyword.equals("")) return true;
		Pattern p = Pattern.compile(".*?"+sKeyword+".*?", Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(sText);
		return m.find();
	}
	
	
	public static String cleanStringToDouble(String sChaine) {
		if(sChaine == null) return null;
		sChaine = replaceAll(sChaine, " ", "");
		sChaine = replaceAll(sChaine, ",", ".");
		return sChaine;
	}
}	