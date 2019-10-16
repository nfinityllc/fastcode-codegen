package com.nfinity.codegen;

import freemarker.template.Configuration;

public class FreeMarkerConfiguration {
	
	public static Configuration cfg = new Configuration(Configuration.VERSION_2_3_28);
	public static String TEMPLATE_FOLDER = "/templates";
	public static String BACKEND_TEMPLATE_FOLDER = "/templates/backendTemplates";
	public static String DTO_TEMPLATE_FOLDER = "/templates/backendTemplates/Dto";
	public static String CLIENT_ROOT_FOLDER = "/client";
	
	public static void configure()
	{
		
	}

}
