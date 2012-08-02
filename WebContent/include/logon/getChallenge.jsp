<%
	String s = "GET_" + System.currentTimeMillis() + "::" + session.getId() + "_CHALLENGE";

	System.out.println("getChallenge.jsp SESSION ID : " + session.getId());

	session.setAttribute("challengePassPhrase", s);
%><%= s %>