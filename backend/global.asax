<%@ Application Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Web.Configuration" %>

<script runat="server">

	void Application_Start(Object sender, EventArgs e)
	{
		Application["ConnectionString"] = ConfigurationManager.ConnectionStrings["Veriff"].ConnectionString;
		Application["API_KEY"] = ConfigurationManager.AppSettings["API_KEY"];
		Application["API_SECRET"] = ConfigurationManager.AppSettings["API_SECRET"];
	}

</script>