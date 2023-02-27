//EditableGridListener @0-38D4C25E
package com.codecharge.events;

public interface EditableGridListener {
    public void beforeShow(Event e);
    public void beforeShowRow(Event e);
    public void onValidate(Event e);
    public void beforeSelect(Event e);
    public void beforeSubmit(Event e);
    public void afterSubmit(Event e);
}
//End EditableGridListener

