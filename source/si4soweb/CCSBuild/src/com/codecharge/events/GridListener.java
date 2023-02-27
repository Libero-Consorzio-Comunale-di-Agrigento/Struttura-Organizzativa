//GridListener @0-E04222DA
package com.codecharge.events;

/**
  GridListener interface defines event handlers for Grid component.
**/
public interface GridListener {
    /**
      This event is raised when Grid is about to show.
      Use this event to hide or change Grid title etc.
      @see com.codecharge.components.Model#setVisible
    **/
    public void beforeShow( Event e );
    /**
      This event is raised when Grid row is about to show.
      Use this event to change row values.
    **/
    public void beforeShowRow( Event e );

    public void beforeSelect( Event e );
}
//End GridListener

