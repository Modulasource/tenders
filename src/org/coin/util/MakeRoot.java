package org.coin.util;


/*
        MakeRoot.java -- basic JNDI application used for
        adding the "root" context to an LDAP server
*/

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.naming.NameAlreadyBoundException;
import javax.naming.directory.*;
import java.util.*;

public class MakeRoot {
        final static String ldapServerName = "localhost";

        final static String rootdn = "cn=Manager,dc=guessant,dc=org";
        //final static String rootdn = "cn=Manager,o=jndiTest";
        final static String rootpass = "secret";
        //final static String rootContext = "o=jndiTest";
        final static String rootContext = "dc=guessant,dc=org";

        public static void main( String[] args ) {
                // set up environment to access the server

                Properties env = new Properties();

                env.put( Context.INITIAL_CONTEXT_FACTORY,
                         "com.sun.jndi.ldap.LdapCtxFactory" );
                env.put( Context.PROVIDER_URL, "ldap://" + ldapServerName + "/" );
                env.put( Context.SECURITY_PRINCIPAL, rootdn );
                env.put( Context.SECURITY_CREDENTIALS, rootpass );

                try {
                        // obtain initial directory context using the environment
                        DirContext ctx = new InitialDirContext( env );

                        // now, create the root context, which is just a subcontext
                        // of this initial directory context.
                        ctx.createSubcontext( rootContext );
                        ctx.list(rootContext);

                } catch ( NameAlreadyBoundException nabe ) {
                        System.err.println( rootContext + " has already been bound!" );
                } catch ( Exception e ) {
                        System.err.println( e );
                }
        }
}

// end MakeRoot.java