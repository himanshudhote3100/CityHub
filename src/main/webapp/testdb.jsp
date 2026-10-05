<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.city.dbutil.DBUtil" %>
<!DOCTYPE html>
<html>
<head><title>DB Test</title></head>
<body>
<%
  try (Connection conn = DBUtil.getConnection()) {
      out.println("<h3>Connection Success!</h3>");
      DatabaseMetaData meta = conn.getMetaData();
      ResultSet tables = meta.getTables(null, null, "%", new String[] {"TABLE"});
      out.println("<h4>Tables:</h4><ul>");
      while (tables.next()) {
          out.println("<li>" + tables.getString("TABLE_NAME") + "</li>");
      }
      out.println("</ul>");
  } catch (Exception e) {
      out.println("<h3>Error:</h3><pre>");
      e.printStackTrace(new java.io.PrintWriter(out));
      out.println("</pre>");
  }
%>
</body>
</html>
