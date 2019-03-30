package com.ninfinity.codegen;
import java.io.File;  
import java.lang.reflect.Constructor;  
import java.lang.reflect.InvocationTargetException;  
import java.net.MalformedURLException;  
import java.net.URL;  
import java.net.URI;
import java.net.URLClassLoader;
public class FileUtils {
    public static URL toURL(File file) {
        try {
            return file.toURI().toURL();
        } catch (MalformedURLException e) {
            throw new InternalError(e);
        }
    }
}