package com.example.booking.controller;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;


@RestController
public class HealthController
{
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
		value = "/health12",
		method = RequestMethod.GET,
		produces = MediaType.APPLICATION_JSON_VALUE
	)
	public ResponseEntity<String> health1()
	{
		return new ResponseEntity<>("{\"status\" : \"UP\"}", HttpStatus.OK);
	}

}
