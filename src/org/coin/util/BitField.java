/*
 * Created on 2 févr. 2005
 *
 */
package org.coin.util;

import java.math.BigInteger;
import java.util.ArrayList;

import org.coin.db.CoinDatabaseUtil;
import org.coin.security.CertificateUtil;


/**
 * @author d.keller
 *
 */
public class BitField {

	/**
	 * correspond à toutes les valeurs que peut prendre un code hexa soit 4 bits soit 2 statuts
	 */
	public static final int[][] bit2hexa 
		= new int[][] { {0,0,0,0},
						 {0,0,0,1},
						 {0,0,1,0},
						 {0,0,1,1},
						 {0,1,0,0},
						 {0,1,0,1},
						 {0,1,1,0},
						 {0,1,1,1},
						 {1,0,0,0},
						 {1,0,0,1},
						 {1,0,1,0},
						 {1,0,1,1},
						 {1,1,0,0},
						 {1,1,0,1},
						 {1,1,1,0},
						 {1,1,1,1} }; 

	public static final int VALUE_FALSE = 0;
	public static final int VALUE_TRUE = 1;
	public static final int VALUE_UNDEFINED = 2;
	public static final int MAX_BITS = 128;
	
	/**
	 * @param iIndex
	 * @param iValue
	 * @return
	 * on coimpare sur 4bits 
	 * un statut estr encodé sur 2bits
	 * car un hexa c'est 4 bits
	 * et selon si on est sur un statut pair ou impair on prend les 2 premiers ou les 2 derniers bits
	 */
	public static ArrayList<String> getHexaListFromBitValues(
			int iIndex, 
			int iValue)
	{
		return getHexaListFromBitValues(iIndex,iValue,VALUE_TRUE);
	}
	
	public static ArrayList<String> getHexaListFromBitValues(
			int iIndex, 
			int iValue, 
			int iInstanciate)
	{
		
		/**
		 * 3  2  | 1  0
		 * 00 00 | 00 00
		 * 
		 * on lit de gauche à droite et par groupe de 4 bits
		 * Pour le statut 1 on veut donc les 2 premiers bits
		 * Pour le statut 2 on veut donc les 2 derniers bits
		 */
		
		if( (iIndex+1)%2 == 0)
		{
			return getHexaListFromBitValues(iInstanciate, iValue, VALUE_UNDEFINED,VALUE_UNDEFINED);
		}
		else
		{
			return getHexaListFromBitValues(VALUE_UNDEFINED, VALUE_UNDEFINED, iInstanciate, iValue);
		}
	}
	
	public static ArrayList<String> getHexaListFromBitValues(
			int iBit3,
			int iBit2,
			int iBit1,
			int iBit0)
	{
		ArrayList<String> sHexaList = new ArrayList<String>();
		for(int i=0;i<bit2hexa.length;i++){
			boolean bAddHexaValue = true;
			int[] hexa = bit2hexa[i];

			/**
			 * on lit de gauche à droite
			 * le bit3 est donc la première valeur dans le code hexa
			 */
			if(!(iBit3==VALUE_UNDEFINED) &&  !(hexa[0]==iBit3) ) bAddHexaValue = false;
			if(!(iBit2==VALUE_UNDEFINED) &&  !(hexa[1]==iBit2) ) bAddHexaValue = false;
			if(!(iBit1==VALUE_UNDEFINED) &&  !(hexa[2]==iBit1) ) bAddHexaValue = false;
			if(!(iBit0==VALUE_UNDEFINED) &&  !(hexa[3]==iBit0) ) bAddHexaValue = false;
			
			if(bAddHexaValue){
				sHexaList.add(Integer.toHexString(i));
			}
		}
		return sHexaList;
	}

	/**
	 * Par défaut on considère que la valeur par défaut d'un statut non instancié est FALSE
	 * @param sBitFieldName
	 * @param iIndexBit
	 * @param iValue
	 * @return
	 */
	public static String getSQLQueryRequestBit(String sBitFieldName,int iIndexBit,int iValue){
		return getSQLQueryRequestBit(sBitFieldName, iIndexBit, iValue,VALUE_FALSE);
	}
	
	/**
	 * Si la valeur par défaut est identique à la valeur recherchée,
	 * alors on inclut dans la recherche les statuts non instanciés
	 * Pour l'instant iDefaultValue = FALSE car le blob de statut est initialisé avec des 0
	 * @param sBitFieldName
	 * @param iIndexBit
	 * @param iValue
	 * @param iDefaultValue
	 * @return
	 */
	public static String getSQLQueryRequestBit(
			String sBitFieldName,
			int iIndexBit,
			int iValue, 
			int iDefaultValue)
	{
		int iInstanciate = VALUE_TRUE;
		if(iValue == iDefaultValue)
			iInstanciate = VALUE_UNDEFINED;
		
		return getSQLQuery(sBitFieldName, iIndexBit, iValue,iInstanciate);
	}
	
	public static String getSQLQuery(
			String sBitFieldName,
			int iIndexBit,
			int iValue,
			int iInstanciate)
	{
		String sHexaList = "(";
		ArrayList<String> aHexaList = getHexaListFromBitValues(iIndexBit,iValue,iInstanciate);
		for(String s : aHexaList){
			sHexaList += "'"+s+"',";
		}
		sHexaList = sHexaList.substring(0,sHexaList.length()-1) + ")";

		int iPosition = (int)Math.ceil(iIndexBit/2)+1;

		//bidouille car sql server requiert obligatoirement la longueur de la chaine
		int iMaxLength = 2000;
		
		String sSQLQuery 
			= CoinDatabaseUtil.getSqlSubStringFunction(
					CoinDatabaseUtil.getSqlLPADFunction(
						CoinDatabaseUtil.getSqlSubStringFunction(
							CoinDatabaseUtil.getSqlHexFunction(sBitFieldName),
							CoinDatabaseUtil.getSqlLengthFunction(CoinDatabaseUtil.getSqlHexFunction(sBitFieldName))+"-("+(iPosition-1)+")",""+iMaxLength
							),
						""+iPosition,
						"0"),
				"1","1") +
				"in "+sHexaList;
		
		return sSQLQuery;
	}
	
	public static byte[] getStatusFormated(BigInteger biStatus) {
		byte[] bytesStatus = new byte[MAX_BITS]; // cela fait qd même 128 x 8 bits !
		byte[] bytesTemp =  biStatus.toByteArray();
		
		for (int i = 0; i < bytesStatus.length; i++) 
		{
			bytesStatus[i] = (byte) 0x00;
		}
		System.arraycopy(
				bytesTemp, 
				0, 
				bytesStatus, 
				bytesStatus.length - bytesTemp.length, 
				bytesTemp.length);
	
		return bytesStatus;
	}


	public static void displayStatusFormated(BigInteger biStatus) {
		System.out.println( "Statuts en hexa : \n" + CertificateUtil.getHexaStringValue( biStatus.toByteArray() ) );
		int iSize = 8 * 128;
		System.out.println( "Statuts en binaire ( " + iSize + " premiers) : " );
		for (int i = 0; i < iSize; i++) 
		{
			boolean b = biStatus.testBit( iSize - (i + 1) );
			System.out.print( b==true?"1":"0" );
			if( ( (i+1)% 8) == 0) System.out.print(" ");
			if( ( (i+1)% 64) == 0) System.out.println("");
				
		}
		System.out.println("");
	}

	
	/**
	 * 
	 * Les données sont dans une bitmap
	 * Le premier bit () sert à savoir si la donnée du second bit a été instancié.
	 * 
	 * @example : 
	 * 
	 * index :      0  1  2  3 
	 * biBitField : 00 01 11 10 
	 * getValue(, 0)  => renvoi une Exception
	 * getValue(, 1)  => renvoi une Exception
	 * getValue(, 2)  => renvoi true
	 * getValue(, 3)  => renvoi false
	 * 
	 * @param biBitField
	 * @param iField
	 * @return
	 * @throws Exception
	 */
	public static boolean getValue(
			BigInteger biBitField, 
			int iField) 
	throws InstantiationException
	{
		
		if ( biBitField.testBit( (iField * 2) + 1 ) )
		{
			return biBitField.testBit( (iField  * 2) );
		}

		InstantiationException e = new InstantiationException ("field not instanciate");
		throw e;	
	}
	
	public static boolean getValue(
			BigInteger biBitField, 
			int iField, 
			boolean bDefaultValue) 
	{
		if ( biBitField.testBit( (iField * 2) + 1 ) )
		{
			return biBitField.testBit( (iField  * 2) );
		}

		return bDefaultValue;	
	}
	
	public static BigInteger setValue(
			BigInteger biBitField, 
			int iField, 
			boolean bValue) 
	{
		// instancier le bit
		biBitField = biBitField.setBit((iField * 2) + 1  );
		
		if(bValue) 
		{
			biBitField = biBitField.setBit((iField * 2) );
		}
		else 
		{
			biBitField = biBitField.clearBit((iField * 2)   );
		}
		
		return biBitField;
	}
	
	public static int getStatutValeur(
			BigInteger biBitField,
			int iIdStatut) 
	{
		int iStatut;
		boolean bStatut;
		try	
		{
			bStatut = getValue(biBitField,iIdStatut);
			if(bStatut) iStatut = VALUE_TRUE;
			else iStatut = VALUE_FALSE;
		}
		catch (Exception e)
		{
			iStatut = VALUE_UNDEFINED;
		}

		return iStatut;
	}
	
	public static String getStatutValeurString(
			BigInteger biBitField,
			int iIdStatut) 
	{
		int iStatut = getStatutValeur(biBitField,iIdStatut);
		String sStatut = "";
		switch(iStatut){
		case VALUE_FALSE:
			sStatut = "non";
			break;
		case VALUE_TRUE:
			sStatut = "oui";
			break;
		case VALUE_UNDEFINED:
			sStatut = "indéfini";
			break;
		}

		return sStatut;
	}
	
	public static BigInteger setStatutValeur(
			BigInteger biBitField, 
			int iField, 
			int iValue) 
	{
		switch(iValue)
		{
			case VALUE_FALSE:
				biBitField = biBitField.setBit((iField * 2) + 1  );
				biBitField = biBitField.clearBit((iField * 2)   );
				break;
				
			case VALUE_TRUE:
				biBitField = biBitField.setBit((iField * 2) + 1  );
				biBitField = biBitField.setBit((iField * 2)   );
				break;
			
			case VALUE_UNDEFINED:
				biBitField = biBitField.clearBit((iField * 2) + 1  );
				biBitField = biBitField.clearBit((iField * 2)   );
				break;	
		}
		
		return biBitField;
	}
	
	
	

	
	public static void main(String[] args) {
		
		/**
		 * 
		 * biBitField 01 11 10 00
		 * getValue(, 0)  => renvoi une Exception
		 * getValue(, 1)  => renvoi false
		 * getValue(, 2)  => renvoi true
		 * getValue(, 3)  => renvoi une Exception
		 * 
		 */ 
		// bits 01 11 10 00 => hexa 78
		BigInteger biBitField = new BigInteger ( new byte[] { 0x78 });
		
		displayStatusFormated( biBitField );
		
		for (int i = 0; i < 4; i++) {
			try {
				System.out.println( "TEST Champ " + i + ": " );
				System.out.println( getValue(biBitField ,i) );
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		biBitField = setValue(biBitField , 0, true);
		biBitField  = setValue(biBitField , 3, true);

		displayStatusFormated( biBitField );
		
		for (int i = 0; i < 4; i++) {
			try {
				System.out.println( "TEST Champ " + i + ": " );
				System.out.println( getValue(biBitField ,i) );
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}
}
