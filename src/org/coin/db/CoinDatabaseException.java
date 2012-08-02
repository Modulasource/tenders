/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.db;


/**
 *
 */
public abstract class CoinDatabaseException extends Exception {
	private static final long serialVersionUID = 1L;
	protected String sSqlQuery ;
	protected String sIdentifierValue;
	protected String sIdentifierName;
	
	public String getSqlQuery() {
		return this.sSqlQuery;
	}
	
	public void setSqlQuery(String sqlQuery) {
		this.sSqlQuery = sqlQuery;
	}
	
	public CoinDatabaseException(String sCause, String sSqlQuery) {
		super(sCause);
		this.sSqlQuery = sSqlQuery;
	} 
}
