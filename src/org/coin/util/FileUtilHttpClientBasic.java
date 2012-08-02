package org.coin.util;

import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.util.Vector;

import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.coin.applet.util.CoinFilePart;

public class FileUtilHttpClientBasic extends FileUtilBasic {

	public static String sendHttpRequestPost(
			String sTargetURL,
			NameValuePair[] data) 
	throws HttpException, IOException
	{
		PostMethod post = new PostMethod(sTargetURL);
        post.setRequestBody(data);
        
		HttpClient client = new HttpClient();
		client.executeMethod(post);
		
        post.getResponseBodyAsString(1024 * 1024);
        return post.getResponseBodyAsString();
	}

	
	public static String sendHttpRequest(
			String sTargetURL,
			Vector<Part> vParts,
			Proxy proxy ,
			String sProxyUsername,
			String sProxyPassword
			) 
	throws HttpException, IOException
	{
		PostMethod postMethod = new PostMethod(sTargetURL);
		Part[] parts = CoinFilePart.toArray(vParts);

		postMethod.setRequestEntity(
				new MultipartRequestEntity(parts, postMethod.getParams())
		);

		HttpClient client = new HttpClient();


		/**
		 * Test Proxy
		 */
		System.out.println("Httpclient : Config Proxy");
		//Proxy proxy = getDefaultProxy(sTargetURL);
		if(proxy != null)
		{
			System.out.println("USE proxy type : " + proxy.type());
			InetSocketAddress addr = (InetSocketAddress) proxy.address();

			if(addr !=null ) {
				System.out.println("USE proxy hostname : " + addr.getHostName());
				System.out.println("USE proxy port : " + addr.getPort());
				client.getHostConfiguration().setProxy( addr.getHostName(), addr.getPort());
			}
		} else {
			System.out.println("Httpclient : not proxy found");
		}
		
		/**
		 * Credentials
		 */
		System.out.println("Httpclient : set Credentials");
		if(sProxyUsername != null && !sProxyUsername.equals(""))
		{
			System.out.println("Httpclient : USE Proxy Username : " + sProxyUsername);
			System.out.println("Httpclient : USE Proxy Password : " + sProxyPassword);
			Credentials credentials = new UsernamePasswordCredentials(sProxyUsername, sProxyPassword);
			AuthScope scope = new AuthScope(AuthScope.ANY_HOST,AuthScope.ANY_PORT, AuthScope.ANY_REALM);
			client.getState().setCredentials(scope, credentials);
		} else{
			System.out.println("Httpclient : not Credentials found");
		}	
		
		client.executeMethod(postMethod);

		postMethod.getResponseBodyAsString(1024 * 1024);
		return postMethod.getResponseBodyAsString();
	}

}
