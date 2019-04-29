<!-- #include file="all.inc" -->
<%
	Response.Clear();
	if (Request.HttpMethod != "POST")
	{
		Response.Status = "400 Bad Request";
		Response.StatusCode = 400;
		Response.End();
	}
	if (Request.Files.Count != 1)
	{
		Response.Status = "501 Not Implemented";
		Response.StatusCode = 501;
		Response.Write("<h1>501 Not Implemented</h1><p>Only one file per request allowed</p>");
		Response.End();
	}
	try
	{
		string FileId = Guid.NewGuid().ToString();
		HttpPostedFile ImageFile = Request.Files.Get(0);
		Int32 i = ImageFile.FileName.LastIndexOf(".");
		string ext = ".jpg";
		if (i != -1)
			ext = ImageFile.FileName.Substring(i);
		string FileName = Server.MapPath("upload\\"+FileId+ext);
		ImageFile.SaveAs(FileName);
		Response.Write(FileId+ext);
	}
	catch
	{
		Response.Status = "500 Internal Server Error";
		Response.StatusCode = 500;
		Response.Write("<h1>500 Internal Server Error</h1><p>Error on file save.</p>");
	}

	Response.End();
%>