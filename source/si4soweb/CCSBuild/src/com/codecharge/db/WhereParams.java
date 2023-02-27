//WhereParams @0-73E37337
package com.codecharge.db;

import com.codecharge.util.*;
import com.codecharge.components.*;
import java.text.*;

public class WhereParams {

  public static String and ( boolean brackets, String left, String right ) {
    String result = null;
    if ( StringUtils.isEmpty( left ) ) {
      if ( ! StringUtils.isEmpty( right ) ) {
        result = right;
      }
    }
    else {
      if ( StringUtils.isEmpty( right )) {
        result = left;
      }
      else {
        result = left + " and " + right;
        if ( brackets ) result = " (" + result + ") ";
      }
    }
    return result;
  }

  public static String or ( boolean brackets, String left, String right ) {
    String result = null;
    if ( StringUtils.isEmpty( left ) ) {
      if ( ! StringUtils.isEmpty( right )) {
        result = right;
      }
    }
    else {
      if ( StringUtils.isEmpty( right ) ) {
        result = left;
      }
      else {
        result = left + " or " + right;
        if ( brackets ) result = " (" + result + ") ";
      }
    }
    return result;
  }

  public static String operation( Field field, DS dataObject ) {
    String result = null;
    if ( field == null || field.getObjectValue() == null ) return "";
    String value = field.getObjectValue().toString();
    if ( ! StringUtils.isEmpty( value ) ) {
      String val = null;
      if ( field instanceof TextField || field instanceof LongTextField) { 
        value = StringUtils.replace( value, "'", "''" );
        val = "'" + value + "'";
      }
      else {
          val = value;
      }
      FieldOperation oper = field.getOperation();
      if ( oper.isComplex() ) {
          result = field.getField() + oper.getOperationStart() + value + oper.getOperationEnd();
      }
      else {
          result = field.getField() + oper.getOperationStart() + val;
      }
    }
    return result;
  }

    public static String operation( String fieldName, FieldOperation oper, 
            Parameter value, Format format, JDBCConnection dataObject ) {
        String result = null;
        if ( value != null && value.getObjectValue() != null ) {
            boolean enclose = false;
            String val = dataObject.format( value, format );
            if ( val != null && val.length() > 0 )
                result = fieldName + " " + oper.getOperation( val, enclose );
        }
        return result;
    }

    public static String rawOperation( String fieldName, FieldOperation oper, 
            Parameter value, Format format, JDBCConnection conn ) {
        String result = null;
        if ( value != null && value.getObjectValue() != null ) {
            int parameterType = -1;
            ControlType type = null;
            if ( value instanceof Control) {
                type = ((Control) value).getType();
            } else if (value instanceof CachedColumn) {
                type = ((CachedColumn) value).getType();
            } else if ( value instanceof SqlParameter ) {
                type = ((SqlParameter) value).getType();
            }
            if ( value instanceof TextField || value instanceof LongTextField || type == ControlType.TEXT || type == ControlType.MEMO ) {
                parameterType = JDBCConnection.TEXT;
            } else if ( value instanceof LongField || type == ControlType.INTEGER ) {
                parameterType = JDBCConnection.INTEGER;
            } else if ( value instanceof DoubleField || type == ControlType.FLOAT ) {
                parameterType = JDBCConnection.FLOAT;
            } else if ( value instanceof BooleanField || type == ControlType.BOOLEAN ) {
                parameterType = JDBCConnection.BOOLEAN;
            } else if ( value instanceof DateField || type == ControlType.DATE ) {
                parameterType = JDBCConnection.DATE;
            }

            String val = conn.format( value, format );
            if ( val != null && val.length() > 0 )
                result = fieldName + " " + oper.getRawOperation( val, conn, parameterType );
        }
        return result;
    }

}
//End WhereParams

