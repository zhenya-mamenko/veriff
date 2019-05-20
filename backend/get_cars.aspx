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

	string FieldToJson(string S)
	{
		string Result = "";
		bool IsCapital = false;
		for (int i = 0; i < S.Length; i++)
		{
			if (IsCapital)
			{
				Result += Char.ToUpper(S[i]);
				IsCapital = false;
			}
			else
			{
				if (S[i] == '_')
					IsCapital = true;
				else
					Result += Char.ToLower(S[i]);
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
		string[] Orders = new string[] { "price_per_day", "price_per_day desc", "passengers desc" };
		string OrderBy = Orders[Convert.ToInt32(Request["order_by"])];
		int Page = Request["page"] == null ? 1 : Convert.ToInt32(Request["page"]);
		int PageSize = Request["page_size"] == null ? 20 : Convert.ToInt32(Request["page_size"]);
		if (Request["point_id"] == null)
			throw new Exception();
		string Where = "";
		Where += " and point_id in (" + PrepareRequestData(Request["point_id"], false) + ")";
		if (Request["car_type"] != null && Request["car_type"] != "")
			Where += " and car_type in (" + PrepareRequestData(Request["car_type"], true) + ")";
		if (Request["passengers"] != null && Request["passengers"] != "")
			Where += " and passengers in (" + PrepareRequestData(Request["passengers"], false) + ")";
		if (Request["bags"] != null && Request["bags"] != "")
			Where += " and bags in (" + PrepareRequestData(Request["bags"], false) + ")";
		if (Request["doors"] != null && Request["doors"] != "")
			Where += " and doors in (" + PrepareRequestData(Request["doors"], true) + ")";
		if (Request["has_ac"] != null && Request["has_ac"] != "")
			Where += " and is_has_ac = 1";
		if (Request["transmission_type"] != null && Request["transmission_type"] != "")
			Where += " and transmission_type in (" + PrepareRequestData(Request["transmission_type"], true) + ")";
		string Query = String.Format("with cars_filtered as (select *, row_number() over (order by {0}) as rn from vw_cars " +
			"where car_id not in (select car_id from dbo.get_rented_cars({4}, {5})) {3}) " +
			"select car_id, airport_name, is_airport, car_type, car_name, passengers, bags, doors, price_per_day, is_has_ac, transmission_type, car_benefits " +
			"from cars_filtered where rn between {1} and {2} order by {0}",
			OrderBy, (Page - 1) * PageSize + 1, Page * PageSize, Where, Quote(Request["date_from"]), Quote(Request["date_to"]));
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
					for (int i = 0; i < Reader.FieldCount - 1; i++)
					{
						(Fields as IDictionary<string, object>).Add(FieldToJson(Reader.GetName(i)), Reader[i]);
					}
					CarsCount += 1;
					(Fields as IDictionary<string, object>).Add("benefits", Reader["car_benefits"].ToString().Split(new Char[]{'|'}));
					(Fields as IDictionary<string, object>).Add("image",
						"data:image/png;base64,"+FileToBase64(String.Format("{0}.png", Reader["car_id"]), @"cars\"));
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
