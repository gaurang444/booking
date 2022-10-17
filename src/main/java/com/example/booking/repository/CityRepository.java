package com.example.booking.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.booking.model.City;

@Repository
public interface CityRepository extends JpaRepository<City, Long>
{

}
