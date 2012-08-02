package org.coin.ws;

import java.io.IOException;
import java.net.URL;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.xml.namespace.QName;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.ServiceException;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.encoding.XMLType;
import org.apache.soap.SOAPException;
import org.coin.util.BasicDom;
import org.coin.util.Outils;
import org.coin.util.StringUtil;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

public class Axis {
	
	public final static String PARAM_NAME = "PARAM_NAME";
	public final static String PARAM_TYPE = "PARAM_TYPE";
	public final static String PARAM_OBJECT = "PARAM_OBJECT";
	
	public static void getAxis(
			URL url, 
			String sOperationName,
			String sParameterName,
			long lParameterValue) 
	throws SOAPException, ServiceException, RemoteException {
		System.out.println("\n\nServeur à contacter : " + url + " sOperationName " + sOperationName);

		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		call.addParameter(sParameterName, XMLType.XSD_LONG, ParameterMode.IN);
		call.setReturnType(XMLType.XSD_ANY);

		String[][] sResp = (String[][]) call.invoke( new Object[] { new Long (lParameterValue)} );
		System.out.println("RESULTAT:" );
		StringUtil.displayArrayString(sResp) ;
	}
	
	
	public static void getAxis(
			URL url, 
			String sOperationName,
			String sParameterName,
			String sParameterValue) 
	throws SOAPException, ServiceException, RemoteException {
		System.out.println("\n\nServeur à contacter : " + url + " sOperationName " + sOperationName);

		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		call.addParameter(sParameterName, XMLType.XSD_STRING, ParameterMode.IN);
		call.setReturnType(XMLType.XSD_ANY);

		String[][] sResp = (String[][]) call.invoke( new Object[] { new String (sParameterValue)} );
		System.out.println("RESULTAT:" );
		StringUtil.displayArrayString(sResp) ;
	}
	
	public static void getAxis(
			URL url, 
			String sOperationName,
			String sParameterName1,
			long lParameterValue1,
			String sParameterName2,
			String sParameterValue2) 
	throws SOAPException, ServiceException, RemoteException {
		System.out.println("\n\nServeur à contacter : " + url + " sOperationName " + sOperationName);

		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		call.addParameter(sParameterName1, XMLType.XSD_LONG, ParameterMode.IN);
		call.addParameter(sParameterName2, XMLType.XSD_STRING, ParameterMode.IN);
		call.setReturnType(XMLType.XSD_ANY);

		String[][] sResp = (String[][]) call.invoke( 
				new Object[] { 
						new Long (lParameterValue1), 
						new String (sParameterValue2)} );
		System.out.println("RESULTAT:" );
		StringUtil.displayArrayString(sResp) ;
	}
	
	
	public static void getAxis(
			URL url, 
			String sOperationName,
			String sParameterName1,
			long lParameterValue1,
			String sParameterName2,
			long lParameterValue2,
			String sParameterName3,
			String sParameterValue3) 
	throws SOAPException, ServiceException, RemoteException {
		System.out.println("\n\nServeur à contacter : " + url + " sOperationName " + sOperationName);

		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		call.addParameter(sParameterName1, XMLType.XSD_LONG, ParameterMode.IN);
		call.addParameter(sParameterName2, XMLType.XSD_LONG, ParameterMode.IN);
		call.addParameter(sParameterName3, XMLType.XSD_STRING, ParameterMode.IN);
		call.setReturnType(XMLType.XSD_ANY);

		String[][] sResp = (String[][]) call.invoke( 
				new Object[] { 
						new Long (lParameterValue1), 
						new Long (lParameterValue2), 
						new String (sParameterValue3)} );
		System.out.println("RESULTAT:" );
		StringUtil.displayArrayString(sResp) ;
	}
	
	
	public static void getAxis(
			URL url, 
			String sOperationName,
			String sParameterName1,
			long lParameterValue1,
			String sParameterName2,
			long lParameterValue2) 
	throws SOAPException, ServiceException, RemoteException {
		System.out.println("\n\nServeur à contacter : " + url + " sOperationName " + sOperationName);

		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		call.addParameter(sParameterName1, XMLType.XSD_LONG, ParameterMode.IN);
		call.addParameter(sParameterName2, XMLType.XSD_LONG, ParameterMode.IN);
		call.setReturnType(XMLType.XSD_ANY);

		String[][] sResp = (String[][]) call.invoke( 
				new Object[] { 
						new Long (lParameterValue1), 
						new Long (lParameterValue2)} );
		System.out.println("RESULTAT:" );
		StringUtil.displayArrayString(sResp) ;
	}

	public static void displayParams(
			ArrayList<HashMap<String, Object>> mapParams) 
	{
		System.out.println(getDisplayParams(mapParams));
	}
	
	public static String getDisplayParams(
			ArrayList<HashMap<String, Object>> mapParams) 
	{
		String sParamList = "";
		
		for(int i=0;i<mapParams.size();i++){
			HashMap<String, Object> mapParam = mapParams.get(i);
			sParamList += 
					i + " "
					+ "[" + (String)mapParam.get(PARAM_NAME) + "]"
					+ " " + mapParam.get(PARAM_OBJECT)
					+ "\n";
		}
		
		return sParamList;
	}
	
	public static String call(
			URL url, 
			String sOperationName,
			String sNameSpace,
			ArrayList<HashMap<String, Object>> mapParams) 
	throws SOAPException, ServiceException, RemoteException 
	{
		return call(url, sOperationName, sNameSpace, mapParams, true);
	}
	
	public static String call(
			URL url, 
			String sOperationName,
			String sNameSpace,
			ArrayList<HashMap<String, Object>> mapParams,
			boolean bTrace) 
	throws SOAPException, ServiceException, RemoteException 
	{
		if(bTrace) {
			System.out.println("MAKE AXIS CALL :\n" 
				+ "Operation name : " + sOperationName + "\n"
				+ "NameSpace      : " + sNameSpace + "\n"
				+ "Url            : " + url );
			displayParams(mapParams);
		}
		
		Service service = new Service();
		Call call = (Call) service.createCall();
		call.setTargetEndpointAddress(url);
		call.setOperationName( sOperationName );
		
		Object[] paramValues = new Object[mapParams.size()];
		for(int i=0;i<mapParams.size();i++){
			HashMap<String, Object> mapParam = mapParams.get(i);
			call.addParameter(
					(String)mapParam.get(PARAM_NAME), 
					(QName)mapParam.get(PARAM_TYPE), 
					ParameterMode.IN);
			paramValues[i] = mapParam.get(PARAM_OBJECT);
		}
		
		
		call.setReturnType(XMLType.XSD_ANY);

		String sResp = (String) call.invoke(
				sNameSpace,
				sOperationName,
				paramValues );
		
		try {
			System.out.println("Return : \n");
			Document doc = BasicDom.parseXmlStream(sResp, false);
			System.out.println(Outils.getXmlStringIndent(doc));
			System.out.println("\n\n\n");
		} catch (Exception e) {
			e.printStackTrace();
		}

		
		return sResp;
	}
	
	public static HashMap<String, Object> setParameter(
			String sParamName,
			QName qParamType,
			Object oValue
			){
		HashMap<String, Object> mapParam = new HashMap<String, Object>();
		mapParam.put(PARAM_NAME, sParamName);
		mapParam.put(PARAM_TYPE, qParamType);
		mapParam.put(PARAM_OBJECT, oValue);
		return mapParam;
	}
}
