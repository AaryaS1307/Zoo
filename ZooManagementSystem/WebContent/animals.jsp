<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.zoo.model.Animal" %>

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

    <title>Animal Management</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .main-content {
            margin-left: 250px;
            width: calc(100% - 250px);
            padding: 30px;
        }

        .page-heading {
            margin-bottom: 24px;
        }

        .table-container {
            background: white;
            padding: 24px;
            border-radius: 12px;
            overflow-x: auto;
        }

        .animal-table {
            width: 100%;
            border-collapse: collapse;
        }

        .animal-table th,
        .animal-table td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .animal-table th {
            background: #f5f7f6;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 15px;
            background: #e5f5e9;
            color: #24743a;
        }

        .animal-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 12px;
            align-items: end;
        }

        .animal-form label {
            display: grid;
            gap: 6px;
            font-weight: 600;
        }

        .animal-form input {
            box-sizing: border-box;
            width: 100%;
            padding: 9px;
            border: 1px solid #ccd4cf;
            border-radius: 6px;
        }

        .animal-form button,
        .row-actions button {
            border: 0;
            border-radius: 6px;
            padding: 10px 14px;
            cursor: pointer;
        }

        .animal-form button,
        .row-actions .update-button {
            background: #24743a;
            color: white;
        }

        .row-actions .delete-button {
            background: #a93226;
            color: white;
        }

        .row-actions {
            display: flex;
            gap: 8px;
        }

        .notice {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
        }

        .notice.error {
            background: #fdecea;
            color: #8a241d;
        }

        .notice.success {
            background: #e5f5e9;
            color: #24743a;
        }

        @media (max-width: 900px) {
            .main-content {
                margin-left: 200px;
                width: calc(100% - 200px);
            }
        }

        @media (max-width: 600px) {
            .main-content {
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
        <li><a href="${pageContext.request.contextPath}/index.jsp">Health Records</a></li>
        <li><a href="${pageContext.request.contextPath}/feeding">Feeding</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp">Visitors</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp">Tickets</a></li>
        <li><a href="${pageContext.request.contextPath}/index.jsp">Reports</a></li>
    </ul>

</div>

<div class="main-content">

    <div class="topbar">
        <h2>Animal Management</h2>
        <span>Administrator</span>
    </div>

    <div class="page-heading">
        <h2>Animal Records</h2>
        <p>Add, update, and remove animals registered in the zoo database.</p>
    </div>

    <div class="table-container">
        <%
            String errorMessage = (String) request.getAttribute("errorMessage");
            String status = request.getParameter("status");
            String statusMessage = null;
            if ("created".equals(status)) {
                statusMessage = "Animal added successfully.";
            } else if ("updated".equals(status)) {
                statusMessage = "Animal updated successfully.";
            } else if ("deleted".equals(status)) {
                statusMessage = "Animal deleted successfully.";
            }
        %>

        <% if (errorMessage != null) { %>
            <p class="notice error"><%= errorMessage %></p>
        <% } else if (statusMessage != null) { %>
            <p class="notice success"><%= statusMessage %></p>
        <% } %>

        <h3>Add an animal</h3>
        <form class="animal-form" action="${pageContext.request.contextPath}/animals" method="post">
            <input type="hidden" name="action" value="add">
            <label>Name <input name="name" maxlength="100" required></label>
            <label>Species <input name="species" maxlength="100" required></label>
            <label>Gender <input name="gender" maxlength="30" required></label>
            <label>Age <input name="age" type="number" min="0" step="1" required></label>
            <label>Health status <input name="healthStatus" maxlength="100" required></label>
            <label>Enclosure ID <input name="enclosureId" type="number" min="0" step="1" required></label>
            <button type="submit">Add animal</button>
        </form>

        <hr>
        <h3>Animal records</h3>
        <%
            List<Animal> animals =
                (List<Animal>) request.getAttribute("animals");
        %>

        <% if (animals == null) { %>
            <p>Animal records are unavailable until the database connection succeeds.</p>
        <% } else if (animals.isEmpty()) { %>

            <p>No animal records found.</p>

        <% } else { %>

        <table class="animal-table">

            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Species</th>
                    <th>Gender</th>
                    <th>Age</th>
                    <th>Health Status</th>
                    <th>Enclosure ID</th>
                    <th>Actions</th>
                </tr>
            </thead>

            <tbody>

            <% for (Animal animal : animals) { %>

                <tr>
                    <td>
                        <%= animal.getAnimalId() %>
                        <form id="update-<%= animal.getAnimalId() %>"
                              action="${pageContext.request.contextPath}/animals" method="post">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="animalId"
                                   value="<%= animal.getAnimalId() %>">
                        </form>
                    </td>
                    <td><input form="update-<%= animal.getAnimalId() %>"
                               name="name" value="<%= escapeHtml(animal.getName()) %>" required></td>
                    <td><input form="update-<%= animal.getAnimalId() %>"
                               name="species" value="<%= escapeHtml(animal.getSpecies()) %>" required></td>
                    <td><input form="update-<%= animal.getAnimalId() %>"
                               name="gender" value="<%= escapeHtml(animal.getGender()) %>" required></td>
                    <td><input name="age" type="number" min="0" step="1"
                               form="update-<%= animal.getAnimalId() %>"
                               value="<%= animal.getAge() %>" required></td>
                    <td>
                        <input form="update-<%= animal.getAnimalId() %>"
                               name="healthStatus"
                               value="<%= escapeHtml(animal.getHealthStatus()) %>" required>
                    </td>
                    <td><input form="update-<%= animal.getAnimalId() %>"
                               name="enclosureId" type="number" min="0" step="1"
                               value="<%= animal.getEnclosureId() %>" required></td>
                    <td class="row-actions">
                        <button form="update-<%= animal.getAnimalId() %>"
                                class="update-button" type="submit">Save</button>
                        <form action="${pageContext.request.contextPath}/animals" method="post"
                              onsubmit="return confirm('Delete this animal record?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="animalId"
                                   value="<%= animal.getAnimalId() %>">
                            <button class="delete-button" type="submit">Delete</button>
                        </form>
                    </td>
                </tr>

            <% } %>

            </tbody>

        </table>

        <% } %>

    </div>

</div>

</body>
</html>