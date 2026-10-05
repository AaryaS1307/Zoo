package com.zoo.servlet;

import com.zoo.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(urlPatterns = {"/enclosures", "/staff", "/feeding"})
public class ZooRecordsServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(ZooRecordsServlet.class.getName());

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String title;
        String sql;

        if ("/enclosures".equals(path)) {
            title = "Enclosures";
            sql = "SELECT enclosure_id, name, habitat_type, location, "
                    + "capacity, status FROM enclosures ORDER BY enclosure_id";
        } else if ("/staff".equals(path)) {
            title = "Staff";
            sql = "SELECT staff_id, name, role, shift, phone "
                    + "FROM staff ORDER BY staff_id";
        } else if ("/feeding".equals(path)) {
            title = "Feeding";
            sql = "SELECT a.name AS animal, f.food, f.quantity, "
                    + "TIME_FORMAT(f.feeding_time, '%h:%i %p') AS feeding_time, "
                    + "f.notes FROM feeding f "
                    + "JOIN animals a ON a.animal_id = f.animal_id "
                    + "ORDER BY f.feeding_time, a.name";
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        request.setAttribute("pageTitle", title);

        try (Connection connection = DBConnection.getConnection();
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sql)) {
            ResultSetMetaData metadata = resultSet.getMetaData();
            List<String> columns = new ArrayList<>();
            for (int i = 1; i <= metadata.getColumnCount(); i++) {
                columns.add(metadata.getColumnLabel(i));
            }

            List<List<String>> records = new ArrayList<>();
            while (resultSet.next()) {
                List<String> record = new ArrayList<>();
                for (int i = 1; i <= metadata.getColumnCount(); i++) {
                    String value = resultSet.getString(i);
                    record.add(value == null ? "" : value);
                }
                records.add(record);
            }

            request.setAttribute("columns", columns);
            request.setAttribute("records", records);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to load " + title + " records", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.setAttribute("errorMessage",
                    "Could not load " + title.toLowerCase()
                            + ". Check the database setup and connection.");
        }

        request.getRequestDispatcher("/records.jsp").forward(request, response);
    }
}
