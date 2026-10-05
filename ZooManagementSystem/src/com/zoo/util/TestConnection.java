package com.zoo.util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TestConnection {

    private static final Logger LOGGER =
            Logger.getLogger(TestConnection.class.getName());

    public static void main(String[] args) {
        try (Connection connection = DBConnection.getConnection()) {
            if (connection.isValid(2)) {
                System.out.println("SUCCESS: Zoo database is connected!");
            } else {
                System.out.println("FAILED: Database connection is not valid.");
            }
        } catch (SQLException e) {
            System.out.println("FAILED: Could not connect to database.");
            LOGGER.log(Level.SEVERE, "Database connection test failed", e);
        }
    }
}