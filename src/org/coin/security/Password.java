/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.security ;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random ;

import javax.servlet.http.HttpSession;

/** Cette classe permet de g�rer les mots de passe :
 * <br />- g�n�ration d'un mot de passe
 * <br />- contr�le d'un mot de passe
 * @author Robert Xavier Montori
 * @version 0.1
 */
public class Password {

    private static final String sTinyChar = "abcdefghijklmnopqrstuvwxyz" ;
    private static final String sCapChar = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" ;
    private static final String[] sWordsField = {"a56b8HpY","GNR91a5V","48AzPzef","Agk6JLKf","ryhetH78","Ajefa8AW","fezfAA6a","QRTbv9Z0","BA9010sN","Pi6rIIaz"};
    private static final String sNumChar = "1234567890";
    private static final String sSpecChar = ".,?;/:!�<>�%*�^�$���&�\"\"(-�_��)=�+~#{[|`@]}�" ;
    public static final int CHARSET_TINY = 1 ;
    public static final int CHARSET_CAP = 2 ;
    public static final int CHARSET_NUM = 4 ;
    public static final int CHARSET_SPEC = 8 ;
       
    /** Cette m�thode permet de g�n�rer un mot de passe d'une longueur donn�e et d'une complexit� donn�e
     * @param iLengthWord Longueur voulue du mot passe.
     * <br />Si 4 < iLengthWord alors iLengthWord = 5.
     * @param iType Compl�xit� voulue du mot de passe.
     * <br />Les valeurs possibles de iType sont :
     * <br />
     * <br />- CHARSET_TINY : minuscules
     * <br />- CHARSET_CAP : majuscules
     * <br />- CHARSET_NUM : chiffres
     * <br />- CHARSET_SPEC : caract�res sp�ciaux
     * <br />- la somme des quatre valeurs pr�c�dentes (ex : CHARSET_TINY + CHARSET_CAP)
     * <br />
     * <br />Il est aussi possible d'utiliser les valeurs num�riques correspondantes des valeurs pr�c�dentes : 
     * <br />
     * <br />- 1 = CHARSET_TINY
     * <br />- 2 = CHARSET_CAP
     * <br />- 4 = CHARSET_NUM
     * <br />- 8 = CHARSET_SPEC
     * <br />- la somme des quatre valeurs num�riques pr�c�dentes (ex : 1 + 2)
     * <br />
     * <br />exemple : pour avoir un mot de passe avec des minuscules et des majuscules :
     * <br />iType = CHARSET_TINY + CHARSET_MAJ (= minuscules + majuscules)
     * <br />iType = 3 (= 1 + 2 = minuscules + majuscules) 
     * <br />
     * <br />Si 0 < iType < 16 alors iType = 1.
     * @return Le mot de passe g�n�r� sous la forme d'un String.
     * @since 0.1
     */  
    public static String calcPassword(int iLengthWord, 
            int iType) {
        int iNumberOfChar = 0 ;
        String sChar = "" ;
        StringBuffer sbPassword = new StringBuffer("") ;
        
        /* Permet de contr�ler si le mot de passe g�n�r� n'est pas inf�rieur � 5 caract�res */
        if (iLengthWord < 4) {
        	iLengthWord = 5 ;
        }
        
        /* Permet de d�finir la compl�xit� du mot de passe � partir d'un masque */
        if (iType > 0 && iType < 16){
        	if((CHARSET_TINY & iType) != 0)
            {
                iNumberOfChar += 25 ;
        		sChar += sTinyChar ;
            }

            if((CHARSET_CAP & iType) != 0)
            {
                iNumberOfChar += 26 ;
        		sChar += sCapChar ;
            }
          
            if((CHARSET_NUM & iType) != 0)
            {
                iNumberOfChar += 10 ;
        		sChar += sNumChar ;
            }
            
            if((CHARSET_SPEC & iType) != 0)
            {
                iNumberOfChar += 43 ;
        		sChar += sSpecChar ;
            }
        }
        /* Valeurs par d�faut si iType est en dehors de la plage (0 < iType < 16) */
        else {
        	iNumberOfChar += 25 ;
    		sChar += sTinyChar ;
        }
        
        Random oRandom = new Random() ;
        
        for (int i=0 ; i<=iLengthWord ; i++){
			sbPassword.append(sChar.charAt(oRandom.nextInt(iNumberOfChar))) ;
		}
        return sbPassword.toString() ;
    }
    
    
	public static boolean checkPassword(String clearTextTestPassword,
			String encodedActualPassword)
	{	
			String encodedTestPassword = MD5.getEncodedString(
					clearTextTestPassword);
			
			return (encodedTestPassword.equals(encodedActualPassword));
	}

	public static String getWord()
	{
		//int iPos = (int) Math.random() * sWordsField.length;
		//double rand = Math.random();
		//int iPos = (int)(rand* sWordsField.length);
		//return sWordsField[iPos];
		return calcPassword(7,CHARSET_CAP+CHARSET_NUM+CHARSET_TINY) ;
	}

	
	public static String computeCryptogram(String sId)
	{
		int iPos = (int) Math.random() * sWordsField.length;

		// TODO : SHA-256
		//return org.coin.security.SHA2.getEncodedString256( sWordsField[iPos] + sId );

		return org.coin.security.MD5.getEncodedString( sWordsField[iPos] + sId );
	}

	public static String computeCryptogramMD5(String sId)
	{
		String sWord = getWord();
		return org.coin.security.MD5.getEncodedString( sWord + sId );
	}
	
	public static String computeCryptogramMD5WithSessionWord(String sId, HttpSession session, String word)
	{
		String sWord = "";
		try{
			String sSessionWord = (String)session.getAttribute(word);
			if(sSessionWord == null || sSessionWord.equalsIgnoreCase("") || sSessionWord.equalsIgnoreCase("null")){
				sWord = getWord();
				session.setAttribute(word,sWord);
			}else sWord = sSessionWord;
			
			
		}catch(Exception e){
			sWord = getWord();
			session.setAttribute(word,sWord);
		}

		return org.coin.security.MD5.getEncodedString( sWord + sId );
	}

	public static String computeCryptogramSHA2(String sId)
	{
		String sWord = getWord();
		return org.coin.security.SHA2.getEncodedString256( sWord + sId );
	}


	public static int getWordIndex(String sCryptogram,String sId)
	{
	    int iIndex = -1;
	    
		for(int i=0;i<sWordsField.length;i++)
	    {
	        if (sCryptogram.equals(org.coin.security.MD5.getEncodedString( sWordsField[i] + sId ) ))
	        	return i;
	    }
		return iIndex;
	}
	/**
	 * 
	 * @param iNumberOfSyllables
	 * @param iNumberOfFigures
	 * @return a syllabic word with a number ; 
	 * example : getSyllabicPassword(2,2) can give "fainki68" or "wonxa87"
	 */
	public static String getSyllabicPassword(int iNumberOfSyllables, int iNumberOfFigures){
		String sWord = "";
		List<String> listConsonnant = new ArrayList<String>();
		Collections.addAll(listConsonnant, 
				"b","c","d","f","g","h","j","k","l","m","n","p","q","r"
				,"s","t","v","w","x","z");
		List<String> listVowels = new ArrayList<String>();
		Collections.addAll(listVowels, 
				"a","e","i","o","u","y","ou","oi","on","en","an","in","ain","ai","eu");
		for (int i=0;i<iNumberOfSyllables;i++){
			Random oRandom = new Random() ;
			sWord += listConsonnant.get(oRandom.nextInt(listConsonnant.size()-1))
					+listVowels.get(oRandom.nextInt(listVowels.size()-1));
		}
		for (int i=0;i<iNumberOfFigures;i++){
			Random oRandom = new Random() ;
			sWord += oRandom.nextInt(9);
		}
		return sWord;
	}
}
