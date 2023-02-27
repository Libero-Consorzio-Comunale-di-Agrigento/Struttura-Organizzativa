//PathListener @0-E0F0F054
package com.codecharge.events;

/**
  GridListener interface defines event handlers for Grid component.
**/
public interface PathListener {
    /**
      This event is raised when Path is about to show.
      Use this event to hide or change Path title etc.
      @see com.codecharge.components.Model#setVisible
    **/
    public void beforeShow( Event e );

    /**
      This event is raised when Path category is about to show.
      Use this event to change category values.
    **/
    public void beforeShowCategory( Event e );

    public void beforeSelect( Event e );
}
//End PathListener

