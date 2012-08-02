/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/


package org.coin.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseMemoryInterface;
import org.coin.db.CoinDatabaseStoreException;

/**
 *
 * @author david
 *
 */
public abstract class EnumeratorStringMemory extends EnumeratorString implements CoinDatabaseMemoryInterface{
	
	private static final long serialVersionUID = 1L;

	public EnumeratorStringMemory() {
        super();
    }

    public EnumeratorStringMemory(
    		String sId,
            String sName) {
        super(sId,sName);
    }

	public EnumeratorStringMemory(String sId) {
	    super(sId);
	}

	public static void populateMemoryStatic(EnumeratorStringMemory bean) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		bean.populateMemory();
	}
	
	public static void populateMemoryStaticConn(EnumeratorStringMemory bean,Connection conn) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		Connection connEmbeddedConnection = bean.connEmbeddedConnection;
		boolean bUseEmbeddedConnection = bean.bUseEmbeddedConnection;
		
		bean.bUseEmbeddedConnection = true;
		bean.connEmbeddedConnection = conn; 
		bean.populateMemory();
		
		bean.bUseEmbeddedConnection = bUseEmbeddedConnection;
		bean.connEmbeddedConnection = connEmbeddedConnection; 
	}
	
	public static void reloadMemoryStatic(EnumeratorStringMemory bean) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		if(bean.getItemMemory()== null)
    	{
    		if(bean.bUseEmbeddedConnection){
				populateMemoryStaticConn(bean, bean.connEmbeddedConnection);
			} else {
				populateMemoryStatic(bean);
			}
    	}
	}
	
	@Override
	public void create(Connection conn) throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
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
	
	public <T> Vector<T> getAllMemoryLocalized(long lIdLanguage) throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException { 
		Vector<T> vResult = this.getAllMemory();
        for (T item : vResult) {
        	EnumeratorStringMemory itemMem = ((EnumeratorStringMemory)item);
        	itemMem.setAbstractBeanLocalization(lIdLanguage);
        	itemMem.setAbstractBeanConnexion(this);
        	String sNameLocalized = itemMem.getName();
        	itemMem.setName(sNameLocalized);
        }
        return vResult;
	}
}
