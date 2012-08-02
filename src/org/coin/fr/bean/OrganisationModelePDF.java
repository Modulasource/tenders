/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 15 nov 2005
 * François Blanchard
 *
 */
package org.coin.fr.bean;

import org.coin.db.*;
import org.coin.util.Enumerator;

import java.sql.*;
import java.util.*;

import javax.naming.NamingException;

/**
 */
public class OrganisationModelePDF extends Enumerator {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public static final int TYPE_DEFAUT = 1;
	public static final int TYPE_REPUBLICAIN_LORRAIN = 2;
	public static final int TYPE_PARIS_NORMANDIE = 3;
	public static final int TYPE_LA_PROVENCE = 4;
	public static final int TYPE_ALSACE = 5;
	
	public void setConstantes(){
        super.TABLE_NAME = "organisation_modele_pdf";
        super.FIELD_ID_NAME  = "id_organisation_modele_pdf";
        super.FIELD_NAME_NAME = "libelle";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
        super.SELECT_FIELDS_NAME_SIZE = 1;
   }
	
    public OrganisationModelePDF () {
        super();
        setConstantes();
    }
    
    public OrganisationModelePDF (String sName) {
        super(sName);
        setConstantes();
    }
    
    public OrganisationModelePDF (int iId) {
        super(iId);
        setConstantes();
    }
    
    public OrganisationModelePDF (int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }
    
    public OrganisationModelePDF(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName)
	{
		return getAll_onNewItem(iId,sName,true);
	}
   
	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new OrganisationModelePDF(iId, sName,bUseHttpPrevent);
	}
	
	public static OrganisationModelePDF getOrganisationModelePDF(int iIdOrganisationModelePDF) throws CoinDatabaseLoadException, SQLException, NamingException 
	{
    	OrganisationModelePDF modelePDF = new OrganisationModelePDF (iIdOrganisationModelePDF );
    	modelePDF.load();
   		return modelePDF;
	}
	
    public static String getOrganisationModelePDFName(int iId) throws Exception {
    	OrganisationModelePDF  modelePDF = new OrganisationModelePDF (iId);
    	modelePDF.load();
    	return modelePDF.getName();
    }

    public static Vector getAllOrganisationModelePDF () throws SQLException, NamingException
	{
    	OrganisationModelePDF modelePDF = new OrganisationModelePDF ();
		return modelePDF.getAllOrderById();
	}
}
