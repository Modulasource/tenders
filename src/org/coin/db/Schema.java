package org.coin.db;


public class Schema implements Comparable<Object>{
	
	protected String sNameSchema;
	
	Schema(){}
	

	public String getSNameSchema() {
		return sNameSchema;
	}

	public void setSNameSchema(String nameSchema) {
		sNameSchema = nameSchema;
	}
	


	public int compareTo(Object arg0) {
		return 0;
	}

}

