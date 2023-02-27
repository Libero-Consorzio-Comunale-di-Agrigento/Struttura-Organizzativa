//ReadOnlyControl interface @0-D77E2D9C
package com.codecharge.components;

import java.text.*;

public interface ReadOnlyControl {
    public String getCaption();
    public Object getValue();
    public Format getDbFormat();
    public Format getFormat();
    public ControlType getType();
    public String getFieldSource();
    public boolean isHtmlEncode();
}
//End ReadOnlyControl interface

