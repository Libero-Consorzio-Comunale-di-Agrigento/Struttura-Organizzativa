//ControllerListener @0-DA9AA98C
package com.codecharge.events;

public interface ControllerListener {

    public void appInitializing( AppEvent e );
    public void appDestroyed( AppEvent e );

    public void controllerInitializing( ControllerEvent e );

}
//End ControllerListener

