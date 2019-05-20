<!-- #include file="all.inc" -->
<%
	Response.Clear();
	if (Request.HttpMethod != "POST")
	{
		Response.Status = "400 Bad Request";
		Response.StatusCode = 400;
		Response.End();
	}
	try
	{
		if (UserId == 0)
		{
			Response.Write(JsonConvert.SerializeObject(new { status = "error", error = "not logged", session = Session["UserId"] }));
		}
		else
		{
			string Query = String.Format("declare @rent_id int; exec sp_rent_insert @rent_id OUTPUT, {0}, {1}, {2}, {3}, {4}, {5}, {6}",
				UserId, Convert.ToInt32(Request["carId"]), Convert.ToInt32(Request["fromPoint"]), Convert.ToInt32(Request["toPoint"]),
				Quote(Request["dateFrom"]), Quote(Request["dateTo"]),
				Convert.ToDecimal(Request["price"], new CultureInfo("en-US")).ToString(new CultureInfo("en-US"))
				);
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
			Response.Write(JsonConvert.SerializeObject(new { status = "ok" }));
		}
	}
	catch
	{
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on getting user status.</p>");
	}
	Connection.Close();
	Response.End();
%>