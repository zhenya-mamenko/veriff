<!-- #include file="all.inc" -->
<%@ Import Namespace="System.Dynamic" %>
<script runat="Server">
	string PrepareRequestData(string Data, bool Quoted = false)
	{
		if (!Quoted)
			Data = Data.Replace("'", "");
		string[] Values = Data.Split(new char[] {','});
		string Result = "";
		for (int i = 0; i < Values.Length; i++)
		{
			string Value = Values[i].Trim();
			if (Value != "")
			{
				Value = Quoted ? Quote(Value) : Value;
				Result += (Result != "" ? ", " : "") + Value;
			}
		}
		return (Result);
	}
</script>
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
		string[] Orders = new string[] {"price_per_day", "passengers", "bags", "doors"};
		string OrderBy = Orders[Convert.ToInt32(Request["order_by"])];
		int Page = Request["page"] == null ? 1 : Convert.ToInt32(Request["page"]);
		int PageSize = Request["page"] == null ? 5 : Convert.ToInt32(Request["page_size"]);
		if (Request["point_id"] == null)
			throw new Exception();
		string Where = "";
		Where += " and point_id in (" + PrepareRequestData(Request["point_id"], false) + ")";
		if (Request["car_type"] != null)
			Where += " and car_type in (" + PrepareRequestData(Request["car_type"], true) + ")";
		if (Request["passengers"] != null)
			Where += " and passengers in (" + PrepareRequestData(Request["passengers"], false) + ")";
		if (Request["bags"] != null)
			Where += " and bags in (" + PrepareRequestData(Request["bags"], false) + ")";
		if (Request["doors"] != null)
			Where += " and doors in (" + PrepareRequestData(Request["doors"], true) + ")";
		if (Request["has_ac"] != null)
			Where += " and is_has_ac = 1";
		if (Request["transmission_type"] != null)
			Where += " and transmission_type = " + Quote(Request["transmission_type"]);
		string Query = String.Format("with cars_filtered as (select *, row_number() over (order by {0}) as rn from vw_cars " +
			"where is_rented = 0 {3}) " +
			"select car_id, airport_name, is_airport, car_type, car_name, passengers, bags, doors, price_per_day, is_has_ac, transmission_type " +
			"from cars_filtered where rn between {1} and {2} order by {0}",
			OrderBy, (Page - 1) * PageSize + 1, Page * PageSize, Where);
		var Command = new SqlCommand(Query, Connection);
		using (SqlDataReader Reader = Command.ExecuteReader())
		{
			try
			{
				List<Object> Cars = new List<Object>();
				int CarsCount = 0;
				while (Reader.Read())
				{
					dynamic Fields = new ExpandoObject();
					for (int i = 0; i < Reader.FieldCount; i++)
					{
						(Fields as IDictionary<string, object>).Add(Reader.GetName(i), Reader[i]);
					}
					CarsCount += 1;
					(Fields as IDictionary<string, object>).Add("image",
						"data:image/png;base64,"+FileToBase64(String.Format("{0}.png", CarsCount), @"cars\"));
					Cars.Add(Fields);
				}
				Response.Write(JsonConvert.SerializeObject(Cars, Newtonsoft.Json.Formatting.Indented));
			}
			finally
			{
				Reader.Close();
			}
		}
	}
	catch
	{
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on select cars.</p>");
	}
	Connection.Close();
	Response.End();
%>
