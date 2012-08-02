package org.coin.servlet;

import org.coin.bean.conf.Configuration;
import org.modula.common.util.servlet.JarDownloaderServlet;

public class CoinJarDownloaderServlet extends JarDownloaderServlet {

	private static final long serialVersionUID = 1L;

	/**
	 * @override
	 * 			
	 */
	public String getRepositoryLocation()
	{
		try {
			/**
			 * example /usr/local/properties/applet
			 */
			String sRepo = Configuration.getConfigurationValueMemory("server.jar.download.repository");
			System.out.println("repo : " + sRepo);
			return sRepo;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
