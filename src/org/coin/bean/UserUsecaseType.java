/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

package org.coin.bean ;

import java.io.Serializable;

import org.coin.util.Enumerator;

/** Cette classe permet de gérer les statuts des utilisateurs
 * @author Robert Xavier Montori
 */
public class UserUsecaseType extends Enumerator implements Serializable{

    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	public static final int TYPE_ADD = 1;
	public static final int TYPE_REMOVE= 2;

	public void setConstantes(){
        super.TABLE_NAME = "coin_user_usecase_type";
        super.FIELD_ID_NAME = "id_coin_user_usecase_type";
        super.FIELD_NAME_NAME = "name";
        super.SELECT_FIELDS_NAME = super.FIELD_NAME_NAME;
    }

    public UserUsecaseType() {
        super();
        setConstantes();
    }

    public UserUsecaseType(String sName) {
        super(sName);
        setConstantes();
    }

    public UserUsecaseType(int iId) {
        super(iId);
        setConstantes();
    }

    public UserUsecaseType(int iId, String sName) {
        super(iId,sName);
        setConstantes();
    }

    public UserUsecaseType(int iId, String sName,boolean bUseHttpPrevent) {
		super(iId,sName);
		this.bUseHttpPrevent = bUseHttpPrevent;
		setConstantes();
	}

	protected Enumerator getAll_onNewItem(int iId, String sName,boolean bUseHttpPrevent)
	{
		return new UserUsecaseType(iId, sName,bUseHttpPrevent);
	}

    protected Enumerator getAll_onNewItem(int iId, String sName)
	{

		return new UserUsecaseType(iId, sName);
	}

    public static String getUserUsecaseTypeName(int iId) throws Exception {
    	UserUsecaseType status = new UserUsecaseType(iId);
    	status.load();
    	return status.getName();
    }

    public static UserUsecaseType getUserUsecaseType (int iId) throws Exception {
		UserUsecaseType status = new UserUsecaseType(iId);
		status.load();
		return status;
	}

}

