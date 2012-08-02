package org.coin.security;

public class SessionException extends Exception {
	private static final long serialVersionUID = 1L;
	
	public SessionException(String string) {
		super(string);
	}

	public SessionException(String string, String sUseCase) {
		super(string);
	}
}
