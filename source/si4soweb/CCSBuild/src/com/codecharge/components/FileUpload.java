//FileUpload component @0-43996FEA
package com.codecharge.components;

import java.io.FileOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileFilter;
import java.text.SimpleDateFormat;
import java.text.MessageFormat;
import java.util.ResourceBundle;
import java.util.Date;
import java.util.Vector;
import java.util.Enumeration;

import com.codecharge.util.multipart.*;
import com.codecharge.util.*;
import com.codecharge.validation.*;
import com.codecharge.events.Event;
import com.codecharge.events.UploadListener;

/**
 * FileUpload allows user to upload files to the server. Current implementation also supports validation by size and mask.
 */
public class FileUpload extends VerifiableControl {

    private File file;
    private String tempFolder;
    private String procFolder;
    private FileFilter filter;
    //private FileRenamePolicy renamePolicy;
    private String[] state = new String[2];
    private long sizeLimit;
    private boolean required;
    private boolean del = false;
    private ResourceBundle res;
    private String stateKey = "FileUpload";
    private String stateKeySuffix;

    public FileUpload(String name, String fieldSource, Page page) {
        super(name, fieldSource, page);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
    }

    public FileUpload(String name, Page page) {
        super(name, page);
        res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
    }

    /** Set temporary folder to save file to the end of form operations and validation.
        @param folder absolute path to temporary folder. */
    public void setTempFolder(String folder) {
        tempFolder = folder.replace('/',File.separatorChar);
/*        
        File fFolder = new File(folder);
        if (!fFolder.exists()) {
            MessageFormat fmt = new MessageFormat(res.getString("TempFolderNotFound"));
            addError(fmt.format(new String[] {getCaption()}));
            //Utils.printFatalError(fmt.format(new String[] {getCaption(),getCaption()}), page.getResponse());
        } else if (! fFolder.canWrite()) {
            MessageFormat fmt = new MessageFormat(res.getString("InsufficientPermissions"));
            addError(fmt.format(new String[] {getCaption()}));
            //Utils.printFatalError(fmt.format(new String[] {getCaption(),getCaption()}), page.getResponse());
        }
*/        
    }
    /** Get temporary folder to save file to the end of form operations and validation.
        @return absolute path to the temporary folder. */
    public String getTempFolder() {return tempFolder;}

    /** Set folder to save processed file after successful operation.
        @param folder abosulte path to the folder. */
    public void setProcessedFolder(String folder) {
        procFolder = folder.replace('/',File.separatorChar);
        /*
        File fFolder = new File(folder);
        if (!fFolder.exists()) {
            MessageFormat fmt = new MessageFormat(res.getString("FilesFolderNotFound"));
            addError(fmt.format(new String[] {getCaption()}));
            //Utils.printFatalError(fmt.format(new String[] {getCaption(),getCaption()}), page.getResponse());
        } else if (! fFolder.canWrite()) {
            MessageFormat fmt = new MessageFormat(res.getString("InsufficientPermissions"));
            addError(fmt.format(new String[] {getCaption()}));
            //Utils.printFatalError(fmt.format(new String[] {getCaption(),getCaption()}), page.getResponse());
        }
        */
    }
    /** Get folder to save processed file after successful operation.
        @return abosulte path to the folder. */
    public String getProcessedFolder() {return procFolder;}

    /** Set size limit for file validation.
      @param limit size limit. */
    public void setSizeLimit(long limit) {sizeLimit = limit;}
    /** Get size limit for file validation.
      @return size limit. */
    public long getSizeLimit() {return sizeLimit;}

    /** Set file filter for allow/disallow policy. */
    public void setFileFilter(FileFilter filter) {this.filter = filter;}

    /** Set whether this component should be not null.
       @param f boolean value indicating requiredness check. */
    public void setRequired(boolean f) {required = f;}
    /** Whether this component should be not null.
       @return boolean value indicating requiredness check. */
    public boolean isRequired() {return required;}

    /** Whether deletion checkbox should be checked. */
    public void setDelete(boolean f) {del = f;}
    /** Whether deletion checkbox is checked. */
    public boolean getDelete() {return del;}

/**
 * Set FileUpload value, that is this is the file name with unique suffix.
 * @param value file name with unique affix
 */
    public void setValue(String value) {
        if (StringUtils.isEmpty(value)) {
            this.value = null;
            return;
        }
        this.value = value;
        if (! isUploaded(value) && (! getParent().isProcessed() || required)) {
            removeErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FILE_NOT_FOUND_ERROR ) );
            MessageFormat fmt = new MessageFormat(res.getString("FileNotFound"));
            addError(ControlErrorTypes.getErrorType( ControlErrorTypes.FILE_NOT_FOUND_ERROR ), 
                    fmt.format(new String[] {getFileName(), getCaption()}));
        }
    }
    

    /** Get file name with unique affix. */
    public Object getValue() {
        if (del) return null;
        return value;
    }

/**
 * Set FileUpload properties from request parameter.
 * @param value file name with unique affix.
 */
    public void setValueFromRequest(String value) {
        setState(value);
        String delName = new StringBuffer(htmlName).insert(name.length(),"_Delete").toString();
        if (page.getHttpPostParams().getParameter(delName) != null) {
            del = true;
        }
		getProcessFolder();
        saveFileTemporarily();
        if (! StringUtils.isEmpty((String) this.value)) {
            if (this.value!=null && ! ((String) this.value).equals(state[1])) {
                deleteFile(state[1]);
            } else if (this.value==null && state[1]!=null) {
				deleteFile(state[1]);
            }
            boolean valid = true;
            if (file == null) {
                file = new File(procFolder + File.separator + this.value.toString());
            }
            if (file.length() > sizeLimit) {
                MessageFormat fmt = new MessageFormat(res.getString("LargeFile"));
                addError(fmt.format(new String[] {getCaption()}));
                valid =  false;
            }
            if (filter != null && !filter.accept(file)) {
                MessageFormat fmt = new MessageFormat(res.getString("WrongType"));
                addError(fmt.format(new String[] {getCaption()}));
                valid =  false;
            }
            if (!valid) {
                deleteFile();
                state[1] = "";
                setValue(state[0]);
				if (this.value!=null) {                
					file = new File(procFolder + File.separator + this.value.toString());
				}
            } else {
                state[1] = (String) this.value;
            }
        } else {
            if (! StringUtils.isEmpty(state[1])) {
                setValue(state[1]);
            } else {
                setValue(state[0]);
            }
            if (file == null && this.value != null) {
                if ( StringUtils.isEmpty(state[1])) {
                    file = new File(procFolder + File.separator + this.value.toString());
                } else {
                    file = new File(tempFolder + File.separator + this.value.toString());
                }
            }
        }
    }

/*
 * for state in hidden
 */
/*
    private void setState(String value) {
        if (StringUtils.isEmpty(value)) return;
        Enumeration items = StringUtils.split(value);
        int count = 0;
        while (items.hasMoreElements() && count < 2) {
            this.state[count++] = (String) items.nextElement();
        }
    }
    
    public String getState() {
        StringBuffer result = new StringBuffer();
        if (! StringUtils.isEmpty(state[0])) {
            result.append(StringUtils.escape(state[0]));
        } else {
            result.append(StringUtils.escape((String) getValue()));
        }
        if (! StringUtils.isEmpty(state[1])) {
            result.append(";"+StringUtils.escape(state[1]));
        }
        return result.toString();
    }
*/

/** Set FileUpload state uniqely identifing it in current session.
 * @param value - last key for state
 */
    private void setState(String value) {
        //stateKey has format: <value>
        if (StringUtils.isEmpty(value)) {
            return;
        } else {
            stateKeySuffix = value;
            state = (String[]) SessionStorage.getInstance(page.getRequest()).getAttribute(stateKeySuffix);
            SessionStorage.getInstance(page.getRequest()).removeAttribute(stateKeySuffix);
        }
    }
    
/** Get FileUpload state uniqely identifing it in current session.
 * @return last key for state
 */
    public String getState() {
        if (StringUtils.isEmpty(state[0])) {
            state[0] = (String) getValue();
        }
        StringBuffer result = new StringBuffer();
        stateKeySuffix = stateKey + generateStateKeySuffix();
        SessionStorage.getInstance(page.getRequest()).setAttribute(stateKeySuffix, state);
        result.append(stateKeySuffix);
        return result.toString();
    }
    
    private String generateStateKeySuffix() {
        StringBuffer result = new StringBuffer();
        result.append(Math.random());
        result.delete(0,2); // remove '0.'
        result.append((new SimpleDateFormat("ddHHmmss")).format(new Date()));
        return result.toString();
    }

    /** Get file contents from request and save it in temp folder. */
   public void saveFileTemporarily() {
        String fileName = new StringBuffer(htmlName).insert(name.length(),"_File").toString();
        UploadedFile upload = page.getFile(fileName);
        if (upload != null) {
			getTemporaryFolder();
            SimpleDateFormat stampFormat = new SimpleDateFormat("yyyyMMddhhmmss");
            String prefix = stampFormat.format(new Date());
            String fname = tempFolder + File.separator + prefix;
            file = new File(fname + "." + upload.getName());
            int n = 1;
            while (file.exists()) {
                file = new File(fname + n + "." + upload.getName());
                n++;
            }
            try {
                FileOutputStream out = new FileOutputStream(file);
				if (upload.getContent()!=null) {               
					out.write(upload.getContent());
				}
                out.close();
                setValue(file.getName());
            } catch (FileNotFoundException fnfe) {
                CCLogger.getInstance().error("",fnfe);
            } catch (IOException ioe) {
                CCLogger.getInstance().error("",ioe);
            }
        }
    }

    /** Move file from temp folder to the processed folder. */
    public void moveProcessedFile() {
        if (del && ! required) {
            deleteFile();
        } else {
            if (! StringUtils.isEmpty((String) value) && ! ((String) value).equals(state[0])) {
                deleteFile(state[0]);
            }
            String val = (String) getValue();
            File temp = new File(tempFolder + File.separator + val);
            if (temp.exists()) {    
                fireBeforeProcessFileEvent();
                File copy =  new File(procFolder + File.separator + val);
                if (!temp.renameTo(copy)) {
                    CCLogger.getInstance().error("Unable to move file to processed folder: " + procFolder);
                }
                fireAfterProcessFileEvent();
            }
        }
    }
    
    public String asString() {
        StringBuffer sb = new StringBuffer();
        sb.append("FileUpload: name="+name+"\n");
        sb.append("\tstate[0]="+state[0]+"\n");
        sb.append("\tstate[1]="+state[1]+"\n");
        sb.append("\tvalue="+value+"\n");
        sb.append("\ttempFolder="+tempFolder+"\n");
        sb.append("\tprocFolder="+procFolder+"\n");
        sb.append("\tsizeLimit="+sizeLimit+"\n");
        sb.append("\trequired="+required+"\n");
        sb.append("\tdel="+del+"\n");
        return sb.toString();
    }

    private void deleteFile(String name) {
        if (! StringUtils.isEmpty(name)) {
            File f = new File(procFolder + File.separator + name);
            if (f.exists()) {
                f.delete();
            } else {
                f = new File(tempFolder + File.separator + name);
                if (f.exists()) f.delete();
            }
        }
    }

    /** Delete file. */
    public void deleteFile() {
        String val = (String) value;
        if (val != null) {
            File f = new File(procFolder + File.separator + val);
            fireBeforeDeleteFileEvent();
            if (f.exists()) {
                f.delete();
            } else {
                f = new File(tempFolder + File.separator + val);
                if (f.exists()) f.delete();
            }
            fireAfterDeleteFileEvent();
        }
    }

    /** Validate uploaded file. */
    public boolean validate() {
        MessageFormat fmt = new MessageFormat(res.getString("RequiredFieldUpload"));
        fireOnValidateEvent();
        if (( StringUtils.isEmpty((String) value) || !file.exists()) && required) {
            int errCount = 0;
            for( Enumeration errs = getErrors(); errs.hasMoreElements(); ) {
                errCount++;
                errs.nextElement();
            }
            if (hasErrorByType(ControlErrorTypes.getErrorType( ControlErrorTypes.FILE_NOT_FOUND_ERROR ))) {
                errCount--;
            }
            if (errCount==0) {
                removeErrorByType( ControlErrorTypes.getErrorType( ControlErrorTypes.FILE_NOT_FOUND_ERROR ) );
                addError(ControlErrorTypes.getErrorType( ControlErrorTypes.REQUIRED_ERROR ),
                        fmt.format(new String[] {getCaption()}));
                return false;
            }
        }
        return ! hasErrors();
    }

    /** Whether file controled by this Upload component was already uploaded. */
    public boolean isUploaded() {
        if (file != null) {
            if (file.exists()) {
                return true;
            }
        } else {
            String val = (String) getValue();
            if (StringUtils.isEmpty(val)) return false;
            if (val != null) {
				getProcessFolder();
                File f = new File(procFolder + File.separator + val);
                if (f.exists()) {
                    return true;
                //} else {
                //    f = new File(tempFolder + File.separator + val);
                //    if (f.exists()) return true;
                }
            }
        }
        return false;
    }


    private boolean isUploaded(String name) {
        if (! StringUtils.isEmpty(name)) {
			getProcessFolder();
            File f = new File(procFolder + File.separator + name);
            if (f.exists()) {
				return true;
            } else {
                f = new File(tempFolder + File.separator + name);
                if (f.exists()) return true;
            }
        }
        return false;
    }

    /** Get the size of the uploaded file.
    @return size of the uploaded file */
    public long getSize() {
        String val = (String) value;
        if (val != null) {
            File f = new File(procFolder + File.separator + val);
            if (f.exists()) {
                return f.length();
            } else {
                f = new File(tempFolder + File.separator + val);
                if (f.exists()) return f.length();
            }
        }
        return 0;
    }

    /** Get simple file name as it will be shown to user.
    @return file name */
    public String getFileName() {
        return FileUpload.getFileName((String) value);
    }

    /** Get simple file name as it will be shown to user.
    @return file name */
    public static String getFileName(String fileName) {
        if (StringUtils.isEmpty(fileName)) {
            return "";
        } else {
            return fileName.substring(fileName.indexOf('.')+1);
        }
    }

    /** Get Full file name with unique affix. */
    public String getFullName() {
        String val = (String) value;
        return val==null?"":val;
    }

    private String getPagePath() {
      	try {
			String rpath = ContextStorage.getContext().getRealPath(page.getRequest().getServletPath());
        	int pos = rpath.lastIndexOf(File.separator);
        	if (pos>-1) {
        		rpath = rpath.substring(0,pos+1);
        	}
        	return rpath;
      	} catch (NullPointerException np) {
        	return null;
      	}
    }

	/*private String getProcessFolder() {
		if (isAbsolutePath(procFolder)) {
			return procFolder;
		} else {
			String pageFolder = getPagePath();
			if (pageFolder == null) {
				CCLogger.getInstance().log("Files folder is not found.");
			} else {
				if (StringUtils.isEmpty(procFolder)) {
					procFolder = pageFolder;
				} else if (".".equals(procFolder)) {
					procFolder = pageFolder;
				} else if ("..".equals(procFolder)) {
					int pos = pageFolder.lastIndexOf(File.separator);
					if (pos == pageFolder.length()) pos = pageFolder.lastIndexOf(File.separator, pos-1);
					if (pos > -1) {
						procFolder = pageFolder.substring(0,pos+1);
					} else {
						CCLogger.getInstance().log("Files folder is not found.");
					}
				} else {
					procFolder = pageFolder + procFolder; 
				}
			}
			return procFolder;
		}
	}*/
	
	private String getProcessFolder() {
		procFolder = getAbsoluteFolder(procFolder);
		File fFolder = new File(procFolder);
		if (!fFolder.exists()) {
			MessageFormat fmt = new MessageFormat(res.getString("FilesFolderNotFound"));
			addError(fmt.format(new String[] {getCaption()}));
		} else if (! fFolder.canWrite()) {
			MessageFormat fmt = new MessageFormat(res.getString("InsufficientPermissions"));
			addError(fmt.format(new String[] {getCaption()}));
		}
		return procFolder;
	}	

	private String getTemporaryFolder() {
		tempFolder = getAbsoluteFolder(tempFolder);
		File fFolder = new File(tempFolder);
		if (!fFolder.exists()) {
			MessageFormat fmt = new MessageFormat(res.getString("TempFolderNotFound"));
			addError(fmt.format(new String[] {getCaption()}));
		} else if (! fFolder.canWrite()) {
			MessageFormat fmt = new MessageFormat(res.getString("InsufficientPermissions"));
			addError(fmt.format(new String[] {getCaption()}));
		}
		return tempFolder;
	}	

	private String getAbsoluteFolder(String folder) {
		if (! isAbsolutePath(folder)) {
			String pageFolder = getPagePath();
			if (pageFolder == null) {
				CCLogger.getInstance().log("Files folder is not found.");
			} else {
				if (StringUtils.isEmpty(procFolder)) {
					folder = pageFolder;
				} else if (".".equals(folder)) {
					folder = pageFolder;
				} else if ("..".equals(folder)) {
					int pos = pageFolder.lastIndexOf(File.separator);
					if (pos == pageFolder.length()) pos = pageFolder.lastIndexOf(File.separator, pos-1);
					if (pos > -1) {
						folder = pageFolder.substring(0,pos+1);
					} else {
						CCLogger.getInstance().log("Files folder is not found.");
					}
				} else {
					folder = pageFolder + folder; 
				}
			}
		}
		return folder;
	}

	/**
	 * @return true if path starts with separator or second char is ':'
	 */
	private boolean isAbsolutePath(String path) {
		boolean isAbsolute = false;
		if (!StringUtils.isEmpty(path)) {
			isAbsolute = (path.charAt(0) == File.separatorChar);
			if (! isAbsolute && path.length() > 1) {
				isAbsolute = (path.charAt(1) == ':');
			}
		}
		return isAbsolute;
	}

    public String getAbsolutePath(String rpath) {
      try {
        return ContextStorage.getContext().getRealPath(rpath);
      } catch (NullPointerException np) {
        return null;
      }
    }

    /** Copy control. */
    public Object clone() {
        Object obj = null;
        obj = super.clone();
        ((FileUpload) obj).state = new String[2];
        ((FileUpload) obj).del = false;
        return obj;
    }

    /** Add Event handler. */
    public synchronized void addFileUploadListener (UploadListener listener) {
        listeners.addElement(listener);
    }

    /** Remove Event handler. */
    public synchronized void removeFileUploadListener (UploadListener listener) {
        listeners.removeElement(listener);
    }

    public void fireAfterDeleteFileEvent() {
        Vector l;
        Event e = new Event();
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((UploadListener)l.elementAt(i)).afterDeleteFile(e);
        }
    }

    public void fireAfterProcessFileEvent() {
        Vector l;
        Event e = new Event();
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((UploadListener)l.elementAt(i)).afterProcessFile(e);
        }
    }

    public void fireBeforeDeleteFileEvent() {
        Vector l;
        Event e = new Event();
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((UploadListener)l.elementAt(i)).beforeDeleteFile(e);
        }
    }

    public void fireBeforeProcessFileEvent() {
        Vector l;
        Event e = new Event();
        e.setSource(this);
        synchronized(this) {l = (Vector)listeners.clone();}
        for (int i=0; i<l.size(); i++) {
            ((UploadListener)l.elementAt(i)).beforeProcessFile(e);
        }
    }
}
//End FileUpload component

