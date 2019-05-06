<!-- #include file="all.inc" -->
<%
	Response.Clear();
	if (Request.HttpMethod != "GET")
	{
		Response.Status = "400 Bad Request";
		Response.StatusCode = 400;
		Response.End();
	}
	// try
	{
		if (UserId == 0)
		{
			var Status = new {
				status = "not logged"
			};
			Response.Write(JsonConvert.SerializeObject(Status));
		}
		else
		{
			string Query = String.Format("select status from vw_users where user_id={0}", UserId);
			var Command = new SqlCommand(Query, Connection);
			using (SqlDataReader Reader = Command.ExecuteReader())
			{
				if (Reader.Read())
				{
					var Status = new {
						status = Reader["status"],
						firstName = UserFirstName,
						lastName = UserLastName
					};
					Response.Write(JsonConvert.SerializeObject(Status, Newtonsoft.Json.Formatting.Indented));
				}
			}
		}
	}
	// catch
	// {
	// 	Response.Status = "500 Internal Server Error";
	// 	Response.StatusCode = 500;
	// 	Response.Write("<h1>500 Internal Server Error</h1><p>Error on getting user status.</p>");
	// }
	Response.End();
%>