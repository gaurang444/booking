package com.example.booking.controller;

import lombok.extern.slf4j.Slf4j;

import javax.xml.ws.Action;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.example.booking.model.City;
import com.example.booking.model.Hotel;
import com.example.booking.repository.CityRepository;
import com.example.booking.repository.HotelRepository;

@Slf4j
@RestController
public class HealthController
{
	@Autowired
	HotelRepository hotelRepository;

	@Autowired
	CityRepository cityRepositorypr;

	@RequestMapping(
		value = "/health",
		method = RequestMethod.GET,
		produces = MediaType.APPLICATION_JSON_VALUE
	)
	public ResponseEntity<String> health()
	{
		return new ResponseEntity<>("{\"status\" : \"UP\"}", HttpStatus.OK);
	}

	@RequestMapping(
		value = "/add-dummy-data",
		method = RequestMethod.GET,
		produces = MediaType.APPLICATION_JSON_VALUE
	)
	public ResponseEntity<String> health12()
	{
		City city=new City("Bangalore", (float) 21.23, (float) 36.23);
		Hotel hotel=new Hotel("oyo-rooms-indiranagar","100feet-road", (float) 67.3, (float) 45.3, 2L);
		cityRepositorypr.save(city);
		hotelRepository.save(hotel);
		return new ResponseEntity<>("{\"status\" : \"UP\"}", HttpStatus.OK);
	}

}
