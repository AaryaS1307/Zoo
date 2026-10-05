<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%!
    private String escapeHtml(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= escapeHtml((String) request.getAttribute("pageTitle")) %> | Zoo Manager</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .records-main {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 30px;
        }

        .records-panel {
            margin-top: 24px;
            padding: 24px;
            background: white;
            border-radius: 12px;
            overflow-x: auto;
        }

        .records-panel table {
            min-width: 620px;
        }

        .records-error {
            padding: 12px 16px;
            border-radius: 6px;
            background: #fdecea;
            color: #8a241d;
        }

        @media (max-width: 900px) {
            .records-main {
                margin-left: 200px;
                width: calc(100% - 200px);
            }
        }

        @media (max-width: 600px) {
            .records-main {
                margin-left: 0;
                width: 100%;
            }
        }
    </style>
</head>
<body>
<div class="sidebar">
    <h2>Zoo Manager</h2>
    <ul>
        <li><a href="${pageContext.request.contextPath}/dashboard">Dashboard</a></li>
        <li><a href="${pageContext.request.contextPath}/animals">Animals</a></li>
        <li><a href="${pageContext.request.contextPath}/enclosures">Enclosures</a></li>
        <li><a href="${pageContext.request.contextPath}/staff">Staff</a></li>
        <li><a href="${pageContext.request.contextPath}/feeding">Feeding</a></li>
    </ul>
</div>
<main class="records-main">
    <header class="topbar">
        <div class="page-title"><%= escapeHtml((String) request.getAttribute("pageTitle")) %></div>
        <div class="user">Administrator</div>
    </header>
    <section class="records-panel">
        <h2><%= escapeHtml((String) request.getAttribute("pageTitle")) %> records</h2>
        <% String errorMessage = (String) request.getAttribute("errorMessage"); %>
        <% if (errorMessage != null) { %>
            <p class="records-error"><%= escapeHtml(errorMessage) %></p>
        <% } else { %>
            <%
                List<String> columns = (List<String>) request.getAttribute("columns");
                List<List<String>> records =
                        (List<List<String>>) request.getAttribute("records");
            %>
            <% if (records == null || records.isEmpty()) { %>
                <p>No <%= escapeHtml(((String) request.getAttribute("pageTitle")).toLowerCase()) %> records found.</p>
            <% } else { %>
                <table>
                    <thead>
                        <tr>
                            <% for (String column : columns) { %>
                                <th><%= escapeHtml(column.replace('_', ' ')) %></th>
                            <% } %>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (List<String> record : records) { %>
                            <tr>
                                <% for (String value : record) { %>
                                    <td><%= escapeHtml(value) %></td>
                                <% } %>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
                <p><%= records.size() %> record(s)</p>
            <% } %>
        <% } %>
    </section>
</main>
</body>
</html>
