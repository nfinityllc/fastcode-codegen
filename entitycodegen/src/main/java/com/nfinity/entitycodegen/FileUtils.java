package com.nfinity.entitycodegen;
import java.io.File;  
import java.net.MalformedURLException;  
import java.net.URL;  

public class FileUtils {
    public static URL toURL(File file) {
        try {
            return file.toURI().toURL();
        } catch (MalformedURLException e) {
            throw new InternalError(e);
        }
    }
}