package org.coin.security;

import java.io.UnsupportedEncodingException;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;

import org.coin.bean.conf.Configuration;
import org.coin.db.CoinDatabaseLoadException;
import org.coin.util.HTMLEntities;
import org.coin.util.Outils;
import org.coin.util.WindowsEntities;

public class PreventInjection {

	public static final String preventLoad(String sData) {
		return preventLoad(sData,true);
	}
	
	public static final String preventLoad(String sData, boolean bUseHttpPrevent) {
		if(sData != null){
			if(bUseHttpPrevent)
				return HTMLEntities.htmlentitiesComplete(Outils.stripSlashes(sData));
			return Outils.stripSlashes(sData);
		}
		return null;
	}
	
	public static final String preventLoadHTMLTag(String sData, boolean bUseHttpPrevent) {
		if(sData != null){
			if(bUseHttpPrevent)
				return HTMLEntities.htmlentitiesWithTag(Outils.stripSlashes(sData));
			return Outils.stripSlashes(sData);
		}
		return null;
	}
	
	public static final String preventStore(String sData) {
		  if(sData != null)
		   return Outils.addSlashes(
		     WindowsEntities.cleanUpWindowsEntities(HTMLEntities.unhtmlentitiesComplete(sData))
		     );
		  return null;
	}

	public static final String preventStore(String sData, boolean bUseHttpPrevent) 
	{
		if(sData != null)
		{
			if(bUseHttpPrevent)
				return Outils.addSlashes(
					WindowsEntities.cleanUpWindowsEntities(HTMLEntities.unhtmlentitiesComplete(sData)));
			
			return sData;
		}
		return null;
	}
	
	public static final String preventForJavascript(String sData){
		return preventForJavascript(sData, true);
	}
	
	public static final String preventForJavascript(String sData, boolean bUseHttpPrevent){
		return preventForJavascript(sData, bUseHttpPrevent, true);
	}
	public static final String preventForJavascript(String sData, boolean bUseHttpPrevent, boolean bUseNl2Br){
		if(sData != null){
			if(bUseHttpPrevent){
				String sContent = WindowsEntities.cleanUpWindowsEntities(HTMLEntities.unhtmlentitiesComplete(sData));
				if (bUseNl2Br) sContent = Outils.replaceNltoBr(sContent);//\\n
				return sContent;
			}
		}
		return null;
	}
	
	public static final String preventRequestXMLParameter(String sXML) throws UnsupportedEncodingException, CoinDatabaseLoadException, SQLException, NamingException, InstantiationException, IllegalAccessException {
		  if(sXML != null){
		   sXML = preventXML(sXML);
		   sXML = new String(sXML.getBytes(), Configuration.getConfigurationValueMemory("server.encoding"));
		   return sXML;
		  }
		  return null;
	}
	
	public static final String preventXML(String sXML) {
		  if(sXML != null){
		   sXML = 
			   WindowsEntities.cleanUpWindowsEntities(
					  HTMLEntities.unhtmlentitiesXmlComplete(
						   Outils.stripSlashes(sXML)));
		   return sXML;
		  }
		  return null;
	}
	
	public static final HashMap<String,String> preventStoreRequest(HttpServletRequest request) {
		HashMap<String,String> mapRequest = new HashMap<String,String>();
		Enumeration eParams =  request.getParameterNames();
		while (eParams.hasMoreElements()) { 
			String sParamName = (String) eParams.nextElement(); 
			String sParamValue = request.getParameter(sParamName);
			sParamValue = preventStore(sParamValue);
			mapRequest.put(sParamName,sParamValue);
		}

		return mapRequest;
	}
	
	public static final HashMap<String,String> preventLoadRequest(HttpServletRequest request) {
		HashMap<String,String> mapRequest = new HashMap<String,String>();
		Enumeration eParams =  request.getParameterNames();
		while (eParams.hasMoreElements()) { 
			String sParamName = (String) eParams.nextElement(); 
			String sParamValue = request.getParameter(sParamName);
			sParamValue = preventLoad(sParamValue);
			mapRequest.put(sParamName,sParamValue);
		}

		return mapRequest;
	}
	
	public static PreparedStatement setSecurePreparedStatement(PreparedStatement ps, ArrayList<HashMap<String,String>> variables, Object obj){
		Field[] fields = obj.getClass().getDeclaredFields();
		for(Field field : fields){
			if(field.getType() == String.class){
				int iFieldPos = -1;
				String sVariable = "";
				String sGetter = "";
				@SuppressWarnings("unused") String sSQL = "";
				for(int iField = 0;iField<variables.size();iField++){
					try{
						HashMap<String,String> map = variables.get(iField);
						sVariable = map.get("variable");
						sGetter = map.get("getter");
						sSQL = map.get("sql");
						if(sVariable.equalsIgnoreCase(field.getName())){
							iFieldPos = iField;
							break;
						}
					}catch(Exception e){}
				}
				if(iFieldPos >= 0 ){
					try{
						Class[] arg = {};
						Object[] arg2 = {};
						Class cl = PreventInjection.class.getClassLoader().loadClass(obj.getClass().getName());
						Method mMethod = cl.getMethod(sGetter, arg);
						ps.setString((iFieldPos+1),preventStore((String)mMethod.invoke(obj, arg2)));
					}catch(Exception e){}
				}
			}
		}
		return ps;
	}
}
