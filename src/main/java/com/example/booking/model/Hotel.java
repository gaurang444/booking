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
@Table(name = "hotels", schema = "bkng_db")
@Getter
@Setter
@ToString
public class Hotel {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private long id;

	@Column(name = "hotel_name")
	private String hotelName;

	@Column(name = "latitude")
	private Float latitude;

	@Column(name = "longitude")
	private Float longitude;

	@Column(name = "address")
	private String address;

	@Column(name = "city_id")
	private Long cityId;

	public Hotel() {

	}

	public Hotel(String hotelName, String address, Float latitude, Float longitude,Long city_id)
	{
		super();
		this.hotelName = hotelName;
		this.address = address;
		this.latitude = latitude;
		this.longitude = longitude;
		this.cityId = city_id;
	}
}
