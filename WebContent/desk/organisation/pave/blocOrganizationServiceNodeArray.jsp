<%@page import="org.coin.db.AbstractBeanArray"%>
<%@page import="org.coin.bean.organigram.OrganigramNode"%>
<%@page import="org.coin.bean.organigram.OrganigramNodeState"%>
<%@page import="java.util.Vector"%>
<%@page import="org.coin.bean.organigram.Organigram"%>
<%@page import="org.coin.bean.ObjectType"%>

<%
	String rootPath = request.getContextPath() +"/";
	boolean bOrganigramServiceFound = false;
	Connection conn = (Connection) request.getAttribute("conn");
	Vector vPersonnePhysique = (Vector) request.getAttribute("vPersonnePhysique");
	Vector vPoste = (Vector) request.getAttribute("vPoste");
	Vector<PkiCertificate> vPkiCertificate = (Vector<PkiCertificate>) request.getAttribute("vPkiCertificate");
	Vector<Multimedia> vMultimedia = (Vector<Multimedia>) request.getAttribute("vMultimedia");
	Vector<User> vUser = (Vector<User>) request.getAttribute("vUser");
	Vector<UserGroup> vUserGroup = (Vector<UserGroup>) request.getAttribute("vUserGroup");
	Vector<Group> vGroup = Group.getAllStaticMemory(false, conn);
	OrganigramNode  onService = (OrganigramNode) request.getAttribute("os");
	Vector  vOrganigramNodeInService = null;
	Organigram organigramService = null;

	Vector vOrganigram
		= Organigram.getAllFromObject(
			ObjectType.ORGANISATION_SERVICE, 
			onService.getIdReferenceObject());
	

	
	if(vOrganigram.size() ==1)
	{
	    organigramService = (Organigram ) vOrganigram.get(0);
	    vOrganigramNodeInService = OrganigramNode.getAllFromIdOrganigram( organigramService.getId() );
		bOrganigramServiceFound = true;
	}
	else{
	    vOrganigramNodeInService = new Vector();
	}
	
	
	
	OrganigramNode.computeName(vOrganigramNodeInService, vPersonnePhysique, vPoste);


	AbstractBeanArray aba = OrganigramNode.generateAbstractBeanArray( vOrganigramNodeInService);
	aba.addUnplacedBean(vOrganigramNodeInService);

	
	
%>	
<%@page import="org.coin.fr.bean.PersonnePhysique"%>
<%@page import="org.coin.fr.bean.PersonnePhysiqueCivilite"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificate"%>
<%@page import="org.coin.bean.pki.certificate.PkiCertificateType"%>
<%@page import="org.coin.fr.bean.Multimedia"%>
<%@page import="org.coin.fr.bean.MultimediaType"%>

<%@page import="org.coin.bean.UserGroup"%>
<%@page import="org.coin.bean.Group"%>
<%@page import="java.sql.Connection"%>
<%@page import="org.coin.db.CoinDatabaseWhereClause"%>
<%@page import="org.coin.bean.User"%>
<%@page import="org.coin.db.CoinDatabaseLoadException"%>
<%@page import="org.coin.bean.CoinUserGroupType"%><table >
<%


	for (int i =0; i <= aba.iMaxRow ; i++)
	{
		int k = i % 2;
		OrganigramNode osTmp = null;
		String sUrlDisplay = "";
		for (int j =0; j <= aba.iMaxColumn  + 1; j++)
		{
			osTmp = (OrganigramNode) aba.table[i][j] ;
			if(osTmp != null)
			{
				sUrlDisplay =
					"onclick=\"Redirect('"
					+ response.encodeURL( rootPath
						+ "desk/organisation/groupe/"
						+ "modifyOrganisationServiceOrganigramNodeForm.jsp?sAction=store&lIdOrganigramNode="
						+ osTmp.getId() )
					+ "')\"" ;
				break;
			}
		}


%>
	<tr  >

<%


		String sNodeState = "";
		String sCellStype = "min-width: 30px;";
		String sCellNotActivatedStyle = "style='background: grey;color:#FFF';";
		for (int j =0; j <= aba.iMaxColumn  + 1; j++)
		{
			OrganigramNode os = (OrganigramNode) aba.table[i][j] ;
			if(os != null)
			{
				switch( (int) os.getIdOrganigramNodeState())
				{
				case OrganigramNodeState.STATE_ACTIVATED:
					sNodeState = "";
					sCellStype = "";
					break;
				case OrganigramNodeState.STATE_DEACTIVATED:
					sNodeState = "State: Désactivé";
					sCellStype = sCellNotActivatedStyle;
					break;
				case OrganigramNodeState.STATE_ARCHIVED:
					sNodeState = "State: Archivés";
					sCellStype = sCellNotActivatedStyle;
					break;
				}
				
				sCellStype +=  "min-width: 30px;";
				
				PersonnePhysique person = null;
				try{
					person
						= PersonnePhysique.getPersonnePhysique(
							os.getIdReferenceObject(),
							vPersonnePhysique);
				} catch (Exception e) {
					person = new PersonnePhysique();
					person.setNom("ERREUR : personne supprimée de l'organisation id : " + os.getIdReferenceObject());
					os.setName(person.getName());
				}
				
				
				
				String sUserIcon = "user.gif";
				switch((int)person.getIdPersonnePhysiqueCivilite() ){
				case PersonnePhysiqueCivilite.MONSIEUR:
				case PersonnePhysiqueCivilite.UNDEFINED:
					 sUserIcon = "user.gif";
					 break;
				case PersonnePhysiqueCivilite.MADAME:
				case PersonnePhysiqueCivilite.MADEMOISELLE:
					 sUserIcon = "user_female.png";
					 break;
				}
				
				
				
%>
		<td <%= sCellStype %> >
			<div style="padding-left: <%= (j * 20) %>px;">
				<img src="<%= rootPath
                            + "images/icons/" + sUserIcon %>"
					style='cursor : pointer;' "
                    onclick="parent.addParentTabForced('chargement en cours...','<%=
                       	response.encodeURL( rootPath
                           + "desk/organisation/afficherPersonnePhysique.jsp?iIdPersonnePhysique="
                           + os.getIdReferenceObject() )
                            %>');" 
                 />
				<%= os.getName() +" "+ sNodeState%>

<%
		boolean bPkiCertificateFound = false;
		String sMultimediaScannedParaphFound = "";
		String sMultimediaScannedVisaFound = "";
		String sMultimediaScannedSignatureFound = "";
		
		for(PkiCertificate cert : vPkiCertificate )
		{
			if(cert.getIdPkiCertificateType() == PkiCertificateType.TYPE_PKCS12
			&& cert.getIdPersonnePhysique() == person.getId())
			{
				bPkiCertificateFound = true;
			}
		}

		for(Multimedia multimedia : vMultimedia )
		{
			if(multimedia.getIdTypeObjet() == ObjectType.PERSONNE_PHYSIQUE
			&& multimedia.getIdReferenceObjet() == person.getId())
			{	
				String sCommonImage = "<img src='" + rootPath + "images/icons/signature_scan.png' />";
				sCommonImage =  "multimedia : ";
				switch ((int) multimedia.getIdMultimediaType() )
				{
				case MultimediaType.TYPE_SCANNED_PARAPH:
					sMultimediaScannedParaphFound = sCommonImage= "Paraphe scanné<br/>\n";
					break;
				case MultimediaType.TYPE_SCANNED_VISA:
					sMultimediaScannedVisaFound = sCommonImage + "Visa scanné<br/>\n";
					break;
				case MultimediaType.TYPE_SCANNED_SIGNATURE:
					sMultimediaScannedSignatureFound = sCommonImage + "Signature scannée<br/>\n";
					break;
				}
			}
		}
		
		String sGroupName = "";
		User usr = null;
		try{
			usr = User.getUserFromIdIndividual(person.getId(), vUser);
			
			sGroupName = "login : " + usr.getLogin() + "<br/>groupes: " ;
			
			Vector<Group> vGroupTmp 
				= UserGroup.getAllGroup(
					usr.getId(),
					CoinUserGroupType.TYPE_HABILITATE,
					vGroup,
	    			vUserGroup);
	    			
	    	for(Group groupTmp : vGroupTmp)
	    	{
	    		sGroupName += groupTmp.getName() + ", ";
	    	}
	    	
	    	sGroupName += "<br/>\n";
		} catch (Exception e) {
			e.printStackTrace();
		} 

		
		
%>
			<%= (!bPkiCertificateFound)?"<span style='color:red' >Pas de certificat !</span>":""  %>
				<div style="color:#555;padding-left: 15px;display: none;" class="person_information" >
					<%= sMultimediaScannedParaphFound %>
					<%= sMultimediaScannedVisaFound %>
					<%= sMultimediaScannedSignatureFound %>
					<%= sGroupName %>
				</div>
			</div>
		</td>
<%
			}
			else
			{
%>
<!--  
		<td style="width: 80%">&nbsp</td>
-->
<%
			}

		}
			%>
	</tr>
			<%
		}
		%>
</table>
<%
	if(!bOrganigramServiceFound)
	{
%>
		<span style="color: red;">Pas d'organigramme !</span>
<%
	}
%>