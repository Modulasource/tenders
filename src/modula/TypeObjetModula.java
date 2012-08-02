/*
 * Created on 15 janv. 2005
 *
 */
package modula;

import java.sql.SQLException;
import java.util.Vector;

import javax.naming.NamingException;

import modula.commission.Commission;
import modula.marche.Marche;

import org.coin.bean.ObjectType;
import org.coin.db.CoinDatabaseAbstractBean;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.PersonnePhysique;


/**
 * @author Robert
 *
 */

public class TypeObjetModula extends ObjectType {
    
	private static final long serialVersionUID = 3905518302632425265L;
		
    
    public TypeObjetModula() {
        super();
    }
        
    public TypeObjetModula(int iId) {
        super(iId);
    }
    
    public TypeObjetModula(int iId, String sName) {
        super(iId,sName);
    }
    

    public static String getTypeObjetModulaName(int iId) throws Exception {
        TypeObjetModula oTypeObjetModula = new TypeObjetModula(iId);
    	oTypeObjetModula.load();
    	return oTypeObjetModula.getName();
    }
    
    public static TypeObjetModula getTypeObjetModula(int iId) throws Exception {
        TypeObjetModula oTypeObjetModula = new TypeObjetModula(iId);
    	oTypeObjetModula.load();
    	return oTypeObjetModula;
    }
   
    public static Vector getAllTypeObjetModula() throws SQLException, NamingException, InstantiationException, IllegalAccessException
	{
        TypeObjetModula oTypeObjetModula = new TypeObjetModula();
		return oTypeObjetModula.getAllOrderById();
	}


    
    public static CoinDatabaseAbstractBean getObjetReference(int iIdTypeObjetModula, int iIdObjetReference) 
    throws CoinDatabaseLoadException, NamingException, SQLException
    {
    	CoinDatabaseAbstractBean object = null;
    	
    	switch (iIdTypeObjetModula) {
		case AAPC:
			
			break;

		case AATR:
			
			break;
		case AFFAIRE:
			object = Marche.getMarche(iIdObjetReference);
			
			break;
		case AVIS_RECTIFICATIF:
			
			break;
		case CANDIDATURE:
			
			break;
		case COMMISSION:
			
			break;
		case ENVELOPPE_A:
			
			break;
		case ENVELOPPE_B:
			
			break;
		case INVITATION_OFFRE:
			
			break;
		case ORGANISATION:
			object = Organisation.getOrganisation(iIdObjetReference);
			
			break;
		case PERSONNE_PHYSIQUE:
			object = PersonnePhysique.getPersonnePhysique(iIdObjetReference);
			break;

		default:
			break;
		}
    	
    	return object ;
    }
    
    public static String getIdObjetReferenceName(int iIdTypeObjetModula, int iIdObjetReference) 
    throws CoinDatabaseLoadException, NamingException, SQLException,
    InstantiationException, IllegalAccessException 
    {
    	String sReferenceName = "";
    	
    	switch (iIdTypeObjetModula) {
		case AAPC:
			
			break;

		case AATR:
			
			break;
		case AFFAIRE:
			Marche marche = Marche.getMarche(iIdObjetReference);
			sReferenceName = marche.getReference() + "(" + iIdObjetReference + ")";
			break;
		case AVIS_RECTIFICATIF:
			
			break;
		case CANDIDATURE:
			
			break;
		case COMMISSION:
			Commission oCommission = Commission.getCommission( iIdObjetReference );
			sReferenceName = oCommission.getNom();
			
			break;
		case ENVELOPPE_A:
			
			break;
		case ENVELOPPE_B:
			
			break;
		case INVITATION_OFFRE:
			
			break;
		case ORGANISATION:
			Organisation organisation = Organisation.getOrganisation(iIdObjetReference);
			sReferenceName = organisation.getRaisonSociale() 
				+ " (" + organisation.getIdOrganisation()+ ")";
			
			break;
		case PERSONNE_PHYSIQUE:
			PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdObjetReference);
			sReferenceName 
				= personne.getCivilitePrenomNom()
				+ " (" + personne.getIdPersonnePhysique() + ")"; 
			
			break;

		default:
			break;
		}
    	
    	return sReferenceName;
    }
    
}
