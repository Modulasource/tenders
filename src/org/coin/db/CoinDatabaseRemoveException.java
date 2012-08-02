/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;

/**
 *
 */
public class CoinDatabaseRemoveException extends CoinDatabaseException {

	/**
	 * @param sCause
	 * @param sSqlQuery
	 */
	public CoinDatabaseRemoveException(String sCause, String sSqlQuery) {
		super(sCause, sSqlQuery);
	}
	
	public CoinDatabaseRemoveException(String sCause) {
		super(sCause, "");
	}

	private static final long serialVersionUID = 1L;
	
}
