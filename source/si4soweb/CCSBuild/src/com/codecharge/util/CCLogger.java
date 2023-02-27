//CCLogger class @0-1700624A
package com.codecharge.util;

public class CCLogger {
    
    public static final int DEBUG = 0;
    public static final int INFO = 1;
    public static final int WARN = 2;
    public static final int ERROR = 3;
    public static final int FATAL = 4;

    public static final int NONE = 0;
    public static final int STDOUT = 1;
    public static final int STDERR = 2;
    public static final int FILE = 3;

    private static CCLogger logger;
    private String logFile;
    private int priority;
    private int output;
    private java.text.DateFormat dateFormat;
    private String context = "";
    
    private CCLogger() {
        output = STDERR;
        priority = ERROR;
        dateFormat = new java.text.SimpleDateFormat("dd-MM hh:mm:ss.S");
    }
    
    public static CCLogger getInstance() {
        if ( logger == null )
            logger = new CCLogger();
        return logger;    
    }
    
    public String getLogFile() { 
        return logFile;
    }
    
    public void setLogFile( String logFile ) {
        this.logFile = logFile;
        if ( this.logFile == null || this.logFile.length() == 0 )
            this.output = STDERR;
        else
            this.output = FILE;
    }

    public void setLogFile(int type) {
        output = type;
    }

    public void setPriority(int p) {
        priority = p;
    }

    public void setDateFormat(String pattern) {
        this.dateFormat = new java.text.SimpleDateFormat(pattern);
    }

    public void setDateFormat(java.text.DateFormat format) {
        this.dateFormat = format;
    }

    public void setContextName(String contextName) {
        this.context = contextName;
    }

    public void log( String str ) {
        log( str, null );
    }

    public synchronized void log( String str, Exception e ) {
        String currDate = this.dateFormat.format(new java.util.Date());
        java.io.FileOutputStream flog = null;
        java.io.PrintStream logStream = null;
        switch(output) {
        case STDOUT:
            logStream = System.out;
            break;
        case STDERR:
            logStream = System.err;
            break;
        case FILE:
            try {
                flog = new java.io.FileOutputStream(logFile, true);
                logStream = new java.io.PrintStream(flog);
            } catch (java.io.FileNotFoundException fnfe) {
                System.out.println("CCS logger ("+currDate+") => Unable to create '"+logFile+"' logfile.");  
            }
            break;
        default:
            return;
        }
        if (logStream != null) {
            logStream.println("CCLogger " + this.context + " [" + currDate + "] " + str);
            if (e != null) e.printStackTrace(logStream);
            if (output == FILE) logStream.close();
        }
        try {
            if (flog != null) flog.close();
        } catch (java.io.IOException ioe) {
            System.out.println("CCS logger ("+currDate+") ===> General error."); 
        }
    }

    public void debug(String msg, Exception e) {
        if (priority <= DEBUG) log("DEBUG: " + msg, e);
    }
    public void debug(String msg) {debug(msg, null);}

    public void info(String msg, Exception e) {
        if (priority <= INFO) log("INFO: " + msg, e);
    }
    public void info(String msg) {info(msg, null);}

    public void warn(String msg, Exception e) {
        if (priority <= WARN) log("WARNING: " + msg, e);
    }
    public void warn(String msg) {warn(msg, null);}

    public void error(String msg, Exception e) {
        if (priority <= ERROR) log("ERROR: " + msg, e);
    }
    public void error(String msg) {error(msg, null);}
}
//End CCLogger class

