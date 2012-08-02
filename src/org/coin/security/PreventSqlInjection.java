package org.coin.security;

public class PreventSqlInjection {
	public static final String ALPHA_LOWERCASE =  "abcdefghijklmnopqrstuvwxyz";
	public static final String ALPHA_UPPERCASE =  "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	public static final String ALPHA_ACCENT =  "ŠŒšœŸçâêôûÄéÆÇàèÊùÌÍÎÏĞîÒÓÔÕÖØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõöøùúûüışÿ";
	public static final String DIGITS = "1234567890";

	/** set by default 256 */
	public static int SIZE_MAX_ADDRESS = 256;

	/** set by default 35 */
	public static int SIZE_MAX_NAME = 35;

	/** set by default 5 */
	public static int SIZE_MAX_ZIPCODE = 5;

	/** set by default 20 */
	public static int SIZE_MAX_PHONE_NUMBER = 20;

	/** set by default 70 */
	public static int SIZE_MAX_EMAIL = 70;



	public static final String clean(String sData, String sAutorizedCharacter ) {
		StringBuffer sDataCleaned = new StringBuffer("");

		for (int i = 0; i < sData.length(); i++) {
			char c = sData.charAt(i);
			if(sAutorizedCharacter.indexOf(c) != -1)
			{
				sDataCleaned.append(c);
			}
		}

		return sDataCleaned.toString();
	}

	public static final String cleanTown(String sData) {
		String sAutorizedCharacter = " -'" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + DIGITS;

		return clean(sData, sAutorizedCharacter);
	}

	public static final String cleanZipCode(String sData) {
		String sAutorizedCharacter = DIGITS;

		return clean(sData, sAutorizedCharacter);
	}


	public static final String cleanAlpha(String sData) {
		if(sData == null) return null;

		String sAutorizedCharacter = " " + ALPHA_LOWERCASE + ALPHA_UPPERCASE + DIGITS;

		return clean(sData, sAutorizedCharacter);
	}

	public static final String cleanAlphaNumeric(String sData) {
		if(sData == null) return null;

		String sAutorizedCharacter = " " + ALPHA_LOWERCASE + ALPHA_UPPERCASE + DIGITS;

		return clean(sData, sAutorizedCharacter);
	}


	public static final String cleanAddress(String sData) {
		String sAutorizedCharacter = ";,:. -'()/#&°" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + ALPHA_ACCENT;

		return clean(sData, sAutorizedCharacter);
	}


	public static final String cleanName(String sData) {
		String sAutorizedCharacter = ". -'" + ALPHA_LOWERCASE + ALPHA_UPPERCASE;

		return clean(sData, sAutorizedCharacter);
	}

	public static final String cleanNameWithAccent(String sData) {
		String sAutorizedCharacter = ". -'" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + ALPHA_ACCENT;

		return clean(sData, sAutorizedCharacter);
	}



	public static final String cleanPhoneNumber(String sData) {
		String sAutorizedCharacter = "#*() +" + DIGITS;

		return clean(sData, sAutorizedCharacter);
	}


	public static final String cleanEmail(String sEmail) {
		String sAutorizedCharacter = ".@_-" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + DIGITS;

		return clean(sEmail, sAutorizedCharacter);
	}







	public static final String prevent(String sData, String sAutorizedCharacter, int iSizeMax ) throws SqlInjectionException {

		if(sData.length() >= iSizeMax) throw new SqlInjectionException("Data Too long : " + iSizeMax + " < " + sData.length() );

		return prevent(sData, sAutorizedCharacter );
	}

	public static final String prevent(String sData, String sAutorizedCharacter ) throws SqlInjectionException {
		StringBuffer sDataCleaned = new StringBuffer("");

		for (int i = 0; i < sData.length(); i++) {
			char c = sData.charAt(i);
			if(sAutorizedCharacter.indexOf(c) != -1)
			{
				sDataCleaned.append(c);
			}
			else throw new SqlInjectionException("Invalid character '" + c +  "'");
		}

		return sDataCleaned.toString();
	}







	/**
	 *
	 * @param sData
	 * @return
	 * @throws SqlInjectionException
	 */
	public static final String preventName(String sData) throws SqlInjectionException {

		return preventName(sData, SIZE_MAX_NAME);
	}

	public static final String preventName(String sData, int iSizeMax) throws SqlInjectionException {
		String sAutorizedCharacter = ". -'" + ALPHA_LOWERCASE + ALPHA_UPPERCASE;

		return prevent(sData, sAutorizedCharacter, iSizeMax);
	}

	/**
	 *
	 * @param sData
	 * @return
	 * @throws SqlInjectionException
	 */
	public static final String preventPhoneNumber(String sData) throws SqlInjectionException {

		return preventPhoneNumber(sData, SIZE_MAX_PHONE_NUMBER);
	}


	public static final String preventPhoneNumber(String sData, int iSize) throws SqlInjectionException {
		String sAutorizedCharacter = "#*() +" + DIGITS;

		return prevent(sData, sAutorizedCharacter, iSize);
	}


	/**
	 *
	 * @param sEmail
	 * @return
	 * @throws SqlInjectionException
	 */
	public static final String preventEmail(String sEmail) throws SqlInjectionException {

		return preventEmail(sEmail, SIZE_MAX_EMAIL);
	}



	public static final String preventEmail(String sData, int iSize) throws SqlInjectionException {
		String sAutorizedCharacter = ".@_-" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + DIGITS;

		return prevent(sData, sAutorizedCharacter, iSize);
	}


	/**
	 *
	 * @param sData
	 * @return
	 * @throws SqlInjectionException
	 */
	public static final String preventZipCode(String sData) throws SqlInjectionException {

		return preventZipCode(sData, SIZE_MAX_ZIPCODE);
	}

	public static final String preventZipCode(String sData, int iSize) throws SqlInjectionException {
		String sAutorizedCharacter = DIGITS;

		return prevent(sData, sAutorizedCharacter, iSize);
	}




	/**
	 *
	 * @param sData
	 * @return
	 */
	public static final String preventAddress(String sData) throws SqlInjectionException {

		return preventAddress(sData, SIZE_MAX_ADDRESS);
	}

	public static final String preventAddress(String sData, int iSize) throws SqlInjectionException {
		String sAutorizedCharacter = ";,:. -'()/#&°" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + ALPHA_ACCENT;

		return prevent(sData, sAutorizedCharacter, iSize);
	}



	/**
	 *
	 * @param sData
	 * @return
	 * @throws SqlInjectionException
	 */
	public static final String preventNameWithAccent(String sData) throws SqlInjectionException {

		return preventNameWithAccent(sData, SIZE_MAX_NAME);
	}


	public static final String preventNameWithAccent(String sData, int iSize) throws SqlInjectionException {
		String sAutorizedCharacter = ". -'" + ALPHA_LOWERCASE + ALPHA_UPPERCASE + ALPHA_ACCENT;

		return prevent(sData, sAutorizedCharacter, iSize);
	}

}
