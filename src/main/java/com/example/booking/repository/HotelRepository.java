package com.example.booking.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.booking.model.Hotel;

@Repository
public interface HotelRepository extends JpaRepository<Hotel, Long>
{

}
