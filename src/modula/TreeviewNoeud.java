/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package modula;

import java.io.Serializable;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Collections;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletResponse;

import org.coin.bean.Group;
import org.coin.bean.GroupRole;
import org.coin.bean.Role;
import org.coin.bean.User;
import org.coin.bean.UserGroup;
import org.coin.bean.UserHabilitation;
import org.coin.bean.UserType;
import org.coin.bean.conf.Configuration;
import org.coin.bean.conf.Treeview;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.ConnectionManager;
import org.coin.util.treeview.TreeviewHabilitationUser;
import org.coin.util.treeview.TreeviewHabilitationUserType;
import org.coin.util.treeview.TreeviewNode;
import org.coin.util.treeview.TreeviewParsing;


/**
 * @author d.keller
 *
 */
public class TreeviewNoeud implements Serializable{

	private static final long serialVersionUID = 3257844381238439984L;

	public static final String FIELD_NAME_ID_ROLE = "id_mt_user_type" ;

    public static Vector<Integer> getHabilitationsFromIdUser(int iIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	return getHabilitationsFromIdUser((long) iIdUser);
    }

    public static Vector<Integer> getHabilitationsFromIdUser(long iIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	UserHabilitation userHabilitation = new UserHabilitation((int)iIdUser);
    	return getHabilitationsFromUserHabilitations(userHabilitation);
    }
    
    public static Vector<Integer> getHabilitationsFromUser(User user) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	return getHabilitationsFromUser(user, true);
    }
    public static Vector<Integer> getHabilitationsFromUser(User user,boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	UserHabilitation userHabilitation = new UserHabilitation(user);
    	return getHabilitationsFromUserHabilitations(userHabilitation,bUseDifferential);
    }

    public static Vector<Integer> getHabilitationsFromUserHabilitations(UserHabilitation userHabilitation) throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	return getHabilitationsFromUserHabilitations(userHabilitation, true);
    }
    public static Vector<Integer> getHabilitationsFromUserHabilitations(UserHabilitation userHabilitation,boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException
    {
    	Vector<Group> vGroups = userHabilitation.getGroups();
    	Vector<Integer> vTreeviewHab = new Vector<Integer>();
    	Vector<Integer> vTreeviewHabTemp = null;
    	
    	for (Group group : vGroups)
    	{
			vTreeviewHabTemp = getHabilitationsFromIdGroup(userHabilitation.getIdUser(),(int)group.getId(),bUseDifferential);
			
			for (int j = 0; j < vTreeviewHabTemp.size(); j++) 
			{
				vTreeviewHab.add( vTreeviewHabTemp.get(j) ); 
				
			}
		}
    	return vTreeviewHab;
    }

    public static Vector<Treeview> getTreeviewFromIdUser(int iIdUser) 
    throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
       	UserHabilitation userHabilitation = new UserHabilitation(iIdUser);
    	return getTreeviewFromHabilitation(userHabilitation);
    }
    
    public static Vector<Treeview> getTreeviewFromIdUser(User user) 
    throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	UserHabilitation userHabilitation = new UserHabilitation(user);
    	return getTreeviewFromHabilitation(userHabilitation);
    }

    public static Vector<Treeview> getTreeviewFromHabilitation(UserHabilitation userHabilitation) 
    throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
    {
    	Vector<Treeview > vTreeview = new Vector<Treeview >();

    	if( userHabilitation.getUser().getIdUserType() == UserType.TYPE_ADMINISTRATEUR )
    	{
    		return Treeview.getAllStatic();
    	}

    	for (Group group : userHabilitation.getGroups()) 
    	{
    		vTreeview.addAll(getTreeviewFromIdGroup((int)group.getId()));
    	}

    	/**
    	 * pour vérifier que l'on a pas de doublon.
    	 */
    	Vector<Treeview > vTreeviewClean = new Vector<Treeview >();
  		for (int i = 0; i < vTreeview.size(); i++) 
    	{
    		Treeview tv = (Treeview)vTreeview.get(i);
        	boolean bAddInList = true;
    		for (int j = 0; j < vTreeviewClean.size(); j++) 
        	{
        		Treeview tv2 = (Treeview)vTreeviewClean.get(j);
        		if(tv2.getId() == tv.getId())
        		{
        			bAddInList = false;
        		}
        	}
    		if(bAddInList )
    		{
    			vTreeviewClean.add(tv);
    		}
        }

    	
    	if(vTreeviewClean.size() == 0)
    	{
    		// il faut au moins ajouter la premiere treeview qui commence avec le noeud 1.
    		Treeview tv = new Treeview();
    		tv.setName("Desk");
    		tv.setIdMenuTreeview(1);
    		vTreeviewClean.add(tv);
    	}

    	return vTreeviewClean;
    }

   /**
    *  Renvoie l'Id de la Treeview du premier groupe du premier Role, sinon renvoi la 
    *  treeview d'ID = 1 (qui doit toujours être paramétrée)
	*
    * @param iIdUser
    * @return
    * @throws SQLException
    * @throws NamingException
    * @throws InstantiationException
    * @throws IllegalAccessException
    */
   public static long getIdTreeviewFromIdUser(long lIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException
   {
	   Vector<Group> vGroups = UserGroup.getAllGroup((int)lIdUser);

	   for (int i = 0; i < vGroups.size(); i++) 
	   {
		   Group group = (Group) vGroups .get(i);
		   long lId = getIdTreeviewFromIdGroup((int)group.getId());
		   if(lId > 0)
			   return lId;
	   }
	   return 1L;
   }
   /**
    * Return all ids from Treeview for 1st group, 1st rule
    * @param lIdUser
    * @return
    * @throws SQLException
    * @throws NamingException
    * @throws InstantiationException
    * @throws IllegalAccessException
    */
   public static Vector<Long> getAllIdTreeviewFromIdUser(long lIdUser) throws SQLException, NamingException, InstantiationException, IllegalAccessException
   {
	   Vector<Group> vGroups = UserGroup.getAllGroup((int)lIdUser);
	   Vector<Long> vIds = new Vector<Long>();

	   for (int i = 0; i < vGroups.size(); i++) 
	   {
		   Group group = (Group) vGroups .get(i);
		   long lId = getIdTreeviewFromIdGroup((int)group.getId());
		   if(lId > 0) vIds.add(lId);
	   }
	   return vIds;
   }

	public static Vector<Integer> getHabilitationsFromIdGroup(int iIdGroup) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		return getHabilitationsFromIdGroup(0, iIdGroup, false);
	}
	public static Vector<Integer> getHabilitationsFromIdGroup(long lIdUser, int iIdGroup, boolean bUseDifferential) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
	 	Vector<Role> vRoles = GroupRole.getAllRole(iIdGroup);
    	Vector <Integer>vTreeviewHab = new Vector<Integer>();
    	Vector <Integer>vTreeviewHabTemp = null;
    	
    	for (int i = 0; i < vRoles.size(); i++) 
    	{
			Role role = (Role) vRoles.get(i);
			vTreeviewHabTemp = getHabilitations(lIdUser,(int)role.getId(),bUseDifferential);
			
			for (int j = 0; j < vTreeviewHabTemp.size(); j++) 
			{
				vTreeviewHab.add( vTreeviewHabTemp.get(j) ); 
				
			}
		}
    	return vTreeviewHab;
 
	}	
	
	/**
	 * 
	 * Renvoi l'Id de la Treeview du premier Role, sinon renvoi la treeview d'ID = 1 (qui doit toujours être paramétrée)
	 * 
	 * @param iIdGroup
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public static long getIdTreeviewFromIdGroup(int iIdGroup) throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
		Vector<Role> vRoles = GroupRole.getAllRole(iIdGroup);
    	
    	for (int i = 0; i < vRoles.size(); i++) 
    	{
			Role role = (Role) vRoles.get(i);
			if(role.getIdTreeview() > 0)
				return role.getIdTreeview();
		}
    	return 1L;
 
	}	

	public static Vector<Treeview > getTreeviewFromIdGroup(int iIdGroup) 
	throws SQLException, NamingException, InstantiationException, IllegalAccessException, CoinDatabaseLoadException
	{
		Vector<Treeview > vTreeview = new Vector<Treeview >();
		Vector<Role> vRoles = GroupRole.getAllRole(iIdGroup);
    	
		for (int i = 0; i < vRoles.size(); i++) 
    	{
			Role role = (Role) vRoles.get(i);
			if(role.getIdTreeview() != 0)
			{
				vTreeview.add( Treeview.getTreeview(role.getIdTreeview()));
			}	
			
		}
		return vTreeview;
 
	}	


	/**
	 * Récupération de la treeview dans un vector 
	 * @return le vector contenant la treeview
	 * @throws NamingException 
	 * @throws SQLException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static Vector<Integer> getHabilitations(int iIdRole) throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		return getHabilitations(0, iIdRole, false);
	}
	public static Vector<Integer> getHabilitations(long lIdUser,int iIdRole,boolean bUseDifferential) throws NamingException, SQLException, InstantiationException, IllegalAccessException
	{
		Vector<Integer> arrHabilitations = new Vector<Integer>();
		String requete = "SELECT id_noeud " 
			+ " FROM habilitations_treeview "
			+ " WHERE " + FIELD_NAME_ID_ROLE + "=" + iIdRole
			+ " ORDER BY id_noeud ASC ";
		
		Connection conn = null;
		Statement stat = null;
		ResultSet rs = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement();
			rs = stat.executeQuery(requete);
			
			while (rs.next()) {
				int iHabNodeId = rs.getInt(1);
				
				arrHabilitations.add(new Integer(iHabNodeId ));
			}
			
			rs.close();
			stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (rs != null) rs.close();
			if (stat != null) stat.close();
			if (conn != null) conn.close();
		} catch (Exception e) {}
		
		if(bUseDifferential){
			Vector<TreeviewHabilitationUser> vTvUser = TreeviewHabilitationUser.getAllFromUser(lIdUser);
			for(TreeviewHabilitationUser tvUser : vTvUser){
				Integer oNode = new Integer((int)tvUser.getIdMenuTreeview());
				boolean bNodeExist = arrHabilitations.contains(oNode);
				
				if(tvUser.getIdTreeviewHabilitationUserType()==TreeviewHabilitationUserType.TYPE_REMOVE
				&& bNodeExist)
					arrHabilitations.remove(oNode);
				
				if(tvUser.getIdTreeviewHabilitationUserType()==TreeviewHabilitationUserType.TYPE_ADD
				&& !bNodeExist)
					arrHabilitations.add(oNode);
			}
		}
		Collections.sort(arrHabilitations);
		
		return arrHabilitations;
	}

	/**
	 * Récupération de la treeview dans un vector 
	 * @return le vector contenant la treeview
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public static void removeHabilitations(int iMtUserType ) throws NamingException, SQLException
	{
		String sSqlQuery = "DELETE FROM habilitations_treeview "
			+ " WHERE " + FIELD_NAME_ID_ROLE + " =" + iMtUserType;
		
		ConnectionManager.executeUpdate(sSqlQuery);
	}
	
	public static void removeHabilitation(int iMtUserType, int iIdNode ) throws NamingException, SQLException
	{
		String sSqlQuery = "DELETE FROM habilitations_treeview "
			+ " WHERE " + FIELD_NAME_ID_ROLE + " =" + iMtUserType + " AND id_noeud = " + iIdNode;
		
		ConnectionManager.executeUpdate(sSqlQuery);
	}
		
	
	/**
	 * Ajoute un enregistrement de MarchePieceJointe correspondant à l'objet appelant
	 * @return true si réussite, false si échec
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public static void createHabilitation( int iIdMtUserType, int iIdNoeud) throws NamingException, SQLException {
		String sSQLQuery = "INSERT INTO habilitations_treeview "
		+ " (id_noeud, " + FIELD_NAME_ID_ROLE + ") "
		+ " VALUES ( ?, ?)";
		
		Connection conn = null;
		Statement stat = null;
		PreparedStatement ps = null;
		
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			stat = conn.createStatement(java.sql.ResultSet.TYPE_FORWARD_ONLY,
                    java.sql.ResultSet.CONCUR_UPDATABLE);
			ps = (stat.getConnection()).prepareStatement(sSQLQuery);

			ps.setInt(1, iIdNoeud);
			ps.setInt(2, iIdMtUserType);
			
			ps.executeUpdate();
			
			ps.close();
		    stat.close();
			conn.close();
		}
		catch (SQLException e) {
			throw e;
		}
		
		try {
			if (ps != null) ps.close();
			if (stat != null) stat.close();
			if (conn != null) conn.close();
		} catch (Exception e) {}
		
	}

	/**
	 * Renvoie le menu correspondant à l'identifiant du type d'utilisateur
	 * @param iMtUserType - identifiant du type d'utilisateur
	 * @return une chaîne de caractère constituant le menu
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws CoinDatabaseLoadException 
	 * @throws IllegalAccessException 
	 * @throws InstantiationException 
	 */
	public static String getXmlMenu(User user, String sRootPath, HttpServletResponse response ) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		return getXmlMenu(user,sRootPath,response,true);
	}

	public static String getXmlMenu(
			User user, 
			String sRootPath, 
			HttpServletResponse response, 
			boolean bUseHttpPrevent  ) 
	throws SQLException, NamingException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		return getXmlMenu(1, user,sRootPath,response,bUseHttpPrevent, false, 0);
	}
	
	public static String getXmlMenu(
			long lIdRootNode, 
			User user, 
			String sRootPath, 
			HttpServletResponse response,
			boolean bUseHttpPrevent ,
			boolean bUseLocalization ,
			int iAbstractBeanIdLanguage) 
	throws SQLException, NamingException, CoinDatabaseLoadException, 
	InstantiationException, IllegalAccessException
	{
		UserHabilitation userHabilitation = new UserHabilitation(user);
		return getXmlMenu(lIdRootNode,
				userHabilitation,
				sRootPath,
				response,
				bUseHttpPrevent,
				bUseLocalization,
				iAbstractBeanIdLanguage);
	}

	/**
	 * synchronized is mandatory because a lot of AJAX queries on menu.jsp are launched when 
	 * a session account on the desk is open, 
	 * 
	 * @param lIdRootNode
	 * @param userHabilitation
	 * @param sRootPath
	 * @param response
	 * @param bUseHttpPrevent
	 * @param bUseLocalization
	 * @param iAbstractBeanIdLanguage
	 * @return
	 * @throws SQLException
	 * @throws NamingException
	 * @throws CoinDatabaseLoadException
	 * @throws InstantiationException
	 * @throws IllegalAccessException
	 */
	public static synchronized String getXmlMenu(
			long lIdRootNode, 
			UserHabilitation userHabilitation, 
			String sRootPath, 
			HttpServletResponse response,
			boolean bUseHttpPrevent ,
			boolean bUseLocalization ,
			int iAbstractBeanIdLanguage) 
	throws SQLException, NamingException, CoinDatabaseLoadException, 
	InstantiationException, IllegalAccessException
	{
		StringBuffer sbXmlMenu = new StringBuffer("");


		TreeviewParsing tvp = new  TreeviewParsing(0) {

			private static final long serialVersionUID = 1L;
			public void preTraitment(TreeviewNode node, Object context){

				StringBuffer sbMenu = (StringBuffer )context;
				node.setAbstractBeanLocalization(this.iAbstractBeanIdLanguage) ;
				sbMenu.append("<menu num='" + node.getId() + "'");
				sbMenu.append(" libelle=\"" + node.getName() + "\"");
				//sbMenu.append(" libelle=\"" + node.sNodeLabel + "\"");
				sbMenu.append(" lien=\"" + node.sURLLink + "\"");
				sbMenu.append(" icone=\"" + node.sIconName + "\"");
				sbMenu.append(" infobulle=\"" + node.sTooltip + "\"");
				if (node.iFirstChildNode == 0)
				{
					sbMenu.append(" /");
				}

				sbMenu.append(">\n");

			}
			public void postTraitment(TreeviewNode node, Object context){
				StringBuffer sbMenu = (StringBuffer )context;

				if (node.iFirstChildNode != 0)
				{
					sbMenu.append("</menu >\n");
				}

			}

		};
		tvp.bUseLocalization = bUseLocalization;
		tvp.iAbstractBeanIdLanguage = iAbstractBeanIdLanguage;
		
		Vector arrTreeViewNoeuds = TreeviewNode.getAll(sRootPath,bUseHttpPrevent);
		// TODO DK pour perf
		/*TreeviewNode.rootPath = sRootPath;
		Vector arrTreeViewNoeuds = null;
		try {
			arrTreeViewNoeuds = TreeviewNode.getAllStaticMemory();
		} catch (InstantiationException e) {
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			e.printStackTrace();
		}
		 */

		for (int i = 0; i < arrTreeViewNoeuds.size(); i++) {
			TreeviewNode node = (TreeviewNode ) arrTreeViewNoeuds.get(i);
			if(! "".equals(node.sURLLink))
				node.sURLLink = response.encodeURL( node.sURLLink );
		}

		// affichage complet pour l'Administrateur (super user)
		if( userHabilitation.getUser().getIdUserType() == UserType.TYPE_ADMINISTRATEUR )
		{
			tvp.visit((int)lIdRootNode , arrTreeViewNoeuds , sbXmlMenu);
		}
		else
		{
			Vector<Integer> vHabilitation = TreeviewNoeud.getHabilitationsFromUserHabilitations(userHabilitation);
			tvp.visitWithHabilitation((int)lIdRootNode , arrTreeViewNoeuds, vHabilitation, sbXmlMenu);
		}

		String sXMLHeader = "<lemenu libelle=\"ADMINISTRATION\">"
		+ "<options>"
		  + "<option titre=\"Style par defaut\" fichierIcone=\""
		  + response.encodeURL(sRootPath + "include/treeview/skin_tv/icones.swf") + "\" "
		  + "fond=\""
		  +response.encodeURL(sRootPath + "include/treeview/skin_tv/fond1.jpg") + "\" "
		  + "couleurTexte=\"FFFFFF\" "
		+   "couleurTxtDisable=\"CCCCCC\"/>"
		+ "</options>";

		String sTreeviewEncodage = "";
		try{sTreeviewEncodage = Configuration.getConfigurationValueMemory("treeview.encodage");}
		catch(Exception e){sTreeviewEncodage = "";}

		if(sTreeviewEncodage != null && sTreeviewEncodage.equalsIgnoreCase("UTF-8")){
			return convertToUTF8(sXMLHeader + sbXmlMenu.toString() + "</lemenu>");
		}else{
			return (sXMLHeader + sbXmlMenu.toString() + "</lemenu>");
		}
	}
	
	public static String getHtmlMenu(int iMtUserType, String sRootPath) throws CoinDatabaseLoadException, NamingException, SQLException {

		StringBuffer sbHtmlMenu = new StringBuffer("");
		
		Vector<TreeviewNode> arrTreeViewNoeuds = TreeviewNode.getAll(sRootPath);
		
		TreeviewParsing tvp = new  TreeviewParsing(0) {
			/**
			 * Comment for <code>serialVersionUID</code>
			 */
			private static final long serialVersionUID = 1L;
			public void preTraitment(TreeviewNode node, Object context){ 
				StringBuffer sbMenu = (StringBuffer )context;
				sbMenu.append("<tr>");
				this.iMaxDepth = 3;

				int i;
				for(i=0; i < this.iCurrentNodeDepth; i++)
				{
					sbMenu.append("<td>|</td>");
				}
				
				sbMenu.append("<td>-</td>");
				sbMenu.append("<td>" + node.getId() + "</td>");
				
				for(; i <= this.iMaxDepth; i++ )
				{
					sbMenu.append("<td>&nbsp;</td>");
				}
				sbMenu.append("<td>(" + node.iFirstChildNode + "," + node.iNextSiblingNode + ")</td>");
				sbMenu.append("<td>" + node.sNodeLabel + "</td>");
				sbMenu.append("<td>" + node.sURLLink + "</td>");
				sbMenu.append("<td>" + node.sIconName + "</td>");
				sbMenu.append("<td>" + node.sTooltip + "</td>");
				sbMenu.append("</tr>");
				
			}
			public void postTraitment(TreeviewNode node, Object context){
				
				if (node.iFirstChildNode != 0)
				{		

				}
				
			}

		};
		
		tvp.visit(arrTreeViewNoeuds , sbHtmlMenu);
		return convertToUTF8( sbHtmlMenu.toString() );
	}

	public static Vector getItemList(int iMtUserType, String sRootPath) throws CoinDatabaseLoadException, NamingException, SQLException {
		return getItemList(1, iMtUserType, sRootPath) ;
	}
	
	public static Vector getItemList(int iIdRootNode, int iMtUserType, String sRootPath) throws CoinDatabaseLoadException, NamingException, SQLException {

		Vector arrTreeViewNoeuds = TreeviewNode.getAll(sRootPath);
		Vector vItemList = new Vector();
		
		TreeviewParsing tvp = new  TreeviewParsing(0) {
			/**
			 * Comment for <code>serialVersionUID</code>
			 */
			private static final long serialVersionUID = 1L;


			@SuppressWarnings("unchecked")
			public void preTraitment(TreeviewNode node, Object context){ 
				Vector<TreeviewNode> vItemsList = (Vector)context;
				node.iDepth = this.iCurrentNodeDepth;
				vItemsList.add(node);
			}

			
			public void postTraitment(TreeviewNode node, Object context){	
			}

		};
		
		tvp.visit(iIdRootNode, arrTreeViewNoeuds , vItemList );
		return vItemList ;
		
	}
	
	public static Vector getItemList(int iIdRootNode, int iMtUserType, String sRootPath, Connection conn) throws CoinDatabaseLoadException, NamingException, SQLException {

		Vector arrTreeViewNoeuds = TreeviewNode.getAll(sRootPath, true, conn);
		Vector vItemList = new Vector();
		
		TreeviewParsing tvp = new  TreeviewParsing(0) {
			/**
			 * Comment for <code>serialVersionUID</code>
			 */
			private static final long serialVersionUID = 1L;


			@SuppressWarnings("unchecked")
			public void preTraitment(TreeviewNode node, Object context){ 
				Vector<TreeviewNode> vItemsList = (Vector)context;
				node.iDepth = this.iCurrentNodeDepth;
				vItemsList.add(node);
			}

			
			public void postTraitment(TreeviewNode node, Object context){	
			}

		};
		
		tvp.visit(iIdRootNode, arrTreeViewNoeuds , vItemList );
		return vItemList ;
		
	}
	public static Vector getItemListWithHabilitations(int iMtUserType, String sRootPath, Vector vHabilitation ) throws CoinDatabaseLoadException, NamingException, SQLException {
		return getItemListWithHabilitations(1, iMtUserType, sRootPath, vHabilitation );
	}
		
	public static Vector getItemListWithHabilitations(int iIdRootNode, int iMtUserType, String sRootPath, Vector vHabilitation ) throws CoinDatabaseLoadException, NamingException, SQLException {
		
		Vector arrTreeViewNoeuds = TreeviewNode.getAll(sRootPath);
		Vector vItemList = new Vector();
		
		TreeviewParsing tvp = new  TreeviewParsing(0) {
			/**
			 * Comment for <code>serialVersionUID</code>
			 */
			private static final long serialVersionUID = 1L;


			@SuppressWarnings("unchecked")
			public void preTraitment(TreeviewNode node, Object context){ 
				Vector vItemList = (Vector)context;
				node.iDepth = this.iCurrentNodeDepth;
				vItemList.add(node);
			}

			
			public void postTraitment(TreeviewNode node, Object context){								
			}

		};
		
		tvp.visitWithHabilitation(iIdRootNode , arrTreeViewNoeuds , vHabilitation , vItemList );
		return vItemList ;
		
	}
	
	
	public static void getConsoleMenu(String sRootPath) throws CoinDatabaseLoadException, NamingException, SQLException {

		TreeviewParsing tvp = new  TreeviewParsing(0) {
			/**
			 * Comment for <code>serialVersionUID</code>
			 */
			private static final long serialVersionUID = 1L;
			public void preTraitment(TreeviewNode node, Object context){ 
				int i;
				for(i=0; i < this.iCurrentNodeDepth; i++)
				{
					System.out.print("| ");
				}
				System.out.print("-" + node.getId() );
				for(; i <= this.iMaxDepth; i++ )
				{
					System.out.print("  ");
				}
				System.out.println(node.sNodeLabel);
				
					if (node.iFirstChildNode == 0)
				{
					
				}
				
				
			}
			public void postTraitment(TreeviewNode node, Object context){
		
				if (node.iFirstChildNode != 0)
				{		

				}
				
			}

		};
		
		tvp.visit(TreeviewNode.getAll(sRootPath), null);

		return ;
	}

	/* convert from UTF-8 encoded HTML-Pages -> internal Java String Format */
	public static String convertFromUTF8(String s) {
	  String out = null;
	  try {
	    out = new String(s.getBytes("ISO-8859-1"), "UTF-8");
	  } catch (java.io.UnsupportedEncodingException e) {
	    return null;
	  }
	  return out;
	}

	/* convert from internal Java String Format -> UTF-8 encoded HTML/JSP-Pages  */
	public static String convertToUTF8(String s) {
	  String out = null;
	  try {
	    out = new String(s.getBytes("UTF-8"));
	  } catch (java.io.UnsupportedEncodingException e) {
	    return null;
	  }
	  return out;
	}

	
}
