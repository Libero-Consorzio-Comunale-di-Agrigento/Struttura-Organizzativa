//RecordDataObjectListener @0-5DBDE8C4
package com.codecharge.events;

public interface RecordDataObjectListener extends DataObjectListener {
    public void beforeBuildInsert(DataObjectEvent e);
    public void beforeExecuteInsert(DataObjectEvent e);
    public void afterExecuteInsert(DataObjectEvent e);
    public void beforeBuildUpdate(DataObjectEvent e);
    public void beforeExecuteUpdate(DataObjectEvent e);
    public void afterExecuteUpdate(DataObjectEvent e);
    public void beforeBuildDelete(DataObjectEvent e);
    public void beforeExecuteDelete(DataObjectEvent e);
    public void afterExecuteDelete(DataObjectEvent e);
}
//End RecordDataObjectListener

