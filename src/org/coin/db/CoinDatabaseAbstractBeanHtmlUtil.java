package org.coin.db;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.util.Vector;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpSession;

import org.coin.security.SecureString;

public abstract class CoinDatabaseAbstractBeanHtmlUtil {
	public static String UNDEFINED_VALUE = "Indéfini";

	public static String getHtmlSelect(
			String sFormSelectName, 
			int iSize, 
			Vector<CoinDatabaseAbstractBean> vBeans, 
			long lIdSelected)
	{
		return getHtmlSelect(sFormSelectName, iSize, vBeans, lIdSelected, "");
	}

	public static String getHtmlSelect(
			String sFormSelectName, 
			int iSize, 
			Vector<CoinDatabaseAbstractBean> vBeans, 
			String sIdSelected)
	{
		return getHtmlSelect(sFormSelectName, iSize, vBeans, sIdSelected, "");
	}


	public static String getHtmlSelect(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle)
	{
		return getHtmlSelect( sFormSelectName,
				 iSize, vBeans,
				lIdSelected,
				sStyle,
				true,
				false);
	}


	public static String getHtmlSelect(String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			String sIdSelected,
			String sStyle)
	{
		return getHtmlSelect( sFormSelectName,
				 iSize, vBeans,
				sIdSelected,
				sStyle,
				true,
				false);
	}

	public static String getHtmlSelect(String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			String sIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue)
	{
		return getHtmlSelect(
				sFormSelectName, 
				iSize, 
				vBeans, 
				sIdSelected,
				sStyle, 
				bUseUndefined, 
				bForceUndefinedValue, 
				UNDEFINED_VALUE,
				false);
	}


	
	public static String getHtmlSelect(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			String sIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue,
			boolean bIgnoreCase)
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";


		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName 
			+"\" size=\"" + iSize + "\" " + sStyle + " >\n";

		if(bForceUndefinedValue || (bUseUndefined && sIdSelected == ""))
			sListe += "<option value=\"\" "+ sSelected +">" + sUndefinedValue + "</option>\n";

		for (int i = 0; i < vBeans.size(); i++)
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			boolean bIsTheSameValue = false;
			if(bIgnoreCase){
				bIsTheSameValue = bean.getIdString().equalsIgnoreCase(sIdSelected);
			} else {
				bIsTheSameValue = bean.getIdString().equals(sIdSelected);
			}
			
			sListe += "<option value=\""+ bean.getIdString() +"\" "
				+ (bIsTheSameValue?sSelected:"")
				+">"+ bean.getName() +"</option>\n";
		}
		sListe += "</select>";

		return sListe;
	}

	public static String getHtmlSelect(String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue)
	{
		return getHtmlSelect(
				sFormSelectName, 
				iSize, 
				vBeans, 
				lIdSelected, 
				sStyle, 
				bUseUndefined, 
				bForceUndefinedValue, 
				UNDEFINED_VALUE);
	}

	public static String getHtmlSelectWithNameIdentifier(String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue
			)
	{
		return getHtmlSelectWithNameIdentifier(sFormSelectName, 
				iSize, 
				vBeans, 
				lIdSelected, 
				sStyle, 
				bUseUndefined, 
				bForceUndefinedValue, 
				sUndefinedValue, 
				"0");
		
	}
	
	/**
	 * Ici la valeur renvoyée n'est pas l'ID mais le NAME
	 * 
	 * 
	 * @param sFormSelectName
	 * @param iSize
	 * @param vBeans
	 * @param lIdSelected
	 * @param sStyle
	 * @param bUseUndefined
	 * @param bForceUndefinedValue
	 * @param sUndefinedValue
	 * @return
	 */
	public static String getHtmlSelectWithNameIdentifier(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue,
			String sUndefinedValuesId)
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";


		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\"" + iSize + "\" " + sStyle + " >\n";

		if(bForceUndefinedValue || (bUseUndefined && lIdSelected <= 0))
		{
			sListe += "<option value=\"" + sUndefinedValuesId + "\" "
				+ sSelected +">" +  sUndefinedValue + "</option>\n";
		}
		for (int i = 0; i < vBeans.size(); i++)
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			sListe += "<option value=\""+ bean.getName() +"\" "
			+ ((bean.getId()==lIdSelected)?sSelected:"")
			+">"+ bean.getName() +"</option>\n";
		}
		sListe += "</select>";

		return sListe;
	}

	public static String getHtmlSelect(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue)
	{
		return getHtmlSelect(
				sFormSelectName, 
				iSize, 
				vBeans, 
				lIdSelected, 
				sStyle, 
				bUseUndefined, 
				bForceUndefinedValue, 
				sUndefinedValue, 
				"0");
	}
	
	public static String getHtmlSelectDefaultValueByName(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			//long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue,
			String sUndefinedValueId,
			String sNameSelected)
	{
		return getHtmlSelect(
				sFormSelectName,
				iSize,
				vBeans,
				-1,
				sStyle,
				bUseUndefined,
				bForceUndefinedValue,
				sUndefinedValue,
				sUndefinedValueId,
				true,
				sNameSelected);
	}

	
	public static String getHtmlSelect(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue,
			String sUndefinedValueId)
	{
		return getHtmlSelect(
				sFormSelectName,
				iSize,
				vBeans,
				lIdSelected,
				sStyle,
				bUseUndefined,
				bForceUndefinedValue,
				sUndefinedValue,
				sUndefinedValueId,
				false,
				null);
	}

	
	public static String getHtmlSelect(
			String sFormSelectName,
			int iSize,
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected,
			String sStyle,
			boolean bUseUndefined,
			boolean bForceUndefinedValue,
			String sUndefinedValue,
			String sUndefinedValueId,
			boolean bSelectDefaultByName,
			String sNameSelected)
	{
		String sList = "";
		String sSelected = "selected=\"selected\"";


		sList += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\"" + iSize + "\" " + sStyle + " >\n";

		if(bForceUndefinedValue || (bUseUndefined && lIdSelected <= 0))
		{
			sList += "<option value=\"" + sUndefinedValueId + "\" "+ sSelected +">" +  sUndefinedValue + "</option>\n";
		}
		
		for (int i = 0; i < vBeans.size(); i++)
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			String sSel = "";
			if(bSelectDefaultByName)
			{
				if(sNameSelected.equalsIgnoreCase(bean.getName()) )
				{
					sSel = sSelected;
				}
			} else {
				sSel = ((bean.getId()==lIdSelected)?sSelected:"");
			}
			
			sList += "<option value=\""+ bean.getId() +"\" "
				+ sSel
				+">"+ bean.getName() +"</option>\n";
		}
		sList += "</select>";

		return sList;
	}

	public static String getHtmlSelectSecure(
			String sFormSelectName, 
			int iSize, 
			Vector<CoinDatabaseAbstractBean> vBeans,
			long lIdSelected, 
			String sStyle,
			HttpSession session) 
	throws InvalidKeyException, NoSuchAlgorithmException, NoSuchProviderException, NoSuchPaddingException,
	IllegalBlockSizeException, BadPaddingException, InvalidAlgorithmParameterException
	{
		String sListe = "";
		String sSelected = "selected=\"selected\"";
		
		sListe += "<select name=\""+ sFormSelectName +"\" id=\""+ sFormSelectName +"\" size=\"" + iSize + "\" " + sStyle + " >\n";
		if(lIdSelected <= 0)
			sListe += "<option value=\""+ (lIdSelected) +"\" "+ sSelected +">Indéfini</option>\n";
		
		for (int i = 0; i < vBeans.size(); i++) 
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			sListe += "<option value=\""+ SecureString.getSessionSecureString(Long.toString(bean.getId()),session) +"\" "
				+ ((bean.getId()==lIdSelected)?sSelected:"") 
				+">"+ bean.getName() +"</option>\n";
		}
		sListe += "</select>";
		
		return sListe;
	}
	
	public static String getHtmlInputRadio(String sFormSelectName, Vector<CoinDatabaseAbstractBean> vBeans, long lIdSelected)
	{
		return getHtmlInput(sFormSelectName, vBeans, lIdSelected, "radio");
	}
	
	public static String getHtmlInputCheckbox(String sFormSelectName, Vector<CoinDatabaseAbstractBean> vBeans, long lIdSelected)
	{
		return getHtmlInput(sFormSelectName, vBeans, lIdSelected, "checkbox");
	}

	public static String getHtmlInputText(String sFormSelectName, Vector<CoinDatabaseAbstractBean> vBeans, long lIdSelected)
	{
		return getHtmlInput(sFormSelectName, vBeans, lIdSelected, "text");
	}

	public static String getHtmlInput(
			String sFormSelectName, 
			Vector<CoinDatabaseAbstractBean> vBeans, 
			long lIdSelected, 
			String sType)
	{
		return getHtmlInput(
				sFormSelectName, 
				vBeans, 
				lIdSelected, 
				sType, 
				"<br />\n");
	}
	
	public static String getHtmlInput(
			String sFormSelectName, 
			Vector<CoinDatabaseAbstractBean> vBeans, 
			long lIdSelected, 
			String sType,
			String sDelimiter)
	{
		String sListe = "";
		String sSelected = "checked='checked'";

		for (int i = 0; i < vBeans.size(); i++)
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			sListe += "<input type='" + sType 
				+ "' name='" + sFormSelectName 
				+ "' id='" + sFormSelectName 
				+ "' value=\""+ bean.getId() +"\" "
				+ ((bean.getId()==lIdSelected)?sSelected:"")
				+ " />"+ bean.getName() 
				+ sDelimiter;
		}

		return sListe;
	}


	public static String getHtmlListName(Vector<CoinDatabaseAbstractBean> vBeans)
	{
		StringBuffer sbListe = new StringBuffer ("");

		for (int i = 0; i < vBeans.size(); i++)
		{
			CoinDatabaseAbstractBean bean = vBeans.get(i);
			sbListe.append(bean.getName() + "<br/>\n") ;
		}

		return sbListe.toString();
	}
	
	public static String getHtmlTableInput(Vector<CoinDatabaseAbstractBean> vBeans,  String sFormSelectName , String sInputType ,int iColumn)
	{
		StringBuffer sbListe = new StringBuffer ("");
		sbListe.append("<table>\n<tr>");
		
		for(int i=0; i < vBeans.size() ; i++)
		{
			CoinDatabaseAbstractBean item = vBeans.get(i);
			sbListe.append("<td style='text-align: left'><input name='");
			sbListe.append(sFormSelectName);
			sbListe.append("' type='");
			sbListe.append(sInputType);
			sbListe.append("' />");
			sbListe.append(item.getId() + " - " + item.getName());

			if( ((i+1) % iColumn) == 0 )
			{
				// un saut de ligne
				sbListe.append("</tr>\n<tr>");
			}
		}
		sbListe.append("</tr>\n</table>\n");

		return sbListe.toString();
	}
}
