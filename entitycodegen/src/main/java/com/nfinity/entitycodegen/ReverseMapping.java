package com.nfinity.entitycodegen;

import java.io.IOException;
import java.sql.SQLException;

import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;


public class ReverseMapping {

	 static JDBCConfiguration jdbc = new JDBCConfigurationImpl();
	 
	 public static void run(String packageName, String directory, String schemaName)
	 {
		 //packageName : "com.nfinity.fastcode.model"
		 //directory : "src/main/java"
		 //tableName : "dbo.users,dbo.roles"
		 
		 String[] array = {"-pkg", packageName, "-d", directory, "-schema", schemaName, "-ann","t" };
		 
		 try {
			 ReverseMappingTool.main(array);
		
			System.out.println(" Generating resources ... ");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	 }
	
}
