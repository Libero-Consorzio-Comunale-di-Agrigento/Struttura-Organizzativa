//RecordListener @0-19D1E165
package com.codecharge.events;

public interface RecordListener {
    public void beforeShow(Event e);
    public void onValidate(Event e);
    public void beforeSelect(Event e);
    public void beforeInsert(Event e);
    public void afterInsert(Event e);
    public void beforeUpdate(Event e);
    public void afterUpdate(Event e);
    public void beforeDelete(Event e);
    public void afterDelete(Event e);
}
//End RecordListener

