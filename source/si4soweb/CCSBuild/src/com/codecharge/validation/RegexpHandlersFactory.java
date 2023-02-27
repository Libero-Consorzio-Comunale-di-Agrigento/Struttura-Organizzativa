//RegexpHandlersFactory class @0-7CD5E50B
package com.codecharge.validation;

import java.lang.reflect.Constructor;

public class RegexpHandlersFactory {
  public static ValidateHandler getHandler(String regexp, String message) {
    Class handlerClass;
    Constructor constructor;
    try {
      handlerClass = Class.forName("com.codecharge.validation.RegexpOroHandler");
      constructor = handlerClass.getConstructor(new Class[] {String.class, String.class});
      return (ValidateHandler)constructor.newInstance(new Object[] {regexp, message});
    } catch (Exception cnfe) {}
    try {
      handlerClass = Class.forName("com.codecharge.validation.RegexpJDK14Handler");
      constructor = handlerClass.getConstructor(new Class[] {String.class, String.class});
      return (ValidateHandler)constructor.newInstance(new Object[] {regexp, message});
    } catch (Exception ignore) {}
    return null;
  }
}
//End RegexpHandlersFactory class

