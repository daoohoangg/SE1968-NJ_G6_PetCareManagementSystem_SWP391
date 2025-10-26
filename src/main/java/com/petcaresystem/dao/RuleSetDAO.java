package com.petcaresystem.dao;

import com.petcaresystem.enities.RuleSet;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.Collections;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RuleSetDAO {

    private static final Logger LOGGER = Logger.getLogger(RuleSetDAO.class.getName());

    public List<RuleSet> getAllRuleSets() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.createQuery("FROM RuleSet ORDER BY ownerType, ownerId", RuleSet.class).list();
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load rule sets", ex);
            return Collections.emptyList();
        }
    }

    public RuleSet getRuleSetById(Long ruleSetId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            return session.get(RuleSet.class, ruleSetId);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load rule set by ID", ex);
            return null;
        }
    }

    public RuleSet getRuleSetByOwner(String ownerType, Long ownerId) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<RuleSet> query = session.createQuery(
                    "FROM RuleSet WHERE ownerType = :ownerType AND ownerId = :ownerId", 
                    RuleSet.class
            );
            query.setParameter("ownerType", ownerType);
            query.setParameter("ownerId", ownerId);
            RuleSet result = query.uniqueResult();
            
            // Force initialization of the collection to avoid lazy loading issues
            if (result != null && result.getWeeklySchedule() != null) {
                result.getWeeklySchedule().getDays().size(); // Force load
            }
            
            return result;
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to load rule set by owner", ex);
            return null;
        }
    }

    public boolean createRuleSet(RuleSet ruleSet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.persist(ruleSet);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            LOGGER.log(Level.SEVERE, "Failed to create rule set", e);
            return false;
        }
    }

    public boolean updateRuleSet(RuleSet ruleSet) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.merge(ruleSet);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            LOGGER.log(Level.SEVERE, "Failed to update rule set", e);
            return false;
        }
    }

    public boolean deleteRuleSet(Long ruleSetId) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            RuleSet ruleSet = session.get(RuleSet.class, ruleSetId);
            if (ruleSet != null) {
                session.remove(ruleSet);
                tx.commit();
                return true;
            }
            return false;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            LOGGER.log(Level.SEVERE, "Failed to delete rule set", e);
            return false;
        }
    }
}
