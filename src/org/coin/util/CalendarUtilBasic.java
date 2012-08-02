/*
 * Studio Matamore - France 2004
/****************************************************************************
 Studio Matamore - France 2004
 Contact : studio@matamore.com - http://www.matamore.com
 ****************************************************************************/

package org.coin.util;

import java.io.Serializable;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Vector;


public class CalendarUtilBasic implements Serializable {

	/**
	 * Comment for <code>serialVersionUID</code>
	 */
	private static final long serialVersionUID = 3256442499651416115L;

	public static final String[] arrMonthNameFR 
	= {"Janvier", "Février", "Mars", "Avril", 
		"Mai", "Juin", "Juillet", "Aout",
		"Septembre", "Octobre", "Novembre", "Décembre"};

	public static final String[] arrMonthNameEN 
	= {"January", "Februay", "March", "April", 
		"May", "June", "July", "August",
		"September", "October", "November", "December"};
	
	public static final String[] arrMonthNameES 
	= {"Enero", "Febrero", "Marzo", "Abril", 
		"Mayo", "Junio", "Julio", "Agosto",
		"Septiembre", "Octubre", "Noviembre", "Diciembre"};

	public static final String[] arrWeekDayNameFR 
	= {"Dimanche", "Lundi", "Mardi", "Mercredi", "Jeudi", 
		"Vendredi", "Samedi", "Dimanche"};

	public static final String[] arrWeekDayNameEN 
	= {"Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", 
		"Friday", "Saturday", "Sunday"};
	
	public static final String[] arrWeekDayNameES 
	= {"Domingo", "Lunes", "Martes", "Miercoles", "Jueves", 
		"Viernes", "Sabado", "Domingo"};

	private static String sDefaultLanguage = "FR";

	public static String sOfficialTime = "17:00";
	
	public static final int MILLSECS_PER_DAY = 24 * 60 * 60 * 1000;

	public static final int INTERVAL_TYPE_DAY = 1;
	public static final int INTERVAL_TYPE_WEEK = 2;
	public static final int INTERVAL_TYPE_MONTH  = 3;


	public static final int DATE_POSITION_TODAY = 1;
	public static final int DATE_POSITION_YESTERDAY = 2;
	public static final int DATE_POSITION_CURRENT_WEEK = 3;
	public static final int DATE_POSITION_LAST_WEEK = 4;
	public static final int DATE_POSITION_LAST_2WEEKS = 5;
	public static final int DATE_POSITION_CURRENT_MONTH = 6;
	public static final int DATE_POSITION_LAST_MONTH = 7;
	public static final int DATE_POSITION_BEFORE_LAST_MONTH = 8;
	public static final int DATE_POSITION_UNKNOWN = 9;


	public static int getDatePosistion(Timestamp tsDate) {
		if(isToday(tsDate)) return DATE_POSITION_TODAY;
		if(tsDate.after(new Date())) return DATE_POSITION_UNKNOWN;
		if(isYesterday(tsDate)) return DATE_POSITION_YESTERDAY;
		if(isCurrentWeek(tsDate)) return DATE_POSITION_CURRENT_WEEK;
		if(isPreviousWeek(tsDate)) return DATE_POSITION_LAST_WEEK;
		if(isOnThisWeek(tsDate, -1)) return DATE_POSITION_LAST_WEEK;
		if(isCurrentMonth(tsDate)) return DATE_POSITION_CURRENT_MONTH;
		if(isOnThisMonth(tsDate, -1)) return DATE_POSITION_LAST_MONTH;

		return DATE_POSITION_BEFORE_LAST_MONTH;
	}

	public static Calendar[] getDateIntervals(int iIdIntervalType, Calendar reference) {
		if (reference == null) {
			reference = Calendar.getInstance();
		}
		Calendar startDate = (Calendar)reference.clone();
		startDate.set(Calendar.HOUR_OF_DAY, 0);
		startDate.set(Calendar.MINUTE, 0);
		startDate.set(Calendar.SECOND, 0);
	    
		Calendar endDate = (Calendar)reference.clone();
		endDate.set(Calendar.MINUTE, 0);
	    endDate.set(Calendar.HOUR_OF_DAY, 0);
	    endDate.set(Calendar.SECOND, 0);
		
		switch (iIdIntervalType) {
		case INTERVAL_TYPE_DAY:

			break;

		case INTERVAL_TYPE_WEEK:
			// previous week by convention (monday ... sunday)

			int dayOfWeek = startDate.get(Calendar.DAY_OF_WEEK);

			while (dayOfWeek != Calendar.MONDAY) {
				startDate.add(Calendar.DATE, -1);
				dayOfWeek = startDate.get(Calendar.DAY_OF_WEEK);
			}

			dayOfWeek = endDate.get(Calendar.DAY_OF_WEEK);
			while (dayOfWeek  != Calendar.SUNDAY) {
				endDate.add(Calendar.DATE, 1);
				dayOfWeek = endDate.get(Calendar.DAY_OF_WEEK);
			}			
			break;

		case INTERVAL_TYPE_MONTH:
			startDate.set(Calendar.DATE, 1);

			endDate.set(Calendar.DATE, 1);
			endDate.add(Calendar.MONTH, 1);

			break;
		}

		return new Calendar[] { startDate, endDate }; 
	}


	public static boolean isToday(Timestamp tsA)
	{
		Calendar calA = Calendar.getInstance();
		calA.setTime(tsA);

		Calendar calB = getCalendarNow();

		return isSameDay(calA, calB);
	}


	public static boolean isYesterday(Timestamp tsA)
	{
		Calendar calA = Calendar.getInstance();
		calA.setTime(tsA);

		Calendar calB = getCalendarNow();
		calB.add(Calendar.DAY_OF_YEAR, -1);

		return isSameDay(calA, calB);
	}

	public static boolean isCurrentWeek(Timestamp tsA)
	{
		return isOnThisWeek(tsA, 0);
	}

	public static boolean isPreviousWeek(Timestamp tsA)
	{
		return isOnThisWeek(tsA, -1);
	}

	public static boolean isOnThisWeek(
			Timestamp tsA, 
			int iWeekShiftFromToday)
	{

		Calendar calA = Calendar.getInstance();
		calA.setTime(tsA);
		
		// shift 
		Calendar calCurrent = Calendar.getInstance();
		calCurrent.add(Calendar.DAY_OF_YEAR, iWeekShiftFromToday * 7);


		Calendar [] calInterval = getDateIntervals(INTERVAL_TYPE_WEEK, calCurrent);
		return isInTimeInterval(calA, calInterval[0], calInterval[1]);
	}

	public static boolean isCurrentMonth(Timestamp tsA)
	{
		return isOnThisMonth(tsA, 0);
	}

	public static boolean isOnThisMonth(
			Timestamp tsA, 
			int iMonthShiftFromToday)
	{
		Calendar calA = Calendar.getInstance();
		calA.setTime(tsA);

		// shift 
		Calendar calCurrent = Calendar.getInstance();
		calCurrent.add(Calendar.MONTH, iMonthShiftFromToday );

		Calendar [] calInterval = getDateIntervals(INTERVAL_TYPE_MONTH, calCurrent);
		return isInTimeInterval(calA, calInterval[0], calInterval[1]);
	}

	public static boolean isInTimeInterval(
			Calendar cal,
			Calendar calStart,
			Calendar calEnd)
	{
		return (cal.after(calStart) && cal.before(calEnd));
	}	

	public static boolean isSameDay(
			Calendar calA,
			Calendar calB)
	{
		if( (calA.get(Calendar.DATE) == calB.get(Calendar.DATE))
		&& (calA.get(Calendar.YEAR ) == calB.get(Calendar.YEAR)) 
		&& (calA.get(Calendar.MONTH) == calB.get(Calendar.MONTH))
		)
		{
			return true;
		}
		else
		{
			return false;
		}
	}

	public static int getFirstDayOfMonth(Calendar calendar)
	{
		int iFirstDayOfMonth;

		iFirstDayOfMonth = ( 7 +
				calendar.get(Calendar.DAY_OF_WEEK) 
				- (((calendar.get(Calendar.DAY_OF_MONTH))%7) -1))%7 ;
		return iFirstDayOfMonth;
	}

	public static String getMonthName(int iMonth)
	{
		return getMonthName(iMonth, sDefaultLanguage);
	}

	public static String getDayOfWeekName(int iDayOfWeekName)
	{
		return getDayOfWeekName(iDayOfWeekName, sDefaultLanguage);
	}

	/**
	 * @param iFieldNumber : n? du mois, de la semaine ..
	 * @param iFieldType : le type de champ : mois, semaine
	 * @return le nom du mois, ou le nom de la semaine, ou le nom...
	 */
	public static String getFieldName(GregorianCalendar gc, int iFieldNumber, int iFieldType){
		String sReturn = "";
		switch(iFieldType){
		case Calendar.YEAR			: sReturn = iFieldNumber+""; break;			
		case Calendar.MONTH 		: sReturn = iFieldNumber+"."+gc.get(GregorianCalendar.YEAR); break;
		case Calendar.WEEK_OF_YEAR	: sReturn = iFieldNumber+"."+gc.get(GregorianCalendar.YEAR); break;
		}
		return sReturn;
	}
	

	public static String getMonthName(int iMonth, String sLanguage)
	{
		if( sLanguage.equalsIgnoreCase("FR"))
		{
			return arrMonthNameFR[iMonth];
		}	

		if( sLanguage.equalsIgnoreCase("EN"))
		{
			return arrMonthNameEN[iMonth];
		}
		
		if( sLanguage.equalsIgnoreCase("ES"))
		{
			return arrMonthNameES[iMonth];
		}	

		return null;
	}
	

	public static String getDayOfWeekName(int iDayOfWeekName, String sLanguage)
	{
		if( sLanguage.equals("FR"))
		{
			return arrWeekDayNameFR[iDayOfWeekName];
		}	

		if( sLanguage.equals("EN"))
		{
			return arrWeekDayNameEN[iDayOfWeekName];
		}
		
		if( sLanguage.equals("ES"))
		{
			return arrWeekDayNameES[iDayOfWeekName];
		}	

		return null;
	}

	public static Calendar getCalendarNow() {
		/* Récupération de la date et de l'heure du jour dans un Calendar */
		Calendar date = Calendar.getInstance();
		date.setTimeInMillis(System.currentTimeMillis());

		return date;
	}
	/**
	 * Renvoie une date formattée comme Lundi 16 Octobre 2004 
	 * @param calendar
	 * @return
	 */

	public static String getDayOfWeekNameFrFromTimestamp(Timestamp tsDay){
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(tsDay.getTime());
		return getDayOfWeekName(calendar.get(Calendar.DAY_OF_WEEK) - 1,sDefaultLanguage);
	}

	

	



	/**
	 * Renvoie l'heure du Calendar passé en argument sous le format HH:mm
	 * @param calendar - objet contenant l'heure
	 * @return une chaîne de caractère formattée HH:mm
	 */
	public static String getHeureMinuteSec(Calendar calendar) {
		SimpleDateFormat formatHeure = new SimpleDateFormat("HH:mm");
		return formatHeure.format(calendar.getTime());
	}
	public static String getHeureMinuteSec(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getHeureMinuteSec(cal);
		}

		return "";
	}

	public static String getHeureMinuteSecDefaultOfficial(Timestamp ts) 
	{
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getHeureMinuteSec(cal);
		}

		return sOfficialTime;
	}

	public static String getHeureMinuteSecLitterale(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getHeureMinuteSec(cal).replaceAll(":","H");
		}

		return "";
	}

	public static Calendar getCalendar(Timestamp ts) {
		if (ts != null) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(ts.getTime());
			return calendar;
		}

		return null;
	}
	public static String getDateStringForJavascript(Timestamp ts) {
		return getDateStringForJavascript(getCalendar(ts));
	}

	public static String getDateStringForJavascript(Calendar cal) {
		String sServerDate = ""+ (cal.get(Calendar.YEAR) - 1900) + "," 
		+ cal.get(Calendar.MONTH) + "," 
		+ cal.get(Calendar.DAY_OF_MONTH) + "," 
		+ cal.get(Calendar.HOUR_OF_DAY) + "," 
		+ cal.get(Calendar.MINUTE) + "," 
		+ cal.get(Calendar.SECOND) 
		;

		return sServerDate;
	}
	/**
	 * 
	 * @param ts date à formater
	 * @param sSimpleDateFormat format attendu en sortie
	 * @return
	 */
	public static String getDateWithFormat(Timestamp ts, String sSimpleDateFormat) {
		if (ts != null) {
			Calendar calendar = Calendar.getInstance();
			calendar.setTimeInMillis(ts.getTime());
			SimpleDateFormat formatDate = new SimpleDateFormat(sSimpleDateFormat);
			return formatDate.format(calendar.getTime());
		}

		return "";
	}

	public static String getDateWithLocale(Timestamp ts, String sSimpleDateFormat, Locale locale) {
		if (ts != null) {
			try{
				Calendar calendar = Calendar.getInstance();
				calendar.setTimeInMillis(ts.getTime()+100000000);

				SimpleDateFormat formatDate = (SimpleDateFormat)DateFormat.getDateTimeInstance(DateFormat.SHORT,DateFormat.SHORT, locale);
				String sFormatLocale = formatDate.toLocalizedPattern();
				sFormatLocale = sFormatLocale.replaceFirst("yy", "yyyy");
				//System.out.println(sFormatLocale);
				formatDate.applyLocalizedPattern(sFormatLocale);
				return formatDate.format(calendar.getTime());
			}catch(Exception e){}
		}

		return "";
	}

	public static void main(String[] args) {
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		System.out.println(getDateWithLocale(ts, "", Locale.FRENCH)+" FRENCH");

		Locale.setDefault(Locale.ENGLISH);
		System.out.println(getDateWithLocale(ts, "", Locale.getDefault())+" ENGLISH");
	}

	public static String getDureeString(Timestamp ts) {
		String sDuree = getDateWithFormat(ts, "mm 'min' ss 's'");
		int iDureeHeure = Integer.parseInt( CalendarUtilBasic.getDateWithFormat(ts, "HH")) - 1;
		String sDureeHeure = "";
		if(iDureeHeure > 0)
			sDureeHeure = "" + iDureeHeure + " heure(s) et ";

		return sDureeHeure + sDuree;

	}
	

	/**
	 * 
	 * @param ts date à formater
	 * @param sSimpleDateFormat format attendu en sortie
	 * @return
	 */
	public static String getDateWithFormat(Calendar calendar, String sSimpleDateFormat) {
		if (calendar != null) {
			SimpleDateFormat formatDate = new SimpleDateFormat(sSimpleDateFormat);
			return formatDate.format(calendar.getTime());
		}

		return "";
	}

	/**
	 * Format dd/MM/yyyy 'à' HH:mm:ss
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getDateFormatCourt(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("dd/MM/yyyy 'à' HH:mm:ss");
		return formatDate.format(calendar.getTime());
	}

	/**
	 * Format yyyy-MM-dd'T'HH:mm:ss
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getXmlDatetimeFormat(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
		return formatDate.format(calendar.getTime());
	}

	/**
	 * Format yyyy-MM-dd'T'HH:mm:ss
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getXmlDatetimeFormat(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getXmlDatetimeFormat(cal);
		}

		return "";
	}
	
	/**
	 * Format yyyy-MM-dd
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getXmlDateFormat(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd");
		return formatDate.format(calendar.getTime());
	}

	/**
	 * Format yyyy-MM-dd'T'HH:mm:ss
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getXmlDateFormat(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getXmlDateFormat(cal);
		}

		return "";
	}

	public static String getFileDatetimeFormat(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getFileDatetimeFormat(cal);
		}

		return "";
	}

	public static String getFileDatetimeFormat(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd'T'HHmmss");
		return formatDate.format(calendar.getTime());
	}


	public static String getFormatDateHeureStd(Date date) {
		GregorianCalendar calendar = new java.util.GregorianCalendar(); 
		calendar.setTime( date ); 
		return getFormatDateHeureStd(calendar);
	}	

	/**
	 * Format dd/MM/yyyy 'à' HH:mm:ss
	 * 
	 * @param calendar
	 * @return
	 */
	public static String getFormatDateHeureStd(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("dd/MM/yyyy 'à' HH'h'mm");
		return formatDate.format(calendar.getTime());
	}

	public static String getFormatDateHeureStd(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getFormatDateHeureStd(cal);
		}

		return "";
	}
	
	

	public static String getDateCourte(Timestamp ts) {
		return getDateCourte(ts, "");
	}

	public static String getDateCourteNeant(Timestamp ts) {
		return getDateCourte(ts, "Néant");
	}

	/**
	 * Renvoie une date au format dd/MM/yyyy
	 * @param ts
	 * @return
	 */
	public static String getDateCourte(Timestamp ts, String sDefaultValue) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getDateCourte(cal);
		}

		return sDefaultValue;
	}

	public static String getDateCourteWithDefaultCurrentDate(Timestamp ts) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance();
			cal.setTimeInMillis(ts.getTime());
			return getDateCourte(cal);
		}

		return getDateCourte(new Timestamp(System.currentTimeMillis())) ;
	}

	public static String getDateCourte(Calendar calendar) {
		SimpleDateFormat formatDate = new SimpleDateFormat("dd/MM/yyyy");
		return formatDate.format(calendar.getTime());
	}

	/**
	 * Méthode permettant de parser une chaine de caractère en Timestamp
	 * @param sDate - date au format "yyyy-MM-dd HH:mm:ss.S"
	 * @return le Timestamp si OK ou null
	 */
	public static Timestamp getTimestamp(String sDate) {
		try {
			SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
			Date dDate = formatDate.parse(sDate);
			return new Timestamp(dDate.getTime());
		}
		catch (ParseException e) {
			System.out.println("Exception de parsing");
			e.printStackTrace();
			return null;
		}
	}

	public static Timestamp getTimestampMarco(String sDate) {
		try {
			SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm");
			Date dDate = formatDate.parse(sDate);
			return new Timestamp(dDate.getTime());
		}
		catch (ParseException e) {
			System.out.println("Exception de parsing");
			e.printStackTrace();
			return null;
		}
	}


	/**
	 * Renvoie le Timestamp correspondant à la chaine de caractère passée
	 * 
	 * @see CalendarUtil.getXmlDatetimeFormat()
	 * @param sDate 
	 * @return objet Timestamp
	 * @throws ParseException 
	 */
	public static Timestamp getConversionXmlDateTimeToTimestamp(String sDate) throws ParseException {
		sDate = sDate.replaceAll("T", " ");
		SimpleDateFormat formatDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date dDate = formatDate.parse(sDate);
		return new Timestamp(dDate.getTime());
	}
	

	/**
	 * Renvoie le Timestamp correspondant à la chaine de caractère passée
	 * @param sDate 
	 * @return objet Timestamp
	 */
	public static Timestamp getConversionTimestamp(String sDate, String sDateFormat) {
		try {
			SimpleDateFormat formatDate = new SimpleDateFormat(sDateFormat);
			Date dDate = formatDate.parse(sDate);
			return new Timestamp(dDate.getTime());
		}
		catch (ParseException e) {
			return null;
		}
	}

	public static Timestamp getConversionTimestampWithException(String sDate, String sDateFormat) throws ParseException {
		SimpleDateFormat formatDate = new SimpleDateFormat(sDateFormat);
		Date dDate = formatDate.parse(sDate);
		return new Timestamp(dDate.getTime());
	}

	public static Timestamp getConversionTimestampDateTimeOptional(String sDate, String sTime)
	{
		if(sDate == null || sTime == null) return null;

		return getConversionTimestamp(sDate + " " + sTime, "dd/MM/yyyy HH:mm");
	}


	public static Timestamp getConversionTimestampDateOptional(String sDate)
	{
		if(sDate == null ) return null;
		return getConversionTimestamp(sDate, "dd/MM/yyyy");
	}


	/**
	 * Renvoie le Timestamp correspondant à la chaine de caractère passée
	 * @param sDate - format de la chaine : dd/MM/yyyy HH:mm
	 * @return objet Timestamp
	 */
	public static Timestamp getConversionTimestamp(String sDate) {
		return getConversionTimestamp(sDate, "dd/MM/yyyy HH:mm");
	}

	public static Timestamp getConversionTimestampFromDateCourte(String sDate) {
		return getConversionTimestamp(sDate, "dd/MM/yyyy");
	}

	/**
	 * Renvoie le Timestamp correspondant à la chaine de caractère passée
	 * @param sDate - format de la chaine : dd/MM/yyyy
	 * @return objet Timestamp
	 */
	public static Timestamp getConversionSimpleTimestamp(String sDate) {
		return getConversionTimestamp(sDate, "dd/MM/yyyy");
	}

	/**
	 * Renvoie la différence en minute de deux Timestamp
	 * si le Timestamp de fin est antérieur au Timestamp de debut la methode renvoie 0
	 * @param tsDebut Timestamp debut
	 * @param tsFin Timestamp fin
	 * @return long minute
	 */
	public static long getDifferenceBetweenTimestamps(Timestamp tsDebut, Timestamp tsFin)
	{
		try {
			if(tsFin.before(tsDebut)) return 0;
		} catch (Exception e) {
			//e.printStackTrace();
			return 0;
		}

		double lDifference = tsFin.getTime() - tsDebut.getTime();

		return (Math.round(lDifference/(60*1000)));
	}

	public static String getDifferenceBetweenTimstampsWithFormatJJHHMM(Timestamp tsDebut, Timestamp tsFin){
		String sTempsRestant = "";
		long lDuree = getDifferenceBetweenTimestamps(tsDebut, tsFin);
		long lMin = lDuree%60;
		long lHeures = ((lDuree - lMin)/60)%24;
		long lJours = Math.round(((lDuree - lMin)/60)/24);
		if (lJours != 0) {
			sTempsRestant = lJours + " jour";
			if (lJours != 1) sTempsRestant +="s";
		}
		if (lHeures != 0) {
			sTempsRestant += " "+lHeures + "h";
		}
		if (lMin != 0) {
			sTempsRestant += " "+lMin + "min";
		}
		return sTempsRestant;

	}
	

	public static long getDifferenceBetweenTimstampsInDays(Timestamp tsBegin, Timestamp tsEnd){
		long lDuree = getDifferenceBetweenTimestamps(tsBegin, tsEnd);
		long lMin = lDuree%60;
		return Math.round(((lDuree - lMin)/60)/24);		
	}
		
	public static long getDifferenceAgainstCurrentDateTSInDays(Timestamp tsDateCircuitStart, int iDay){
		
		Calendar calNow = Calendar.getInstance();
		Calendar calDateToCompare = Calendar.getInstance();
		calDateToCompare.setTime(new Date(tsDateCircuitStart.getTime()));
		calDateToCompare.add(Calendar.DATE, iDay);
		
		long diff = (calNow.getTimeInMillis() - calDateToCompare.getTimeInMillis()) / MILLSECS_PER_DAY;
		
		return diff;
	}

	public static void setHour(Timestamp tsDate, int iHour){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.set(Calendar.HOUR_OF_DAY,iHour);
		tsDate.setTime(gc.getTime().getTime());
	}

	public static void setMinute(Timestamp tsDate, int iMinute){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.set(Calendar.MINUTE,iMinute);
		tsDate.setTime(gc.getTime().getTime());
	}

	public static void setSecond(Timestamp tsDate, int iSecond){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.set(Calendar.SECOND,iSecond);
		tsDate.setTime(gc.getTime().getTime());
	}

	public static void addDay(Timestamp tsDate, int iDay){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.add(Calendar.DATE,iDay);
		tsDate.setTime(gc.getTime().getTime());
	}

	public static void addMonth(Timestamp tsDate, int iMonth){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.add(Calendar.MONTH,iMonth);
		tsDate.setTime(gc.getTime().getTime());
	}

	public static void addYear(Timestamp tsDate, int iYear){
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Time(tsDate.getTime()));
		gc.add(Calendar.YEAR,iYear);
		tsDate.setTime(gc.getTime().getTime());
	}

	/**
	 * Renvoie la date du jour formattée comme YY-mm-ddTHH:ii:ss+01:00
	 * @param
	 * @return
	 */
	public static String getDateDuJourFormatteeForHorloge() {
		Date today = new Date();
		SimpleDateFormat df=new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss+01:00"); 
		return df.format(today);
	}

	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector containing the years of the period
	 */
	public static Vector<Integer> getYearsFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<Integer> vResult = new Vector<Integer>();
		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarEnd = new GregorianCalendar();

		calendarBegin.setTime(new Date(tsBegin.getTime()));
		calendarEnd.setTime(new Date(tsEnd.getTime()));

		while(calendarBegin.get(Calendar.YEAR) <= calendarEnd.get(Calendar.YEAR)){
			vResult.add(calendarBegin.get(Calendar.YEAR));
			calendarBegin.add(Calendar.YEAR,1);
		}

		return vResult;
	}

	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector of String containing the years of the period
	 */
	public static Vector<String> getYearsNameFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<Integer> vInt = getYearsFromPeriod(tsBegin,tsEnd);
		Vector<String> vResult = new Vector<String>();

		for(int i=0; i<vInt.size(); i++){
			vResult.add(""+vInt.elementAt(i));
		}

		return vResult;
	}

	public static int getLastWeekOfYear(int iYear){
		GregorianCalendar calendar = new GregorianCalendar(iYear,12,31);
		return calendar.get(Calendar.WEEK_OF_YEAR);			
	}


	public static int getLastDayOfYear(int iYear){
		GregorianCalendar calendar = new GregorianCalendar(iYear,12,31);
		return calendar.get(Calendar.DAY_OF_YEAR);			
	}


	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector containing the months' name of the period
	 * expl : 
	 * - period = from 2005-10-01 to 2006-02-01
	 * - return =  octobre november december january february
	 */
	public static Vector<String> getMonthsNamesFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<String> vResult = new Vector<String>();
		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarEnd = new GregorianCalendar();

		calendarBegin.setTime(new Date(tsBegin.getTime()));
		calendarEnd.setTime(new Date(tsEnd.getTime()));

		while(calendarBegin.get(Calendar.MONTH) <= calendarEnd.get(Calendar.MONTH)){
			vResult.add(getMonthName(calendarBegin.get(Calendar.MONTH)));
			calendarBegin.add(Calendar.MONTH,1);
		}

		return vResult;
	}

	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector containing the weeks numbers of the period
	 * expl : 
	 * - period = from 2005-10-01 to 2006-02-01
	 * - return =  39 40 41 ... 51 52 1 2 ... 5 6 
	 */
	public static Vector<Integer> getWeekOfYearsFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<Integer> vResult = new Vector<Integer>();
		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarEnd = new GregorianCalendar();

		calendarBegin.setTime(new Date(tsBegin.getTime()));
		calendarEnd.setTime(new Date(tsEnd.getTime()));

		while(calendarBegin.get(Calendar.WEEK_OF_YEAR) <= calendarEnd.get(Calendar.WEEK_OF_YEAR)){
			vResult.add(calendarBegin.get(Calendar.WEEK_OF_YEAR));
			calendarBegin.add(Calendar.WEEK_OF_YEAR,1);
		}

		return vResult;
	}


	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector of String containing the weeks numbers of the period
	 * expl : 
	 * - period = from 2005-10-01 to 2006-02-01
	 * - return =  39 40 41 ... 51 52 1 2 ... 5 6 
	 */
	public static Vector<String> getWeekOfYearsNameFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<Integer> vInt = getWeekOfYearsFromPeriod(tsBegin,tsEnd);
		Vector<String> vResult = new Vector<String>();

		for(int i=0; i<vInt.size(); i++){
			vResult.add(""+vInt.elementAt(i));
		}

		return vResult;
	}

	/**
	 * @param tsBegin
	 * @param tsEnd
	 * @return a vector containing the formated days of the period
	 */
	public static Vector<String> getDaysFromPeriod(Timestamp tsBegin, Timestamp tsEnd){
		Vector<String> vResult = new Vector<String>();

		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarEnd = new GregorianCalendar();
		calendarBegin.setTime(new Date(tsBegin.getTime()));
		calendarEnd.setTime(new Date(tsEnd.getTime()));

		while(calendarBegin.compareTo(calendarEnd) <= 0){
			vResult.add(getDateCourte(calendarBegin));
			calendarBegin.add(Calendar.DAY_OF_YEAR,1);
		}

		return vResult;
	}

	/**
	 * @param iYear
	 * @return the date of paques wich is "the first sunday after the full moon wich follows the solstice of spring .
	 * Explication (in french, sorry) : http://quincy.inria.fr/data/courses/ipa-java-99/td1.html
	 */
	public static GregorianCalendar getPaquesDate(int iYear){
		GregorianCalendar calendar = new GregorianCalendar();

		int g = (iYear % 19) + 1;
		int c = iYear / 100 + 1;
		int x = 3 * c / 4 - 12;
		int z = (8 * c + 5) / 25 - 5;
		int d = 5 * iYear / 4 - x - 10;
		int e = (11 * g + 20 + z - x) % 30;
		if ( e == 25 && g > 11 || e == 24 )
			++e;
		int n = 44 - e;
		if (n < 21)
			n = n + 30;
		int j = n + 7 - ((d + n) % 7);
		if (j > 31)
			calendar.set(iYear, 04, (j - 31));
		else
			calendar.set(iYear, 03, j);

		return calendar;
	}


	public static Timestamp now(){
		return new Timestamp(System.currentTimeMillis());
	}

	public static Timestamp yesterdayMidnight(){
		Timestamp ts = new Timestamp(System.currentTimeMillis());
		addDay(ts, -1);
		setHour(ts, 23);
		setMinute(ts, 59);
		setSecond(ts, 59);
		return ts;
	}

	public static Timestamp setStartDay(Timestamp ts){
		setHour(ts, 0);
		setMinute(ts, 0);
		setSecond(ts, 0);
		return ts;
	}

	public static Timestamp setEndDay(Timestamp ts){
		setHour(ts, 23);
		setMinute(ts, 59);
		setSecond(ts, 59);
		return ts;
	}
	
	/**
	 * Return the timestamp of the first day (00h00m00s000ms) of the month
	 * iOffsetMonth = -1 will return the first day of the month preceding 
	 * the current system date.
	 * @param iOffsetMonth
	 * @return
	 */
	public static Timestamp firstDayOfMonthRelativ(int iOffsetMonth){
		Date now = new Date();
		Timestamp tsDate = new Timestamp(now.getTime());
		return firstDayOfMonthRelativ(tsDate, iOffsetMonth);
	}
	
	/**
	 * Return the timestamp of the first day (00h00m00s000ms) of the month
	 * iOffsetMonth = -1 will return the first day of the month preceding 
	 * the tsDate.
	 * @param tsDate
	 * @param iOffsetMonth
	 * @return
	 */
	public static Timestamp firstDayOfMonthRelativ(Timestamp tsDate, int iOffsetMonth){
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.setTimeInMillis(tsDate.getTime());
		calendar.add(GregorianCalendar.MONTH, iOffsetMonth);
		calendar.set(GregorianCalendar.DAY_OF_MONTH, 1);
		calendar.set(GregorianCalendar.HOUR_OF_DAY, 0);
		calendar.set(GregorianCalendar.MINUTE, 0);
		calendar.set(GregorianCalendar.SECOND, 0);
		calendar.set(GregorianCalendar.MILLISECOND, 0);
		return new Timestamp(calendar.getTimeInMillis());
	}
	
	/**
	 * Return the timestamp of the last day (23h59m59s999ms) of the month
	 * iOffsetMonth = -1 will return the last day of the month preceding 
	 * the current system date.
	 * @param iOffsetMonth
	 * @return
	 */
	public static Timestamp lastDayOfMonthRelativ(int iOffsetMonth){
		Date now = new Date();
		Timestamp tsDate = new Timestamp(now.getTime());
		return lastDayOfMonthRelativ(tsDate, iOffsetMonth);
	}
	
	/**
	 * Return the timestamp of the last day (23h59m59s999ms) of the month
	 * iOffsetMonth = -1 will return the last day of the month preceding 
	 * the tsDate.
	 * @param iOffsetMonth
	 * @return
	 */
	public static Timestamp lastDayOfMonthRelativ(Timestamp tsDate, int iOffsetMonth){
		Calendar calendar = GregorianCalendar.getInstance();
		calendar.setTimeInMillis(tsDate.getTime());
		calendar.add(GregorianCalendar.MONTH, iOffsetMonth + 1);
		calendar.set(GregorianCalendar.DAY_OF_MONTH, 1);
		calendar.add(GregorianCalendar.DAY_OF_YEAR, -1);
		calendar.set(GregorianCalendar.HOUR_OF_DAY, 23);
		calendar.set(GregorianCalendar.MINUTE, 59);
		calendar.set(GregorianCalendar.SECOND, 59);
		calendar.set(GregorianCalendar.MILLISECOND, 999);
		return new Timestamp(calendar.getTimeInMillis());
	}
	
	public static int getAge(Timestamp tsBegin, Timestamp tsEnd){
		int iResult = 0;
		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarEnd = new GregorianCalendar();

		calendarBegin.setTime(new Date(tsBegin.getTime()));
		calendarEnd.setTime(new Date(tsEnd.getTime()));

		iResult = calendarEnd.get(Calendar.YEAR) - calendarBegin.get(Calendar.YEAR); 
		if ((calendarBegin.get(Calendar.MONTH) > calendarEnd.get(Calendar.MONTH)) 
		|| (calendarBegin.get(Calendar.MONTH) == calendarEnd.get(Calendar.MONTH) 
				&& calendarBegin.get(Calendar.DATE) > calendarEnd.get(Calendar.DATE))) {
			iResult--; 
		}

		return iResult;
	}
}
