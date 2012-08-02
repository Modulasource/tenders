package org.coin.security;

import java.sql.SQLException;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.localization.LocalizationConstant;
import org.coin.localization.Localize;

public class HabilitationException extends Exception {
	protected String sUseCase = "";
	
	public HabilitationException(String string) {
		super(string);
	}

	public HabilitationException(String string, String sUseCase) {
		super(string);
		this.sUseCase = sUseCase;
	}
	
	public HabilitationException(String sUseCase,long iIdLanguage) throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException {
		this(getLocalizedMessage(iIdLanguage,sUseCase), sUseCase);
	}
	
	public static String getLocalizedMessage(long iIdLanguage, String sUseCase) throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException{
		String sTitleMsg = "";
		try{
		if(iIdLanguage>0){
			Localize locMessage = new Localize(
					iIdLanguage,
					LocalizationConstant.CAPTION_CATEGORY_COIN_DB_MESSAGE);
			sTitleMsg = locMessage.getValue(3, "You aren't allowed for this use case");
		}else{
			sTitleMsg = "You aren't allowed for this use case";
		}
		}catch(Exception e){
			sTitleMsg = "You aren't allowed for this use case";
		}
		return sTitleMsg+" : " + sUseCase;
	}

	public String getUseCase() {
		return sUseCase;
	}
	
	public void setUseCase(String useCase) {
		this.sUseCase = useCase;
	}
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

}
