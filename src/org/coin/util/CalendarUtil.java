/*
 * Studio Matamore - France 2004
/****************************************************************************
 Studio Matamore - France 2004
 Contact : studio@matamore.com - http://www.matamore.com
 ****************************************************************************/

package org.coin.util;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Vector;

import javax.naming.NamingException;

import org.coin.localization.Language;
import org.coin.localization.LocalizationConstant;
import org.coin.localization.Localize;



public class CalendarUtil extends CalendarUtilBasic
{

	private static final long serialVersionUID = 1L;

	public static String getDateFormatteeLoc(
			Calendar calendar,
			boolean bDisplayHour, 
			String jour, 
			String mois,
			int iIdLang ) 
	{
		StringBuffer dateTemp = new StringBuffer();
		
		
		String jourNum = "" + calendar.get(Calendar.DATE);
		String annee = "" + calendar.get(Calendar.YEAR); //$NON-NLS-1$

		switch (iIdLang) {
		case Language.LANG_FRENCH:
			dateTemp.append(jour + " ");
			dateTemp.append(jourNum + " ");
			dateTemp.append(mois + " ");
			dateTemp.append(annee + " ");
			break;

		case Language.LANG_ENGLISH:
			dateTemp.append(mois + " ");
			dateTemp.append(jourNum + ", ");
			dateTemp.append(annee + " ");
			break;

		case Language.LANG_SPANISH:
			dateTemp.append(jour + " ");
			dateTemp.append(jourNum + " ");
			dateTemp.append("de ");
			dateTemp.append(mois + " ");
			dateTemp.append("de ");
			dateTemp.append(annee + " ");	
			break;

		default:
			/**
			 * French type by default
			 */
			dateTemp.append(jour + " ");
			dateTemp.append(jourNum + " ");
			dateTemp.append(mois + " ");
			dateTemp.append(annee + " ");
			break;
		}
		
		
		
		
		if(bDisplayHour){
			dateTemp.append("- ");
			dateTemp.append(getHeureMinuteSec(calendar));
		}
		return dateTemp.toString();
	}

	public static String getDateFormattee(
			Timestamp tsDate,
			boolean bDisplayHour)
	{
		return getDateFormatteeLoc(
				getCalendar(tsDate),
				true,
				Language.LANG_FRENCH);
	}

	public static Locale getLocaleFromLanguage(int iIdLang){
		switch(iIdLang){
		case Language.LANG_ENGLISH:
			return Locale.ENGLISH;
		case Language.LANG_FRENCH:
			return Locale.FRENCH;
		case Language.LANG_GERMAN:
			return Locale.GERMAN;
		case Language.LANG_SPANISH:
		case Language.LANG_SPANISH_AR:
		case Language.LANG_SPANISH_CL:
		case Language.LANG_SPANISH_CO:
		case Language.LANG_SPANISH_CR:
		case Language.LANG_SPANISH_DO:
		case Language.LANG_SPANISH_EC:
		case Language.LANG_SPANISH_ES:
		case Language.LANG_SPANISH_GT:
		case Language.LANG_SPANISH_HN:
		case Language.LANG_SPANISH_LA:
		case Language.LANG_SPANISH_MX:
		case Language.LANG_SPANISH_NI:
		case Language.LANG_SPANISH_PA:
		case Language.LANG_SPANISH_PE:
		case Language.LANG_SPANISH_PR:
		case Language.LANG_SPANISH_SV:
		case Language.LANG_SPANISH_UY:
		case Language.LANG_SPANISH_VE:
			return new Locale("es");
		}
		return null;
	}

	public static int getLanguageFromLocale(Locale locale){
		
		String lang = locale.getLanguage();
		
		if(lang.equalsIgnoreCase("es")) return Language.LANG_SPANISH;
		else if(lang.equalsIgnoreCase("en")) return Language.LANG_ENGLISH;
		
		else return Language.LANG_FRENCH;
	}
	
	public static String getDateFormatteeLang(
			Timestamp ts, 
			String sDefaultValue,
			boolean bDisplayHour,
			int iIdLang) {
		if (ts != null) {
			Locale locale = getLocaleFromLanguage(iIdLang);
			Calendar cal = null;
			if(locale == null){
				cal = Calendar.getInstance();
				cal.setTimeInMillis(ts.getTime());
				return getDateFormattee(cal,bDisplayHour);
			}
			else {
				cal = Calendar.getInstance(locale);
				cal.setTimeInMillis(ts.getTime());
				return getDateFormatteeLoc(cal, bDisplayHour, locale);
			}
			
		}
		return sDefaultValue;
	}

	public static String getLocalizedString(int iId, String sDefault, int iLang){
		
		String caption = "";
		
		try {
			Localize locDate = new Localize(
					iLang,
					LocalizationConstant.CAPTION_CATEGORY_DATES_LOCALIZATION);
			
			caption = locDate.getValue(iId, sDefault);
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return caption;
		
	}

	
	public static String getDifferenceBetweenTimstampsWithFormatJJHHMMLoc(Timestamp tsDebut, Timestamp tsFin, int iLang){
		String sTempsRestant = "";
		long lDuree = getDifferenceBetweenTimestamps(tsDebut, tsFin);
		long lMin = lDuree%60;
		long lHeures = ((lDuree - lMin)/60)%24;
		long lJours = Math.round(((lDuree - lMin)/60)/24);
		if (lJours != 0) {
			sTempsRestant = lJours + getLocalizedString(23, " jour", iLang);
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

	public static String getDayOfWeekNameLoc(int iDayOfWeekName, int iLang)
	{
		
		//String[] values = Localize.getArrayValue(iLang, LocalizationConstant.CAPTION_CATEGORY_DATES_LOCALIZATION);
		
		int iId = iDayOfWeekName + 1;
		return getLocalizedString(iId, "", iLang);
	}

	public static String getMonthNameLoc(int iMonth, int iLang)
	{
		
		int iId = iMonth + 8;
		return getLocalizedString(iId, "", iLang);
	}

	public static String getDateFormatteeLoc(
			Calendar calendar,
			boolean bDisplayHour, 
			Locale locale) 
	{
		int iIdLang = getLanguageFromLocale(locale);
		
		return getDateFormatteeLoc(
				calendar, 
				bDisplayHour, 
				iIdLang);
	}
	
	public static String getDateFormatteeLoc(
			Calendar calendar,
			boolean bDisplayHour, 
			int iIdLang ) 
	{
		String jour = null;
		String mois = null;
		
		if(iIdLang > 0)
		{
			/**
			 * get from localization DB
			 */
			jour = getDayOfWeekNameLoc(calendar.get(Calendar.DAY_OF_WEEK) - 1, iIdLang);
			mois = getMonthNameLoc(calendar.get(Calendar.MONTH), iIdLang);
		} else {
			/**
			 * static embeded values
			 */
			jour = getDayOfWeekName(calendar.get(Calendar.DAY_OF_WEEK) - 1);
			mois = getMonthName(calendar.get(Calendar.MONTH));
		}
		return getDateFormatteeLoc(calendar, bDisplayHour, jour, mois, iIdLang);
	}

	
	public static String getDateFormatteeLoc(
			Timestamp tsDate,
			boolean bDisplayHour, 
			int iIdLang ) 
	{
		return getDateFormatteeLoc(
				getCalendar(tsDate),
				bDisplayHour,
				iIdLang);
	}

	
	public static String getDateCourteFormattee(Timestamp ts, String sDefaultValue, int iIdLang) {
		return getDateFormattee(ts, sDefaultValue, getLocaleFromLanguage(iIdLang), false);
	}

	public static String getDateFormattee(Timestamp ts, String sDefaultValue, int iIdLang) {
		return getDateFormattee(ts, sDefaultValue, getLocaleFromLanguage(iIdLang));
	}
	
	public static String getDateFormatteeHourLoc(Timestamp ts, String sDefaultValue, int iIdLang) {
		return getDateFormatteeLang(ts, sDefaultValue, true, iIdLang);
	}

	public static String getFormatDateHeureStdLoc(Calendar calendar, int iLang) {
		
		SimpleDateFormat formatDate = new SimpleDateFormat(getLocalizedString(22,"dd/MM/yyyy 'à' HH'h'mm",iLang));
		return formatDate.format(calendar.getTime());
				
}

	public static String getFormatDateHeureStdLoc(Timestamp ts, int iLang) {
		if (ts != null) {
			Calendar cal = Calendar.getInstance(getLocaleFromLanguage(iLang));
			cal.setTimeInMillis(ts.getTime());
			return getFormatDateHeureStdLoc(cal, iLang);
		}

		return "";
	}

	public static String getDureeStringLoc(Timestamp ts, int iLang) {
		String sDuree = getDateWithFormat(ts, "mm 'min' ss 's'");
		int iDureeHeure = Integer.parseInt( org.coin.util.CalendarUtilBasic.getDateWithFormat(ts, "HH")) - 1;
		String sDureeHeure = "";
		if(iDureeHeure > 0)
			sDureeHeure = "" + iDureeHeure + " "+getLocalizedString(20, "heures(s) et", iLang)+" ";

		return sDureeHeure + sDuree;

	}


	
	public static String getDateLitteraleFormattee(Calendar calendar)
	{
		return getDateFormattee(calendar,true);
	}
	/**
	 * Renvoie une date formattée comme Lundi 16 Octobre 2004 à 10:45:00
	 * @param calendar
	 * @return
	 */
	public static String getDateFormattee(Calendar calendar) {
		return getDateFormattee(calendar,true);
	}



	
	public static String getDateFormattee(
			Calendar calendar,
			boolean bDisplayHour)
	{
		return getDateFormatteeLoc(calendar,bDisplayHour,-1);
	}
	
	
	/**
	 * Renvoie la date du jour au format Lundi 16 Octobre 2004 par exemple
	 * @return la date du jour
	 */
	public static String getDateDuJour() {
		/* Récupération de la date et de l'heure du jour dans un Calendar */
		Calendar date = Calendar.getInstance();
		date.setTimeInMillis(System.currentTimeMillis());

		return getDateFormattee(date);
	}

	public static String getDateFormattee(
			Timestamp ts, 
			String sDefaultValue,
			Locale locale,
			boolean bDisplayHour)
	{
		if (ts != null) {
			Calendar cal = null;
			if(locale == null){
				cal = Calendar.getInstance();
				cal.setTimeInMillis(ts.getTime());
				return getDateFormattee(cal,bDisplayHour);
			}
			else {
				cal = Calendar.getInstance(locale);
				cal.setTimeInMillis(ts.getTime());
				return getDateFormatteeLoc(cal, bDisplayHour, locale);
			}
			
		}
		return sDefaultValue;
	}

	
	/**
	 * Renvoie une date formattée comme Lundi 16 Octobre 2004 à 10:45:00
	 * @param ts - Timestamp de la date
	 * @return un String au format sinon une chaine vide
	 */
	public static String getDateFormattee(Timestamp ts, String sDefaultValue) {
		return getDateFormattee(ts, sDefaultValue, null);
	}

	public static String getDateCourteFormattee(Timestamp ts, String sDefaultValue) {
		return getDateFormattee(ts, sDefaultValue, null, false);
	}


	public static String getDateFormattee(Timestamp ts, String sDefaultValue,Locale locale) {
		return getDateFormattee(ts, sDefaultValue, locale, true);
	}
	
	


	public static String getDateFormatteeNeant(Timestamp ts) {
		return getDateFormattee(ts, "Néant");
	}

	public static String getDateFormattee(Timestamp ts) {
		return getDateFormattee(ts, "");
	}

	
	public static Vector<GregorianCalendar> getFloatingNonWorkingDays(int iYear){
		Vector<GregorianCalendar> v = new Vector<GregorianCalendar>();

		// --> paques
		GregorianCalendar gcPaques = getPaquesDate(iYear);	//paques is not added, it is a sunday

		// --> ascension
		gcPaques.add(Calendar.DATE,39);
		GregorianCalendar gcAscension = new GregorianCalendar(gcPaques.get(Calendar.YEAR),gcPaques.get(Calendar.MONTH),gcPaques.get(Calendar.DAY_OF_MONTH)); 
		v.add(gcAscension);

		// --> pentencote
		gcPaques.add(Calendar.DATE,10);
		GregorianCalendar gcPentecote = new GregorianCalendar(gcPaques.get(Calendar.YEAR),gcPaques.get(Calendar.MONTH),gcPaques.get(Calendar.DAY_OF_MONTH)); 
		v.add(gcPentecote);

		return v;

	}

	public static Timestamp addWorkingDays(Timestamp tsBegin, int iNbDays) throws InstantiationException, IllegalAccessException, 
	NamingException, SQLException{
		GregorianCalendar calendarBegin = new GregorianCalendar();
		GregorianCalendar calendarRun = new GregorianCalendar();
		Vector<GregorianCalendar> vNonWorkingDays = new Vector<GregorianCalendar>();
		calendarBegin.setTime(new Date(tsBegin.getTime()));


		int iYear = calendarBegin.get(Calendar.YEAR);

		// init Vector of non working days
		// --> with fixed days
		Vector<FixedNonWorkingDay> vFixed = FixedNonWorkingDay.getAllStatic();
		for( FixedNonWorkingDay fixedDay:vFixed){
			vNonWorkingDays.add(new GregorianCalendar(iYear,fixedDay.getMonth(), fixedDay.getDay()));
		}

		// --> with flating days (paques, pentecote and ascension)
		vNonWorkingDays.addAll(getFloatingNonWorkingDays(iYear));


		// run the days
		calendarRun.setTime(calendarBegin.getTime());
		for(int j=0; j<iNbDays; j++){
			// it is a non-working day
			if ((calendarRun.get(Calendar.DAY_OF_WEEK) == 0) || (calendarRun.get(Calendar.DAY_OF_WEEK) == 6 ) || (vNonWorkingDays.contains(calendarRun))){
				j--;
			}
			calendarRun.add(Calendar.DATE,1);

			if (calendarRun.get(Calendar.YEAR) != iYear){
				iYear = calendarRun.get(Calendar.YEAR);
				vNonWorkingDays.addAll(getFloatingNonWorkingDays(iYear));
			}
		}


		return new Timestamp(calendarRun.getTime().getTime());
	}

	public static boolean isANonWorkingDay(Timestamp tsDay) throws InstantiationException, IllegalAccessException, NamingException, SQLException{
		GregorianCalendar gc = new GregorianCalendar();
		gc.setTime(new Date(tsDay.getTime()));
		return isANonWorkingDay(gc);
	}

	public static boolean isANonWorkingDay(GregorianCalendar gcDay) throws InstantiationException, IllegalAccessException, NamingException, SQLException{
		Vector<GregorianCalendar> vNonWorkingDays = new Vector<GregorianCalendar>();
		int iYear = gcDay.get(Calendar.YEAR);

		// init Vector of non working days
		// --> with fixed days
		Vector<FixedNonWorkingDay> vFixed = FixedNonWorkingDay.getAllStatic();
		for( FixedNonWorkingDay fixedDay:vFixed){
			vNonWorkingDays.add(new GregorianCalendar(iYear,fixedDay.getMonth(), fixedDay.getDay()));
		}

		// --> with flating days (paques, pentecote and ascension)
		vNonWorkingDays.addAll(getFloatingNonWorkingDays(iYear));


		// is tsDay a saturday, or a sunday, or a non working day ?
		if ((gcDay.get(Calendar.DAY_OF_WEEK ) == Calendar.SATURDAY) || (gcDay.get(Calendar.DAY_OF_WEEK ) == Calendar.SUNDAY) || (vNonWorkingDays.contains(gcDay))){
			return true;
		}else{
			return false;
		}

	}


}