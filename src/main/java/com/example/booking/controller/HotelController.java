package com.example.booking.controller;

import lombok.extern.java.Log;
import lombok.extern.slf4j.Slf4j;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.TreeMap;
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

import com.example.booking.model.City;
import com.example.booking.model.Hotel;
import com.example.booking.repository.CityRepository;
import com.example.booking.repository.HotelRepository;

@Slf4j
@RestController
@RequestMapping("/hotel")
public class HotelController
{
	@Autowired
	HotelRepository hotelRepository;

	@Autowired
	CityRepository cityRepository;

	public final static double AVERAGE_RADIUS_OF_EARTH_KM = 6371;

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
		Hotel model = hotelRepository.findById(hotelId).orElse(null);
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
		hotelRepository.deleteById(hotelId);
		log.info("Hotel Model Deleted By id {}",hotelId);
		return ResponseEntity.status(HttpStatus.OK).body("OK");
	}

	@RequestMapping(
		method = RequestMethod.GET,
		value = "/search/{city_id}/distance"
	)
	public @ResponseBody
	ResponseEntity<Map<Float, Hotel>> searchHotelByCityClosetoCenter(
		@PathVariable(value = "city_id")
			Long cityId
	)
	{
		List<Hotel> hotelList = hotelRepository.findAll();
		City cityById = cityRepository.findById(cityId).orElse(null);
		Map<Float, Hotel> responseMap = new HashMap<>();
		for(int i=0;i<hotelList.size();i++)
		{
			if(hotelList.get(i).getCityId()==cityId)
			{
				Float distanceOfHotelFromCity=calculateDistanceInKilometer(hotelList.get(i).getLatitude(),hotelList.get(i).getLongitude(),cityById.getCityLatitude(),cityById.getCityLongitude());
				responseMap.put(distanceOfHotelFromCity, hotelList.get(i));
			}
		}
		Map<Float, Hotel> hotelsClosestToCity = new TreeMap<Float, Hotel>(responseMap);
		log.info("Hotel Closest to City id {} is {}",cityId,hotelsClosestToCity);
		return ResponseEntity.ok(hotelsClosestToCity);
	}


	public float calculateDistanceInKilometer(double hotelLat, double hotelLong,
		double cityLat, double cityLong)
	{

		double latDistance = Math.toRadians(hotelLat - cityLat);
		double lngDistance = Math.toRadians(hotelLong - cityLong);

		double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
			+ Math.cos(Math.toRadians(hotelLat)) * Math.cos(Math.toRadians(cityLat))
			* Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);

		double finalDistance = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

		return (float) finalDistance;
	}

}

