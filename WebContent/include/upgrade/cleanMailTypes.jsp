<%@page import="mt.paraph.batch.ScannedSignatureNameAndRatioMigration" %>
<%@page import="java.sql.Connection" %>
<%@page import="org.coin.db.ConnectionManager" %>
<%@page import="java.util.HashSet" %>
<%@page import="java.util.Set" %>
<%@page import="java.util.Vector" %>
<%@page import="org.coin.fr.bean.mail.MailType" %>
<%@page import="org.coin.localization.Language" %>
<html>
<head><title>Remove all but not Paraph Folder Mail Type in French</title></head>
<body>
<%!
 /**
  * Class made for the bug#3389.
  * http://bugzilla.mtsoftware.fr/show_bug.cgi?id=3389
  * 
  * Batch that removes all the mail types that:
  * 1. Do not correspond with Parapheur.
  * 2. Are not written in French.
  * 
  * Please see the id mail types in the doBatch () method.
  * This is a copy of the mt.paraph.batch.CleanMailTypes class, without the main () method.
  * 
  * @author Juan José A. Paz
  */
static class CleanMailTypes {
	protected StringBuilder out = new StringBuilder();
	protected Connection conn;
	
	protected void print (){
		out.append ("\n");
	}
	
	protected void print (Object object){
		out.append (object);
		print ();
	}
	
	public String toString (){
		return out.toString();
	}
	
	public CleanMailTypes (Connection conn) throws Exception {
		this.conn = conn;
		doBatch ();
	}
	
	protected void print (MailType mailType, boolean deleted){
		print ((deleted ? "DELETED  " : "KEPT     ") +
				mailType.getId() + "\t| " +
				mailType.getReference() + "\t| " +
				mailType.getLibelle() + "\t| " +
				mailType.getIdLanguage () );
	}
	
	/** Languages to keep **/
	protected final static Set <Long> languagesToKeep = new HashSet <Long> ();
	static {
		for (long lIdLanguage : new long []{0, Language.LANG_FRENCH})
			languagesToKeep.add (lIdLanguage);
	}
	
	protected void doBatch () throws Exception {
		Vector<MailType> vMailType = MailType.getAllMailType (false, conn);
		
		Set <Long> mailsToKeep = new HashSet <Long> ();
		/** Put here the mail types to preserve **/
		for (long lIdMailType : new long []{94, 67, 19, 20,24, 26, 28, 29, 30, 44, 2037, 54, 2038, 53, 2039, 83, 100,
				/** Added in the bug ballotage **/
				27, 21})
			mailsToKeep.add (lIdMailType);
		
		final String sReference = "PARAPH";
		
		int totalKept = 0;
		int totalDeleted = 0;
		
		for (int i = 0; i < vMailType.size(); ++i){
			MailType mailType = vMailType.get (i);
			
			if ((mailsToKeep.contains(mailType.getId())
			|| (mailType.getReference () != null && mailType.getReference().contains (sReference) ) )
			&& languagesToKeep.contains (mailType.getIdLanguage()) )
			{
				print (mailType, false);
				++totalKept;
			} else {
				print (mailType, true);
				mailType.remove (conn);
				++totalDeleted;
			}
		}
		
		print ();
		print ("Total kept: " + totalKept);
		print ("Total deleted: " + totalDeleted);
	}
}
%>
<pre>
<%
Connection conn = ConnectionManager.getConnection ();
try {
	out.println (new CleanMailTypes (conn));
	out.println ("End");
} finally {
	conn.close ();
}
%>
</pre>
</body>
</html>