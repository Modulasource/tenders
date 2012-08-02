/*
 * Created on 18 octobre 2005
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package org.coin.servlet;

import java.io.IOException;
import java.util.Vector;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.coin.bean.User;
import org.coin.bean.UserHabilitation;
import org.coin.bean.editorial.EditorialAssistance;
import org.coin.security.PreventInjection;
import org.coin.util.HTMLEntities;
import org.coin.util.Outils;

/**
 * @author François
 *
 * Retourne un tableau (en code Javascript) contenant la liste des raisons sociales
 * s'apparentant à la chaine de caractères fournie en entrée.
 * 
 */
public class GetListeForAjaxAideRedac extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doPost(
			HttpServletRequest request, 
			HttpServletResponse response) {
	
		response.setHeader("Cache-Control", "no-cache");
		try 
		{
			User user = (User)request.getSession().getAttribute("sessionUser");
			UserHabilitation userHabilitation = (UserHabilitation)request.getSession().getAttribute("sessionUserHabilitation");
			
			String sAction=request.getParameter("sAction");
			int iId = -1;
			try
			{
				iId = Integer.parseInt(sAction.split("_")[1]);
				sAction = sAction.split("_")[0];
			}
			catch(Exception e){}
			
			if (sAction.equalsIgnoreCase("getEditorialAssistanceGroup")){
				String sChampRecherche = PreventInjection.preventStore(request.getParameter("sChampRecherche"));
				String sChampTextField = request.getParameter("sChampTextField");
				String sVarAJAR = request.getParameter("sVarAJAR");

				int iLimitOffset = 0;
				if (request.getParameter("iLimitOffset")!=null){
					iLimitOffset = Integer.parseInt(request.getParameter("iLimitOffset"));
				}
				int iLimit = 0;
				if (request.getParameter("iLimit")!=null){
					iLimit = Integer.parseInt(request.getParameter("iLimit"));
				}
				
				Vector<EditorialAssistance> vEdit = EditorialAssistance.getAllFromEditorialAssistanceGroupWithHabilitationsLike(iId,user,userHabilitation,sChampRecherche,iLimit,iLimitOffset,true);
				int iTotal = EditorialAssistance.getCountFromEditorialAssistanceGroupWithHabilitationsLike(iId,user,userHabilitation,sChampRecherche,0,0);
				
				/**
				 * USAGE :
				 * 
				 * Il faut retourner dans du code Javascript, 2 tableaux :
				 * 1) Un tableau aEntete définissant l'entête du Datagrid
				 * 2) Un tableau aDonnees définissant les résultats
				 * 3) Un objet onRowClick pour le comportement
				 * 
				 */

				String sSyntaxJavascript = "var aEntete = new Array(" +
						"{libelle:'Nom', titre:'Nom', width:'20%', visible:true}," +
						"{libelle:'Contenu', titre:'Contenu', width:'80%', visible:true}," +
						"{libelle:'ContenuEntier', titre:'', width:'0%', visible:false}" +
						");";
				
				sSyntaxJavascript += "var aDonnees = new Array();";
				
				for(int i=0;i<vEdit.size();i++)
				{
					EditorialAssistance edit = vEdit.get(i);
					String sNom = Outils.encodeUtf8("<br/><b>"+Outils.addSlashes(edit.getName())+"</b>");
					String sContenu = Outils.encodeUtf8(Outils.tronquerChaineParMot("<br/>"+Outils.replaceNltoBr(Outils.addSlashes(edit.getContenu())),200)+"<br/><br/>");
					String sContenuEntier = Outils.encodeUtf8(Outils.replaceNltoBr(Outils.addSlashes(edit.getContenu())));
					sSyntaxJavascript += "aDonnees.push(new Array(\""+sNom+"\", \""+sContenu+"\", \""+sContenuEntier+"\"));";
				}
				sSyntaxJavascript += "var onRowClick = new Object(" +
						"{sAction:'AJAR_addToTextField', " +
						"iParamColIndexValue:2," +
						"aParamSuppl:['"+sChampTextField+"','"+sVarAJAR+"']}" +
						");";
				response.getWriter().write(sSyntaxJavascript);
				response.getWriter().write("iTotal="+iTotal+";");
			}

			else
			{
				response.getWriter().write("");
			}
		} catch (IOException e) {
			e.printStackTrace();
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
}
