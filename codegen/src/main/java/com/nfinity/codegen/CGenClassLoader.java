package com.nfinity.codegen;

import java.io.*;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.nio.file.*;
import java.nio.file.attribute.BasicFileAttributes;
import java.util.*;
import java.util.jar.*;
import javax.persistence.*;

public class CGenClassLoader extends ClassLoader {
    public static Map<String, String> retrieveClasses(Path rootDir, String packageName) throws IOException {
        // ArrayList<String> classFiles = new ArrayList<String>();
        Map<String, String> classFiles = new HashMap<String, String>();
        String packagePath = packageName == null ? "" : packageName.replace('.', '/');
        Files.walkFileTree(rootDir, new SimpleFileVisitor<Path>() {
            @Override
            public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {

                // Files.delete(file);
                String filePath = file.toString();
                if (filePath.endsWith(".class")
                        && (packagePath == null || packagePath.isEmpty() || filePath.contains(packagePath))) {

                    String qalifiedName = packagePath.isEmpty() ? filePath.replace(rootDir + "/", "")
                            : filePath.substring(filePath.indexOf(packagePath));
                    qalifiedName = qalifiedName.replace(".class", "").replace("/", ".");
                    classFiles.put(qalifiedName, filePath);
                    // classFiles.add(file.toString());
                }
                System.out.println("Processing file:" + file);
                return FileVisitResult.CONTINUE;
            }

            @Override
            public FileVisitResult postVisitDirectory(Path dir, IOException exc) throws IOException {

                // Files.delete(dir);
                return FileVisitResult.CONTINUE;
            }
        });
        return classFiles;
    }

    URLClassLoader classLoader;
    String path = ".";
    String packageName = "";

    public CGenClassLoader(String path) {
        this.path = path;
        // this.packageName= packageName;
        try {
            URL url = new URL("file:///" + path);
            classLoader = new URLClassLoader(new URL[] { url });
        } catch (MalformedURLException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    @Override
    public Class<?> findClass(String qualifiedClassName) throws ClassNotFoundException {
        File d = new File(this.path);
        URL url;
        try {
            url = d.toURI().toURL();
            ClassLoader cld = new URLClassLoader(new URL[] { url });
            Class<?> loadedClass = cld.loadClass(qualifiedClassName);
            return loadedClass;
        } catch (MalformedURLException e) {

            e.printStackTrace();
        }
        return null;
    }

    public ArrayList<Class<?>> findClasses(String packageName) throws ClassNotFoundException {

        File d = new File(this.path);
        try {
            URL url = d.toURI().toURL();

            Map<String, String> classFiles;
            ClassLoader cld;
            if (this.path.endsWith(".jar")) {
                classFiles = this.findClassesFromJar(packageName);
                // cld = new URLClassLoader(new URL[]{url});// URLClassLoader.newInstance(new
                // URL[]{url});
            } else {
                url = d.toURI().toURL();
                classFiles = CGenClassLoader.retrieveClasses(Paths.get(this.path), packageName);

            }
            ClassLoader context = Thread.currentThread().getContextClassLoader();
            cld = new URLClassLoader(new URL[] { url }, context);
            ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
            // Map<String,String> classFiles=
            // CGenClassLoader.retrieveClasses(Paths.get(this.path), packageName);
            // CGenClassLoader.recursiveList(Paths.get(this.path + "/" +
            // pckgname.replace('.', '/') ));

            // classFiles= CGenClassLoader.retrieveClasses(Paths.get(this.path),null);
            // cld = new URLClassLoader(new URL[]{url});
            for (Map.Entry<String, String> entry : classFiles.entrySet()) {
                // Class<?> cs =
                // cld.loadClass(entry.getKey());//("com.ninfinity.entitycodegen.EntitycodegenApplication");
                Class<?> cs = cld.loadClass(entry.getKey());
                // Class<?> cs = Class.forName(entry.getKey());
                classes.add(cs);
            }
            // ClassLoader cld = Thread.currentThread().getContextClassLoader();

            return classes;
        } catch (NullPointerException x) {
            throw new ClassNotFoundException(
                    packageName + " does not appear to be a valid package (Null pointer exception)");
        } catch (IOException ioex) {
            throw new ClassNotFoundException(
                    "IOException was thrown when trying to get all resources for " + packageName);
        }

    }

    private Map<String, String> findClassesFromJar(String packageName) {
        try {
            // CGenClassLoader loader = new CGenClassLoader(jarPath);
            // ArrayList<Class<?>> list = loader.findClasses("com.ninfinity.entitycodegen");
            // Class<?> cls = loader.findClass(entityName);
            // File file = new File(this.path);
            // URL url = file.toURI().toURL();
            String packagePath = packageName == null ? "" : packageName.replace('.', '/');
            JarFile jarFile = new JarFile(this.path);
            Enumeration e = jarFile.entries();

            URL[] urls = { new URL("jar:file:" + this.path + "!/") };
            URLClassLoader loader = URLClassLoader.newInstance(urls);
            ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
            Map<String, String> classFiles = new HashMap<String, String>();
            String qalifiedName;
            while (e.hasMoreElements()) {
                JarEntry je = (JarEntry) e.nextElement();
                String filePath = je.getName();
                System.out.println("filepath:" + filePath);
                if (je.isDirectory() || (!packagePath.isEmpty() && !filePath.contains(packagePath))
                        || !filePath.endsWith(".class")) {
                    continue;
                }
                // .substring(0,je.getName().length()-6);
                qalifiedName = filePath.indexOf("classes/") > 0 ? filePath.substring(filePath.indexOf("classes/") + 8)
                        : filePath;
                qalifiedName = qalifiedName.replace(".class", "").replace("/", ".");
                qalifiedName = qalifiedName.replace(".class", "").replace("/", ".");
                classFiles.put(qalifiedName, filePath);
                // className = className.replace("!/", ".");
                // className = className.replace('/','.');
                System.out.println(qalifiedName + ":" + filePath);
                // Class<?> c = cl.loadClass(className);
            }
            return classFiles;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }

    }
    /*
     * public Class<?> findClass(String name) throws ClassNotFoundException { byte[]
     * b = loadClassFromFile(name); return defineClass(name, b, 0, b.length); }
     */

    private byte[] loadClassFromFile(String fileName) {
        InputStream inputStream = getClass().getClassLoader()
                .getResourceAsStream(fileName.replace('.', File.separatorChar) + ".class");
        byte[] buffer;
        ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
        int nextValue = 0;
        try {
            while ((nextValue = inputStream.read()) != -1) {
                byteStream.write(nextValue);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        buffer = byteStream.toByteArray();
        return buffer;
    }
}