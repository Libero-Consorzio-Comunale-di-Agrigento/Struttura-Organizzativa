//DS @0-AD48632A
package com.codecharge.db;

import javax.servlet.*;
import java.util.*;
import com.codecharge.components.*;
import com.codecharge.util.*;

/** Abstract class that provides basic functionality of a DataSource. */
abstract public class DS implements CCSDataSource {

  protected Vector listeners = new Vector();
  protected Vector errors;
  protected ServletContext servletContext;
  protected boolean empty;
  protected boolean next;
  protected long amountOfRows;
  protected CCLogger logger = CCLogger.getInstance();
  protected Page page;
  protected Component model;
  
  protected StringBuffer sql = new StringBuffer();
  protected StringBuffer countSql = new StringBuffer();
  protected StringBuffer where = new StringBuffer();
  protected String orderBy;
  
  private ResourceBundle res;

  public DS(Page page) {
      this.page = page;
      this.res = ResourceBundle.getBundle("MessagesBundle", page.getCCSLocale().getLocale());
  }
  
  public ResourceBundle getResourceBundle() {
      return res;
  }
  
  public StringBuffer getSql() {
    return sql;
  }
  public void setSql( StringBuffer sql ) {
    this.sql = sql;
  }
  
  public StringBuffer getCountSql() {
    return countSql;
  }
  public void setCountSql( StringBuffer countSql ) {
    this.countSql = countSql;
  }
  
  public StringBuffer getWhere() {
    return where;
  }
  public void setWhere( StringBuffer where ) {
    this.where = where;
  }
  
  public String getOrderBy() {
    return orderBy;
  }
  public void setOrderBy( String orderBy ) {
    this.orderBy = orderBy;
  }
  
  public Page getPage() {return page;}

  public Component getComponent() {return model;}
  public void setComponent( Component model ) {this.model = model;}

  /**
   * Whether the data source has more data.
   * @return true if the data source has more data.
   */
  public boolean hasNext() {
    return next;
  }

  public boolean isNext() {
    return next;
  }

  /**
   * Indicates whether or not the data source is empty.
   * @return true if the data source is empty; false otherwise
   */
  public boolean isEmpty() {
    return empty;
  }
  
  /** Get the total numder of rows. 
   * @return the total numder of rows.
   */
  public long getAmountOfRows() {
      return amountOfRows;
  }

  public ServletContext getServletContext() {
    return servletContext;
  }
  public void setServletContext( ServletContext servletContext ) {
    this.servletContext = servletContext;
  }

  public void clearErrors() {
    errors.removeAllElements();
  }

  /** Whether data source has errors. 
   * @return true - if data source has errors; false otherwise
   */
  public boolean hasErrors() {
    return ( errors != null && errors.size() > 0 );
  }

  /** Get Collection of errors. 
   * @return the collection of errors
   */
  public Vector getErrors() {
    return errors;
  }

  /** Get all errors represented as one string. 
   * @return a String that represent of the all errors. 
   */
  public String getErrorsAsString() {
    StringBuffer sb = new StringBuffer();
    for ( int i = 0; i < errors.size(); i++ ) {
      sb.append( errors.get( i ) );
    }
    return sb.toString();
  }

/** Add error message to errors collection. 
 * @param error the error message
 */
  public void addError( String error ) {
    if ( error == null ) return;
    if ( errors == null ) errors = new Vector();
    errors.add( error );
  }

  public void addErrors( Collection errors ) {
    if ( errors == null ) return;
    if ( this.errors == null ) this.errors = new Vector();
    this.errors.addAll( errors );
  }
}
//End DS

