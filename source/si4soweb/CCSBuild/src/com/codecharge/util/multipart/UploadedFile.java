//UploadedFile class @0-A41B083C
package com.codecharge.util.multipart;

import java.io.File;
import java.util.Vector;
import java.util.Enumeration;

public class UploadedFile {
    private String name;
    private String originalName;
    private String temporaryName;
    private File file;
    private byte[] content;
    private long size;
    private Vector errors = new Vector();
    
    public UploadedFile( String name, byte[] content ) {
        this.name = name;
        this.content = content;
    }
    
    public UploadedFile( String name, File file ) {
        this.file = file;
        this.name = name;
        this.temporaryName = file.getName();
    }
    
    public String getName() {
        return name;
    }
    
    public byte[] getContent() {
        if (temporaryName == null) {
            return content;
        } else {
            //TODO:
            //not implemented yet
            return null;
        }
    }
    
    public File getFile() {
        return file;
    }
    
    public String getOriginalName() {
        return originalName;
    }
    
    public void setOriginalName(String originalName) {
        this.originalName = originalName;
    }
    
    public long getSize() {
        return content == null ? size : content.length;
    }
    
    public void setSize(long size) {
        this.size = size;
    }
    
    public boolean hasErrors() {
        return (errors.size() > 0); 
    }
    
    public Enumeration getErrors() {
        return errors.elements();
    }
    
    public void addError(String messageKey) {
        if (messageKey!=null) {
            errors.add(messageKey);
        }
    }
}

//End UploadedFile class

