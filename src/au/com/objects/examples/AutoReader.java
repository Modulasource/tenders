package au.com.objects.examples;

/*
*  Copyright (c) 2001-2004 by Objects Pty Ltd
*/

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.ArrayList;
import java.util.Iterator;

/**
*  Reads a text stream line by line notifying registered listeners of it's progress.
*
*  @author Mick Barry http://www.objects.com.au
*/

public class AutoReader implements Runnable
{
	private BufferedReader In = null;
	
	private ArrayList Listeners = new ArrayList();
	
	/**
	*  Constructor 
	*  @param in stream to read, line by line
	*/
	
	public AutoReader(InputStream in)
	{
		this(new InputStreamReader(in));
	}

	/**
	*  Constructor 
	*  @param in reader to read, line by line
	*/

	public AutoReader(Reader in)
	{
		In = new BufferedReader(in);
	}

	/**
	*  Adds listener interested in progress of reading
	*  @param listener listener to add
	*/
	
	public void addListener(Listener listener)
	{
		Listeners.add(listener);
	}

	/**
	*  Removes listener interested in progress of reading
	*  @param listener listener to remove
	*/

	public void removeListener(Listener listener)
	{
		Listeners.remove(listener);
	}

	/**
	*  Handles reading from stream until eof, notify registered listeners of progress.
	*/
	
	public void run()
	{
		try
		{
			String line = null;
			while (null!=(line = In.readLine()))
			{
				fireLineRead(line);
			}
		}
		catch (IOException ex)
		{
			fireError(ex);
		}
		finally
		{
			fireEOF();
		}
	}
	
	/**
	*  Interface listeners must implement
	*/
	
	public interface Listener
	{
		/**
		*  Invoked after each new line is read from stream
		*  @param reader where line was read from
		*  @param line line read
		*/
		
		public void lineRead(AutoReader reader, String line);
		
		/**
		*  Invoked if an I/O error occurs during reading
		*  @param reader where error occurred
		*  @param ex exception that was thrown
		*/
		
		public void error(AutoReader reader, IOException ex);

		/**
		*  Invoked after EOF is reached
		*  @param reader where EOF has occurred
		*/

		public void eof(AutoReader reader);
	}

	/**
	*  Notifies registered listeners that a line has been read
	*/
		
	private void fireLineRead(String line)
	{
		Iterator i = Listeners.iterator();
		while (i.hasNext())
		{
			((Listener)i.next()).lineRead(this, line);
		}
	}

	/**
	*  Notifies registered listeners that an error occurred during reading
	*/

	private void fireError(IOException ex)
	{
		Iterator i = Listeners.iterator();
		while (i.hasNext())
		{
			((Listener)i.next()).error(this, ex);
		}
	}

	/**
	*  Notifies registered listeners that EOF has been reached
	*/

	private void fireEOF()
	{
		Iterator i = Listeners.iterator();
		while (i.hasNext())
		{
			((Listener)i.next()).eof(this);
		}
	}
	
}
