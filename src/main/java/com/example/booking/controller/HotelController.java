package com.example.booking.controller;

import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import javax.xml.ws.Action;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.booking.model.Hotel;
import com.example.booking.repository.HotelRepository;

@Slf4j
@RestController
@RequestMapping("/hotel")
public class HotelController
{
	@Autowired
	HotelRepository hpr;

	@RequestMapping(
		method = RequestMethod.GET,
		value = "/{hotel_id}"
	)
	public @ResponseBody
	ResponseEntity<Hotel> getHotelById(
		@PathVariable(value = "hotel_id")
			Long hotelId
	)
	{
		Hotel model = hpr.findById(hotelId).orElse(null);
		log.info("Hotel Model By id {} is {}",hotelId,model);
		return ResponseEntity.ok(model);
	}

	@RequestMapping(
		method = RequestMethod.DELETE,
		value = "/{hotel_id}"
	)
	public @ResponseBody
	ResponseEntity<String> deleteHotelById(
		@PathVariable(value = "hotel_id")
			Long hotelId
	)
	{
		hpr.deleteById(hotelId);
		log.info("Hotel Model Deleted By id {}",hotelId);
		return ResponseEntity.status(HttpStatus.OK).body("OK");
	}

	@RequestMapping(
		method = RequestMethod.DELETE,
		value = "/search/{city_id}"
	)
	public @ResponseBody
	ResponseEntity<List<Hotel>> searchHotelByCityClosetoCenter(
		@PathVariable(value = "city_id")
			Long cityId
	)
	{
		List<Hotel> hotelList = hpr.findAll();
		List<Hotel> hotelsByCityId = new ArrayList<>();
		for(int i=0;i<hotelList.size();i++)
		{
			if(hotelList.get(i).getCityId()==cityId)
			{
				hotelsByCityId.add(hotelList.get(i));
			}
		}
		hotelsByCityId.stream().sorted();
		log.info("Hotel Model By City id {} is {}",cityId,hotelsByCityId);
		return ResponseEntity.ok(hotelsByCityId);
	}
}

