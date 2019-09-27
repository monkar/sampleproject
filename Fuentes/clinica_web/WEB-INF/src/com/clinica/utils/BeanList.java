package com.clinica.utils;

import java.util.Vector;

// Referenced classes of package com.workflow.util:
//            Bean

public class BeanList extends Vector
{

    public BeanList()
    {
    }

    public Bean getBean(int ind)
    {
        return (Bean)get(ind);
    }
    
    public String getClassLastRow(int currentIndex, int lastIndexRow, 
          String classNameLastRow, String classNamePairRow)
    {
        String classLastRow = "";
        if( currentIndex == lastIndexRow ){
          classLastRow = classNameLastRow;
        }
        if( currentIndex%2 != 0 ){
          classLastRow += " " + classNamePairRow;
        }
        return classLastRow;
    }
}