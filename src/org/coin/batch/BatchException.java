package org.coin.batch;

public class BatchException extends Exception{

	private static final long serialVersionUID = 1L;
	
	public BatchException(Exception e){
		super(e);
	}

}
