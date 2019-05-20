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
		string Query = String.Format("select [point_output_city] as city, point_id from vw_points order by city");
		var Command = new SqlCommand(Query, Connection);
		using (SqlDataReader Reader = Command.ExecuteReader())
		{
			var Cities = new List<Object>();
			while (Reader.Read())
			{
				var City = new {
					pointId = Reader["point_id"],
					city = Reader["city"]
				};
				Cities.Add(City);
			}
			Response.Write(JsonConvert.SerializeObject(Cities, Newtonsoft.Json.Formatting.Indented));
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