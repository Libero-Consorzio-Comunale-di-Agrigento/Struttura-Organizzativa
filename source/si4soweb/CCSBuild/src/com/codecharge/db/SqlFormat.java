//SqlFormat interface @0-FB758058
package com.codecharge.db;

import java.text.*;
import com.codecharge.db.*;

public interface SqlFormat {
    public Format getDateFormat();
    public Format getBooleanFormat();
    public String format(ReadOnlyField field);
    public Object parse(String source, ReadOnlyField field) throws ParseException;
}
//End SqlFormat interface

