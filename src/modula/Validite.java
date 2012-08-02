/*
 * Studio Matamore - France 2005, tous droits réservés
 * Contact : studio@matamore.com - http://www.matamore.com
 *
 */
package modula;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import modula.algorithme.AffaireProcedure;
import modula.marche.MarcheLot;

import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseStoreException;
import org.coin.db.ConnectionManager;
import org.coin.util.CalendarUtil;
import org.coin.bean.*;

/**
 * @author d.keller
 *
 */

public class Validite extends CoinDatabaseAbstractBean{

	private static final long serialVersionUID = 1L;
	
	protected int iIdTypeObjetModula;
	protected Timestamp tsDateDebut;
	protected Timestamp tsDateFin;
	protected long lIdReferenceObjet;

    public Validite(long iIdValidite) 
    {
    	init();
    	this.lId = iIdValidite;
    }

    public Validite() 
    {
    	init();
    }
    
    public void init() {
		this.TABLE_NAME = "validite";
		this.FIELD_ID_NAME = "id_"+ this.TABLE_NAME ;

		this.SELECT_FIELDS_NAME 
			= " id_type_objet_modula, "
			+ " date_debut, "
			+ " date_fin, "
			+ " id_reference_objet ";
	 
		this.SELECT_FIELDS_NAME_SIZE = this.SELECT_FIELDS_NAME.split(",").length ; 

		this.lId = 0;
    	this.iIdTypeObjetModula = 0;
    	this.tsDateDebut = null;
    	this.tsDateFin = null;
    	this.lIdReferenceObjet = 0;
	}

    public static Validite getValidite(long lId,boolean bUseHttpPrevent) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	Validite item = new Validite(lId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load();
    	return item;
    }
    public static Validite getValidite(long lId,boolean bUseHttpPrevent, Connection conn) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	Validite item = new Validite(lId);
    	item.bUseHttpPrevent = bUseHttpPrevent;
    	item.load(conn);
    	return item;
    }
    
    public static Validite getValidite(long lId) 
    throws CoinDatabaseLoadException, SQLException, NamingException 
    {
    	return getValidite(lId,true);
    }
    
	public void setFromResultSet(ResultSet rs) throws SQLException {
		int i=0;
		this.iIdTypeObjetModula = rs.getInt(++i);
		this.tsDateDebut = rs.getTimestamp(++i);
		this.tsDateFin = rs.getTimestamp(++i);
		this.lIdReferenceObjet = rs.getLong(++i);
	}

	public void setPreparedStatement(PreparedStatement ps) throws SQLException {
		int i=0;
		ps.setInt(++i, this.iIdTypeObjetModula);
		ps.setTimestamp(++i, this.tsDateDebut);
		ps.setTimestamp(++i, this.tsDateFin);
		ps.setLong(++i, this.lIdReferenceObjet);
	}	

	
	public static Validite getValidite(
			int iIdTypeObjetModula, 
			int iIdReferenceObjet,
			Connection conn) 
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeFromTypeObjetModulaAndReferenceObjet(iIdTypeObjetModula,iIdReferenceObjet, conn).firstElement();
	}

	
    public static Validite getValidite(int iIdTypeObjetModula, int iIdReferenceObjet) 
    throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(iIdTypeObjetModula,iIdReferenceObjet).firstElement();
    }
    
    public static Validite getValidite(int iIdTypeObjetModula, int iIdReferenceObjet, Vector<Validite> vValidite) 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(iIdTypeObjetModula,iIdReferenceObjet,vValidite).firstElement();
    }

    public static Vector<Validite> getAllValiditeFromAffaire(int iIdAffaire) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
        
        	String sWhereClause = " WHERE id_reference_objet="+iIdAffaire;
        	return getAllWithWhereAndOrderByClauseStatic( sWhereClause ,"");
    }
        
    public static Vector<Validite> getAllValiditeAffaireFromAffaire(int iIdAffaire) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AFFAIRE,iIdAffaire);
    }

    public static Vector<Validite> getAllValiditeAffaireFromAffaire(int iIdAffaire, Vector<Validite> vValidite)
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AFFAIRE,iIdAffaire,vValidite);
    }
    
    
    public static Vector<Validite> getAllValiditeAffaireFromAffaire(int iIdAffaire,  Connection conn) 
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, IllegalAccessException
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AFFAIRE,iIdAffaire,conn);
    }
    
    public static Vector<Validite> getAllValiditeAvisRectFromAffaire(int iIdAffaire) throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AVIS_RECTIFICATIF,iIdAffaire);
    }
    
    public static Vector<Validite> getAllValiditeEnveloppeAFromAffaire(int iIdAffaire)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_A,iIdAffaire);
    }

    public static Vector<Validite> getAllValiditeEnveloppeAFromAffaire(int iIdAffaire, Connection conn)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_A,iIdAffaire, conn);
    }
    public static Vector<Validite> getAllValiditeEnveloppeAFromAffaire(int iIdAffaire, Vector<Validite> vValidite)
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_A,iIdAffaire, vValidite);
    }

    public static Vector<Validite> getAllValiditeAAPCFromAffaire(int iIdAffaire)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AAPC,iIdAffaire);
    }
    public static Vector<Validite> getAllValiditeAAPCFromAffaire(int iIdAffaire, Vector<Validite> vValidite)
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AAPC,iIdAffaire,vValidite);
    }
    public static Vector<Validite> getAllValiditeAAPCFromAffaire(int iIdAffaire, Connection conn) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AAPC,iIdAffaire, conn);
    }

    public static Vector<Validite> getAllValiditeAATRFromAffaire(int iIdAffaire) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AATR,iIdAffaire);
    }
    
    public static Vector<Validite> getAllValiditeAATRFromAffaire(int iIdAffaire, Vector<Validite> vValidite) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AATR,iIdAffaire, vValidite);
    }

    public static Vector<Validite> getAllValiditeAATRFromAffaire(
    		int iIdAffaire,
    		Connection conn) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.AATR,iIdAffaire, conn);
    }
    
    public static Vector<Validite> getAllValiditeInvitationOffreFromValiditeOffre(int iIdValiditeOffre)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.INVITATION_OFFRE,iIdValiditeOffre);
    }
 
    public static Vector<Validite> getAllValiditeInvitationOffreFromValiditeOffre(int iIdValiditeOffre, Connection conn)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.INVITATION_OFFRE,iIdValiditeOffre, conn);
    }
 
    public static Vector<Validite> getAllValiditeEnveloppeBFromAffaire(int iIdAffaire, Connection conn)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_B,iIdAffaire, conn);
    }

    public static Vector<Validite> getAllValiditeEnveloppeBFromAffaire(int iIdAffaire) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_B,iIdAffaire);
    }
    public static Vector<Validite> getAllValiditeEnveloppeBFromAffaire(int iIdAffaire, Vector<Validite> vValidite)
    {
    	return getAllValiditeFromTypeObjetModulaAndReferenceObjet(ObjectType.ENVELOPPE_B,iIdAffaire, vValidite);
    }
    
    public static Vector<Validite> getValiditeEnveloppeBCouranteFromAffaire(int iIdAffaire) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllValiditeValidesFromTypeObjetModulaAndReferenceObjetWithDoubleEnvoi(ObjectType.ENVELOPPE_B,iIdAffaire);
    }
    
	public static Vector<Validite> getAllValiditeAAPCValides()
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModulaWithDelaiUrgence(ObjectType.AAPC);
	}

	public static Vector<Validite> getAllValiditeAvisRectificatifValides()
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModula(ObjectType.AVIS_RECTIFICATIF);
	}

	public static Vector<Validite> getAllValiditeAnnoncesValides() 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModula(ObjectType.AFFAIRE);
	}
	
	public static Vector<Validite> getAllValiditeAAPCInvalides() 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence(ObjectType.AAPC);
	}
	
	public static Vector<Validite> getAllValiditeAnnoncesInvalides()
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModula(ObjectType.AFFAIRE);
	}
	
	public static Vector<Validite> getAllValiditeAATRValides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModula(ObjectType.AATR);
	}
	
	public static Vector<Validite> getAllValiditeAATRInvalides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModula(ObjectType.AATR);
	}
	
	public static Vector<Validite> getAllValiditeEnveloppeAValides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModula(ObjectType.ENVELOPPE_A );
	}

	public static Vector<Validite> getAllValiditeEnveloppeAInvalides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModula( ObjectType.ENVELOPPE_A );
	}
	
	public static Vector<Validite> getAllValiditeEnveloppeAConstituables() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModulaWithDelaiUrgence( ObjectType.ENVELOPPE_A );
	}

	public static Vector<Validite> getAllValiditeEnveloppeAInconstituables() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence( ObjectType.ENVELOPPE_A );
	}
	
	public static Vector<Validite> getAllValiditeEnveloppeBValides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModulaWithDoubleEnvoi(ObjectType.ENVELOPPE_B );
	}

	public static Vector<Validite> getAllValiditeEnveloppeBInvalides() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeInvalidesFromTypeObjetModulaWithDoubleEnvoi( ObjectType.ENVELOPPE_B );
	}
	
	public static Vector<Validite> getAllValiditeEnveloppeBConstituables() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		return getAllValiditeValidesFromTypeObjetModulaWithDelaiUrgence( ObjectType.ENVELOPPE_B );
	}

	public static Vector<Validite> getAllValiditeEnveloppeBInconstituables() throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
    	return getAllValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence( ObjectType.ENVELOPPE_B );
	}
	public static Validite getPrecValiditeEnveloppeBFromLot(int iIdLot)
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, ValidityException 
	{
		MarcheLot lot = MarcheLot.getMarcheLot(iIdLot );
		Vector<Validite> vValiditeEnveloppeB = getAllValiditeEnveloppeBFromAffaire(lot.getIdMarche());
		return getPrecValiditeEnveloppeBFromLot(lot, vValiditeEnveloppeB);

	}	
	
	public static Validite getPrecValiditeEnveloppeBFromLot(
			int iIdLot,
			Vector<MarcheLot> vMarcheLot,
			Vector<Validite> vValidite)
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, ValidityException 
	{
		MarcheLot lot = MarcheLot.getMarcheLot(iIdLot,vMarcheLot);
		Vector<Validite> vValiditeEnveloppeB = getAllValiditeEnveloppeBFromAffaire(lot.getIdMarche(),vValidite);
		return getPrecValiditeEnveloppeBFromLot(lot,vValiditeEnveloppeB);

	}	
	
	public static Validite getPrecValiditeEnveloppeBFromLot(
			MarcheLot lot,
			Vector<Validite> vValiditeEnveloppeB)
	throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
	IllegalAccessException, ValidityException 
	{
		String sExceptionMessage;
		
	
		Validite oPrecValidite = null;
		boolean bPrecValiditeTrouvee = false;
		int i = vValiditeEnveloppeB.size()-1;
		if(vValiditeEnveloppeB.size()>0)
		{
			while(i>0 && !bPrecValiditeTrouvee)
			{
				Validite oValidite = vValiditeEnveloppeB.get(i);
				if(oValidite.getId() == lot.getIdValiditeEnveloppeBCourante()) 
				{
					if(i-1 >= 0)
					{
						oPrecValidite = vValiditeEnveloppeB.get(i-1);
						bPrecValiditeTrouvee = true;
					}
					else
					{
						sExceptionMessage = "Validite.getPrecValiditeEnveloppeBFromLot - Le lot "+lot.getIdMarcheLot()+ " est deja sur sa premiere validite B";
						ValidityException e = new ValidityException (sExceptionMessage);
						throw e;
					}
				}
			i--;
			}
		}
		else
		{
			sExceptionMessage = "Validite.getPrecValiditeEnveloppeBFromLot - les validites B du marché n'ont pas été définies";
			ValidityException e = new ValidityException (sExceptionMessage);
			throw e;
		}
		
		return oPrecValidite;
	}
	
	public static Validite getNextValiditeEnveloppeBFromLot (MarcheLot lot)
	throws CoinDatabaseLoadException, ValidityException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			return getNextValiditeEnveloppeBFromLot(lot,conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		} 
	}
	
	public static Validite getNextValiditeEnveloppeBFromLot(MarcheLot lot,Connection conn) 
	throws ValidityException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		String sExceptionMessage;

		Validite oNextValidite = null;
		boolean bNextValiditeTrouvee = false;
		int i = 0;
		Vector<Validite> vValiditeEnveloppeB 
			= getAllValiditeFromTypeObjetModulaAndReferenceObjet(
					ObjectType.ENVELOPPE_B,
					lot.getIdMarche(),
					conn);
		
		if(vValiditeEnveloppeB.size()>0)
		{
			while(i<vValiditeEnveloppeB.size() && !bNextValiditeTrouvee)
			{
				Validite oValidite = vValiditeEnveloppeB.get(i);
				if(oValidite.getId() == lot.getIdValiditeEnveloppeBCourante()) 
				{
					if(i+1 < vValiditeEnveloppeB.size())
					{
						oNextValidite = vValiditeEnveloppeB.get(i+1);
						bNextValiditeTrouvee = true;
					}
					else
					{
						sExceptionMessage = "Validite.getNextValiditeEnveloppeBFromLot - Le lot est deja sur sa derniere validite B";
						ValidityException e = new ValidityException (sExceptionMessage);
						throw e;
					}
				}
			i++;
			}
		}
		else
		{
			sExceptionMessage = "Validite.getNextValiditeEnveloppeBFromLot - les validites B du marché n'ont pas été définies";
			ValidityException e = new ValidityException(sExceptionMessage);
			throw e;
		}
		
		return oNextValidite;
	}
	
	public static Validite getNextValiditeEnveloppeBFromLotWithoutException(MarcheLot lot)
	throws CoinDatabaseLoadException, ValidityException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{
		Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			return getNextValiditeEnveloppeBFromLotWithoutException(lot,conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		} 
	}
	
	public static Validite getNextValiditeEnveloppeBFromLotWithoutException(MarcheLot lot,Connection conn) 
	throws ValidityException, CoinDatabaseLoadException, NamingException, SQLException, 
	InstantiationException, IllegalAccessException 
	{

		Validite oNextValidite = null;
		boolean bNextValiditeTrouvee = false;
		int i = 0;
		Vector<Validite> vValiditeEnveloppeB 
			= getAllValiditeFromTypeObjetModulaAndReferenceObjet(
					ObjectType.ENVELOPPE_B,
					lot.getIdMarche(),
					conn);
		
		if(vValiditeEnveloppeB.size()>0)
		{
			while(i<vValiditeEnveloppeB.size() && !bNextValiditeTrouvee)
			{
				Validite oValidite = vValiditeEnveloppeB.get(i);
				if(oValidite.getId() == lot.getIdValiditeEnveloppeBCourante()) 
				{
					if(i+1 < vValiditeEnveloppeB.size())
					{
						oNextValidite = vValiditeEnveloppeB.get(i+1);
						bNextValiditeTrouvee = true;
					}
					else
					{
						return null;
					}
				}
			i++;
			}
		}
		else
		{
			return null;
		}
		
		return oNextValidite;
	}
	
    public static String getSQLValiditeFromTypeObjetModulaAndReferenceObjet(
    		int iIdTypeObjetModula,
    		int iIdReferenceObjet) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	String sWhereClause = " WHERE id_reference_objet="+iIdReferenceObjet
    						 +" AND id_type_objet_modula="+iIdTypeObjetModula
    						 +" ORDER BY date_debut";
    	return new Validite().getAllSelect()+sWhereClause;
    }
    
    public static Vector<Validite> getAllValiditeFromTypeObjetModulaAndReferenceObjet(
    		int iIdTypeObjetModula, 
    		int iIdReferenceObjet) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllWithSqlQueryStatic( 
    			getSQLValiditeFromTypeObjetModulaAndReferenceObjet(iIdTypeObjetModula,iIdReferenceObjet),
    			true);
    }
    
    public static Vector<Validite> getAllValiditeFromTypeObjetModulaAndReferenceObjet(
    		int iIdTypeObjetModula, 
    		int iIdReferenceObjet,
    		Vector<Validite> vValidite) 
    {
    	Vector<Validite> vValiditeSelected = new Vector<Validite>();
    	for (int i = 0; i < vValidite.size(); i++) {
    		Validite item  = vValidite.get(i);
    		if(item.getIdReferenceObjet() == iIdReferenceObjet
    		&& item.getIdTypeObjetModula() == iIdTypeObjetModula)
    		{
    			vValiditeSelected.add(item);
    		}
		}
    	return vValiditeSelected;
    }
	
    
    public static Vector<Validite> getAllValiditeFromTypeObjetModulaAndReferenceObjet(
    		int iIdTypeObjetModula, 
    		int iIdReferenceObjet,
    		Connection conn) 
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
    {
    	return getAllWithSqlQueryStatic( 
    			getSQLValiditeFromTypeObjetModulaAndReferenceObjet(iIdTypeObjetModula,iIdReferenceObjet),
    			true,
    			conn);
    }
	
	public static Vector<Validite> getAllValiditeInvalidesFromTypeObjetModulaAndReferenceObjetWithDelaiUrgence(
			int iTypeObjetModula, 
			int iIdReferenceObjet) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException 
	{
		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND validite.id_reference_objet="+iIdReferenceObjet
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > (validite.date_fin +  INTERVAL (marche.delai_urgence) HOUR)";
    	
    	return getAllWithWhereAndOrderByClauseStatic( sWhereClause,"" );
	}
	
	public static Vector<Validite> getAllValiditeValidesFromTypeObjetModulaAndReferenceObjetWithDelaiUrgence(
			int iTypeObjetModula, 
			int iIdReferenceObjet) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND validite.id_reference_objet="+iIdReferenceObjet
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > validite.date_debut"
							+ " AND '"+ tsDateJour + "' < (validite.date_fin +  INTERVAL (marche.delai_urgence) HOUR)";
    	
		return getAllWithWhereAndOrderByClauseStatic( sWhereClause,"" );
	}
	
	public static String getSQLValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		Validite val = new Validite();
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > (validite.date_fin +  INTERVAL (marche.delai_urgence) HOUR)";
    	
		return val.getAllSelect()+sWhereClause;
	}
	
	public static Vector<Validite> getAllValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		String sSQL = getSQLValiditeInvalidesFromTypeObjetModulaWithDelaiUrgence(iTypeObjetModula);
		return getAllWithSqlQueryStatic( sSQL,true);
	}
	
	public static Vector<Validite> getAllValiditeValidesFromTypeObjetModulaWithDelaiUrgence(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		String sSQL = getSQLValiditeValidesFromTypeObjetModulaWithDelaiUrgence(iTypeObjetModula);
		return getAllWithSqlQueryStatic( sSQL,true);
	}
	
	public static String getSQLValiditeValidesFromTypeObjetModulaWithDelaiUrgence(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		Validite val = new Validite();
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > validite.date_debut"
							+ " AND '"+ tsDateJour + "' < (validite.date_fin +  INTERVAL (marche.delai_urgence) HOUR)";
    	
		return val.getAllSelect()+sWhereClause;
	}
	
	public static String getSQLValiditeInvalidesFromTypeObjetModulaWithDoubleEnvoi(int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > (validite.date_fin +  INTERVAL (marche.timing_double_envoi) HOUR)"
							+ " ORDER BY validite.date_debut";
    	
		return new Validite().getAllSelect()+sWhereClause;
	}
	
	public static Vector<Validite> getAllValiditeInvalidesFromTypeObjetModulaWithDoubleEnvoi(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		return getAllWithSqlQueryStatic(getSQLValiditeInvalidesFromTypeObjetModulaWithDoubleEnvoi(iTypeObjetModula),true);
	}
	
	public static Vector<Validite> getAllValiditeValidesFromTypeObjetModulaWithDoubleEnvoi(
			int iTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > validite.date_debut"
							+ " AND '"+ tsDateJour + "' < (validite.date_fin +  INTERVAL (marche.timing_double_envoi) HOUR)";
    	
		return getAllWithWhereAndOrderByClauseStatic( sWhereClause,"" );
	}
	
	public static Vector<Validite> getAllValiditeValidesFromTypeObjetModulaAndReferenceObjetWithDoubleEnvoi(
			int iTypeObjetModula, int iIdReferenceObjet)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
	{
		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " validite ,marche marche"
							+ " WHERE validite.id_type_objet_modula="+iTypeObjetModula
							+ " AND validite.id_reference_objet="+iIdReferenceObjet
							+ " AND marche.id_marche = validite.id_reference_objet"
							+ " AND '"+ tsDateJour + "' > validite.date_debut"
							+ " AND '"+ tsDateJour + "' < (validite.date_fin +  INTERVAL (marche.timing_double_envoi) HOUR)";
    	
		return getAllWithWhereAndOrderByClauseStatic( sWhereClause,"" );
	}
	
	public static Vector<Validite> getAllValiditeInvalidesFromTypeObjetModula(
			int iIdTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		String sSQL = getSQLValiditeInvalidesFromTypeObjetModula(iIdTypeObjetModula);
		return getAllWithSqlQueryStatic( sSQL,true);
	}
	
	public static String getSQLValiditeInvalidesFromTypeObjetModula(int iIdTypeObjetModula) 
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " WHERE id_type_objet_modula="+iIdTypeObjetModula
    						+ " AND '"+ tsDateJour + "' > date_fin";
    	
		return new Validite().getAllSelect()+sWhereClause;
	}
	
	public static Vector<Validite> getAllValiditeValidesFromTypeObjetModula(int iIdTypeObjetModula)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {
		String sSQL = getSQLValiditeValidesFromTypeObjetModula(iIdTypeObjetModula);
		return getAllWithSqlQueryStatic( sSQL,true);
	}
	
	public static String getSQLValiditeValidesFromTypeObjetModula(int iIdTypeObjetModula)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		String sWhereClause = " WHERE id_type_objet_modula="+iIdTypeObjetModula
    						+ " AND '"+ tsDateJour + "' > date_debut "
    						+ " AND '"+ tsDateJour + "' < date_fin ";
    	
		return new Validite().getAllSelect()+sWhereClause;
	}
    
	public static String getSQLValiditeValidesFromTypeObjetModulaAndAffaireAllReadyNotOnline(
			int iIdTypeObjetModula)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		/*
		 * bIsAffaireValidee && bIsAffaireEnvoyeePublisher && !bIsAffairePublieePublisher)
		 * 
		 * WARNING : attention ici on filtre selon la procédure
		 * donc si un jour on rajoute une seconde procédure de type PA alors elle ne sera pas prise 
		 * en compte dans cette requete
		 */
		
		String sWhereClause =
							" , marche mar, marche_statut stat"
							+ " WHERE val.id_type_objet_modula="+iIdTypeObjetModula
							+ " AND val.id_reference_objet=mar.id_marche"
							+ " AND stat.id_marche=mar.id_marche"
    						+ " AND mar.id_algo_affaire_procedure =" + AffaireProcedure.AFFAIRE_PROCEDURE_PETITE_ANNONCE
    						+ " AND stat.valide=1" 
    						+ " AND stat.envoye_publisher=1" 
    						+ " AND stat.publie_publisher<>1" 
    						+ " AND '"+ tsDateJour + "' > val.date_debut "
    						+ " AND '"+ tsDateJour + "' < val.date_fin ";

		
		
		return new Validite().getAllSelect("val.")+sWhereClause;
	}
	
	public static String getSQLValiditeValidesFromMarcheWithoutCommission(
			int iIdTypeObjetModula)
	throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException {

		//Timestamp tsDateJour =  new Timestamp(System.currentTimeMillis());
		
		/*
		 * bIsAffaireValidee && bIsAffaireEnvoyeePublisher && !bIsAffairePublieePublisher)
		 * 
		 * WARNING : attention ici on filtre selon la procédure
		 * donc si un jour on rajoute une seconde procédure de type PA alors elle ne sera pas prise 
		 * en compte dans cette requete
		 */
		
		String sWhereClause =
							" , marche mar"
							+ " WHERE val.id_type_objet_modula="+iIdTypeObjetModula
							+ " AND val.id_reference_objet=mar.id_marche"
							+ " AND mar.id_commission=0" ;
		
		
		return new Validite().getAllSelect("val.")+sWhereClause;
	}
	
	
    public static boolean isFirstValiditeFromAffaire(int iIdValidite,int iIdMarche)
    throws CoinDatabaseLoadException, InstantiationException, IllegalAccessException, SQLException, NamingException 
	{
		Connection conn = null;
		try {
			conn = ConnectionManager.getDataSource().getConnection();
			return isFirstValiditeFromAffaire(iIdValidite,iIdMarche, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
    public static boolean isFirstValiditeFromAffaire(
    		int iIdValidite,
    		int iIdMarche,
    		Connection conn)
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	Vector<Validite> vValidite 
    		= getAllValiditeFromTypeObjetModulaAndReferenceObjet(
    				ObjectType.ENVELOPPE_B,
    				iIdMarche,
    				conn);
    	
    	return isFirstValidite(iIdValidite, vValidite);
    }
    
    public static boolean isFirstValiditeFromAffaire(
    		int iIdValidite,
    		int iIdMarche,
    		Vector<Validite> vValiditeTotal )
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	Vector<Validite> vValidite = new Vector<Validite>();
    	
    	for (int i = 0; i < vValiditeTotal.size(); i++) {
    		Validite item = vValiditeTotal.get(i);
    		
    		if( item.getIdTypeObjetModula()== ObjectType.ENVELOPPE_B
    		&& item.getIdReferenceObjet()== iIdMarche)
    		{
    			vValidite.add(item);
    		}
		}
    	
    	return isFirstValidite(iIdValidite, vValidite);
    }
    
    /**
     * est-ce que l'objet iIdValidite est bien le premier contenu dans le la liste vValidite ?
     * @param iIdValidite
     * @param iIdMarche
     * @param vValidite
     * @return
     * @throws NamingException
     * @throws SQLException
     * @throws CoinDatabaseLoadException
     * @throws InstantiationException
     * @throws IllegalAccessException
     */
    public static boolean isFirstValidite(int iIdValidite,Vector<Validite> vValidite )
    throws NamingException, SQLException, CoinDatabaseLoadException, InstantiationException, IllegalAccessException
    {
    	if(vValidite != null && vValidite.size()>0)
    	{
    		if(vValidite.get(0).getId() == iIdValidite) return true;
    	}
    	return false;
    }
    
    /**
     * 
     * @param iIdValidite
     * @param iIdMarche
     * @return true si tout les lots du marché en sont à leur premiere validite B
     * @throws SQLException 
     * @throws ValidityException 
     * @throws IllegalAccessException 
     * @throws InstantiationException 
     * @throws NamingException 
     * @throws CoinDatabaseLoadException 
     * @throws Exception 
     */
    public static boolean isMarcheInFirstValidite(int iIdMarche) 
    throws SQLException, CoinDatabaseLoadException, NamingException, InstantiationException, 
    IllegalAccessException, ValidityException 
	{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			return isMarcheInFirstValidite(iIdMarche, conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
    public static boolean isMarcheInFirstValidite(int iIdMarche,Connection conn)
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException, 
    IllegalAccessException, ValidityException
    {
    	Vector<MarcheLot> vLots = MarcheLot.getAllLotsFromMarche(iIdMarche,conn);

		for(MarcheLot lot : vLots)
		{
    		if(getValiditeRowFromAffaire(lot.getIdValiditeEnveloppeBCourante(),iIdMarche,conn)>0) 
    			return false;
    	}
    	return true;
    }
    public static int getValiditeRowFromAffaire(int iIdValidite,int iIdMarche) 
    throws SQLException, CoinDatabaseLoadException, NamingException, InstantiationException, 
    IllegalAccessException, ValidityException 
	{
		Connection conn = ConnectionManager.getDataSource().getConnection();
		try {
			return getValiditeRowFromAffaire(iIdValidite, iIdMarche,conn);
		} finally{
			ConnectionManager.closeConnection(conn);	
		}
	}
    public static int getValiditeRowFromAffaire(int iIdValidite,int iIdMarche,Connection conn) 
    throws CoinDatabaseLoadException, NamingException, SQLException, InstantiationException,
    IllegalAccessException, ValidityException 
    {
    	Vector<Validite> vValidite
    		= getAllValiditeFromTypeObjetModulaAndReferenceObjet(
    				ObjectType.ENVELOPPE_B,iIdMarche,conn);
    	if(vValidite != null && vValidite.size()>0)
    	{
    		for(int i=0;i<vValidite.size();i++)
    		{
    			if(vValidite.get(i).getId() == iIdValidite) return i;
    		}
    	}
    	throw new ValidityException("Rang de la validité non trouvé");
    }

	public void removeWithObjectAttached() 
	throws SQLException, NamingException 
	{
		Connection conn = ConnectionManager.getConnection();
		try {
			removeWithObjectAttached(conn);
		} finally {
			ConnectionManager.closeConnection(conn);
		}
	}
	
	public void removeWithObjectAttached(
			Connection conn) 
	throws SQLException, NamingException 
	{
		try
		{
			Vector<Validite> vValiditesInvit 
				= Validite.getAllValiditeInvitationOffreFromValiditeOffre(
						(int)this.lId,
						conn);
			
			for(int i=0;i<vValiditesInvit.size();i++)
			{
				vValiditesInvit.get(i).remove(conn);
			}
		}
		catch(Exception e){}
		this.remove(conn);
	}
	
	public int getIdTypeObjetModula() {
		return this.iIdTypeObjetModula;
	}

	public void setIdTypeObjetModula(int iIdTypeObjetModula) {
		this.iIdTypeObjetModula = iIdTypeObjetModula;
	}

	public Timestamp getDateDebut() {
		return this.tsDateDebut;
	}

	public void setDateDebut(Timestamp tsDateDebut) {
		this.tsDateDebut = tsDateDebut;
	}
	
	public Timestamp getDateFin() {
		return this.tsDateFin;
	}

	public void setDateFin(Timestamp tsDateFin) {
		this.tsDateFin = tsDateFin;
	}

	public int getIdReferenceObjet() {
		return (int)this.lIdReferenceObjet;
	}

	public void setIdReferenceObjet(int lIdReferenceObjet) {
		this.lIdReferenceObjet = lIdReferenceObjet;
	}
	
	public int getIdValidite() {
		return (int)this.lId;
	}

	public void setIdValidite(int iId) {
		this.lId = iId;
	}
	
	public void setFromForm(HttpServletRequest request, String sFormPrefix)
	{	
		if ( (request.getParameter(sFormPrefix + "tsDateValiditeDebut") != null)
			&& (request.getParameter(sFormPrefix + "tsHeureValiditeDebut") != null))
			this.tsDateDebut = CalendarUtil.getConversionTimestamp(
									request.getParameter(sFormPrefix + "tsDateValiditeDebut")
									+ " " + request.getParameter(sFormPrefix + "tsHeureValiditeDebut"));

		if ( (request.getParameter(sFormPrefix + "tsDateValiditeFin") != null)
				&& (request.getParameter(sFormPrefix + "tsHeureValiditeFin") != null))
				this.tsDateFin = CalendarUtil.getConversionTimestamp(
										request.getParameter(sFormPrefix + "tsDateValiditeFin")
										+ " " + request.getParameter(sFormPrefix + "tsHeureValiditeFin"));
		
		if(request.getParameter(sFormPrefix + "iIdTypeObjetModula") != null)
			this.iIdTypeObjetModula = Integer.parseInt(request.getParameter(sFormPrefix + "iIdTypeObjetModula"));
		
		if(request.getParameter(sFormPrefix + "iIdReferenceObjet") != null)
			this.lIdReferenceObjet = Long.parseLong(request.getParameter(sFormPrefix + "iIdReferenceObjet"));
	}
	
	public String getName() {
		return null;
	}
	
	public static Vector<Validite> getAllWithSqlQueryStatic(String sSQLQuery,boolean bUseHttpPrevent) 
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Validite item = new Validite(); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return getAllWithSqlQuery(sSQLQuery, item);
	}
	public static Vector<Validite> getAllWithSqlQueryStatic(String sSQLQuery,boolean bUseHttpPrevent,Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
	Validite item = new Validite(); 
	item.bUseHttpPrevent = bUseHttpPrevent;
	return getAllWithSqlQuery(sSQLQuery, item,conn);
}
	
	public static Vector<Validite> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause) throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		return getAllWithWhereAndOrderByClauseStatic(sWhereClause,sOrderByClause,true);
	}
	
	public static Vector<Validite> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,boolean bUseHttpPrevent) 
		throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Validite item = new Validite(); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause);
	}
	
	public static Vector<Validite> getAllWithWhereAndOrderByClauseStatic(String sWhereClause, String sOrderByClause,boolean bUseHttpPrevent,Connection conn) 
	throws InstantiationException, IllegalAccessException, NamingException, SQLException {
		Validite item = new Validite(); 
		item.bUseHttpPrevent = bUseHttpPrevent;
		return item.getAllWithWhereAndOrderByClause(sWhereClause, sOrderByClause,conn);
	}
	
	public void storeNotNull() throws SQLException, NamingException, CoinDatabaseStoreException {
		if(this.getDateDebut() != null
		&& this.getDateFin() != null){
			this.store();
		}else{
			throw new CoinDatabaseStoreException("la période de Validité n'est pas correctement initialisée","");
		}
	}

}
