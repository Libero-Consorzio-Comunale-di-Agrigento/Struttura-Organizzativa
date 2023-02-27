//Event class @0-022FA27F
package com.codecharge.events;

import com.codecharge.components.*;

public class Event {
  private Object src;

  public Event() {}
  public Event(Object src) {this.src = src;}

  public Object getSource() {return src;}
  public List getList() {
    if (src instanceof List) {
      return (List)src;
    } else {
      return null;
    }
  }
  public RadioButton getRadioButton() {
    if (src instanceof RadioButton) {
      return (RadioButton)src;
    } else {
      return null;
    }
  }
  public ListBox getListBox() {
    if (src instanceof ListBox) {
      return (ListBox)src;
    } else {
      return null;
    }
  }
  public Model getModel() {
    if (src instanceof Model) {
      return (Model)src;
    } else {
      return null;
    }
  }
  public Button getButton() {
    if (src instanceof Button) {
      return (Button)src;
    } else {
      return null;
    }
  }
  public Control getControl() {
    if (src instanceof Control) {
      return (Control)src;
    } else {
      return null;
    }
  }
  public VerifiableControl getMutableControl() {
    if (src instanceof VerifiableControl) {
      return (VerifiableControl)src;
    } else {
      return null;
    }
  }
  public Sorter getSorter() {
    if (src instanceof Sorter) {
      return (Sorter)src;
    } else {
      return null;
    }
  }
  public Navigator getNavigator() {
    if (src instanceof Navigator) {
      return (Navigator)src;
    } else {
      return null;
    }
  }

  public Component getComponent() {
    if (src instanceof Component) {
      return (Component)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof Component) {
      return (Component) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public Record getRecord() {
    if (src instanceof Record) {
      return (Record)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof Record) {
      return (Record) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public Grid getGrid() {
    if (src instanceof Grid) {
      return (Grid)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof Grid) {
      return (Grid) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public EditableGrid getEditableGrid() {
    if (src instanceof EditableGrid) {
      return (EditableGrid)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof EditableGrid) {
      return (EditableGrid) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public Directory getDirectory() {
    if (src instanceof Directory) {
      return (Directory)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof Directory) {
      return (Directory) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public Path getPath() {
    if (src instanceof Path) {
      return (Path)src;
    } else if (src instanceof Model && ((Model) src).getParent() instanceof Path) {
      return (Path) ((Model) src).getParent();
    } else {
      return null;
    }
  }

  public void setSource(Object src) {this.src = src;}

  public Page getPage() {
    if (src instanceof Control) {
      return ((Control)src).getPage();
    } else if (src instanceof Page) {
      return (Page)src;
    } else if (src instanceof Sorter) {
      return ((Sorter)src).getPage();
    } else if (src instanceof Navigator) {
      return ((Navigator)src).getPage();
    } else if (src instanceof Component) {
      return ((Component)src).getPageModel();
    } else if (src instanceof Button) {
      return ((Button)src).getPage();
    } else {
      return null;
    }
  }

  public String getValue() {
    if (src instanceof Control) {
      return ((Control)src).getFormattedValue();
    } else {
      return null;
    }
  }
  public void setValue(String value) {
    if (src instanceof Control) {
      ((Control)src).setFormattedValue(value);
    }
  }

  public Component getParent() {
    if (src instanceof Control) {
      return ((Control)src).getParent();
    } else if (src instanceof Button) {
      return ((Button)src).getParent();
    } else {
      return null;
    }
  }
}
//End Event class

