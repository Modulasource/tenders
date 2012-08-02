
<%@page import="org.coin.fr.bean.OrganisationDepotType"%><%@page import="mt.veolia.vfr.vehicle.Vehicle"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.db.CoinDatabaseRemoveException"%>
<%@page import="java.util.Vector"%>
<%@page import="mt.veolia.vfr.planification.Planification"%>
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.OrganisationGroupPersonnePhysique"%>
<%@page import="org.coin.fr.bean.OrganisationDepotPersonnePhysique"%>
<%@page import="org.coin.fr.bean.Adresse"%>
<%@page import="modula.graphic.Onglet"%>
<%@page import="org.coin.fr.bean.OrganisationDepot"%>
<%@page import="org.coin.util.HttpUtil"%>

<%@ include file="../../../../include/beanSessionUser.jspf" %>
<%
    String sAction = HttpUtil.parseString("sAction",request,"");
    long lIdOrganisationDepot = HttpUtil.parseLong("lIdOrganisationDepot",request,0);
    String rootPath = request.getContextPath()+"/";
    long lIdOrganisation = HttpUtil.parseLong("lIdOrganisation",request,0);
    PersonnePhysique personneUser = PersonnePhysique.getPersonnePhysique(sessionUser.getIdIndividual());
    
    if (sAction.equals("create"))
    {
        Adresse adresse = new Adresse();
        adresse.setFromForm(request, "");
        OrganisationDepot item = new OrganisationDepot();
        OrganisationDepotType orgDepotType = new OrganisationDepotType();
        orgDepotType.setFromForm(request, "");
        item.setIdOrganisationDepotType(orgDepotType.getId());
        item.setFromForm(request, "");
        item.setIdAdresse(adresse.getIdAdresse());
                
        
        if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-7" ))
        {
        	
        } else if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-9" )
            && OrganisationGroupPersonnePhysique.isOrganisationHerarchical(
            		personneUser.getId(), 
            		item.getIdOrganisation())){
            
        } else if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-8" )
        		&& personneUser.getIdOrganisation() == item.getIdOrganisation()) {
        } else {
        	sessionUserHabilitation.isHabilitateException("IHM-DESK-ORG-DEPOT-7");
        }
        
        adresse.create(); 
        
        item.setIdAdresse(adresse.getIdAdresse());
        item.create();
    }
    
    if(sAction.equals("createPP"))
    {
    	OrganisationDepotPersonnePhysique item = new OrganisationDepotPersonnePhysique();
        item.setFromForm(request,"");
        item.create();
        
        response.sendRedirect(
                response.encodeRedirectURL("displayOrganisationDepot.jsp?lIdOrganisationDepot="+lIdOrganisationDepot));
        return;
    } 

    if (sAction.equals("remove"))
    {
    	
		/**
         * Check Individual associated
         */
	    Vector<OrganisationDepotPersonnePhysique> vPersonnes 
	    	= OrganisationDepotPersonnePhysique.getAllFromDepot(lIdOrganisationDepot);

		if(vPersonnes != null 
		&& vPersonnes.size() > 0 )
		{
			
			String sReferenceOrganisationDepotPersonnePhysique = "";
			for (int i = 0; i < vPersonnes.size(); i++)
			{
				OrganisationDepotPersonnePhysique pp = (OrganisationDepotPersonnePhysique)vPersonnes.get(i);
				PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(pp.getIdPersonnePhysique());
		           
				sReferenceOrganisationDepotPersonnePhysique += 
					"<b>" + personne.getPrenomNom() + "</b><br/>";
			}
			
			throw new CoinDatabaseRemoveException("Vous ne pouvez pas supprimer ce dépôt "
					+ "car il y a encore des personnes rattachées :<br/>"
					+ sReferenceOrganisationDepotPersonnePhysique);
		}
		
    	
    	
        /**
         * Check Vehicle
         */
        Vector vVehicle = Vehicle.getAllFromOrganisationDepot(lIdOrganisationDepot); 
		if(vVehicle != null 
		&& vVehicle.size() > 0 )
		{
			
			String sReferenceVehicle = "";
			for (int i = 0; i < vVehicle.size(); i++)
			{
				Vehicle vehicle = (Vehicle)vVehicle.get(i);
				sReferenceVehicle += 
					"<b>" + vehicle.getVehicleNumber() + "</b><br/>";
			}
			
			throw new CoinDatabaseRemoveException("Vous ne pouvez pas supprimer cette organisation "
					+ "car il y a encore des véhicules rattachés :<br/>"
					+ sReferenceVehicle);
		}
		
		
        /**
         * Check Planification
         */
        Vector vPlanification = Planification.getAllFromOrganisationDepot(lIdOrganisationDepot); 
		if(vPlanification != null 
		&& vPlanification.size() > 0 )
		{
			
			String sReferencePlanification = "";
			for (int i = 0; i < vPlanification.size(); i++)
			{
				Planification planification = (Planification)vPlanification.get(i);
				sReferencePlanification += 
					"<b>" + planification.getReference() + "</b><br/>";
			}
			
			throw new CoinDatabaseRemoveException("Vous ne pouvez pas supprimer ce dépôt "
					+ "car il y a encore des planifications rattachées :<br/>"
					+ sReferencePlanification);
		}
		
 

    	
    	
    	new OrganisationDepot(lIdOrganisationDepot).removeWithObjectAttached();
    }
    
    if (sAction.equals("removePP"))
    {
    	long lIdOrganisationDepotPP = HttpUtil.parseLong("lIdOrganisationDepotPersonnePhysique",request,0);
    	new OrganisationDepotPersonnePhysique().remove(lIdOrganisationDepotPP);
    	
        response.sendRedirect(
                response.encodeRedirectURL("displayOrganisationDepot.jsp?lIdOrganisationDepot="+lIdOrganisationDepot));
        return;
    }
    
    if (sAction.equals("store"))
    {
        OrganisationDepot item = OrganisationDepot.getOrganisationDepot(lIdOrganisationDepot);
        if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-2" ))
        {
        	
        } else if(sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-10" )
            && OrganisationGroupPersonnePhysique.isOrganisationHerarchical(
            		personneUser.getId(), 
            		item.getIdOrganisation())){
            
        } else if (sessionUserHabilitation.isHabilitate("IHM-DESK-ORG-DEPOT-5" )
        		&& personneUser.getIdOrganisation() == item.getIdOrganisation()) {
        } else {
        	sessionUserHabilitation.isHabilitateException("IHM-DESK-ORG-DEPOT-2");
        }
    	
    	OrganisationDepotType orgDepotType = new OrganisationDepotType();
    	orgDepotType.setFromForm(request, "");
        item.setIdOrganisationDepotType(orgDepotType.getId());
        item.setFromForm(request, "");
        item.store();        

        Adresse adresse = null;
    	try {
       	    adresse = Adresse.getAdresse((int)item.getIdAdresse());
        } catch (CoinDatabaseLoadException e) {
       	    adresse = new Adresse();
       	    adresse.create();
       	    item.setIdAdresse(adresse.getId());
       	    item.store();        

        }
        
        adresse.setFromForm(request, "");
        adresse.store(); 
        
        lIdOrganisation = item.getIdOrganisation();
    }
    
    response.sendRedirect(
            response.encodeRedirectURL(rootPath 
            	+ "desk/organisation/afficherOrganisation.jsp?iIdOrganisation="+lIdOrganisation
            		+ "&iIdOnglet="+Onglet.ONGLET_ORGANISATION_DEPOTS));
%>