package com.zoo.dao;

import com.zoo.model.Animal;
import com.zoo.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AnimalDAO {

    public List<Animal> getAllAnimals() throws SQLException {

        List<Animal> animals = new ArrayList<>();

        String sql = "SELECT animal_id, name, species, gender, age, "
                + "health_status, enclosure_id FROM animals ORDER BY animal_id";

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery()
        ) {

            while (resultSet.next()) {

                Animal animal = new Animal();

                animal.setAnimalId(resultSet.getInt("animal_id"));
                animal.setName(resultSet.getString("name"));
                animal.setSpecies(resultSet.getString("species"));
                animal.setGender(resultSet.getString("gender"));
                animal.setAge(resultSet.getInt("age"));
                animal.setHealthStatus(
                    resultSet.getString("health_status")
                );
                animal.setEnclosureId(
                    resultSet.getInt("enclosure_id")
                );

                animals.add(animal);
            }

        }

        return animals;
    }

    public long countAnimals() throws SQLException {
        String sql = "SELECT COUNT(*) FROM animals";

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql);
            ResultSet resultSet = statement.executeQuery()
        ) {
            resultSet.next();
            return resultSet.getLong(1);
        }
    }

    public void addAnimal(Animal animal) throws SQLException {
        String sql = "INSERT INTO animals "
                + "(name, species, gender, age, health_status, enclosure_id) "
                + "VALUES (?, ?, ?, ?, ?, ?)";

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            setAnimalValues(statement, animal);
            statement.executeUpdate();
        }
    }

    public boolean updateAnimal(Animal animal) throws SQLException {
        String sql = "UPDATE animals SET name = ?, species = ?, gender = ?, "
                + "age = ?, health_status = ?, enclosure_id = ? "
                + "WHERE animal_id = ?";

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            setAnimalValues(statement, animal);
            statement.setInt(7, animal.getAnimalId());
            return statement.executeUpdate() == 1;
        }
    }

    public boolean deleteAnimal(int animalId) throws SQLException {
        String sql = "DELETE FROM animals WHERE animal_id = ?";

        try (
            Connection connection = DBConnection.getConnection();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, animalId);
            return statement.executeUpdate() == 1;
        }
    }

    private void setAnimalValues(
            PreparedStatement statement,
            Animal animal) throws SQLException {
        statement.setString(1, animal.getName());
        statement.setString(2, animal.getSpecies());
        statement.setString(3, animal.getGender());
        statement.setInt(4, animal.getAge());
        statement.setString(5, animal.getHealthStatus());
        statement.setInt(6, animal.getEnclosureId());
    }
}