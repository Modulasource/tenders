<%@page import="java.io.File"%>
<%@page import="org.apache.commons.io.FileSystemUtils"%>
<html>
<head>
<title>Disk space control</title>
</head>
<body>
<table border="1">
  <tr>
    <th>Root</th>
    <th>Total space</th>
    <th>Free space</th>
    <th>Free space (Apache lib)</th>
    <th>Usable space</th>
    <th>Occupation %</th>
  </tr>

<%
	File[] roots = File.listRoots();

	if(roots[0].getAbsolutePath().equals("/"))
	{
		// unix system
		File ff = new File("/dev");
        roots = ff.listFiles();
        roots = new File[]{ new File("/"), new File("/boot") , new File("/dev/shm"), new File("/usr/local")};
	}
	 
   
    for(int i = 0; i< roots.length ; i++)
    {
    	File f = roots[i];
        //File f = new File("c:\\");
	    try{
	    	long r = 1024 * 1024 * 1024;
	        long lTotalSpace = f.getTotalSpace() / r;
	    	long lFreeSpace = f.getFreeSpace() / r;
	    	long lUsableSpace = f.getUsableSpace() / r;
	    	long lFreeSpaceKb =  FileSystemUtils.freeSpaceKb(f.getAbsolutePath()) * 1024 / r;
	        double dFreeSpacePercent = lFreeSpace * 100 / lTotalSpace;
	        %>
		  <tr>
            <td><%= f %></td>
            <td><%= lTotalSpace %> Gb</td>
		    <td><%= lFreeSpace %> Gb</td>
	        <td><%= lFreeSpaceKb %> Gb</td>
	        <td><%= lUsableSpace %> Gb</td>
	        <td><%= dFreeSpacePercent %></td>
	 	  </tr>
	
	        <%
	       
    	} catch (Exception e) {
    		   e.printStackTrace();	
%>
        <tr>
          <td><%= f %></td>
          <td colspan="5"><%= e.getMessage() %></td>
        </tr>
<%
    	}  
    }   
%>
</table>
</body>
</html>
