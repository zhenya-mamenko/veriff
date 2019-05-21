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
		string Result = "";
		string CallbackUrl = null;
		if (Request["callback"] != null)
			CallbackUrl = Request["callback"];
		{
			var Info = new {
				verification = new {
					callback = CallbackUrl,
					person = new {
						firstName = UserId == 0 ? Request["first_name"] : UserFirstName,
						lastName = UserId == 0 ? Request["last_name"] : UserLastName
					},
					features = new string[] {"selfid"},
					timestamp = TimeStamp()
				}
			};
			string InfoJson = JsonConvert.SerializeObject(Info, Newtonsoft.Json.Formatting.Indented,
				new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });
			var Message1 = new HttpRequestMessage(new HttpMethod("POST"), API_URL + "/sessions");
			Message1.Content = new StringContent(InfoJson);
			Message1.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
			Message1.Content.Headers.Add("x-auth-client", API_KEY);
			Message1.Content.Headers.Add("x-signature", GenerateSignature(InfoJson, API_SECRET));
			var T1 = Task.Run(async delegate
			{
				return (await CallVeriffApi(Message1));
			});
			T1.Wait();
			Result = T1.Result;
		}
		var ResponseDefinition = new {
			verification = new {
				id = "",
				url = "",
				status = "",
				sessionToken = ""
			}
		};
		var VeriffResponse = JsonConvert.DeserializeAnonymousType(Result, ResponseDefinition);
		if (UserId == 0)
		{
			string Login = Request["email"];
			string Pass = GenerateSignature(Request["password"], "");
			string Query = String.Format("set nocount on; declare @user_id int; exec sp_users_insert @user_id OUTPUT, {0}, {1}, {2}, {3}; select @user_id",
				Quote(Login), Quote(Pass), Quote(UserFirstName), Quote(UserLastName));
			var Command = new SqlCommand(Query, Connection);
			using (SqlDataReader Reader = Command.ExecuteReader())
			{
				try
				{
					if (Reader.Read())
					{
						UserId = Reader.GetInt32(0);
						Session["UserId"] = UserId;
						Session["UserFirstName"] = UserFirstName;
						Session["UserLastName"] = UserLastName;
					}
				}
				finally
				{
					Reader.Close();
				}
			}
		}
		if (UserId != 0)
		{
			string Query = String.Format("exec sp_sessions_insert {0}, {1}, {2}, {3}",
				Quote(VeriffResponse.verification.id), UserId, Quote(VeriffResponse.verification.status),
				Quote(VeriffResponse.verification.url));
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
		}
		if (Request["document_front_id"] != null)
		{
			string[] Images = new string[] { Request["document_front_id"], Request["document_back_id"], Request["selfi_id"] };
			string[] ImagesContext = new string[] { "document-front", "document-back", "face" };
			for (int i = 0; i < Images.Length; i++)
			{
				string Image = "data:image/" + (Images[i].IndexOf(".png") != -1 ? "png" : "jpeg") + ";base64," + FileToBase64(Images[i]);
				var Media = new {
					image = new {
						context = ImagesContext[i],
						content = Image,
						timestamp = TimeStamp()
					}
				};
				string MediaJson = JsonConvert.SerializeObject(Media, Newtonsoft.Json.Formatting.Indented,
					new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });
				var Message2 = new HttpRequestMessage(new HttpMethod("POST"), String.Format("{0}/sessions/{1}/media", API_URL, VeriffResponse.verification.id));
				Message2.Content = new StringContent(MediaJson);
				Message2.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
				Message2.Content.Headers.Add("x-auth-client", API_KEY);
				Message2.Content.Headers.Add("x-signature", GenerateSignature(MediaJson, API_SECRET));
				var T2 = Task.Run(async delegate
				{
					return (await CallVeriffApi(Message2));
				});
				T2.Wait();
				Result = T2.Result;
				if ((JsonConvert.DeserializeAnonymousType(Result, new { status = "" })).status != "success")
				{
					throw new Exception();
				}
			}
			var Done = new {
				verification = new {
					frontState = "done",
					status = "submitted",
					timestamp = TimeStamp()
				}
			};
			string DoneJson = JsonConvert.SerializeObject(Done, Newtonsoft.Json.Formatting.Indented,
				new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });
			var Message3 = new HttpRequestMessage(new HttpMethod("PATCH"), String.Format("{0}/sessions/{1}", API_URL, VeriffResponse.verification.id));
			Message3.Content = new StringContent(DoneJson);
			Message3.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
			Message3.Content.Headers.Add("x-auth-client", API_KEY);
			Message3.Content.Headers.Add("x-signature", GenerateSignature(DoneJson, API_SECRET));
			var T3 = Task.Run(async delegate
			{
				return (await CallVeriffApi(Message3));
			});
			T3.Wait();
			Result = T3.Result;
			Response.Write(Result);
			if ((JsonConvert.DeserializeAnonymousType(Result, new { status = "" })).status != "success")
			{
				throw new Exception();
			}
			string Query = String.Format("exec sp_sessions_update @session_id={0}, @status={1}",
				Quote(VeriffResponse.verification.id), Quote("submited"));
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
		}
		else
		{
			string Query = String.Format("exec sp_sessions_update @session_id={0}, @status={1}",
				Quote(VeriffResponse.verification.id), Quote("submitted"));
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
		}
		Response.Write(JsonConvert.SerializeObject(new {sessionId = VeriffResponse.verification.id, url = VeriffResponse.verification.url }));
	}
	catch
	{
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on create Veriff session.</p>");
	}
	Connection.Close();
	Response.End();
%>