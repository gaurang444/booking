package com.example.booking;

import static org.assertj.core.api.AssertionsForInterfaceTypes.assertThat;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;

import com.example.booking.model.Hotel;
import com.example.booking.repository.HotelRepository;

@SpringBootTest
class BookingApplicationTests {

	@MockBean
	private HotelRepository repository;

	@Test
	void contextLoads() {
	}


}
