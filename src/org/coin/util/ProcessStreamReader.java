/****************************************************************************
 JFreeVote Project: A GPL Tool for Electronic Voting
 
 File: jfreevote.shared.ProcessStreamReader.java

 Based in GPL class GnuPG by John Anderson
 JFreeVote adaptation: Juan Antonio Martínez <jonsito@teleline.es>
 JFreeVote adaptation: Jesús Antonio Martínez <jamarcer@inicia.es>

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

package org.coin.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;


/**
 *  Class to manage a subprocess stdout output
 */
public class ProcessStreamReader extends Thread {
    StringBuffer stream;
    InputStreamReader in;

    final static int BUFFER_SIZE = 256;

    /**
     *  Constructor for the ProcessStreamReader object
     *@param  name  Description of the Parameter
     *@param  in    Description of the Parameter
     */
    public ProcessStreamReader(InputStream in) {
        super();
        this.in = new InputStreamReader(in);
        this.stream = new StringBuffer();
    }


    /**
     *  Main processing method for the ProcessStreamReader object
     */
    public void run() {
        try {
            int read;
            char[] c = new char[BUFFER_SIZE];

            while ((read = this.in.read(c, 0, BUFFER_SIZE - 1)) > 0) {
            	this.stream.append(c, 0, read);
                if (read < BUFFER_SIZE - 1) {
                    break;
                }
            }
        } catch (IOException io) {
            
        }
    }


    /**
     *  Gets the string attribute of the ProcessStreamReader object
     *
     *@return    The string value
     */
    public String getString() {
        return this.stream.toString();
    }
}

