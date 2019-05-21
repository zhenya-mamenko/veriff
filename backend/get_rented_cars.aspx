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
		int Page = Request["page"] == null ? 1 : Convert.ToInt32(Request["page"]);
		int PageSize = Request["page_size"] == null ? 20 : Convert.ToInt32(Request["page_size"]);
		if (UserId == 0)
			throw new Exception();
		string Where = "";
		string Query = String.Format("with cars_filtered as (select *, row_number() over (order by {0}) as rn from vw_rent " +
			"where user_id={3} and is_returned=0) " +
			"select car_id, from_airport_name, from_city, to_city, to_airport_name, car_type, car_name, "+
			"car_passengers as passengers, car_bags as bags, car_doors as doors, price_total as price, "+
			"car_is_has_ac as is_has_ac, car_transmission_type as transmission_type, "+
			"text_rent_from, text_rent_until, car_benefits " +
			"from cars_filtered where rn between {1} and {2} order by {0}",
			"rent_from, rent_until", (Page - 1) * PageSize + 1, Page * PageSize, UserId);
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
						(Fields as IDictionary<string, object>).Add(FieldToJson(Reader.GetName(i)), Reader[i]);
					}
					CarsCount += 1;
					//(Fields as IDictionary<string, object>).Add("benefits", Reader["car_benefits"].ToString().Split(new Char[]{'|'}));
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
