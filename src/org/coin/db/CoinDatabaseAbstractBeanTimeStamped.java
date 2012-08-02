package org.coin.db;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.naming.NamingException;

import org.coin.localization.LocalizationConstant;
import org.coin.localization.Localize;

/**
 * @author d.keller
 * @version $Id: CoinDatabaseAbstractBeanTimeStamped.java,v 1.5 2009/03/03 17:58:27 julien.renier Exp $
 *
 */
public abstract class CoinDatabaseAbstractBeanTimeStamped extends CoinDatabaseAbstractBean{
	private static final long serialVersionUID = 1L;
	
	protected Timestamp tsDateCreation;
	protected Timestamp tsDateModification;
	
	protected boolean bUseDateCreation = true;
	protected boolean bUseDateModification = true;

	@Override
	public void create(Connection conn) throws CoinDatabaseCreateException, SQLException, NamingException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
		if(bUseDateCreation )
			this.tsDateCreation = new Timestamp(System.currentTimeMillis());
		
		if(bUseDateModification)
			this.tsDateModification = new Timestamp(System.currentTimeMillis());
		
		super.create(conn);
	}
	
	@Override
	public void store(Connection conn) throws SQLException, NamingException, CoinDatabaseStoreException {
		if(bUseDateModification)
			this.tsDateModification = new Timestamp(System.currentTimeMillis());
		
		super.store(conn);
	}
	
	public Timestamp getDateCreation() {
		return this.tsDateCreation;
	}
	
	public Timestamp getDateModification() {
		return this.tsDateModification;
	}
	
	public void setDateCreation(Timestamp tsDate) {
		this.tsDateCreation = tsDate;
	}
	
	public void setDateModification(Timestamp tsDate) {
		this.tsDateModification = tsDate;
	}
	
	public String getDateModificationLabel() throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException {
		Localize loc = new Localize(
				this.iAbstractBeanIdLanguage,
				LocalizationConstant.CAPTION_CATEGORY_COIN_DB_LABEL);
		return loc.getValue(1, "Date de modification");
	}

	public String getDateCreationLabel() throws NamingException, SQLException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException {
		Localize loc = new Localize(
				this.iAbstractBeanIdLanguage,
				LocalizationConstant.CAPTION_CATEGORY_COIN_DB_LABEL);
		return loc.getValue(2, "Date de création");
	}

}