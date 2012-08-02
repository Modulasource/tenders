/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;

import java.sql.SQLException;

import javax.naming.NamingException;

import org.coin.localization.LocalizationConstant;
import org.coin.localization.Localize;

/**
 *
 */
public class CoinDatabaseLoadException extends CoinDatabaseException {

	/**
	 * @param sCause
	 * @param sSqlQuery
	 */
	
	public CoinDatabaseLoadException(String sIdentifierValue, String sSqlQuery) {
		super("Element non trouvé '" + sIdentifierValue + "'", sSqlQuery);
		this.sIdentifierValue = sIdentifierValue;
	}
	
	public CoinDatabaseLoadException(String sIdentifierValue, String sSqlQuery, String sLocalizeMessage) {
		super(sLocalizeMessage, sSqlQuery);
		this.sIdentifierValue = sIdentifierValue;
	}
	
	public CoinDatabaseLoadException(String sIdentifierValue, String sSqlQuery,long iIdLanguage) throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException {
		this(sIdentifierValue, sSqlQuery, getLocalizedMessage(iIdLanguage, sIdentifierValue));
	}
	
	public static String getLocalizedMessage(long iIdLanguage, String sIdentifierValue) throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException{
		String sTitleMsg = "";
		try{
		if(iIdLanguage>0){
			Localize locMessage = new Localize(
					iIdLanguage,
					LocalizationConstant.CAPTION_CATEGORY_COIN_DB_MESSAGE);
			sTitleMsg = locMessage.getValue(1, "Element non trouvé");
		}else{
			sTitleMsg = "Element non trouvé";
		}
		}catch(Exception e){
			sTitleMsg = "Element non trouvé";
		}
		return sTitleMsg+" '" + sIdentifierValue + "'";
	}

	private static final long serialVersionUID = 1L;
	
}
