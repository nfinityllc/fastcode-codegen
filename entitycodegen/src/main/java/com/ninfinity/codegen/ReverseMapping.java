package com.ninfinity.codegen;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;
import org.springframework.beans.factory.annotation.Autowired;


public class ReverseMapping {

	 static JDBCConfiguration jdbc = new JDBCConfigurationImpl();
	 
	 static ReverseMappingTool reverse;
	 
	 public static void run(String packageName, String directory, String tableName)
	 {
		 //packageName : "com.nfinity.fastcode.model"
		 //directory : "src/main/java"
		 //tableName : "dbo.users,dbo.roles"
		 
		 String[] as = {"-pkg", packageName, "-d", directory, "-schema", tableName, "-ann","t" };
		 
		// System.out.println("SSS\n" + jdbc.getConnectionURL());
		 reverse= new ReverseMappingTool(jdbc);
		
		
		 try {
			reverse.main(as);
			System.out.println(" Generating resources ... ");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	   //  reverse.run();
	 }
	
}
