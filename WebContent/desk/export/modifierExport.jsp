
<%@ page import="java.util.*,org.coin.fr.bean.export.*"%>
<%@ include file="../include/beanSessionUser.jspf" %>
<%
	String sAction = request.getParameter("sAction");
	String sUrlRedirect ="";
	if (request.getParameter("sUrlRedirect") != null)
	{
		sUrlRedirect = request.getParameter("sUrlRedirect") ;
	}
	
	if(sAction.equals("remove"))
	{
		int iIdExport = Integer.parseInt(request.getParameter("iIdExport"));
		Export export = Export.getExport(iIdExport );
		
		sUrlRedirect += "&iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
				 + "&nonce=" +System.currentTimeMillis();
		
		
		if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
		{
			//ExportModeEmail exportModeEmail = ExportModeEmail.getExportModeEmail(export.getIdExportModeId());
			// exportModeEmail.remove();
		}


		if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
		{
			ExportModeWS exportModeWS = ExportModeWS.getExportModeWS(export.getIdExportModeId());
			exportModeWS.remove();
		}

		if (export.getIdExportMode() == ExportMode.MODE_FTP) 
		{
			ExportModeFTP exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
			exportModeFTP.remove();
		}

		Vector<ExportParametre> vParams = ExportParametre.getAllFromIdExport(export.getIdExport());
		
		for(int i =0 ;i < vParams.size() ; i++)
		{
			vParams.get(i).remove(); 
		}

		export.remove();
		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}


	if(sAction.equals("create"))
	{
		Export export = new Export();
		export.setFromForm(request, "");

	
		sUrlRedirect += "&iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
				 + "&nonce=" +System.currentTimeMillis();

		if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
		{
			//ExportModeEmail exportModeEmail = new ExportModeEmail();
			//exportModeEmail.setFromForm(request, "");
			//exportModeEmail.create();
			//export.setIdExportModeId(exportModeEmail.getIdExportModeEmail());
		}

		if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
		{
			ExportModeWS exportModeWS = new ExportModeWS();
			exportModeWS.setFromForm(request, "");
			exportModeWS.create();
			export.setIdExportModeId(exportModeWS.getIdExportModeWS());
		}

		if (export.getIdExportMode() == ExportMode.MODE_FTP) 
		{
			ExportModeFTP exportModeFTP = new ExportModeFTP();
			exportModeFTP.setFromForm(request, "");
			exportModeFTP.create();
			export.setIdExportModeId(exportModeFTP.getIdExportModeFTP());
		}

		export.create();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	

	if(sAction.equals("store"))
	{
		Export export = Export.getExport(Integer.parseInt( request.getParameter("iIdExport") ));
		export.setFromForm(request, "");
		export.store();

		if (export.getIdExportMode() == ExportMode.MODE_WEB_SERVICE) 
		{
			if(export.getIdExportModeId() != 0)
			{
				ExportModeWS  exportModeWS = ExportModeWS.getExportModeWS(export.getIdExportModeId());
				exportModeWS.setFromForm(request, "");
				exportModeWS.store();
			}
			else
			{
				ExportModeWS  exportModeWS = new ExportModeWS();
				exportModeWS.setFromForm(request, "");
				exportModeWS.create();
				export.setIdExportModeId(exportModeWS.getIdExportModeWS());
				export.store();
			}		
		}

		if (export.getIdExportMode() == ExportMode.MODE_FTP) 
		{
			if(export.getIdExportModeId() != 0)
			{
				ExportModeFTP  exportModeFTP = ExportModeFTP.getExportModeFTP(export.getIdExportModeId());
				exportModeFTP.setFromForm(request, "");
				exportModeFTP.store();
			}
			else
			{
				ExportModeFTP exportModeFTP = new ExportModeFTP();
				exportModeFTP.setFromForm(request, "");
				exportModeFTP.create();
				export.setIdExportModeId(exportModeFTP.getIdExportModeFTP());
				export.store();
			}		
		}
	
		if (export.getIdExportMode() == ExportMode.MODE_EMAIL) 
		{
			if(export.getIdExportModeId() != 0)
			{
				//ExportModeEmail exportModeEmail = ExportModeEmail.getExportModeEmail(export.getIdExportModeId());
				//exportModeEmail.setFromForm(request, "");
				//exportModeEmail.store();
			}
			else
			{
				//ExportModeEmail exportModeEmail = new ExportModeEmail();
			//	exportModeEmail.setFromForm(request, "");
				//exportModeEmail.create();
				export.setIdExportModeId(ExportMode.MODE_EMAIL);
				export.store();
			}		
			int iDestinataireSize = 0;
			try {
				iDestinataireSize = Integer.parseInt( request.getParameter("iDestinataireSize") );
			} catch (Exception e) {}
			for(int i=0 ;i < iDestinataireSize; i++)
			{
				int iIdDestinataire = Integer.parseInt( request.getParameter("iIdDestinataire" + i) );
				String sTypeDestinataire = request.getParameter("sTypeDestinataire" + i) ;
				String sEmailDestinataire = request.getParameter("sEmailDestinataire" + i) ;
				
				ExportModeEmailDestinataire destinataire = ExportModeEmailDestinataire.getExportModeEmailDestinataire(iIdDestinataire);
				destinataire.setEmailDestinataire(sEmailDestinataire);
				destinataire.setTypeDestinataire(sTypeDestinataire);
				destinataire.store();
				Vector<org.coin.fr.bean.export.ExportModeEmailPieceJointeType> vPieceJointeType = org.coin.fr.bean.export.ExportModeEmailPieceJointeType.getAllExportModeEmailPieceJointeType();
				String piecesJointes[] = request.getParameterValues("pieceJointe"+i);
				if (piecesJointes!=null){
					Vector<ExportModeEmailDestinatairePieceJointe> vDestinatairePieceJointe = ExportModeEmailDestinatairePieceJointe.getAllDestinatairesPieceJointeFromDestinataire(destinataire.getIdExportModeEmailDestinataire());
					for(int j=0;j<vDestinatairePieceJointe.size();j++){
						vDestinatairePieceJointe.get(j).remove();
					}
					for(int j=0;j<piecesJointes.length;j++){
						ExportModeEmailDestinatairePieceJointe pieceJointe = new ExportModeEmailDestinatairePieceJointe();
						pieceJointe.setIdExportModeEmailDestinataire(destinataire.getIdExportModeEmailDestinataire());
						pieceJointe.setIdExportModeEmailPieceJointeType(Integer.parseInt(piecesJointes[j]));
						pieceJointe.create();
					}
				}
			}
		}

		int iParamSize = Integer.parseInt( request.getParameter("iParamSize") );
		for(int i=0 ;i < iParamSize; i++)
		{
			int iIdParametre = Integer.parseInt( request.getParameter("param_" + i) );
			String sParametreName = request.getParameter("paramName_" + i) ;
			String sParametreValue = request.getParameter("paramValue_" + i) ;
			
			ExportParametre param = ExportParametre.getExportParametre(iIdParametre);
			param.setName(sParametreName);
			param.setValue(sParametreValue);
			param.store();
		}


		sUrlRedirect += "&iIdObjetReferenceSource=" + export.getIdObjetReferenceSource()
				 + "&nonce=" +System.currentTimeMillis();

		response.sendRedirect(response.encodeRedirectURL(sUrlRedirect)); 
		return;
	}	
	
%>
