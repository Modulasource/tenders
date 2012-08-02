/****************************************************************************
 JFreeVote Project: A GPL Tool for Electronic Voting
 
 File: jfreevote.shared.GnuPG.java

 Based in GPL class GnuPG by John Anderson

 Copyright 2002-2003 by Juan Antonio Martinez & HispaLinux

 This file is FREE SOFTWARE.; you can redistribute it and/or modify it 
 under the terms of the GNU General Public License as published by the 
 Free Software Foundation; either version 2 of the License, or 
 (at your option) any later version. 

 This program is distributed in the hope that it will be useful, but 
 WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
 or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License 
 for more details.

 You should have received a copy of the GNU General Public License along 
 with this program; if not, write to the Free Software Foundation, Inc., 59 
 Temple Place, Suite 330, Boston, MA  02111-1307  USA

****************************************************************************/

package modula;

import java.io.*;

import org.coin.util.ProcessStreamReader;



/**
 *  Description: A small class to encrypt and decrypt text using GnuPG
 *
 *@author     Based in GPL class GnuPG by John Anderson
 *@author     JFreeVote adaptation: Juan Antonio Martínez <jonsito@teleline.es>
 *@author     JFreeVote adaptation: Jesús Antonio Martínez <jamarcer@inicia.es>
 *@version    1.0
 *@see        "gpg (GnuPG) 1.0.6 or newer"
 */
public class GnuPG {
    //private static String gpg_comm = "/usr/bin/gpg --no-secmem-warning ";
    private static String gpg_comm = "c:\\GnuPG\\gpg --no-secmem-warning ";
    private static String encrypt_param = "--armor --batch --encrypt -r ";
    private static String decrypt_param = "--passphrase-fd 0 --batch --decrypt ";


    /**
     *  Default constructor
     */
    public GnuPG() {
        
    }

	/**
	* DKE : premier jet ...
	**/
    public static  String encrypt(String sFileName, String sPath, String rcpt) throws Exception  {
	    Process p;
        String sPathFileNameIn = sPath + sFileName;
        String sPathFileNameOut = sPath + sFileName + ".gpg";
	    String sCommandLine ;
	    //sCommandLine = gpg_comm + encrypt_param + rcpt + " < " + sPathFileNameIn + " > " + sPathFileNameOut;
	    sCommandLine = gpg_comm + encrypt_param + rcpt + " --compress-algo 2 --output \""  + sPathFileNameOut + "\" \"" + sPathFileNameIn + "\"";
	    
	    try {
		    System.out.println(sCommandLine );
	        p = Runtime.getRuntime().exec(sCommandLine );
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

    
        ProcessStreamReader psr_stdout = new ProcessStreamReader(p.getInputStream());
        ProcessStreamReader psr_stderr = new ProcessStreamReader(p.getErrorStream());

        psr_stdout.start();
        psr_stderr.start();
            
        
        try {
            p.waitFor();
        	psr_stdout.join();
        	psr_stderr.join();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        // étrange ... sort avec le code 2
       /* if (p.exitValue() != 0) {
            throw new Exception("gpg error >> code: " + p.exitValue() + " >> " );
        }
		*/
        System.out.println("gpg output : " + psr_stdout.getString());
        System.out.println("gpg output : " + psr_stderr.getString());
	    
        return sPathFileNameOut;
	}
    
    /**
     *  Encrypt text.
     *@param  str            Text to encrypt
     *@param  rcpt           User ID
     *@return                Description of the Return Value
     *@exception  Exception  Description of the Exception
     */
    public String encrypt(String str, String rcpt) throws Exception {
        Process p;
        try {
	        p = Runtime.getRuntime().exec(gpg_comm + encrypt_param + rcpt);
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        ProcessStreamReader psr_stdout = new ProcessStreamReader(p.getInputStream());
        ProcessStreamReader psr_stderr = new ProcessStreamReader(p.getErrorStream());

        psr_stdout.start();
        psr_stderr.start();

        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));
        try {
            out.write(str);
            out.close();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        try {
            p.waitFor();
            psr_stdout.join();
            psr_stderr.join();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        if (p.exitValue() != 0) {
            throw new Exception("gpg error >> code: " + p.exitValue() + " >> " + psr_stderr.getString());
        }

        return psr_stdout.getString();
    }


    /**
     *  Decrypt text encrypted.
     *
     *@param  str            Text encrypted
     *@param  passphrase     GnuPG passphrase
     *@return                Description of the Return Value
     *@exception  Exception  Description of the Exception
     */
    public String decrypt(String str, String passphrase) throws Exception {
        Process p = null;
        File f = null;

        try {
            f = File.createTempFile("gpg-decrypt", null);
            FileWriter fw = new FileWriter(f);
            fw.write(str);
            fw.flush();
	    fw.close();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        try {
            p = Runtime.getRuntime().exec(gpg_comm + decrypt_param + f.getAbsolutePath());
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        ProcessStreamReader psr_stdout = new ProcessStreamReader(p.getInputStream());
        ProcessStreamReader psr_stderr = new ProcessStreamReader(p.getErrorStream());

        psr_stdout.start();
        psr_stderr.start();

        BufferedWriter out = new BufferedWriter(new OutputStreamWriter(p.getOutputStream()));

        try {
            out.write(passphrase);
            out.close();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        try {
            p.waitFor();
            psr_stdout.join();
            psr_stderr.join();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }

        if (p.exitValue() != 0) {
            throw new Exception("gpg error >> code: " + p.exitValue() + " >> " + psr_stderr.getString());
        }

        try {
            f.delete();
        } catch (Exception e) {
            throw new Exception("gpg error >> " + e.toString());
        }
        return psr_stdout.getString();
    }
}
