package com.sena.cafetinapp.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sena.cafetinapp.model.Rol;

import jakarta.persistence.criteria.CriteriaBuilder.In;

public interface RolRepository extends JpaRepository<Rol, Integer>{


    boolean existsByName(String name);

}
