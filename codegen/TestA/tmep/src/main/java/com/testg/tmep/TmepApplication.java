package com.testg.tmep;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;

@EnableCaching
@SpringBootApplication
public class TmepApplication {

	public static void main(String[] args) {
		SpringApplication.run(TmepApplication.class, args);
	}

}

