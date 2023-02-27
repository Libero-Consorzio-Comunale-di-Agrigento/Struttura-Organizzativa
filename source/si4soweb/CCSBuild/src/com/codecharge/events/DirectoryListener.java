//DirectoryListener @0-A50EF9AD
package com.codecharge.events;

/**
  GridListener interface defines event handlers for Grid component.
**/
public interface DirectoryListener {
    /**
      This event is raised when Directory is about to show.
      Use this event to hide or change Directory title etc.
      @see com.codecharge.components.Model#setVisible
    **/
    public void beforeShow( Event e );

    /**
      This event is raised when Directory category is about to show.
      Use this event to change category values.
    **/
    public void beforeShowCategory( Event e );

    /**
      This event is raised when Directory subcategory is about to show.
      Use this event to change subcategory values.
    **/
    public void beforeShowSubcategory( Event e );

    public void beforeSelect( Event e );
}
//End DirectoryListener

