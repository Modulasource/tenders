/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package org.coin.bean;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseCreateException;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;


@RemoteProxy
public class UserUsecase extends CoinDatabaseAbstractBean  {

	private static final long serialVersionUID = 1L;

	public static final int SELECT_FIELDS_SIZE = 3;

	protected long lIdUserUsecaseType;
	protected long lIdUser;
	protected String sIdUseCase;


	public void setPreparedStatement (PreparedStatement ps ) throws SQLException
	{
		int i = 0;
		ps.setLong(++i, this.lIdUserUsecaseType);
		ps.setLong(++i, this.lIdUser);
		ps.setString(++i, this.sIdUseCase);
	}

	public void setFromResultSet(ResultSet rs) throws SQLException
	{
		int i = 0;
		this.lIdUserUsecaseType = rs.getLong(++i);
		this.lIdUser = rs.getLong(++i);
		this.sIdUseCase = rs.getString(++i);
	}
	/**
	 * Constructeur
	 *
	 */
	public UserUsecase() {
		init();
	}


	/**
	 * Constructeur
	 * @param id - identifiant de l'enregistrement correspondant dans la base
	 * @throws Exception
	 */
	public UserUsecase(long lIdCaption) {
		init();
		this.lId = lIdCaption;
	}

	/**
	 * Initilisation
	 */
	public void init() {

		this.TABLE_NAME = "coin_user_usecase";
		this.FIELD_ID_NAME = "id_" + this.TABLE_NAME ;

		this.SELECT_FIELDS_NAME
			= " id_coin_user_usecase_type,"
			+ " id_coin_user,"
			+ " id_use_case";

		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ;

		this.lId = -1;
		this.lIdUserUsecaseType = -1;
		this.lIdUser = -1;
		this.sIdUseCase = "";

	}

	public void setFromFormUTF8(HttpServletRequest request, String sFormPrefix)
	{
		setFromForm(request, sFormPrefix);
		this.sIdUseCase = Outils.decodeUtf8 (request.getParameter(sFormPrefix + "sIdUseCase"));
	}


	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{
		this.sIdUseCase = request.getParameter(sFormPrefix + "sIdUseCase");
		this.lIdUserUsecaseType= Long.parseLong(request.getParameter(sFormPrefix + "lIdUserUsecaseType"));
		this.lIdUser= Long.parseLong(request.getParameter(sFormPrefix + "lIdUser"));

	}

	public static Vector<UserUsecase> getAllFromIdUser(long lIdUSer)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		return getAllWithWhereAndOrderByClauseStatic(
				" WHERE id_coin_user=" + lIdUSer , " ORDER BY id_use_case ");
	}


	public static Vector<UserUsecase> getAllFromIdUser(long lIdUSer, long lIdUserUsecaseType)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		return getAllWithWhereAndOrderByClauseStatic(
				" WHERE id_coin_user=" + lIdUSer
				+ " AND id_coin_user_usecase_type=" + lIdUserUsecaseType,
				" ORDER BY id_use_case ");
	}

	public static Vector<UserUsecase> getAllWithSqlQueryStatic(String sSQLQuery)
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		UserUsecase item = new UserUsecase ();
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	public static Vector<UserUsecase> getAllStatic()
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {

		UserUsecase item = new UserUsecase ();
		String sSQLQuery
		= "SELECT " + item.SELECT_FIELDS_NAME + ", " + item.FIELD_ID_NAME
		+ " FROM " + item.TABLE_NAME;
		return getAllWithSqlQuery(sSQLQuery, item);
	}

	@SuppressWarnings("unchecked")
	public <T> Vector<T> getAllWithSqlQuery(String sSqlquery) throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		return (Vector<T>) getAllWithSqlQueryStatic(sSqlquery);
	}

	public static Vector<UserUsecase> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause)
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		UserUsecase item = new UserUsecase();
	return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}

	public static UserUsecase getUserUsecase(int iId) throws CoinDatabaseLoadException, NamingException, SQLException
	{
		return getUserUsecase((long)iId);
	}

	public static UserUsecase getUserUsecase(long iId) throws CoinDatabaseLoadException, NamingException, SQLException
	{
		UserUsecase item = new UserUsecase(iId);
		item.load();
		return item;
	}


	@Override
	public String getName() {
		return this.sIdUseCase + "_" + this.lIdUserUsecaseType + "_" + this.lIdUser;


	}

	public String getIdUseCase() {
		return this.sIdUseCase;
	}


	public long getIdUser() {
		return this.lIdUser;
	}

	public long getIdUserUsecaseType() {
		return this.lIdUserUsecaseType;
	}

	public void setIdUser(long idUser) {
		this.lIdUser = idUser;
	}

	public void setIdUserUsecaseType(long idUserUsecaseType) {
		this.lIdUserUsecaseType = idUserUsecaseType;
	}

	public void setIdUseCase(String idUseCase) {
		this.sIdUseCase = idUseCase;
	}
	
	@RemoteMethod
    public static void updateManageable(long iIdUser, String sCU) throws JSONException, InstantiationException, IllegalAccessException, NamingException, SQLException, CoinDatabaseCreateException, CoinDatabaseDuplicateException, CoinDatabaseLoadException {
    	JSONArray jsonCU = new JSONArray(sCU);
    	Vector<UserUsecase> vUserCU = UserUsecase.getAllFromIdUser(iIdUser);
    	for(int i=0;i<jsonCU.length();i++){
    		JSONObject cu = jsonCU.getJSONObject(i);
    		String sIdCU = cu.getString("id");
    		int iValue = cu.getInt("value");
    		boolean bFindRemoveCU = false;

    		for(UserUsecase uuc : vUserCU){
    			if(iValue==1 && uuc.getIdUseCase().equalsIgnoreCase(sIdCU)){
    				/*
    				 * c'est coché mais comme on gere que les remove 
    				 * Un element coché est un élément original
    				 * on en as donc pas besoin dans cette table
    				 * car il est inutile de l'ajouter 2 fois
    				 */
    				uuc.remove();
    			}
    			if(iValue==0 
    			&& uuc.getIdUseCase().equalsIgnoreCase(sIdCU) 
    			&& uuc.getIdUserUsecaseType()==UserUsecaseType.TYPE_REMOVE){
    				bFindRemoveCU = true;
    			}
    		}

    		if(iValue==0 && !bFindRemoveCU){
    			UserUsecase uuc = new UserUsecase();
    			uuc.setIdUseCase(sIdCU);
    			uuc.setIdUser(iIdUser);
    			uuc.setIdUserUsecaseType(UserUsecaseType.TYPE_REMOVE);
    			uuc.create();
    		}
    	}
    }

}