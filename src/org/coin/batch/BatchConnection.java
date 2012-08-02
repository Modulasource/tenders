package org.coin.batch;

import mt.modula.batch.RemoteControlServiceConnection;

import org.coin.db.ConnectionManager;
import org.coin.util.JavaUtil;

public class BatchConnection {
	public static RemoteControlServiceConnection connMysqlS8VeoliaDev = new RemoteControlServiceConnection("jdbc:mysql://serveur8.matamore.com:3306/veolia_dev?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlS24VeoliaDev = new RemoteControlServiceConnection("jdbc:mysql://serveur24.matamore.com:3306/veolia_dev?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlM1VeoliaPlay = new RemoteControlServiceConnection("jdbc:mysql://m1.mtsoftware.fr:3306/veolia_play?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlM1VeoliaDev = new RemoteControlServiceConnection("jdbc:mysql://m1.mtsoftware.fr:3306/veolia_dev?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlS8VeoliaMig = new RemoteControlServiceConnection("jdbc:mysql://serveur8.matamore.com:3306/veolia_migration?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	
	public static RemoteControlServiceConnection connSqlserverLocalVeoliaDevJR = new RemoteControlServiceConnection("jdbc:sqlserver://localhost:1433;databaseName=veolia_dev;user=veolia_login;password=veolia_login2008","veolia_login", "veolia_login",ConnectionManager.DBTYPE_SQL_SERVER );
	public static RemoteControlServiceConnection connSqlserverLocalVeoliaDevDK = new RemoteControlServiceConnection("jdbc:sqlserver://127.0.0.1:1433;databaseName=vfr_prod;user=sa;password=modula","sa", "modula",ConnectionManager.DBTYPE_SQL_SERVER );
	public static RemoteControlServiceConnection connSqlserverLocalVeoliaDevJRPort = new RemoteControlServiceConnection("jdbc:sqlserver://localhost:1433;databaseName=vfr_prod;user=sa;password=mt5*team","sa", "mt5*team",ConnectionManager.DBTYPE_SQL_SERVER );
	public static RemoteControlServiceConnection connSqlServerLocalVeoliaPlayLG = new RemoteControlServiceConnection("jdbc:sqlserver://localhost:1433;databaseName=vfr_prod;user=sa;password=sa","sa", "sa",ConnectionManager.DBTYPE_SQL_SERVER );
	public static RemoteControlServiceConnection connSqlServerDev = new RemoteControlServiceConnection("jdbc:sqlserver://192.168.1.101:1433;databaseName=veolia_dev;user=veolia_login;password=veolia_login2008","veolia_login", "veolia_login2008",ConnectionManager.DBTYPE_SQL_SERVER );
	
	public static RemoteControlServiceConnection connMysqlS8ModulaTest = new RemoteControlServiceConnection("jdbc:mysql://serveur8.matamore.com:3306/modula_test?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlS12ModulaAntillesGuyane = new RemoteControlServiceConnection("jdbc:mysql://serveur12.matamore.com:3306/modula_antilles_guyane?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlS11ModulaCCCE = new RemoteControlServiceConnection("jdbc:mysql://serveur11.matamore.com:3306/modula_ccce?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	public static RemoteControlServiceConnection connMysqlS11ModulaCCCE_streaming = new RemoteControlServiceConnection("jdbc:mysql://serveur11.matamore.com:3306/modula_ccce?","dba_account", "dba_account",ConnectionManager.DBTYPE_MYSQL );
	
	public static RemoteControlServiceConnection getRequestRemoteConnection(String sConnFieldName) throws SecurityException, IllegalArgumentException, ClassNotFoundException, NoSuchFieldException, IllegalAccessException{
		RemoteControlServiceConnection rc = (RemoteControlServiceConnection)JavaUtil.getPublicFieldValue(new BatchConnection(), BatchConnection.class.getName(), sConnFieldName);
		return rc;
	}
}
