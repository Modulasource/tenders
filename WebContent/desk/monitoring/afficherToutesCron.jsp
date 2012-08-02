<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.util.*,org.coin.bean.html.*,java.util.*,org.quartz.*,org.coin.bean.cron.*,mt.modula.cron.*" %>
<%
	String sTitle = "Les CRON";
	String sPageUseCaseId = "IHM-DESK-PARAM-CRON-1";
	
	String sAction = "";
	if(request.getParameter("sAction") != null)
		sAction = request.getParameter("sAction");
	
	String sMessage = "";
	try{sMessage = request.getParameter("sMessage");}
	catch(Exception e){}
	if(sMessage == null) sMessage = "";
	
	HtmlBeanTableTrPave hbFormulaire = new HtmlBeanTableTrPave();
	hbFormulaire.bIsForm = false;

	if(sAction.equalsIgnoreCase("launchManuallyJob"))
	{
		String sJobName = request.getParameter("sJobName");
		String sJobGroup = request.getParameter("sJobGroup");
		CronUtil.launchManuallyJob(sJobName,sJobGroup);
		
		sMessage = "Execution de "+sJobName+" réalisée avec succès!";
	}
	
	JobDetail jobDetailModify = null;
	if(sAction.equalsIgnoreCase("storeForm"))
	{
		String sJobName = request.getParameter("sJobName");
		String sJobGroup = request.getParameter("sJobGroup");
		jobDetailModify = CronUtil.getJobDetail(sJobName,sJobGroup);
	}
	
	if(sAction.equalsIgnoreCase("store") || sAction.equalsIgnoreCase("create"))
	{
		String sJobClass = request.getParameter("sJobClass");
		Class[] argTypes = JavaUtil.getConstructorParamType(sJobClass,0);
		ArrayList<Object> arg = new ArrayList<Object>();
		int i = 0;
		while(request.getParameter("sJobArg"+i) != null)
		{
			if(argTypes[i] == int.class){
				arg.add(Integer.parseInt(request.getParameter("sJobArg"+i)));
			} else if(argTypes[i] == String.class){
				arg.add(request.getParameter("sJobArg"+i));
			} else if(argTypes[i] == Boolean.class){
				arg.add(Boolean.parseBoolean(request.getParameter("sJobArg"+i)));
			}

			i++;
		}
		Object objCron = JavaUtil.invokeConstructor(sJobClass,arg);
		JavaUtil.invokeMethod(objCron,sJobClass,sAction,new ArrayList());
	}
	
	if(sAction.equalsIgnoreCase("remove"))
	{
		String sJobClass = request.getParameter("sJobClass");
		Object objCron = JavaUtil.invokeConstructor(sJobClass,new ArrayList());
		JavaUtil.invokeMethod(objCron,sJobClass,sAction,new ArrayList());
	}
%>
<%@ include file="../include/checkHabilitationPage.jspf" %>
</head>
<body style="overflow: auto;">
<%@ include file="../../include/new_style/headerFiche.jspf" %>
<div style="padding:15px">
<p class="mention">
<strong>Syntaxe des tâches de fond (CRON)</strong><br />
1. Secondes<br />
2. Minutes<br />
3. Heures<br />
4. Jour du mois<br />
5. Mois<br />
6. Jour de la semaine (en anglais)<br />
7. Année (champ optionnel)<br />
<br />
Exemple d'expression complète pour une tâche de fond : "0 0 12 ? * WED" - qui signifie "chaque mercredi à 12h00 (midi)".
</p>
<%
if(!sMessage.equalsIgnoreCase(""))
{
%>
<div class="rouge" style="text-align:left" id="message"><%= sMessage %></div>
<br />
<%
}
%>
<br/>
<%
	try{
	String sPackageCron = org.coin.bean.conf.Configuration.getConfigurationValueMemory("quartz.cron.package");
	Class[] crons = JavaUtil.getClasses(sPackageCron);
	Vector<CronTrigger> vCron = CronUtil.getAllSystemCron();
	
	HashMap<String,Boolean> mapExist = new HashMap<String,Boolean>();
	for(CronTrigger cronExist : vCron )
	{
		mapExist.put(sPackageCron+"."+cronExist.getJobName(),true);
	}
	Vector<JobDetail> vJobDetailCreate = new Vector<JobDetail>();
	Vector<String> vJobCronExp = new Vector<String>();
	for(Class cron : crons){
		Boolean bExist = mapExist.get(cron.getName());
		if(bExist == null || (bExist != null && !bExist)){
			Object objCron = JavaUtil.invokeConstructor(cron.getName(),new ArrayList());
			vJobDetailCreate.add((JobDetail)JavaUtil.invokeMethod(objCron,cron.getName(),"getNewJobDetail",new ArrayList()));
			
	        String sJobCronExp = "";
            try{sJobCronExp = (String)JavaUtil.getPublicFieldValue(objCron,cron.getName(),"sCronExp");}
            catch(Exception e){sJobCronExp = "";}
            vJobCronExp.add(sJobCronExp);
		}
	}

%>
<table class="pave" >
		<tr>
			<td class="pave_titre_gauche"> Liste des cron </td>

			<td class="pave_titre_droite"><%= vCron.size()+vJobDetailCreate.size() %> cron</td>
		</tr>
		<tr>
			<td colspan="2">
				<table class="liste" >
					<tr>
						<th>Cron</th>
						<th>Job</th>
						<th>Expression</th>
						<th>Description</th>
						<th>Paramètres</th>
						<th>&nbsp;</th>
						<th>&nbsp;</th>
						<th>&nbsp;</th>
					</tr>
					<%
					int j=0;
					for (int i = 0; i < vCron.size(); i++)	
					{
						CronTrigger cron = vCron.get(i);
						JobDetail jobDetail = CronUtil.getJobDetailFromTrigger(cron);
						JobDataMap map = jobDetail.getJobDataMap();
						String[] tabKey = map.getKeys();
						
						if(jobDetailModify != null && jobDetailModify.getJobClass() == jobDetail.getJobClass())
						{
							hbFormulaire.bIsForm = true;
							%>
							<form action="<%= response.encodeURL("afficherToutesCron.jsp?sAction=store")%>" method="post" name="formulaire<%= i %>">
							<%
						}
						else
						{
							hbFormulaire.bIsForm = false;
						}
						%>
						<%@ include file="pave/paveListItemCron.jspf" %> 
						<%
						if(hbFormulaire.bIsForm)
						{
							%>
							</form>
							<%
						}
					}
					
					for (int i = 0; i < vJobDetailCreate.size(); i++)
					{
						JobDetail jobDetail = vJobDetailCreate.get(i);
						JobDataMap map = jobDetail.getJobDataMap();
						hbFormulaire.bIsForm = true;
						String[] tabKey = map.getKeys();
						String sCronExp = vJobCronExp.get(i);
						%>
						<form action="<%= response.encodeURL("afficherToutesCron.jsp?sAction=create")%>" method="post" name="formcreate<%= i %>">
						<%@ include file="pave/paveListItemCronCreate.jspf" %> 
						</form>
						<%
					}
					%>
				</table>
			</td>
		</tr>
	</table>
<%
}
catch(Exception e){
	e.printStackTrace();
%>
<table class="pave" summary="none">
		<tr>
			<td class="pave_titre_gauche"> Liste des cron </td>

			<td class="pave_titre_droite">Cron désactivées</td>
		</tr>
		<tr>
			<td colspan="2">Les crons ont été desactivées sur ce serveur</td>
		</tr>
</table>
<%
}
%>
</div>
<%@ include file="../../include/new_style/footerFiche.jspf" %>
</body>
</html>