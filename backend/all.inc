<%@ Page Language="C#" Debug="true" validateRequest="false" Async="true" %>
<%@ Import Namespace="Newtonsoft.Json" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Net" %>
<%@ Import Namespace="System.Net.Http" %>
<%@ Import Namespace="System.Net.Http.Headers" %>
<%@ Import Namespace="System.Security.Cryptography" %>
<%@ Import Namespace="System.Text" %>
<%@ Import Namespace="System.Threading.Tasks" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Xml" %>
<script runat="Server">

	string Quote(string S)
	{
		return "'"+ S.Replace("'", "''") + "'";
	}

	string TimeStamp()
	{
		DateTime d = DateTime.UtcNow;
		return (d.ToString("yyyy-MM-dd'T'HH:mm:ss.fffK", CultureInfo.InvariantCulture));
	}

	string GenerateSignature(string Payload, string Secret)
	{
		var Builder = new StringBuilder();
		using (SHA256 SHA = SHA256.Create())
		{
			byte[] Data = SHA.ComputeHash(Encoding.UTF8.GetBytes(Payload + Secret));
			for (int i = 0; i < Data.Length; i++)
			{
				Builder.Append(Data[i].ToString("x2"));
			}
		}
		return (Builder.ToString());
	}

	string FileToBase64(string FileName)
	{
		var InputFileStream = new FileStream(Server.MapPath("upload\\"+FileName), FileMode.Open, FileAccess.Read);
		var Base64Transform = new ToBase64Transform();
		byte[] InputData = new byte[InputFileStream.Length];
		InputFileStream.Read(InputData, 0, InputData.Length);
		InputFileStream.Close();
		return (Convert.ToBase64String(InputData, 0, InputData.Length, Base64FormattingOptions.None));
	}

	async Task<string> CallVeriffApi(HttpRequestMessage Message)
	{
		string VeriffResponse = "";
		try
		{
			using (HttpClient Client = new HttpClient())
			{
				HttpResponseMessage Result;
				Result = await Client.SendAsync(Message);
				Result.EnsureSuccessStatusCode();
				VeriffResponse = await Result.Content.ReadAsStringAsync();
			}
		}
		catch {}
		return (VeriffResponse);
	}

</script>
<%
	HttpContext Context = HttpContext.Current;
	SqlConnection Connection = new SqlConnection((string)Application["ConnectionString"]);
	Connection.Open();

	string API_KEY = (string)Application["API_KEY"];
	string API_SECRET = (string)Application["API_SECRET"];
	string API_URL = "https://api.veriff.me/v1";

	int UserId = 0;
	string UserFirstName = "", UserLastName = "";
	if (Session["UserId"] != null)
	{
		UserId = (int)Session["UserId"];
		UserFirstName = (string)Session["UserFirstName"];
		UserLastName = (string)Session["UserLastName"];
	}
%>
