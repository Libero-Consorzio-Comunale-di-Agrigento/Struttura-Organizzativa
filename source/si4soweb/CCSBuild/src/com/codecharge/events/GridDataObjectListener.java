//GridDataObjectListener @0-E9563F2D
package com.codecharge.events;

public interface GridDataObjectListener extends java.util.EventListener {
    public void beforeBuildSelect(DataObjectEvent e);
    public void beforeExecuteSelect(DataObjectEvent e);
    public void afterExecuteSelect(DataObjectEvent e);
}
//End GridDataObjectListener

