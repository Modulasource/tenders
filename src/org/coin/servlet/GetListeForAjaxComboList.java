/*
 * Created on 18 octobre 2005
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.coin.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Vector;

import javax.naming.NamingException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import modula.commission.Commission;
import modula.marche.cpv.CPVPrincipal;
import modula.marche.cpv.CPVSupplementaire;
import mt.common.addressbook.AddressBookOwner;

import org.coin.bean.User;
import org.coin.bean.UserHabilitation;
import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseDuplicateException;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.db.CoinDatabaseUtil;
import org.coin.db.CoinDatabaseWhereClause;
import org.coin.db.ConnectionManager;
import org.coin.fr.bean.Adresse;
import org.coin.fr.bean.CategorieJuridique;
import org.coin.fr.bean.CodeNaf;
import org.coin.fr.bean.Organisation;
import org.coin.fr.bean.OrganisationDepot;
import org.coin.fr.bean.OrganisationGroupPersonnePhysique;
import org.coin.fr.bean.OrganisationService;
import org.coin.fr.bean.OrganisationType;
import org.coin.fr.bean.PersonnePhysique;
import org.coin.localization.Language;
import org.coin.security.DwrSession;
import org.coin.security.PreventInjection;
import org.coin.servlet.filter.HabilitationFilterUtil;
import org.coin.util.HttpUtil;
import org.coin.util.Outils;
import org.directwebremoting.annotations.RemoteMethod;
import org.directwebremoting.annotations.RemoteProxy;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author François
 *
 * Retourne un tableau (en code Javascript) contenant la liste des raisons sociales
 * s'apparentant à la chaine de caractères fournie en entrée.
 * 
 */
@RemoteProxy
public class GetListeForAjaxComboList extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	private static boolean s_enableEncode = false;
	
	static final int TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME = 1;
	static final int TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL = 2;
	static final int TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME_FUNCTION = 3;
	static final int TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME = 4;
	static final int TYPE_NAME_INDIVIDUAL_LAST_NAME_ORGANIZATION_NAME = 5;
	
	protected void doPost(
			HttpServletRequest request, 
			HttpServletResponse response) {
	
		response.setHeader("Cache-Control", "no-cache");
		try 
		{
			PrintWriter out = response.getWriter();
			s_enableEncode = Configuration.isTrueMemory("server.ajaxcombolist.encode", false);
			
			User user = (User)request.getSession().getAttribute(HabilitationFilterUtil.sSessionUserBeanName);
			Language lang = (Language)request.getSession().getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE);
			UserHabilitation userHabilitation = (UserHabilitation)request.getSession().getAttribute(HabilitationFilterUtil.sSessionUserHabilitationBeanName);
			String sChamp = PreventInjection.preventStore(request.getParameter("sChamp"));
			int iLimitOffset = HttpUtil.parseInt("iLimitOffset", request,0);	
			int iLimit = HttpUtil.parseInt("iLimit", request,0);		
			int iForceId = HttpUtil.parseInt("iForceId", request,0);
			String sAction = HttpUtil.parseString("sAction", request, "");
			
			String sList 
				= getList(
					user, 
					userHabilitation, 
					sChamp, 
					iLimitOffset, 
					iLimit, 
					iForceId, 
					sAction,
					lang, 
					false,
					request);
			out.write(sList);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	protected void doGet(
			HttpServletRequest request, 
			HttpServletResponse response) {
		// Renvoi à la fonction doPost()
		doPost(request, response);
	}

	@RemoteMethod
	public static String getAjaxList(
			String sAction,
			String sChamp,
			int iLimitOffset,
			int iLimit,
			int iForceId) 
	throws CoinDatabaseLoadException, IOException, SQLException, NamingException, InstantiationException, 
	IllegalAccessException, JSONException
	{
		String sList = "";
		try{
			HttpSession session = DwrSession.getSession();
			
			User user = (User)session.getAttribute(HabilitationFilterUtil.sSessionUserBeanName);
			Language lang = (Language)session.getAttribute(HabilitationFilterUtil.SESSION_LANGUAGE);
			UserHabilitation userHabilitation = (UserHabilitation)session.getAttribute(HabilitationFilterUtil.sSessionUserHabilitationBeanName);
			sChamp = PreventInjection.preventStore(sChamp);
			
			sList = getList(user, 
					userHabilitation, 
					sChamp, 
					iLimitOffset, 
					iLimit, 
					iForceId, 
					sAction,
					lang);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return sList;
	}
	
	public static String getList(User user,
			UserHabilitation userHabilitation,
			String sChamp,
			int iLimitOffset,
			int iLimit,
			int iForceId,
			String sAction,
			Language lang)
	throws CoinDatabaseLoadException, SQLException, NamingException, 
	InstantiationException, IllegalAccessException, JSONException, CoinDatabaseDuplicateException{
		return getList(user, 
				userHabilitation, 
				sChamp, 
				iLimitOffset, 
				iLimit, 
				iForceId, 
				sAction, 
				lang,
				false, 
				null);
	}

	public static String getResponseIdAndNameAndJSONObject(
			int i,
			long lId,
			String sName,
			JSONObject json)
	{
		return getResponseIdAndNameAndJSONObject(i, "" + lId, sName, json);
	}
	
	public static String getResponseIdAndNameAndJSONObject(
			int i,
			long lId,
			String sName,
			String sAppendBeforeJsonObject,
			JSONObject json)
	{
		return getResponseIdAndNameAndJSONObject(i, "" + lId, sName, sAppendBeforeJsonObject, json);
	}

	public static String getResponseIdAndNameAndJSONObject(
			int i,
			String sId,
			String sName,
			JSONObject json)
	{
		return getResponseIdAndNameAndJSONObject(i, sId, sName, null, json );
	}

	public static String getResponseIdAndNameAndJSONObject(
			int i,
			String sId,
			String sName,
			String sAppendBeforeJsonObject,
			JSONObject json)
	{
		String sList = getResponseIdAndName(i, sId, sName);
		if(sAppendBeforeJsonObject != null) sList += sAppendBeforeJsonObject;
		sList += "aReponseObj["+i+"]="+json+";";
		return sList;
	}
	
	public static String getResponseIdAndName(
			int i,
			String sId,
			String sName)
	{
		String sList = "aReponseId["+i+"]='" + sId + "';";
		sList += "aReponseLibelle["+i+"]='" + encode( Outils.addSlashes( sName ) )+"';";
		
		return sList;
	}
	
	public static String getList(
			User user,
			UserHabilitation userHabilitation,
			String sChamp,
			int iLimitOffset,
			int iLimit,
			int iForceId,
			String sAction,
			Language lang,
			boolean bReturnOnlyJSON,
			HttpServletRequest request)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
	IllegalAccessException, JSONException, CoinDatabaseDuplicateException
	{
		return getList(
				user, 
				userHabilitation, 
				sChamp, 
				iLimitOffset, 
				iLimit, 
				iForceId, 
				sAction, 
				lang, 
				bReturnOnlyJSON, 
				false, 
				request);
	}
	
	@SuppressWarnings("unchecked")
	public static String getList(
			User user,
			UserHabilitation userHabilitation,
			String sChamp,
			int iLimitOffset,
			int iLimit,
			int iForceId,
			String sAction,
			Language lang,
			boolean bReturnOnlyJSON,
			boolean bReturnOnlyJSONArray,
			HttpServletRequest request)
	throws CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, 
	IllegalAccessException, JSONException, CoinDatabaseDuplicateException
	{
		sChamp = sChamp.trim();
		Connection conn = ConnectionManager.getConnection();
		if(request != null) request.setAttribute("conn", conn);
		//System.out.println(sAction);
		String sList = "";
		ArrayList<Long> lIdContractType = new ArrayList<Long>();
		long lIdVehicleType = 0;
		boolean bForceShowAllOrganisation = false;
		int iIdOrganisationType = OrganisationType.TYPE_ACHETEUR_PUBLIC;
		int[] listIdOrganisationType = null;
		String sFrom = "";
		String sAddClause = "";
		String sAddWhereClause = "";
		String sGroupClause = "";
		String sFieldCount = "";
		long lIdModelType = 0;
		JSONObject json = null;
		JSONArray jsonArrItems = new JSONArray();
		
		if (sAction.equalsIgnoreCase("getRaisonSocialeClient")){
			iIdOrganisationType = OrganisationType.TYPE_CLIENT;
			bForceShowAllOrganisation = true;
		}
		if (sAction.equalsIgnoreCase("getRaisonSocialeTrainClient")){
			iIdOrganisationType = OrganisationType.TYPE_TRAIN_CUSTOMER;
			bForceShowAllOrganisation = true;
		}
		if (sAction.equalsIgnoreCase("getRaisonSocialeCandidat")){
			iIdOrganisationType = OrganisationType.TYPE_CANDIDAT;
			bForceShowAllOrganisation = true;
		}			
		/**
		 * TODO un peu crado pour le moment , mais bon...
		 */
		if (sAction.equalsIgnoreCase("getRaisonSocialeVeolia")){
			iIdOrganisationType = OrganisationType.TYPE_BUSINESS_UNIT;
			bForceShowAllOrganisation = true;
			

			if(userHabilitation.isHabilitate("IHM-DESK-ORG-BU-8"))
			{
				CoinDatabaseWhereClause wc 
					= OrganisationGroupPersonnePhysique.getWhereClauseIdOrganisationHerarchical(
							user.getIdIndividual());
			
				sAddWhereClause = " organisation.id_organisation in "+ wc.generateArrayClause();	
			}
			
			if(userHabilitation.isSuperUser()
			|| userHabilitation.isHabilitate("IHM-DESK-ORG-BU-7"))
				sAddWhereClause = "";
			
		}			
		if (sAction.equalsIgnoreCase("getRaisonSocialeVeoliaHQ")){
			iIdOrganisationType = OrganisationType.TYPE_HEAD_QUARTER;
			sAddWhereClause = " AND id_organisation=-1 ";
			bForceShowAllOrganisation = true;
		}			
		if (sAction.equalsIgnoreCase("getRaisonSocialeManufacturer")){
			iIdOrganisationType = OrganisationType.TYPE_FOURNISSEUR;
			bForceShowAllOrganisation = true;
		}	
		if (sAction.equalsIgnoreCase("getRaisonSocialeExternalCompany")){
			iIdOrganisationType = OrganisationType.TYPE_EXTERNAL_COMPANY;
			bForceShowAllOrganisation = true;
		}	
		
		
		if (sAction.equalsIgnoreCase("getRaisonSocialeExternal")){
			iIdOrganisationType = OrganisationType.TYPE_EXTERNAL;
			if(!userHabilitation.isSuperUser())
			{
				sAddWhereClause  = AddressBookOwner.getWhereClauseOwnerRestriction(user, "organisation.", true, conn);
			}
			bForceShowAllOrganisation = true;
		}	
		if (sAction.equalsIgnoreCase("getRaisonSocialeExternalCasual")){
			iIdOrganisationType = OrganisationType.TYPE_EXTERNAL_CASUAL;
			if(!userHabilitation.isSuperUser())
			{
				sAddWhereClause  = AddressBookOwner.getWhereClauseOwnerRestriction(user, "organisation.", true, conn);
			}
			bForceShowAllOrganisation = true;
		}	
		if (sAction.startsWith("getRaisonSocialeManufacturerType")){
			iIdOrganisationType = OrganisationType.TYPE_FOURNISSEUR;
			bForceShowAllOrganisation = true;
			
			lIdVehicleType = 0;
			if(sAction.length()>"getRaisonSocialeManufacturerType".length()){
				try{lIdVehicleType = Long.parseLong(sAction.substring("getRaisonSocialeManufacturerType".length(), sAction.length()));}
				catch(Exception e){lIdVehicleType=0;}
			}
			
			sFrom = ", vehicle_component_model model";
			sAddClause = "model.id_organisation_manufacturer = organisation.id_organisation";
			if(lIdVehicleType>0){
				sAddClause += " AND model.id_vehicle_type="+lIdVehicleType;
			}

			sFieldCount = "DISTINCT organisation.id_organisation";
		}
		if (sAction.startsWith("getRaisonSocialeManufacturerTypeAndModel")){
			iIdOrganisationType = OrganisationType.TYPE_FOURNISSEUR;
			bForceShowAllOrganisation = true;
			
			lIdVehicleType = 0;
			lIdModelType = 0;
			if(sAction.length()>"getRaisonSocialeManufacturerTypeAndModel".length()){
				String sId = sAction.substring("getRaisonSocialeManufacturerTypeAndModel".length(), sAction.length());
				String[] sIds = sId.split("_");
				try{lIdVehicleType = Long.parseLong(sIds[0]);}
				catch(Exception e){lIdVehicleType=0;}
				try{lIdModelType = Long.parseLong(sIds[1]);}
				catch(Exception e){lIdModelType=0;}
			}
			
			sFrom = ", vehicle_component_model model";
			sAddClause = "model.id_organisation_manufacturer = organisation.id_organisation";
			if(lIdVehicleType>0){
				sAddClause += " AND model.id_vehicle_type="+lIdVehicleType;
			}
			if(lIdModelType>0){
				sAddClause += " AND model.id_vehicle_component_model_type="+lIdModelType;
			}

			sFieldCount = "DISTINCT organisation.id_organisation";
		}
		if (sAction.startsWith("getRaisonSocialeBrand")){
			iIdOrganisationType = OrganisationType.TYPE_FOURNISSEUR;
			bForceShowAllOrganisation = true;
			
			lIdModelType = 0;
			if(sAction.length()>"getRaisonSocialeBrand".length()){
				try{lIdModelType = Long.parseLong(sAction.substring("getRaisonSocialeBrand".length(), sAction.length()));}
				catch(Exception e){lIdModelType=0;}
			}
			
			sFrom = ", vehicle_component_model model";
			sAddClause = "model.id_organisation_manufacturer = organisation.id_organisation";
			if(lIdModelType>0){
				sAddClause += " AND model.id_vehicle_component_model_type="+lIdModelType;
			}

			sFieldCount = "DISTINCT organisation.id_organisation";
		}	
		if (sAction.startsWith("getRaisonSociale")){
			
			Vector<Organisation> vOrganisations = new Vector<Organisation>();
			Organisation oOrganisation = null;
			try{
				PersonnePhysique oPersonnePhysique = PersonnePhysique.getPersonnePhysique(user.getIdIndividual());
				oOrganisation = Organisation.getOrganisation(oPersonnePhysique.getIdOrganisation(),false);
			}catch (Exception e){
				oOrganisation = new Organisation(false);
			}
			
			String sUseCaseId = "IHM-DESK-AFF-1";
			int iTotal = 0;
			if(bForceShowAllOrganisation || userHabilitation.isHabilitate(sUseCaseId))
			{
				if(iForceId>0){
					vOrganisations.add(Organisation.getOrganisation(iForceId, false));
					iTotal = 1;
				}else{
					if(listIdOrganisationType==null) listIdOrganisationType = new int[]{iIdOrganisationType};
					vOrganisations 
						= Organisation
							.getOrganisationsWithTypeAndRaisonSocialeLike(
									listIdOrganisationType,
									sChamp, 
									iLimitOffset, 
									iLimit,
									false,
									sFrom,
									sAddClause
									+sAddWhereClause
									+sGroupClause,
									false);
					
					vOrganisations = CoinDatabaseUtil.distinct(vOrganisations);
					
					iTotal 
					= Organisation
						.getCountOrganisationsWithTypeAndRaisonSocialeLike(
								listIdOrganisationType,
								sChamp, 
								0, 
								0,
								sFrom,
								sAddClause+sAddWhereClause,
								sFieldCount);
				}
				

			}else{
				sUseCaseId = "IHM-DESK-AFF-55";
				vOrganisations. add(oOrganisation);
				iTotal = 1;

			}
			
			CoinDatabaseWhereClause wc = new CoinDatabaseWhereClause(CoinDatabaseWhereClause.ITEM_TYPE_INTEGER);
			for (Organisation org : vOrganisations){
				wc.add(org.getId());
			}
			
			Vector<OrganisationDepot> vDepots = new Vector<OrganisationDepot>();
			if(iIdOrganisationType == OrganisationType.TYPE_BUSINESS_UNIT){
				OrganisationDepot depot = new OrganisationDepot();
				depot.bUseHttpPrevent=false; 
				vDepots
				= depot.getAllWithWhereAndOrderByClause(
						" WHERE " + wc.generateWhereClause("id_organisation"), "");
			}
			
			
		
			boolean bAddAddress = false;
			switch(iIdOrganisationType){
			case OrganisationType.TYPE_BUSINESS_UNIT:
				bAddAddress = true;
				break;
			}
			
			Vector<Adresse> vAddress = null;
			if(bAddAddress) vAddress = Organisation.getAllAdresseWithAllOrganisation(vOrganisations);
			
			for (int i=0;i<vOrganisations.size();i++){
				Organisation org = vOrganisations.get(i);
				org.setAbstractBeanLocalization(lang);
				
				
				json = org.toJSONObject(bAddAddress, vAddress);
				jsonArrItems.put(json);
				
				switch(org.getIdOrganisationType()){
				case OrganisationType.TYPE_BUSINESS_UNIT:
					JSONArray depots = OrganisationDepot.getJSONArrayFromOrganisation(org.getId(),vDepots,true);
					json.put("depots", depots);
					break;
				}
			
				sList += getResponseIdAndNameAndJSONObject(i, org.getIdOrganisation(), org.getRaisonSociale(), json);
			}
			sList += "iTotal="+iTotal+";";
		}
		if (sAction.startsWith("getContractFromType")){
			String sTypes = sAction.substring("getContractFromType_".length(), sAction.length());
			String[] sTypesId = sTypes.split("_");
			for(String sId : sTypesId){
				try{
					lIdContractType.add(Long.parseLong(sId));
				}catch(Exception e){e.printStackTrace();}
			}
		}
		else if (sAction.equalsIgnoreCase("getCommission")){
			
			Vector<Commission> vCommission = new Vector<Commission>();
			if(iForceId>0){
				vCommission.add(Commission.getCommission(iForceId, false));
			}else{
				vCommission = Commission.getAllcommissionWithIdOrganisation(Integer.parseInt(sChamp),false);
			}
			for (int i=0;i<vCommission.size();i++){
				Commission com = vCommission.get(i);
				json = com.toJSONObject();

				sList += getResponseIdAndNameAndJSONObject(i, com.getIdCommission(), com.getNom(), json);
			}
		}
		else if (sAction.equalsIgnoreCase("getCandidat")){
			Vector<PersonnePhysique> vPersonnePhysique 
				= PersonnePhysique.getAllFromIdOrganisation(Integer.parseInt(sChamp), false);

			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique,
					//TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME_FUNCTION,
					TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME,
					true,
					false);
			
		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueAllType")){
			
			Vector<PersonnePhysique> vPersonnePhysique = PersonnePhysique.getAllFromEmailOrName(sChamp, false);
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique,
					TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME,
					true,
					false);
		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueAllTypeAndOrganisationName")){
			
			Vector<PersonnePhysique> vPersonnePhysique
				= PersonnePhysique.getAllFromEmailOrNameOrOrganizationName(sChamp, false);
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique,
					TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME,
					true,
					false);
		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueAllTypeWithOrg")){
			Vector<PersonnePhysique> vPersonnePhysique = null;
			if(iForceId>0){
				vPersonnePhysique = new Vector<PersonnePhysique> ();
				vPersonnePhysique.add(PersonnePhysique.getPersonnePhysique(iForceId, false));
			}else{
				vPersonnePhysique = PersonnePhysique.getAllFromEmailOrName(sChamp, false);
			}
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME,
					true,
					true);
		}
		else if (sAction.startsWith("getAllPersonnePhysiqueFromIdOrganisation_")){
			long lIdOrganisation = 0;
			try{lIdOrganisation = Long.parseLong(sAction.split("_")[1]);
			}catch(Exception e){}
			
			
			Vector<PersonnePhysique> vPersonnePhysique = new Vector<PersonnePhysique> ();
			if(iForceId>0){
				vPersonnePhysique.add(PersonnePhysique.getPersonnePhysique(iForceId, false));
			}else{
				if (lIdOrganisation>0){
					String sSQLQuery = "WHERE CONCAT(prenom, nom, email) LIKE ?" 
							+ " AND id_organisation=?";
					Vector <Object> vParams = new Vector <Object> ();
					vParams.add ("%" + sChamp + "%");
					vParams.add (lIdOrganisation);
					vPersonnePhysique = PersonnePhysique.getAllWithWhereClause(sSQLQuery, vParams, false);
				}else{
					vPersonnePhysique = PersonnePhysique.getAllFromEmailOrName(sChamp, false);
				}
			}
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME,
					true,
					true);
		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueAllTypeWithOrgIdForced")){
			Vector<PersonnePhysique> vPersonnePhysique = null;
			PersonnePhysique pp = new PersonnePhysique();
			pp.bUseHttpPrevent = false;
			Vector<Object> vParams = new Vector<Object>();
			String sQueryPP = 
				" WHERE (nom LIKE ?" 
				+ " OR email LIKE ?)";
			vParams.add("%" + sChamp + "%");
			vParams.add("%" + sChamp + "%");
			
			if(iForceId > 0){
				vParams.add(new Long(iForceId));
				vPersonnePhysique = 
					pp.getAllWithWhereAndOrderByClause(
							sQueryPP
							+ " AND id_organisation=? ",
							"", 
							vParams);
			} else {
				vPersonnePhysique = 
					pp.getAllWithWhereAndOrderByClause(
							sQueryPP,
							"", 
							vParams);
			}
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME,
					true,
					true);
		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueAcheteurPublic")){
			
			Vector<PersonnePhysique> vPersonnePhysique 
				= PersonnePhysique.getAllWithOrganisationTypeAndNameLike(
						OrganisationType.TYPE_ACHETEUR_PUBLIC, 
						sChamp, 
						false);
			
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME,
					false,
					false);

		}
		else if (sAction.equalsIgnoreCase("getPersonnePhysiqueExternalAndOrganisationName")){
			
			sAddWhereClause = "";
			if(!userHabilitation.isSuperUser())
			{
				sAddWhereClause  = " AND " + AddressBookOwner.getWhereClauseOwnerRestriction(user, "pers.", false, conn);
			}
			
			if(sChamp.equalsIgnoreCase("*")){
				sChamp = "_";
			}
			
			Vector<PersonnePhysique> vPersonnePhysique 
				= PersonnePhysique.getAllWithOrganisationTypeAndNameLikeFull(
						OrganisationType.TYPE_EXTERNAL, 
						sChamp, 
						sAddWhereClause,
						false);
			
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_LAST_NAME_ORGANIZATION_NAME,
					false,
					false);

		}
		else if (sAction.equalsIgnoreCase("getHQCollaborator")){

			Vector<PersonnePhysique> vPersonnePhysique 
			= PersonnePhysique.getAllWithOrganisationTypeAndNameLike(
					OrganisationType.TYPE_HEAD_QUARTER, 
					sChamp, 
					false);
		
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME,
					false,
					false);
		}
		if (sAction.startsWith("getVehicleFromType")){
			String sType = sAction.substring("getVehicleFromType_".length(), sAction.length());
			try{
				lIdVehicleType = Long.parseLong(sType);
			}catch(Exception e){}
		}
		else if (sAction.startsWith("getOrganisationDepotPersonnePhysique_")){
			long lIdOrganisation = Long.parseLong(sAction.substring(
					"getOrganisationDepotPersonnePhysique_".length(), sAction.length()));
			
			Vector<PersonnePhysique> vPersonnePhysique
				= PersonnePhysique.getAllFromIdOrganisationAndNameLike(
						(int)lIdOrganisation, 
						sChamp, 
						false);
		
			sList += getAllPersonnPhysiqueJson(
					vPersonnePhysique, 
					TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME, 
					false,
					false);
		}
		else if (sAction.equalsIgnoreCase("getCategorieJuridique")){
			int iTotal = 0;
			Vector<CategorieJuridique> vCatJuridique = new Vector<CategorieJuridique>();
			vCatJuridique = CategorieJuridique.getAllCategorieJuridiqueLike(sChamp, iLimitOffset, iLimit,false);
			iTotal = CategorieJuridique.getCountCategorieJuridiqueLike(sChamp, 0, 0);
			for (int i=0;i<vCatJuridique.size();i++){
				CategorieJuridique item = vCatJuridique.get(i);
				json = item.toJSONObject();
				
				sList += getResponseIdAndNameAndJSONObject(
						i, 
						item.getId(), 
						item.getName() ,
						json);
				
			}
			sList += "iTotal="+iTotal+";";
		}
		else if (sAction.equalsIgnoreCase("getCodeNaf")){
			int iTotal = 0;
			Vector<CodeNaf> vCodeNaf = new Vector<CodeNaf>();
			vCodeNaf = CodeNaf.getAllCodeNafValideLike(sChamp, iLimitOffset, iLimit,false);
			iTotal = CodeNaf.getCountCodeNafValideLike(sChamp, 0, 0);
			for (int i=0;i<vCodeNaf.size();i++){
				CodeNaf item = vCodeNaf.get(i);
				json = item.toJSONObject();
				
				sList += getResponseIdAndNameAndJSONObject(
						i, 
						item.getIdCodeNaf(), 
						item.getCodeNafEtLibelle() ,
						json);

			}
			sList += "iTotal="+iTotal+";";
		}
		else if (sAction.equalsIgnoreCase("getCPVDescripteurPrincipal")){
			int iTotal = 0;
			CPVPrincipal item = new CPVPrincipal();
			String sWhereClause 
				= " WHERE id_cpv_principal LIKE '%" + sChamp  + "%' "
				+ "OR libelle  LIKE '%" + sChamp  + "%' ";
			item.bUseHttpPrevent = false;
			
			Vector<CPVPrincipal> vCPVPrincipal 
				= item.getAllWithWhereAndOrderByClauses(
						sWhereClause, 
						" LIMIT "+iLimitOffset+", "+iLimit);
			
			iTotal = ConnectionManager.getCountInt(item, sWhereClause);
			for (int i=0;i<vCPVPrincipal.size();i++){
				CPVPrincipal cpv = vCPVPrincipal.get(i);
				json = cpv.toJSONObject();
				
				sList += getResponseIdAndNameAndJSONObject(
						i, 
						cpv.getIdString(), 
						cpv.getIdString() + " " + cpv.getName(),
						json);
			}
			sList += "iTotal="+iTotal+";";
		}
		else if (sAction.equalsIgnoreCase("getCPVDescripteurSupplementaire")){
			int iTotal = 0;
			CPVSupplementaire item = new CPVSupplementaire();
			String sWhereClause = " WHERE id_cpv_supplementaire LIKE '%" + sChamp  + "%' "
					+ "OR libelle  LIKE '%" + sChamp  + "%' ";
			item.bUseHttpPrevent = false;
			Vector<CPVSupplementaire> vCPVSupplementaire
				= item.getAllWithWhereAndOrderByClauses(
						sWhereClause, 
						" LIMIT "+iLimitOffset+", "+iLimit);
			iTotal = ConnectionManager.getCountInt(item, sWhereClause);
			for (int i=0;i<vCPVSupplementaire.size();i++){
				CPVSupplementaire cpv = vCPVSupplementaire.get(i);
				json = cpv.toJSONObject();
				
				sList += getResponseIdAndNameAndJSONObject(
						i, 
						cpv.getIdString(), 
						cpv.getIdString() + " " + cpv.getName(),
						json);
			}
			sList += "iTotal="+iTotal+";";
		} else if (sAction.equalsIgnoreCase("getOrganisationServiceFromName")){
			Vector<OrganisationService > vOrganisationService  
			 = OrganisationService.getAllOrganisationServiceFromNameWithLimit(
					 sChamp, 
					 iLimitOffset,
					 iLimit,
					 false);

			Vector<Organisation> vOrganisation 
				= OrganisationService.getAllOrganisationFromAllOrganisationService(vOrganisationService);
			
			for (int i=0;i<vOrganisationService.size();i++){
				OrganisationService item = vOrganisationService.get(i);
				Organisation orga = Organisation.getOrganisation(item.getIdOrganisation(), vOrganisation);	
				sList += getResponseIdAndNameAndJSONObject(
						i, 
						item.getId(), 
						item.getName() + " (" + orga.getName() +  ")",
						json);
			}
			
			sList += "iTotal="+vOrganisationService.size()+";";
		}
		else
		{
			sList += "";
		}
		
		ConnectionManager.closeConnection(conn);
		
		if(bReturnOnlyJSON)
			return json.toString();
		if(bReturnOnlyJSONArray)
			return jsonArrItems.toString();
		return sList;
	}
	
	private static String encode(String s){
		if(s_enableEncode)
			return Outils.encodeUtf8(s);
		else
			return s;
	}
	

	
	private static String getAllPersonnPhysiqueJson(
			Vector<PersonnePhysique> vPersonnePhysique,
			int iNameType,
			boolean bAddOrganization, 
			boolean bAddAddress) 
	throws JSONException, NamingException, SQLException, InstantiationException,
	IllegalAccessException, CoinDatabaseLoadException
	{
		String sList = "";
		JSONObject json = null;
		Vector<Organisation> vOrganization = null;
		Vector<Adresse> vAddress = null;
		
		if(TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME == iNameType
		|| TYPE_NAME_INDIVIDUAL_LAST_NAME_ORGANIZATION_NAME == iNameType)
		{
			/**
			 * Its mandatory to have it for this name type
			 */
			bAddOrganization = true;
		}
		
		if(bAddOrganization) vOrganization = Organisation.getAllWithAllPersonne(vPersonnePhysique);
		if(bAddAddress) vAddress = Organisation.getAllAdresseWithAllOrganisation(vOrganization);
		
		
		for (int i=0;i<vPersonnePhysique.size();i++){
			PersonnePhysique pp = vPersonnePhysique.get(i);
			json = pp.toJSONObject(bAddOrganization, bAddAddress, vOrganization, vAddress);
			
			String sName = null;
			switch (iNameType) {
			case TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME:
				sName = pp.getPrenomNom();
				break;
				
			case TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL:
				sName = pp.getPrenomNom() + " / " + pp.getEmail();
				break;

			case TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME:
			case TYPE_NAME_INDIVIDUAL_LAST_NAME_ORGANIZATION_NAME:
				String sOrganizatioName = null;
				try{
					Organisation orga =  Organisation.getOrganisation(pp.getIdOrganisation(), vOrganization);
					sOrganizatioName = orga.getName();
				} catch (CoinDatabaseLoadException e) {
					sOrganizatioName = "(error organization id " + pp.getIdOrganisation() + " not found)";
				}
				String sEmail = "";
				if(TYPE_NAME_INDIVIDUAL_LAST_NAME_EMAIL_ORGANIZATION_NAME == iNameType)
				{
					sEmail = "/" + pp.getEmail();
				}
				
				sName = pp.getPrenomNom() + sEmail + " / " + sOrganizatioName;
				break;

			case TYPE_NAME_INDIVIDUAL_FIRST_NAME_LAST_NAME_FUNCTION:
				sName = pp.getCivilitePrenomNomFonction();
				break;
				

			default:
				break;
			}
			
			
			sList += getResponseIdAndNameAndJSONObject(
					i, 
					pp.getId(), 
					sName, 
					json);
		}
		sList += "iTotal="+vPersonnePhysique.size()+";";

		return sList;
	}
}
