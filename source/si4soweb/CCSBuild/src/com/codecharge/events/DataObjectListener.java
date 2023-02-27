//DataObjectListener @0-447D46FB
package com.codecharge.events;

public interface DataObjectListener extends java.util.EventListener {
    public void beforeBuildSelect(DataObjectEvent e);
    public void beforeExecuteSelect(DataObjectEvent e);
    public void afterExecuteSelect(DataObjectEvent e);
}
//End DataObjectListener

