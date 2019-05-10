<!-- #include file="all.inc" -->
<%
	Response.Clear();
	if (Request.HttpMethod != "GET")
	{
		Response.Status = "400 Bad Request";
		Response.StatusCode = 400;
		Response.End();
	}
	var Message = new HttpRequestMessage(new HttpMethod("GET"), String.Format("{0}/sessions/{1}/decision", API_URL, Request["session_id"]));
	Message.Headers.Add("x-auth-client", API_KEY);
	Message.Headers.Add("x-signature", GenerateSignature(Request["session_id"], API_SECRET));
	var T = Task.Run(async delegate
	{
		return (await CallVeriffApi(Message));
	});
	T.Wait();
	string Result = T.Result;
	var ResponseDefinition = new {
		status = "",
		verification = new {
			status = "",
			code = 9000,
			reason = "",
			person = new {
				firstName = "",
				lastName = "",
				dateOfBirth = ""
			},
			document = new {
				number = "",
				type = "",
				country = "",
				validFrom = "",
				validUntil = ""
			}
		}
	};
	var VeriffResponse = JsonConvert.DeserializeAnonymousType(Result, ResponseDefinition);
	if (VeriffResponse.status != "success")
	{
		throw new Exception();
	}
	if (VeriffResponse.verification != null)
	{
		bool DL = VeriffResponse.verification.document != null && (VeriffResponse.verification.document.type == "DRIVERS_LICENCE");
		string Status = DL ? VeriffResponse.verification.status : "invalid_document";
		string Reason = DL ? VeriffResponse.verification.reason : "Document must be Driver License";
		{
			string Query = "";
			if (VeriffResponse.verification.code == 9001 && DL)
				Query = String.Format("exec sp_users_update @user_id={0}, @status={1}, @birth_date = {2}, " +
					"@document_number = {3}, @document_type = 3, @document_country = {4}, @document_valid_from = {5}, @document_valid_until = {6}",
					UserId, Quote(Status), Quote(VeriffResponse.verification.person.dateOfBirth),
					Quote(VeriffResponse.verification.document.number), Quote(VeriffResponse.verification.document.country),
					Quote(VeriffResponse.verification.document.validFrom), Quote(VeriffResponse.verification.document.validUntil));
			else
				Query = String.Format("exec sp_users_update @user_id={0}, @status={1}",
					UserId,
					Quote(Status));
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
		}
		{
			string Query = String.Format("exec sp_sessions_update @session_id={0}, @status={1}, @reason={2}",
				Quote(VeriffResponse.verification.id), Quote(Status), Quote(Reason)
				);
			var Command = new SqlCommand(Query, Connection);
			Command.ExecuteNonQuery();
		}
	}
	Response.Write(Result);
	Connection.Close();
%>