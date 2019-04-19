package com.nfinity.entitycodegen;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import org.apache.openjpa.jdbc.conf.JDBCConfiguration;
import org.apache.openjpa.jdbc.conf.JDBCConfigurationImpl;
import org.apache.openjpa.jdbc.meta.ReverseMappingTool;
import org.apache.openjpa.lib.util.Options;



public class ReverseMapping {

	static JDBCConfiguration jdbc = new JDBCConfigurationImpl();

	public static void run(String packageName, String directory, String schemaName, Map<String,String> connectionProps)
	{
		//packageName : "com.nfinity.fastcode.model"
		//directory : "src/main/java"
		//tableName : "dbo.users,dbo.roles"
		String schemaKey= schemaName.contains(",")?"-s":"-schema";
		String[] array = {"-pkg", packageName, "-d", directory, schemaKey, schemaName, "-ann","t" };

		try {
			//			 ReverseMappingTool.main(array);
			Options opts = new Options();
			final String[] arguments = opts.setFromCmdLine(array);
			JDBCConfiguration conf = new JDBCConfigurationImpl();
			
			conf.setConnectionURL(connectionProps.get("url"));
			conf.setConnectionUserName(connectionProps.get("username"));
			conf.setConnectionPassword(connectionProps.get("password"));
			conf.setConnectionDriverName("org.postgresql.Driver");
			
			try {
				ReverseMappingTool.run(conf, arguments, opts);
			} finally {
				conf.close();
			}
				

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
