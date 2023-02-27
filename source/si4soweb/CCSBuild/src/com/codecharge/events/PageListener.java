//PageListener @0-5C77D8C8
package com.codecharge.events;

public interface PageListener extends java.util.EventListener {
    public void afterInitialize(Event e);
    public void onInitializeView(Event e);
    public void beforeShow(Event e);
    public void beforeUnload(Event e);
}
//End PageListener

