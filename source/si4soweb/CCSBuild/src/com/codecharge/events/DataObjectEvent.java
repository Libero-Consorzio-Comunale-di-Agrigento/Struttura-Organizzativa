//DataObjectEvent @0-FA6D8EB5
package com.codecharge.events;

import com.codecharge.components.*;
import com.codecharge.db.*;

public class DataObjectEvent {
  private Object src;
  private Command cmd;
  private JDBCConnection con;
  private CCSDataSource ds;
  private String sql;
  private String countSql;
  private String where;
  private String order;
  private String vlist;

  public DataObjectEvent() {}
  public DataObjectEvent(Command cmd) {this.cmd = cmd;}

  public Command getCommand() {return cmd;}
  public void setCommand(Command cmd) {this.cmd = cmd;}

  public CCSDataSource getDataSource() {return ds;}
  public void setDataSource(CCSDataSource ds) {this.ds = ds;}

  public JDBCConnection getConnection() {return con;}
  public void setConnection(JDBCConnection con) {this.con = con;}

  public Object getSource() {return src;}
  public Record getRecord() {
    if (src instanceof Record) {
      return (Record)src;
    } else {
      return null;
    }
  }
  public Grid getGrid() {
    if (src instanceof Grid) {
      return (Grid)src;
    } else {
      return null;
    }
  }
  public EditableGrid getEditableGrid() {
    if (src instanceof EditableGrid) {
      return (EditableGrid)src;
    } else {
      return null;
    }
  }
  public Component getComponent() {
    if (src instanceof Component) {
      return (Component)src;
    } else {
      return null;
    }
  }
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
  public Page getPage() {
    if (src == null) return null;
    if (src instanceof Control) {
      return ((Control)src).getPage();
    } else if (src instanceof Page) {
      return (Page)src;
    } else if (src instanceof Component) {
      return ((Component)src).getPageModel();
    } else if (src instanceof Button) {
      return ((Button)src).getPage();
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
  public void setSource(Object src) {this.src = src;}

  /** Set sql string to retrieve form data without where and order by clauses.
    You can use (?) to specify parameters supplied by addParamater() method.
  **/
  public void setSql(String sql) {
    if (cmd == null) {
        this.sql = sql;
    } else {
        cmd.setSql(sql);
    }
  }
  /** Get sql string to retrieve form data without WHERE and ORDER BY clauses. **/
  public String getSql() {
    if (cmd == null) {
        return sql;
    } else {
        return cmd.getSql();
    }
  }

  public void setCountSql(String sql) {
    if (cmd == null) {
      countSql = sql;
    } else {
      cmd.setCountSql(sql);
    }
  }
  /** Get countSql string to retrieve form data without WHERE and ORDER BY clauses. **/
  public String getCountSql() {
    if (cmd == null) {
      return countSql;
    } else {
      return cmd.getCountSql();
    }
  }

  /** Set string used to form where clause without starting WHERE keyword. **/
  public void setWhere(String where) {
    if (cmd == null) {
      this.where = where;
    } else {
      cmd.setWhere(where);
    }
  }
  /** Get string used to form where clause without starting WHERE keyword. **/
  public String getWhere() {
    if (cmd == null) {
      return where;
    } else {
      return cmd.getWhere();
    }
  }

  /** Set string used to form ORDER BY clause without starting ORDER BY keyword. **/
  public void setOrder(String order) {
    if (cmd == null) {
      this.order = order;
    } else {
      cmd.setOrder(order);
    }
  }
  /** Get string used to form ORDER BY clause without starting ORDER BY keyword. **/
  public String getOrder() {
    if (cmd == null) {
      return order;
    } else {
      return cmd.getOrder();
    }
  }
  public void setListOfValues(String values) {
    if (src instanceof List) {
      ((List)src).setListOfValues(values);
    } else {
      vlist = values;
    }
  }
  public String getListOfValues() {
    if (src instanceof List) {
      return null; //((List)src).getListOfValues();
    } else {
      return vlist;
    }
  }

  public Parameter getParameter(String name) {
    if (ds != null) {
      return ds.getParameterByName(name);
    } else {
      return null;
    }
  }
  public void addParameter(SqlParameter param) {
    if (cmd == null) {
    } else {
      cmd.addParameter(param);
    }
  }
  public void addParameter(String name, Object value) {
    SqlParameter param = new SqlParameter();
    param.setName(name);
    param.setField(name);
    try {param.setValue(value);} catch (java.text.ParseException pe) {}
    addParameter(param);
  }
  public void clearParameters() {
    if (cmd != null) {
      cmd.clearParameters();
    }
  }

}
//End DataObjectEvent

