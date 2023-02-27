//SqlFormatControl interface @0-7D6AA086
package com.codecharge.db;

import java.text.*;
import com.codecharge.components.*;

public interface SqlFormatControl {
    public Format getDateFormat();
    public Format getBooleanFormat();
    public String format(ReadOnlyControl control);
    public Object parse(String source, ReadOnlyControl control) throws ParseException;
}
//End SqlFormatControl interface

