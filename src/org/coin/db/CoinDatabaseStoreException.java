/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;

/**
 *
 */
public class CoinDatabaseStoreException extends CoinDatabaseException {

	/**
	 * @param sCause
	 * @param sSqlQuery
	 */
	public CoinDatabaseStoreException(String sCause, String sSqlQuery) {
		super(sCause, sSqlQuery);
	}

	private static final long serialVersionUID = 1L;
	
}
