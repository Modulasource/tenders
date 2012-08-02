package org.coin.util;


import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;


public class StringErrorHandler implements ErrorHandler {
	public String sFullErrorMessage = "";
	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#warning(org.xml.sax.SAXParseException)
	 */
	public void warning(SAXParseException e) throws SAXException {

		sFullErrorMessage += "WARNING : " + e.getMessage() + "\n";
	}

	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#error(org.xml.sax.SAXParseException)
	 */
	public void error(SAXParseException e) throws SAXException {
		sFullErrorMessage += "ERROR : " + e.getMessage() + "\n";

	}

	/* (non-Javadoc)
	 * @see org.xml.sax.ErrorHandler#fatalError(org.xml.sax.SAXParseException)
	 */
	public void fatalError(SAXParseException e) throws SAXException {

		sFullErrorMessage += "FATAL ERROR : " + e.getMessage() +  "\n";

	}

}
