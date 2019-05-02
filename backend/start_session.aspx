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
			UserFirstName = Request["first_name"];
			UserLastName = Request["last_name"];
		}
		string Result = "";
		string CallbackUrl = null;
		if (Request["callback"] != null)
			CallbackUrl = Request["callback"];
		{
			var Info = new {
				verification = new {
					callback = CallbackUrl,
					person = new {
						firstName = UserFirstName,
						lastName = UserLastName
					},
					features = new string[] {"selfid"},
					timestamp = TimeStamp()
				}
			};
			string InfoJson = JsonConvert.SerializeObject(Info, Newtonsoft.Json.Formatting.Indented,
				new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore });
			var Message = new HttpRequestMessage(new HttpMethod("POST"), API_URL + "/sessions");
			Message.Content = new StringContent(InfoJson);
			Message.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
			Message.Content.Headers.Add("x-auth-client", API_KEY);
			Message.Content.Headers.Add("x-signature", GenerateSignature(InfoJson, API_SECRET));
			var T = Task.Run(async delegate
			{
				return (await CallVeriffApi(Message));
			});
			T.Wait();
			Result = T.Result;
		}
		Result = "{\"status\":\"success\",\"verification\":{\"id\":\"d58a9b37-fdd4-4864-b3ba-2af1e13c40df\",\"url\":\"https://magic.veriff.me/v/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uX2lkIjoiZDU4YTliMzctZmRkNC00ODY0LWIzYmEtMmFmMWUxM2M0MGRmIiwiaWF0IjoxNTU2NjA1Mzg1LCJleHAiOjE1NTcyMTAxODV9.7jsbjAy1Ln7gKB2x1PzRBKpuiWrdu6zzKFoGNGa-dyY\",\"vendorData\":null,\"host\":\"https://magic.veriff.me\",\"status\":\"created\",\"sessionToken\":\"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzZXNzaW9uX2lkIjoiZDU4YTliMzctZmRkNC00ODY0LWIzYmEtMmFmMWUxM2M0MGRmIiwiaWF0IjoxNTU2NjA1Mzg1LCJleHAiOjE1NTcyMTAxODV9.7jsbjAy1Ln7gKB2x1PzRBKpuiWrdu6zzKFoGNGa-dyY\"}}";
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
				var Message = new HttpRequestMessage(new HttpMethod("POST"), String.Format("{0}/sessions/{1}/media", API_URL, VeriffResponse.verification.id));
				Message.Content = new StringContent(MediaJson);
				Message.Content.Headers.ContentType = new MediaTypeHeaderValue("application/json");
				Message.Content.Headers.Add("x-auth-client", API_KEY);
				Message.Content.Headers.Add("x-signature", GenerateSignature(MediaJson, API_SECRET));
				var T = Task.Run(async delegate
				{
					return (await CallVeriffApi(Message));
				});
				T.Wait();
				Result = T.Result;
				if ((JsonConvert.DeserializeAnonymousType(Result, new { status = "" })).status != "success")
				{
					throw new Exception();
				}
			}
		}
		Response.Write(JsonConvert.SerializeObject(new {sessionId = VeriffResponse.verification.id, url = VeriffResponse.verification.url }));
	}
	catch
	{
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on create Veriff session.</p>");
	}
	Response.End();
%>