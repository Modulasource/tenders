/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/


package org.coin.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseMemoryInterface;
import org.coin.db.CoinDatabaseStoreException;

public abstract class EnumeratorMemory extends Enumerator implements CoinDatabaseMemoryInterface{
	
	private static final long serialVersionUID = 1L;

	public EnumeratorMemory() {
        super();
    }
    
    public EnumeratorMemory(
    		int iId, 
            String sName) {
    	super(iId,sName);
    }
        
	public EnumeratorMemory(int iId) {
		super(iId);
	}
	public EnumeratorMemory(long lId) {
		super(lId);
	}
	
	public EnumeratorMemory(String sName) {
		super(sName);
	}
	
	public static void populateMemoryStatic(EnumeratorMemory bean)
	throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		bean.populateMemory();
	}
	
	public static void populateMemoryStaticConn(EnumeratorMemory bean,Connection conn)
	throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		Connection connEmbeddedConnection = bean.connEmbeddedConnection;
		boolean bUseEmbeddedConnection = bean.bUseEmbeddedConnection;
		
		bean.bUseEmbeddedConnection = true;
		bean.connEmbeddedConnection = conn; 
		bean.populateMemory();
		
		bean.bUseEmbeddedConnection = bUseEmbeddedConnection;
		bean.connEmbeddedConnection = connEmbeddedConnection; 
	}
	
	public static void reloadMemoryStatic(EnumeratorMemory bean) 
	throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		if(bean.getItemMemory() == null)
    	{
    		populateMemoryStatic(bean);
    	}
	}
	
	@Override
	public void create(Connection conn) 
	throws CoinDatabaseCreateException, SQLException, NamingException, 
	CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		super.create(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void store(Connection conn) throws SQLException, NamingException, CoinDatabaseStoreException {
		super.store(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void remove(Connection conn) throws SQLException, NamingException {
		super.remove(conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
	
	@Override
	public void remove(int id) throws SQLException, NamingException {
		super.remove(id);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(long id) throws SQLException, NamingException {
		super.remove(id);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}
	
	@Override
	public void removeFromPK(String sId, Connection conn) throws SQLException, NamingException {
		super.removeFromPK(sId,conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(String sWhereClause) throws SQLException, NamingException {
		super.remove(sWhereClause);
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}

	@Override
	public void remove(String sWhereClause, Connection conn) throws SQLException, NamingException {
		super.remove(sWhereClause,conn);
		try {populateMemoryStaticConn(this,conn);} 
		catch (Exception e) {}
	}
}
