/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/

/*
 * Created on 23 oct. 2004
 *
 */
package org.coin.bean;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.security.HabilitationException;
import org.coin.util.Outils;

/**
 * @author d.keller
 *
 */
public class UserHabilitation implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	protected Vector<UseCase> vUseCases;
	protected Vector<UseCase> vUseCasesManageable;
	protected long lIdUser;
	protected User user;
	protected boolean bIsInstantiate;
	protected boolean bIsSuperUser;
	protected boolean bIsDebugSession;
	protected Vector<Group> vGroups;
	protected Vector<Group> vGroupsManageable;

	public Vector<Group> getGroups() {
		return this.vGroups;
	}

	public void setGroups(Vector<Group> groups) {
		this.vGroups = groups;
	}
	
	public Vector<Group> getGroupsManageable() throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		if(this.bIsSuperUser)
			this.vGroupsManageable = Group.getAllStaticMemory();
		return this.vGroupsManageable;
	}

	public void setGroupsManageable(Vector<Group> groups) {
		this.vGroupsManageable = groups;
	}

	public long getIdUser() {
		return this.lIdUser;
	}

	public void setIdUser(long idUser) throws CoinDatabaseLoadException, SQLException, NamingException {
		this.lIdUser = idUser;
		if(lIdUser>0){
			this.user = User.getUser((int)idUser);
		}
	}
	
	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}
	
	public UserHabilitation ()
	{
		this.lIdUser = 0;
		this.vUseCases = null;
		this.bIsInstantiate = false;
		this.bIsSuperUser = false;
		this.bIsDebugSession = false;
		this.vGroups = new Vector<Group>();
		this.vGroupsManageable = new Vector<Group>();
	}
	
	public UserHabilitation (User user)
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		this.user = user;
		this.lIdUser = user.getId();
		this.vGroups = new Vector<Group>();
		this.vGroupsManageable = new Vector<Group>();
		
		this.setUseCases((int)this.lIdUser);
		this.bIsInstantiate = true;
		this.bIsSuperUser = false;
		this.bIsDebugSession = false;
	}
	
	public UserHabilitation (int iIdUser)
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		this.vGroups = new Vector<Group>();
		this.vGroupsManageable = new Vector<Group>();
		this.setIdUser(iIdUser);
		this.setUseCases(iIdUser);
		this.bIsInstantiate = true;
		this.bIsSuperUser = false;
		this.bIsDebugSession = false;
	}

	public Vector<UseCase> getUseCases()
	{
		return this.vUseCases;
	}
	
	public Vector<UseCase> getUseCasesManageable(){
		return this.vUseCasesManageable;
	}
	
	public void setUseCases(int iIdUser,boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException{
		this.vGroups = UserGroup.getAllGroup(iIdUser);
		this.vGroupsManageable = UserGroup.getAllGroup(iIdUser,CoinUserGroupType.TYPE_MANAGEABLE);
		
		ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdUser(this.vGroups,iIdUser,bUseDifferential);
		this.vUseCases = arrCU.get(0);
		this.vUseCasesManageable = arrCU.get(1);
	}
	
	public void setUseCasesFromGroup(int iIdGroup) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException{
		this.vGroups = new Vector<Group>();
		this.vGroups.add(Group.getGroupMemory(iIdGroup));
		
		if(this.bIsSuperUser)
			this.vGroupsManageable = Group.getAllStaticMemory();
		else
			this.vGroupsManageable = UserGroup.getAllGroup(this.lIdUser,CoinUserGroupType.TYPE_MANAGEABLE);
		
		ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdGroup(iIdGroup);
		this.vUseCases = arrCU.get(0);
		this.vUseCasesManageable = arrCU.get(1);
	}
	
	public void setUseCases(int iIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException{
		setUseCases(iIdUser,true);
	}
	
	public String getGroupName(){
		String sGroupName = "";
		for(int i=0;i<this.vGroups.size();i++){
			sGroupName+=this.vGroups.get(i).getName();
			if(i!=(vGroups.size()-1))
				sGroupName+=", ";
		}
		if(Outils.isNullOrBlank(sGroupName) && this.bIsSuperUser){
			sGroupName = "Super Admin";
		}
		return sGroupName;
	}
	
	public void setHabilitations (int iIdUser) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		this.setIdUser(iIdUser);
		this.setUseCases(iIdUser);
		this.bIsInstantiate = true;
	}
	
	public void setHabilitations(int iIdUser, int iIdGroup) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		this.setIdUser(iIdUser);
		this.setUseCasesFromGroup(iIdGroup);
		this.bIsInstantiate = true;
	}
	
	
	public void setHabilitations (long lIdUser, boolean bUseDifferential) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		this.setIdUser((int)lIdUser);
		if(this.bIsSuperUser)
		{
			// on a pas besoin de la liste des use cases
			this.vUseCases = new Vector<UseCase>();
		}
		else
		{	
			this.setUseCases((int)lIdUser,bUseDifferential);
		}
		this.bIsInstantiate = true;
	}

	public void addUseCase(UseCase useCase) 
	{
		this.vUseCases.add(useCase);
	}
	

	public void setAsSuperUser() {this.bIsSuperUser = true; }
	public void unsetAsSuperUser() {this.bIsSuperUser = false; }
	public void setDebugSession() {this.bIsDebugSession = true; }
	public void setDebugSession(boolean bValue) {this.bIsDebugSession = bValue; }
	
	public boolean isInstantiate() {return this.bIsInstantiate; }
	public boolean isSuperUser () {return this.bIsSuperUser; }
	public boolean isDebugSession () {return this.bIsDebugSession; }

	/**
	 * to close properly the db conn
	 * 
	 * @param sUseCaseId
	 * @param conn
	 * @throws HabilitationException
	 */
	public void isHabilitateException(
			String sUseCaseId,
			Connection conn)
	throws HabilitationException
	{
		if(!isHabilitate(sUseCaseId))
		{
			try {
				ConnectionManager.closeConnection(conn);
			} catch (SQLException e) {
			}
			throw new HabilitationException("You aren't allowed for this use case : " + sUseCaseId, sUseCaseId);
		}
	}

	public void isHabilitateException(String sUseCaseId)
	throws HabilitationException
	{
		if(!isHabilitate(sUseCaseId))
		{
			throw new HabilitationException("You aren't allowed for this use case : " + sUseCaseId, sUseCaseId);
		}
	}
	
	public boolean isHabilitate(String sUseCaseId)
	{
		if(sUseCaseId == null) return false;
		if("".equals(sUseCaseId)) return false;

		if(!this.bIsInstantiate) return false;

		if(this.bIsSuperUser) return true;
			
		for (int i = 0; i < this.vUseCases.size(); i++) {
			UseCase usecase = (UseCase ) this.vUseCases.get(i);
			
			if(usecase.getIdString().equals(sUseCaseId))
				return true;
		}
		
		return false;
	}
	
	public void displayOnConsoleUseCase()
	{
		for (int i = 0; i < this.vUseCases.size(); i++)
		{
			UseCase uc = (UseCase) this.vUseCases.get(i);
			System.out.println("UseCase habilitate  : " + uc.getIdString() );

		}

	}
	
}
