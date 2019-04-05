package com.nfinity.entitycodegen;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.JarOutputStream;
import java.util.jar.Manifest;

public class UpdateJar {


	public void updateJarFile(File srcJarFile, String targetPackage, List<String> filesToAdd,String directory) throws IOException {
		File tmpJarFile = File.createTempFile("tempJar", ".tmp");
		JarFile jarFile = new JarFile(srcJarFile);
		targetPackage=targetPackage.replace(".", "/");
		boolean jarUpdated = false;

		try {
			JarOutputStream tempJarOutputStream = new JarOutputStream(new FileOutputStream(tmpJarFile));
			System.out.println("SIze of files " + filesToAdd.size());
			try {
				//Added the new files to the jar.
				for(int i=0; i < filesToAdd.size(); i++) {
					System.out.println("SS " + directory+"/"+targetPackage+"/"+filesToAdd.get(i)+".java");
					File file = new File(directory+"/"+targetPackage+"/"+filesToAdd.get(i) +".java");
					FileInputStream fis = new FileInputStream(file);
					try {
						byte[] buffer = new byte[1024];
						int bytesRead = 0;
						JarEntry entry = new JarEntry(targetPackage+File.separator+file.getName());
						tempJarOutputStream.putNextEntry(entry);
						while((bytesRead = fis.read(buffer)) != -1) {
							tempJarOutputStream.write(buffer, 0, bytesRead);
						}

						//System.out.println(entry.getName() + " added.");
					}
					finally {
						fis.close();
					}
				}

				//Copy original jar file to the temporary one.
				Enumeration jarEntries = jarFile.entries();
				while(jarEntries.hasMoreElements()) {
					JarEntry entry = (JarEntry) jarEntries.nextElement();
					InputStream entryInputStream = jarFile.getInputStream(entry);
					tempJarOutputStream.putNextEntry(entry);
					byte[] buffer = new byte[1024];
					int bytesRead = 0;
					while ((bytesRead = entryInputStream.read(buffer)) != -1) {
						tempJarOutputStream.write(buffer, 0, bytesRead);
					}
				}

				jarUpdated = true;
			}
			catch(Exception ex) {
				ex.printStackTrace();
				tempJarOutputStream.putNextEntry(new JarEntry("stub"));
			}
			finally {
				tempJarOutputStream.close();
			}

		}
		finally {
			jarFile.close();
			//System.out.println(srcJarFile.getAbsolutePath() + " closed.");

			if (!jarUpdated) {
				tmpJarFile.delete();
			}
		}

		if (jarUpdated) {
			srcJarFile.delete();
			tmpJarFile.renameTo(srcJarFile);
			System.out.println(srcJarFile.getAbsolutePath() + " updated.");
		}
	}

	public void updateJar(String jarName,String fileName) throws IOException {
		// Get the jar name and entry name from the command-line.

		//String jarName = args[0];
		//String fileName = args[1];

		// Create file descriptors for the jar and a temp jar.

		File jarFile = new File(jarName);
		File tempJarFile = new File(jarName + ".tmp");

		// Open the jar file.

		JarFile jar = new JarFile(jarFile);
		System.out.println(jarName + " opened.");

		// Initialize a flag that will indicate that the jar was updated.

		boolean jarUpdated = false;

		try {
			// Create a temp jar file with no manifest. (The manifest will
			// be copied when the entries are copied.)

			Manifest jarManifest = jar.getManifest();
			JarOutputStream tempJar =
					new JarOutputStream(new FileOutputStream(tempJarFile));

			// Allocate a buffer for reading entry data.

			byte[] buffer = new byte[1024];
			int bytesRead;

			try {
				// Open the given file.

				FileInputStream file = new FileInputStream(fileName);

				try {
					// Create a jar entry and add it to the temp jar.

					JarEntry entry = new JarEntry(fileName);
					tempJar.putNextEntry(entry);

					// Read the file and write it to the jar.

					while ((bytesRead = file.read(buffer)) != -1) {
						tempJar.write(buffer, 0, bytesRead);
					}

					System.out.println(entry.getName() + " added.");
				}
				finally {
					file.close();
				}

				// Loop through the jar entries and add them to the temp jar,
				// skipping the entry that was added to the temp jar already.

				for (Enumeration entries = jar.entries(); entries.hasMoreElements(); ) {
					// Get the next entry.

					JarEntry entry = (JarEntry) entries.nextElement();

					// If the entry has not been added already, add it.

					if (! entry.getName().equals(fileName)) {
						// Get an input stream for the entry.

						InputStream entryStream = jar.getInputStream(entry);

						// Read the entry and write it to the temp jar.

						tempJar.putNextEntry(entry);

						while ((bytesRead = entryStream.read(buffer)) != -1) {
							tempJar.write(buffer, 0, bytesRead);
						}
					}
				}

				jarUpdated = true;
			}
			catch (Exception ex) {
				System.out.println(ex);

				// Add a stub entry here, so that the jar will close without an
				// exception.

				tempJar.putNextEntry(new JarEntry("stub"));
			}
			finally {
				tempJar.close();
			}
		}
		finally {
			jar.close();
			System.out.println(jarName + " closed.");

			// If the jar was not updated, delete the temp jar file.

			if (! jarUpdated) {
				tempJarFile.delete();
			}
		}

		// If the jar was updated, delete the original jar file and rename the
		// temp jar file to the original name.

		if (jarUpdated) {
			jarFile.delete();
			tempJarFile.renameTo(jarFile);
			System.out.println(jarName + " updated.");
		}
	}

}