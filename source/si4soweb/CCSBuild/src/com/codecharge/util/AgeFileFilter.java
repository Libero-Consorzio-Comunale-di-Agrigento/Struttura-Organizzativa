//AgeFileFilter class @0-5C60EAD4
package com.codecharge.util;

import java.io.File;
import java.io.FileFilter;
import java.util.Date;

public class AgeFileFilter implements FileFilter {

    private long maxAge;
    
    public AgeFileFilter(long maxAge) {
        this.maxAge = maxAge;
    }
    
    public boolean accept(File file) {
        return (file != null && file.isFile() && file.lastModified() + maxAge < new Date().getTime());
    }

}

//End AgeFileFilter class

