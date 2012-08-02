package org.coin.batch;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.sql.Timestamp;
import java.util.Vector;

import modula.journal.Evenement;
import modula.journal.EvenementSeverite;
import mt.modula.bean.mail.MailModula;

import org.coin.bean.ObjectType;
import org.coin.bean.conf.Configuration;
import org.coin.fr.bean.mail.MailConstant;
import org.coin.fr.bean.mail.MailType;
import org.coin.mail.Courrier;
import org.coin.util.Outils;

public class BatchListener{

	public static final String _NAME = "BatchListener";
	public long lStartTime = 0;
	public long lStopTime = 0;
	public long lDuration = 0;
	
	public boolean bUseEventLogger = true;
	
	public BatchListener(boolean bUseEventLogger) {
		this.bUseEventLogger = bUseEventLogger;
	}
	
	public String getName() {
		return _NAME;
	}
	
	public void batchToBeExecuted(Batch ctx) {
		batchToBeExecuted(ctx,"CU-CRON-1");
	}

	public void batchToBeExecuted(Batch ctx, String sUseCaseID) {
		this.lStartTime = System.currentTimeMillis();
		if(this.bUseEventLogger)
			addEvenementStarted(ctx,sUseCaseID);
	}

	public void batchExecutionVetoed(Batch arg0) {
	}
	
	public void batchWasExecuted(Batch ctx, BatchException e) {
		batchWasExecuted(ctx,e,"CU-BATCH-1");
	}

	public void batchWasExecuted(Batch ctx, BatchException e, String sUseCaseID) {
		this.lStopTime = System.currentTimeMillis();
		if(this.bUseEventLogger)
			addEvenementExecuted(ctx,sUseCaseID);
		
		if(e != null)
		{
			try
			{
				String sMessage = e.getMessage();
				
				Evenement.addEvenementException(
						0, 
						sUseCaseID , 
						Evenement.ID_CRON_USER, 
						ctx.getName()+" error : "+sMessage,
						EvenementSeverite.TYPE_ERROR,
						e);
				
				sendMail(ctx,sMessage);
			}
			catch(Exception evt){}
		}
	}
	
	public void batchWasExecutedMultiple(Batch ctx, Vector<BatchException> vE, String sUseCaseID) {
		
		if(vE != null && vE.size()>0)
		{
			try
			{
				String sException = "";
				String sMessage = "";
				for(BatchException e : vE){
					ByteArrayOutputStream baosException = new ByteArrayOutputStream();
					PrintStream psException = new PrintStream(baosException, true);
					e.printStackTrace(psException);
					sMessage += e.getMessage()+"\n";
					sException += baosException.toString()+"\n";
				}

				Evenement.addEvenement(
						0, 
						sUseCaseID , 
						Evenement.ID_CRON_USER, 
						ctx.getName()+" error : "+sMessage,
						EvenementSeverite.TYPE_ERROR,
						sException);
				
				sendMail(ctx,sMessage + sException);
			}
			catch(Exception evt){}
		}
	}
	
	public void addEvenementExecuted(Batch ctx,String sUseCaseID){
		try
		{
			this.lDuration = this.lStopTime - this.lStartTime;
			Evenement.addEvenement(
					0, 
					sUseCaseID , 
					Evenement.ID_CRON_USER, 
					ctx.getName()+" executed ("+this.lDuration+" ms)",
					EvenementSeverite.TYPE_INFO);
		}
		catch(Exception exc){}
	}
	
	public void addEvenementStarted(Batch ctx,String sUseCaseID){
		try
		{
			Evenement.addEvenement(
					0, 
					sUseCaseID , 
					Evenement.ID_CRON_USER, 
					ctx.getName()+" started",
					EvenementSeverite.TYPE_INFO);
		}
		catch(Exception exc){}
	}
	
	public static void sendMail(Batch ctx,String sMessage) throws Exception{
		boolean bSendMail = (Configuration.getConfigurationValueMemory("batch.mail").equalsIgnoreCase("enabled")?true:false);
		
		if(bSendMail){
			String sTo = Configuration.getConfigurationValueMemory("batch.mail.list");
			MailType mailType = MailType.getMailTypeMemory(MailConstant.MAIL_TRAITEMENT_ERREUR,false);
			Courrier courrier = new Courrier();  
			courrier.setIdObject(Evenement.ID_CRON_USER);
			courrier.setIdObjectType(ObjectType.SYSTEME);
			courrier.setTo(sTo);
			courrier.setDateStockage(new Timestamp(System.currentTimeMillis()));
			courrier.setDateEnvoiPrevu(new Timestamp(System.currentTimeMillis()));
			courrier.setSend(true);
	
			String sObjet = mailType.getObjetType();
			String contenuMail = mailType.getContenuType();
			contenuMail = Outils.replaceAll(contenuMail, "[erreur]", ctx.getName()+" error : "+sMessage);
			courrier.setSubject(sObjet);
			courrier.setMessage(contenuMail);
			courrier.create();
			
			MailModula mail = new MailModula();
			mail.addTo(sTo);
			mail.computeFromCourrier(courrier);
			mail.send();
		}
	}
}
