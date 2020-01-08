package com.nfinity;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.nfinity.codegen.FolderContentReader;
import com.nfinity.codegen.FreeMarkerConfiguration;

@Configuration
public class BeanConfig {
	
	@Bean
	public static FreeMarkerConfiguration getFreeMarkerConfigBean() {
		return new FreeMarkerConfiguration();
	}
	
	@Bean
	public static FolderContentReader getFolderContentReaderBean() {
		return new FolderContentReader();
	}
	
//	@Bean
//	public static FreeMarkerConfiguration freeMarkerConfig() {
//		return new FreeMarkerConfiguration();
//	}
//	
//	@Bean
//	public static FreeMarkerConfiguration freeMarkerConfig() {
//		return new FreeMarkerConfiguration();
//	}


}
