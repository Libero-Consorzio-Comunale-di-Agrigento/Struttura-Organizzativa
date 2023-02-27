//GridControl component @0-D90DC4B1
package com.codecharge.components;

public class GridControl extends Model {

    protected String pageName;
    protected Page page;

    public GridControl(String name, Page page) {
      super(name);
      this.page = page;
    }
    public void setParent(Grid grid) {
      parent = grid;
    }
    public void setPageName(String page) {
      this.pageName = page;
    }
}
//End GridControl component

