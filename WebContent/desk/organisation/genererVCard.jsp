
<%@ page import="org.coin.fr.bean.*,java.io.*" %>
<%
	String rootPath = request.getContextPath()+"/";
	int iIdPersonne ;
	
	try {
		iIdPersonne= Integer.parseInt(request.getParameter("iIdPersonnePhysique"));
		
	} catch (Exception e) {
		response.sendRedirect(response.encodeRedirectURL(rootPath + "desk/errorAdmin.jsp?idError=17"));
		return;
	}	
	
	/* Modification de la personne physique */
	PersonnePhysique personne = PersonnePhysique.getPersonnePhysique(iIdPersonne);
				
	Adresse adresse = Adresse.getAdresse(personne.getIdAdresse());
	Organisation organisation = Organisation.getOrganisation(personne.getIdOrganisation());


	response.setContentType("application/outlook");
	String sbFilename = personne.getNom() + "_" + personne.getPrenom() + ".vcf";
	ByteArrayOutputStream baosPDF = new ByteArrayOutputStream();
	
	StringBuffer sbContentDispValue = new StringBuffer();
	sbContentDispValue.append("inline");
	sbContentDispValue.append("; filename=");
	sbContentDispValue.append(sbFilename);
					
	response.setHeader(
		"Content-disposition",
		sbContentDispValue.toString());

	String s = "BEGIN:VCARD\nVERSION:2.1\n";
	String sTemp;	
	
	s += "N:" + personne.getNom() + ";" + personne.getPrenom() +"\n";
	s += "FN:" + personne.getPrenom() + " " + personne.getNom() +"\n";
	s += "ORG:" + organisation.getRaisonSociale() + "\n";
	s += "TEL;WORK;VOICE:" + personne.getTel() + "\n";
	s += "TEL;CELL;VOICE:" + personne.getTelPortable() + "\n";
	s += "ADR;WORK:ENCODING=QUOTED-PRINTABLE:;;" ;

	sTemp = adresse.getAdresseLigne1();
	if(!sTemp.equals(""))
		s += sTemp + "=0D=0A" ;
		
	sTemp = adresse.getAdresseLigne2();
	if(!sTemp.equals(""))
		s += sTemp  + "=0D=0A" ;

	sTemp = adresse.getVoieNom();
	if(!sTemp.equals(""))
		s += adresse.getVoieNumero() + " " + adresse.getVoieType() + " " +  adresse.getVoieNom() + ";";

	sTemp = adresse.getAdresseLigne3();
	if(!sTemp.equals(""))
		s += adresse.getAdresseLigne3() + "=0D=0A" ;


	s  += adresse.getCommune() + ";;"
		+ adresse.getCodePostal() + ";" 
		+ Pays.getPaysName(adresse.getIdPays()) + "\n" ;
	s += "EMAIL;PREF;INTERNET:"  + personne.getEmail() + "\n";		
	s += "END:VCARD";
	
	baosPDF.write(s.getBytes());
	response.setContentLength(baosPDF.size());
	ServletOutputStream sos;

	sos = response.getOutputStream();
	baosPDF.writeTo(sos);
	
	sos.flush();
%>