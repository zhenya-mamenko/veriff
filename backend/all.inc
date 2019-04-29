<%@ Page Language="C#" Debug="true" validateRequest="false" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Collections.Specialized" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Xml" %>
<%
	HttpContext Context = HttpContext.Current;
	SqlConnection Connection = new SqlConnection((string)Application["ConnectionString"]);
	Connection.Open();
	string API_KEY = (string)Application["API_KEY"];
	string API_SECRET = (string)Application["API_SECRET"];
%>