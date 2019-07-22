package com.nfinity.codegen;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.security.CodeSource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;

import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.RegexFileFilter;

public class GetFilesFromFolder {
	
	public static List<String> getFilesFromFolder(String folderPath) {

		try {
			URI uri = FronendBaseTemplateGenerator.class.getResource(folderPath).toURI();
			List<String> list = new ArrayList<String>();
			if (uri.getScheme().equals("jar")) {
				list = getFilesFromJar(folderPath);
			} else {
				Collection<File> files = getFilesFromFileSystem(new File(System.getProperty("user.dir").replace("\\", "/") + "/src/main/resources/"+ folderPath));
				for(File file:files) {
					if(file.isFile())
						list.add(file.getAbsolutePath());
				}
			}
			return list;

		}
		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (URISyntaxException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	private static Collection<File> getFilesFromFileSystem(File path){
		Collection<File> files = org.apache.commons.io.FileUtils.listFilesAndDirs(
				path,
				new RegexFileFilter("^(.*?)"), 
				DirectoryFileFilter.DIRECTORY
				);
		return files;
	}

	private static List<String> getFilesFromJar(String path) throws IOException{
		CodeSource src = FronendBaseTemplateGenerator.class.getProtectionDomain().getCodeSource();
		List<String> list = new ArrayList<String>();
		if( src != null ) {
			java.net.URL jar = src.getLocation();
			ZipInputStream zip = new ZipInputStream( jar.openStream());
			ZipEntry ze = null;

			while( ( ze = zip.getNextEntry() ) != null ) {
				String entryName = ze.getName();
				if( entryName.startsWith("BOOT-INF/classes" + path) && entryName.endsWith(".ftl") ) {
					list.add( entryName );
				}
			}
		}
		return list;
	}

}
