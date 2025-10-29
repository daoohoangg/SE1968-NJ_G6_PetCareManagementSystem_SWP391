package com.petcaresystem.dao;

import com.petcaresystem.enities.AiData;
import com.petcaresystem.utils.HibernateUtil;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.util.List;
import java.util.Optional;

public class AiDataDAO {
    
    /**
     * Save or update AI data
     */
    public boolean saveOrUpdate(AiData aiData) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            session.saveOrUpdate(aiData);
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Find AI data by ID
     */
    public Optional<AiData> findById(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            AiData aiData = session.get(AiData.class, id);
            return Optional.ofNullable(aiData);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    
    /**
     * Find all AI data
     */
    public List<AiData> findAll() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AiData> query = session.createQuery("FROM AiData ORDER BY id", AiData.class);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * Find AI data by creativity level
     */
    public List<AiData> findByCreativityLevel(int creativityLevel) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AiData> query = session.createQuery(
                "FROM AiData WHERE creativityLevel = :level ORDER BY id", 
                AiData.class
            );
            query.setParameter("level", creativityLevel);
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * Find AI data by prompt content (case insensitive search)
     */
    public List<AiData> findByPromptContaining(String prompt) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AiData> query = session.createQuery(
                "FROM AiData WHERE LOWER(prompt) LIKE LOWER(:prompt) ORDER BY id", 
                AiData.class
            );
            query.setParameter("prompt", "%" + prompt + "%");
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return List.of();
        }
    }
    
    /**
     * Get the first AI data (for default configuration)
     */
    public Optional<AiData> getFirst() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AiData> query = session.createQuery(
                "FROM AiData ORDER BY id", 
                AiData.class
            );
            query.setMaxResults(1);
            AiData aiData = query.uniqueResult();
            return Optional.ofNullable(aiData);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    
    /**
     * Get the most recent AI data
     */
    public Optional<AiData> getLatest() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<AiData> query = session.createQuery(
                "FROM AiData ORDER BY id DESC", 
                AiData.class
            );
            query.setMaxResults(1);
            AiData aiData = query.uniqueResult();
            return Optional.ofNullable(aiData);
        } catch (Exception e) {
            e.printStackTrace();
            return Optional.empty();
        }
    }
    
    /**
     * Delete AI data by ID
     */
    public boolean deleteById(Long id) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            
            AiData aiData = session.get(AiData.class, id);
            if (aiData != null) {
                session.delete(aiData);
            }
            
            tx.commit();
            return true;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Get total count of AI data
     */
    public long getTotalCount() {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(*) FROM AiData", 
                Long.class
            );
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }
    
    /**
     * Get count by creativity level
     */
    public long getCountByCreativityLevel(int creativityLevel) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(*) FROM AiData WHERE creativityLevel = :level", 
                Long.class
            );
            query.setParameter("level", creativityLevel);
            return query.uniqueResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0L;
        }
    }
    
    /**
     * Check if AI data exists
     */
    public boolean exists(Long id) {
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            Query<Long> query = session.createQuery(
                "SELECT COUNT(*) FROM AiData WHERE id = :id", 
                Long.class
            );
            query.setParameter("id", id);
            return query.uniqueResult() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update only the prompt content
     */
    public boolean updatePrompt(Long id, String newPrompt) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            
            Query<?> query = session.createQuery(
                "UPDATE AiData SET prompt = :prompt WHERE id = :id"
            );
            query.setParameter("prompt", newPrompt);
            query.setParameter("id", id);
            
            int updatedRows = query.executeUpdate();
            tx.commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update only the creativity level
     */
    public boolean updateCreativityLevel(Long id, int newCreativityLevel) {
        Transaction tx = null;
        try (Session session = HibernateUtil.getSessionFactory().openSession()) {
            tx = session.beginTransaction();
            
            Query<?> query = session.createQuery(
                "UPDATE AiData SET creativityLevel = :level WHERE id = :id"
            );
            query.setParameter("level", newCreativityLevel);
            query.setParameter("id", id);
            
            int updatedRows = query.executeUpdate();
            tx.commit();
            return updatedRows > 0;
        } catch (Exception e) {
            if (tx != null) {
                tx.rollback();
            }
            e.printStackTrace();
            return false;
        }
    }
}

