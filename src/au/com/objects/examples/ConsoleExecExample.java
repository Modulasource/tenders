package au.com.objects.examples;

/*
*  Copyright (c) 2004 by Objects Pty Ltd
*/

import java.io.IOException;

/**
*  Example demonstrating reading output from Process.exec() to console.
*
*  @author Mick Barry http://www.objects.com.au
*/

public class ConsoleExecExample implements AutoReader.Listener
{
	public void lineRead(AutoReader reader, String line)
	{
		System.out.println(line);
	}
	
	public void error(AutoReader reader, IOException ex)
	{
		ex.printStackTrace();
	}

	public void eof(AutoReader reader)
	{
	}

	public static void main(String[] args)
	{
		try
		{
			ConsoleExecExample ex = new ConsoleExecExample();
			Process p = Runtime.getRuntime().exec(args);
			AutoReader in = new AutoReader(p.getInputStream());
			in.addListener(ex);
			AutoReader err = new AutoReader(p.getErrorStream());
			err.addListener(ex);
			new Thread(in).start();
			new Thread(err).start();
			p.waitFor();
		}
		catch (Exception ex)
		{
			ex.printStackTrace();
		}		
	}
}
