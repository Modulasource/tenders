package modula;

import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.OrganisationType;

public class OrganisationTypeModula {
	
	public static boolean isUserDesk(Organisation organisation ) {
		boolean bUserDesk = true;
		switch(organisation.getIdOrganisationType() )
		{
		case OrganisationType.TYPE_ACHETEUR_PUBLIC :
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_CANDIDAT :
			bUserDesk = false;
			break;
		case OrganisationType.TYPE_CONSULTANT :
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_PUBLICATION :
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_ADMINISTRATEUR:
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_ANNONCEUR :
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_BUSINESS_UNIT :
			bUserDesk = true;
			break;
		case OrganisationType.TYPE_HEAD_QUARTER :
			bUserDesk = true;
			break;
		}
		
		return bUserDesk;
	}
}
