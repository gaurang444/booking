package com.example.booking.model;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "city", schema = "bkng_db")
@Getter
@Setter
@ToString
public class City {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(name = "city_name")
	private String cityName;

	@Column(name = "city_latitude")
	private Float cityLatitude;

	@Column(name = "city_longitude")
	private Float cityLongitude;


	public City() {

	}

	public City(String cityName, Float latitude, Float longitude)
	{
		super();
		this.cityLatitude = latitude;
		this.cityName = cityName;
		this.cityLongitude = longitude;
	}
}
