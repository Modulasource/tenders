package org.coin.util;

import java.util.Vector;

import org.coin.fr.bean.PersonnePhysique;



public class MailUtil {
	
	MailUtil(){}	
	
	public static Vector<String> getEmailAdress(String sarr_recipients[])throws Exception{
		int iSizeEmailAdressTO = sarr_recipients.length;
		Vector<String> vEmailAdressTo = new Vector<String>();
		Vector<Long> vEmailAdressId = new Vector<Long>();	
		
		for(int i=0; iSizeEmailAdressTO > i; i++){		
			try{			
				vEmailAdressId.add(Long.parseLong(sarr_recipients[i]));
			}catch(NumberFormatException ex){
				vEmailAdressTo.add(sarr_recipients[i]);
			}		
		}
		 
		
		for(Long idPersonnePhysique : vEmailAdressId){		
			PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(idPersonnePhysique);		
			vEmailAdressTo.add(personne.getEmail());
		}
			
		return vEmailAdressTo;

	}
}