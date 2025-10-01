package com.petcaresystem.dao;

import com.petcaresystem.enities.Pet;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;

import java.util.List;

public class PetDAO {
    public List<Pet> getPet() {
        Session session = HibernateUtil.getSessionFactory().openSession();
        List<Pet> pets = session.createQuery("from Pet", Pet.class).list();
        session.close();
        return pets;
    }

    public static void main(String[] args) {
        PetDAO petDAO = new PetDAO();
        List<Pet> pets = petDAO.getPet();
        pets.forEach(System.out::println);
    }
}
