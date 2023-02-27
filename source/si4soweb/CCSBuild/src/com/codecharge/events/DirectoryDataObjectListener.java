//DirectoryDataObjectListener @0-4CB6E329
package com.codecharge.events;

public interface DirectoryDataObjectListener extends java.util.EventListener {
    public void beforeBuildSelect(DataObjectEvent e);
    public void beforeExecuteSelect(DataObjectEvent e);
    public void afterExecuteSelect(DataObjectEvent e);
}
//End DirectoryDataObjectListener

