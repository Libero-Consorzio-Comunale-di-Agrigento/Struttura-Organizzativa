//ListDataObjectListener @0-3071C137
package com.codecharge.events;

public interface ListDataObjectListener extends java.util.EventListener {
    public void beforeBuildSelect(DataObjectEvent e);
    public void beforeExecuteSelect(DataObjectEvent e);
    public void afterExecuteSelect(DataObjectEvent e);
}
//End ListDataObjectListener

