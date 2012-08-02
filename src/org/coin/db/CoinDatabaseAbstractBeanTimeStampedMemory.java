package org.coin.db;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;

/**
 * @author d.keller
 * @version $Id: CoinDatabaseAbstractBeanTimeStampedMemory.java,v 1.2 2009/03/03 17:58:27 julien.renier Exp $
 *
 */
public abstract class CoinDatabaseAbstractBeanTimeStampedMemory extends CoinDatabaseAbstractBeanTimeStamped implements CoinDatabaseMemoryInterface{
	private static final long serialVersionUID = 1L;
	
	public static void populateMemoryStatic(CoinDatabaseAbstractBeanTimeStampedMemory bean) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		CoinDatabaseAbstractBeanTimeStampedMemory item = bean.getClass().newInstance();
		item.populateMemory();
	}
	
	public static void reloadMemoryStatic(CoinDatabaseAbstractBeanTimeStampedMemory bean) throws NamingException, SQLException, IllegalAccessException, InstantiationException{
		CoinDatabaseAbstractBeanTimeStampedMemory item = bean.getClass().newInstance();
		if(item.getItemMemory()== null)
    	{
    		populateMemoryStatic(bean);
    	}
	}
	
	@Override
	public void create(Connection conn) throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		super.create(conn);
		
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}
	
	@Override
	public void store(Connection conn) throws SQLException, NamingException, CoinDatabaseStoreException {
		super.store(conn);
		
		try {populateMemoryStatic(this);} 
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
		try {populateMemoryStatic(this);} 
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
		try {populateMemoryStatic(this);} 
		catch (Exception e) {}
	}
}