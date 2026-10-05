package com.zoo.model;

public class Animal {

    private int animalId;
    private String name;
    private String species;
    private String gender;
    private int age;
    private String healthStatus;
    private int enclosureId;

    public Animal() {
    }

    public Animal(int animalId, String name, String species,
                  String gender, int age, String healthStatus,
                  int enclosureId) {

        this.animalId = animalId;
        this.name = name;
        this.species = species;
        this.gender = gender;
        this.age = age;
        this.healthStatus = healthStatus;
        this.enclosureId = enclosureId;
    }

    public int getAnimalId() {
        return animalId;
    }

    public void setAnimalId(int animalId) {
        this.animalId = animalId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSpecies() {
        return species;
    }

    public void setSpecies(String species) {
        this.species = species;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getHealthStatus() {
        return healthStatus;
    }

    public void setHealthStatus(String healthStatus) {
        this.healthStatus = healthStatus;
    }

    public int getEnclosureId() {
        return enclosureId;
    }

    public void setEnclosureId(int enclosureId) {
        this.enclosureId = enclosureId;
    }
}