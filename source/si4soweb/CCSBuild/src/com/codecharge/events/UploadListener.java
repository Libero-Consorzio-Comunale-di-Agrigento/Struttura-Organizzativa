//UploadListener @0-9F62CD22
package com.codecharge.events;

public interface UploadListener extends ValidationListener {
    public void beforeProcessFile(Event e);
    public void afterProcessFile(Event e);
    public void beforeDeleteFile(Event e);
    public void afterDeleteFile(Event e);
}
//End UploadListener

