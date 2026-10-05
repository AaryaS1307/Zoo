package com.zoo.servlet;

import com.zoo.dao.AnimalDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(DashboardServlet.class.getName());
    private AnimalDAO animalDAO;

    @Override
    public void init() {
        animalDAO = new AnimalDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        try {
            request.setAttribute("totalAnimals",
                    animalDAO.countAnimals());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to load dashboard animal count", e);
            request.setAttribute("dashboardError",
                    "Animal totals are unavailable. Check the database connection.");
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
