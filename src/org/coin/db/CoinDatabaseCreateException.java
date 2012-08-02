/*
 * Studio Matamore - France 2005, tous droits r�serv�s
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;

/**
 *
 */
public class CoinDatabaseCreateException extends CoinDatabaseException {

	/**
	 * @param sCause
	 * @param sSqlQuery
	 */
	public CoinDatabaseCreateException(String sCause, String sSqlQuery) {
		super(sCause, sSqlQuery);
	}

	public CoinDatabaseCreateException(String sSqlQuery) {
		super("Cr�ation impossible : " + sSqlQuery, sSqlQuery);
	}

	private static final long serialVersionUID = 1L;
	
}
