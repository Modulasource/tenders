/****************************************************************************
Studio Matamore - France 2004
Contact : studio@matamore.com - http://www.matamore.com
****************************************************************************/
/*
 * Created on 2 nov. 2004
 *
 */
package org.coin.fr.bean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.ConnectionManager;

/**
 * @deprecated il faut passer par BoampCPFItem
 */
public class CompetenceMarche extends CoinDatabaseAbstractBean {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	// cf grosse bidouille iIdMarche = lId: protected int iIdMarche;
	protected int iIdCompetence;

    public CompetenceMarche(){
    	this.init();
    }
    
    public CompetenceMarche(int iIdMarche,int iIdCompetence){
    	init();
    	// cf grosse bidouille
    	this.lId = iIdMarche;
    	this.iIdCompetence = iIdCompetence;
    }

    public CompetenceMarche(int iIdMarche){
    	init();
    	// cf grosse bidouille
    	this.lId = iIdMarche;
    }
    
    public void init(){
		this.TABLE_NAME = "competence_par_marche";
		/** 
		 * TODO : Grosse bidouille
		 * en fait c'est une table sans clé primaire 
		 * on a le couple (id_marche, id_competence).
		 * 
		 */
		this.FIELD_ID_NAME = "id_marche" ;
		this.bAutoIncrement = false;
		this.SELECT_FIELDS_NAME 
			= "id_competence";
 
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 
 	
    	// cf grosse bidouille
		//this.iIdMarche = 0;

		this.iIdCompetence = 0;
  	}
    
    /* GETTERs */
    public void setIdCompetence(int iIdCompetence){
    	this.iIdCompetence = iIdCompetence;
    }
    public void setIdMarche(int iIdMarche) {
       	// cf grosse bidouille
    	this.lId = iIdMarche;
    }

    /* SETTERs */
    public int getIdCompetence(){
    	return this.iIdCompetence;
    }
    public int getIdMarche(){
       	// cf grosse bidouille
    	return (int)this.lId;
    }
    
    /**
     * Méthode renvoyant les compétences associées au marché identifié
     * @param iIdMarche - identifiant du marché
     * @return un Vector d'objets CompetenceMarche ou un Vector null
     * @throws NamingException 
     * @throws SQLException 
     * @throws IllegalAccessException 
     * @throws InstantiationException 
     */
    public static Vector<CompetenceMarche> getAllCompetencesFromMarche(int iIdMarche)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		CompetenceMarche item =  new CompetenceMarche();
    	return item.getAllWithWhereAndOrderByClause( " WHERE id_marche = " + iIdMarche, "");
    }
    public static Vector<CompetenceMarche> getAllCompetencesFromMarche(int iIdMarche,Connection conn)
    throws NamingException, SQLException, InstantiationException, IllegalAccessException {
		CompetenceMarche item =  new CompetenceMarche();
    	return item.getAllWithWhereAndOrderByClause( " WHERE id_marche = " + iIdMarche, "",conn);
    }
 
	/**
	 * Méthode supprimant un enregistrement correspondant à un objet CompetenceMarche dans la base
	 * @throws SQLException 
	 * @throws NamingException 
	 * 
	 */
	public void removeAll() throws NamingException, SQLException {
		CompetenceMarche.removeAllFromMarche(this.lId);
	}

	/**
	 * Méthode supprimant un enregistrement correspondant à un objet CompetenceMarche dans la base
	 * @throws SQLException 
	 * @throws NamingException 
	 */
	public static void removeAllFromMarche(long iIdMarche) throws NamingException, SQLException {
		CompetenceMarche item =  new CompetenceMarche();
		String sSqlQuery 
			= "DELETE FROM " + item.TABLE_NAME + " WHERE " 
			+ item.FIELD_ID_NAME + "="+ iIdMarche ;
		ConnectionManager.executeUpdate(sSqlQuery);
	}

	
	public void remove() throws NamingException, SQLException {
		// grosse bidouille iIdMarche = lId
		CompetenceMarche.remove(this.lId,this.iIdCompetence);
	}
	

	public static void remove(long iIdMarche, long iIdCompetence) throws NamingException, SQLException {
		CompetenceMarche item =  new CompetenceMarche();
		String sSqlQuery 
			= "DELETE FROM " + item.TABLE_NAME 
			+ " WHERE " + item.FIELD_ID_NAME + "="+ iIdMarche 
			+ " AND id_competence="+iIdCompetence  ;

		ConnectionManager.executeUpdate(sSqlQuery);
	}

	@Override
	public String getName() {
		return "competence_marche_" + this.lId + "_" + this.iIdCompetence;
	}

	public void setFromForm(HttpServletRequest request, String sFormPrefix) throws SQLException, NamingException {
		
	}

	public void setFromResultSet(ResultSet rs) throws SQLException {
		this.iIdCompetence = rs.getInt(1);
	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		ps.setInt(1, this.iIdCompetence);
		
	}
}
