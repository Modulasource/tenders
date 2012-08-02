<%@ include file="../../../../include/new_style/headerDesk.jspf" %>

<%@ page import="org.coin.bean.*,java.util.*" %>
<%
	long lIdUser = -1;
	String sAction;
	sAction = request.getParameter("sAction") ;

	if (sAction.equals("remove") )
	{
		UserUsecase uuc = UserUsecase.getUserUsecase(
				Long.parseLong( request.getParameter("lIdUserUsecase") ));
		lIdUser = uuc.getIdUser();
		uuc.remove();

	}

	if (sAction.equals("store") )
	{
		lIdUser = Long.parseLong( request.getParameter("lIdUser") );
	 	ArrayList<Vector<UseCase>> arrCU = Habilitation.getAllUseCaseFromIdUser((int) lIdUser );
		Vector<UseCase> vUseCases = arrCU.get(0);
		Vector<UseCase> vUseCasesManageable = arrCU.get(1);

		UserUsecase uuc = new UserUsecase();
		uuc.remove(" WHERE id_coin_user =" + lIdUser
				+ " AND id_coin_user_usecase_type = " + UserUsecaseType.TYPE_REMOVE);

		for (int j=0; j < vUseCases.size(); j++)
		{
			UseCase usecase = (UseCase) vUseCases.get(j);

    		Enumeration params = request.getParameterNames();
    		boolean bToRemove = true;
			while (params.hasMoreElements())
    		{

				String param = (String)params.nextElement();
				if(param.startsWith("_UC_"))
				{
			    	String sUC = param.substring("_UC_".length());
					if( usecase.getIdString().equals(sUC))
					{
						bToRemove = false;
						break;
					}
				}
			}

	    	if(bToRemove)
	    	{
				uuc.setIdUser(lIdUser);
				uuc.setIdUserUsecaseType(UserUsecaseType.TYPE_REMOVE);
				uuc.setIdUseCase(usecase.getIdString());
				uuc.create();
	    	}


		}

	}

	if (sAction.equals("create") )
	{
		UserUsecase uuc = new UserUsecase();
		uuc.setFromFormUTF8(request, "");
		lIdUser = uuc.getIdUser();
		uuc.create();
	}



	response.sendRedirect(
			response.encodeRedirectURL(
					"afficherUtilisateurGroupe.jsp?iIdUser=" + lIdUser
					+ "&nonce=" + System.currentTimeMillis() ));
%>