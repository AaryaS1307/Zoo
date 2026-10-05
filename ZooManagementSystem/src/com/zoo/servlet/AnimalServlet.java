package com.zoo.servlet;

import com.zoo.dao.AnimalDAO;
import com.zoo.model.Animal;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/animals")
public class AnimalServlet extends HttpServlet {

    private static final Logger LOGGER =
            Logger.getLogger(AnimalServlet.class.getName());
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

        renderPage(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            String action = requiredParameter(request, "action");

            if ("add".equals(action)) {
                animalDAO.addAnimal(readAnimal(request, 0));
                response.sendRedirect(request.getContextPath()
                        + "/animals?status=created");
            } else if ("update".equals(action)) {
                Animal animal = readAnimal(
                        request, parsePositiveInt(request, "animalId"));
                if (animalDAO.updateAnimal(animal)) {
                    response.sendRedirect(request.getContextPath()
                            + "/animals?status=updated");
                } else {
                    showError(request, response, "Animal record was not found.");
                }
            } else if ("delete".equals(action)) {
                int animalId = parsePositiveInt(request, "animalId");
                if (animalDAO.deleteAnimal(animalId)) {
                    response.sendRedirect(request.getContextPath()
                            + "/animals?status=deleted");
                } else {
                    showError(request, response, "Animal record was not found.");
                }
            } else {
                showError(request, response, "Choose a valid animal action.");
            }
        } catch (IllegalArgumentException e) {
            showError(request, response, e.getMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to save animal record", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            showError(request, response,
                    "Could not save the animal. Check the database connection and schema.");
        }
    }

    private void renderPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<Animal> animals = animalDAO.getAllAnimals();
            request.setAttribute("animals", animals);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Unable to load animal records", e);
            request.setAttribute("errorMessage",
                    "Could not load animals. Check the database connection and schema.");
        }

        request.getRequestDispatcher("/animals.jsp").forward(request, response);
    }

    private void showError(
            HttpServletRequest request,
            HttpServletResponse response,
            String message)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", message);
        renderPage(request, response);
    }

    private Animal readAnimal(HttpServletRequest request, int animalId) {
        Animal animal = new Animal();
        animal.setAnimalId(animalId);
        animal.setName(requiredParameter(request, "name"));
        animal.setSpecies(requiredParameter(request, "species"));
        animal.setGender(requiredParameter(request, "gender"));
        animal.setAge(parseNonNegativeInt(request, "age"));
        animal.setHealthStatus(requiredParameter(request, "healthStatus"));
        animal.setEnclosureId(parseNonNegativeInt(request, "enclosureId"));
        return animal;
    }

    private String requiredParameter(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException("Please complete all animal fields.");
        }
        return value.trim();
    }

    private int parseNonNegativeInt(HttpServletRequest request, String name) {
        try {
            int value = Integer.parseInt(requiredParameter(request, name));
            if (value < 0) {
                throw new IllegalArgumentException(
                        "Age and enclosure ID must be zero or greater.");
            }
            return value;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Age and enclosure ID must be whole numbers.");
        }
    }

    private int parsePositiveInt(HttpServletRequest request, String name) {
        int value = parseNonNegativeInt(request, name);
        if (value == 0) {
            throw new IllegalArgumentException("Animal ID must be greater than zero.");
        }
        return value;
    }
}