//CCSDataSource class @0-6CEE6D6C
package com.codecharge.db;

public interface CCSDataSource {
    public Parameter getParameterByName(String name);
    public Parameter getParameterByName(String name, ParameterSource parameterSource);
}
//End CCSDataSource class

