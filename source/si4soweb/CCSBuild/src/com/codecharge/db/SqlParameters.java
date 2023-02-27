//SqlParameters class @0-0F726E33
package com.codecharge.db;      

import java.util.*;

public class SqlParameters implements CCSDataSource {

    private Collection sqlParameters;
    private HashMap hashSqlParameters;
    private Collection whereParameters;
    private HashMap hashWhereParameters;

    public SqlParameters ( Collection sqlParams, Collection whereParams ) {
        this.sqlParameters = sqlParams;
        this.whereParameters = whereParams;
        this.hashWhereParameters = null;
    }
    
    public Collection getSqlParameters() {
        return sqlParameters;
    }
    
    public Collection getWhereParameters() {
        return whereParameters;
    }
    
    synchronized public SqlParameter getWhereParameter( String name ) {
        if ( whereParameters == null ) return null;
        if ( hashWhereParameters == null ) {
            hashWhereParameters = new HashMap();
            Iterator params = whereParameters.iterator();
            while ( params.hasNext() ) {
                SqlParameter param = (SqlParameter) params.next();
                hashWhereParameters.put( param.getName(), param );
            }
        }
        HashMap hash = null;
        hash = (HashMap) hashWhereParameters.clone();
        return (SqlParameter) hash.get( name );
    }
    
    synchronized public SqlParameter getSqlParameter( String name ) {
        if ( sqlParameters == null ) return null;
        if ( hashSqlParameters == null ) {
            hashSqlParameters = new HashMap();
            Iterator params = sqlParameters.iterator();
            while ( params.hasNext() ) {
                SqlParameter param = (SqlParameter) params.next();
                hashSqlParameters.put( param.getName(), param );
            }
        }
        HashMap hash = null;
        hash = (HashMap) hashSqlParameters.clone();
        return (SqlParameter) hash.get( name );
    }
    
    public String getWhereParametersAsString() {
        if ( whereParameters == null ) return "";
        StringBuffer sb = new StringBuffer();
        Iterator params = whereParameters.iterator();
        while ( params.hasNext() ) {
            SqlParameter param = (SqlParameter) params.next();
            sb.append( param.toString() );
        }
        return sb.toString();
    }
    
    public Parameter getParameterByName(String name) {
      SqlParameter param = getSqlParameter(name);
      if (param == null) {
        return getWhereParameter(name);
      } else {
        return param;
      }
    }

    public Parameter getParameterByName(String name, ParameterSource parameterSource) {
      Iterator sqlParams = sqlParameters.iterator();
      while ( sqlParams.hasNext() ) {
          SqlParameter param = (SqlParameter) sqlParams.next();
          if (param.getName().equals(name) && param.getSourceType() == parameterSource) {
            return param;
          }
      }
      Iterator whereParams = sqlParameters.iterator();
      while ( whereParams.hasNext() ) {
          SqlParameter param = (SqlParameter) whereParams.next();
          if (param.getName().equals(name) && param.getSourceType() == parameterSource) {
            return param;
          }
      }
      return null;
    }
}
//End SqlParameters class

