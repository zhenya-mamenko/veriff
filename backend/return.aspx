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
		if (UserId == 0)
		{
			Response.Write(JsonConvert.SerializeObject(new { status = "error", error = "not logged" }));
		}
		else
		{
			string Query = String.Format("set nocount on; declare @rent_id int; "+
				"set @rent_id = (select top 1 rent_id from vw_rent where user_id={0} and car_id={1} and is_returned=0); " +
				"exec sp_rent_update @rent_id = @rent_id, @is_returned = 1",
				UserId, Convert.ToInt32(Request["car_id"])
				);
			Response.Write(Query);
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