<!-- #include file="all.inc" -->
<%
	Response.Clear();
	if (Request.HttpMethod != "GET")
	{
		Response.Status = "400 Bad Request";
		Response.StatusCode = 400;
		Response.End();
	}
	try
	{
		if (Session["UserId"] != null)
		{
			Response.Write(JsonConvert.SerializeObject(new { status = "logged", already = true }));
		}
		else
		{
			string Query = String.Format("select user_id, first_name, last_name from vw_users where login={0} and pass={1}",
				Quote(Request["email"]), Quote(Request["hash"]));
			var Command = new SqlCommand(Query, Connection);
			using (SqlDataReader Reader = Command.ExecuteReader())
			{
				if (Reader.Read())
				{
					Session["UserId"] = Reader.GetInt32(0);
					Session["UserFirstName"] = Reader["first_name"].ToString();
					Session["UserLastName"] = Reader["last_name"].ToString();
					Response.Write(JsonConvert.SerializeObject(new { status = "logged" }));
				}
				else
				{
					Response.Write(JsonConvert.SerializeObject(new { status = "error" }));
				}
			}
		}
	}
	catch
	{
		Response.Clear();
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on getting user status.</p>");
	}
	Connection.Close();
	Response.End();
%>