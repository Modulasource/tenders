package org.coin.util;

import java.net.Authenticator;
import java.net.PasswordAuthentication;

public class CoinAuthenticator extends Authenticator {
	
	protected String sUsername ;
	protected String sPassword ;
	
	public CoinAuthenticator(
			String sUsername,
			String sPassword ) 
	{
		this.sUsername = sUsername ;
		this.sPassword = sPassword;
	}
	
	public PasswordAuthentication getPasswordAuthentication() {
		return (
				new PasswordAuthentication(
						sUsername,
						sPassword.toCharArray()));
	}
}
