/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;

/**
 *
 */
public class CoinDatabaseDuplicateException extends CoinDatabaseException {

	/**
	 * @param sCause
	 * @param sSqlQuery
	 */
	public CoinDatabaseDuplicateException(String sCause, String sSqlQuery) {
		super(sCause, sSqlQuery);
	}

	public CoinDatabaseDuplicateException(String sIdentifierName, String sIdentifierValue, String sSqlQuery) {
		super("Duplicate insert detected: the value "+sIdentifierValue+" already exists for "+sIdentifierName, sSqlQuery);
		this.sIdentifierName = sIdentifierName;
		this.sIdentifierValue = sIdentifierValue;
	}

	private static final long serialVersionUID = 1L;
	
}
