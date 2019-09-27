package com.clinica.utils;

import java.util.Date;
import java.util.Calendar;
import java.text.SimpleDateFormat;

/** 
 * This class determines the difference between 2 dates not including the dates themselves, i.e. inclusive 
 * passed as java.utilCalendar.
 * Owner : Niraj Agarwal
 */
public class DateDiff  
{
    // The year difference between passed dates
    private int yearDiff = 0;
    // The month difference between passed dates, excluding years
    private int monthDiff = 0;
    // The day difference between passed dates, excluding years and months
    private int dayDiff = 0;
    // Total day difference between passed dates, including years and months 
    private int dayOnly = 0;

    private Calendar startDate = null;
    private Calendar endDate = null;

    private static final long DAY = 86400000;

    public DateDiff(String fma, String fmi)
    {

        Calendar pStartDate = Calendar.getInstance();
        Calendar pEndDate = Calendar.getInstance();

        pStartDate.set(Integer.parseInt(fmi.substring(6)), Integer.parseInt(fmi.substring(3,5))-1, Integer.parseInt(fmi.substring(0,2)));
        pEndDate.set(Integer.parseInt(fma.substring(6)), Integer.parseInt(fma.substring(3,5))-1, Integer.parseInt(fma.substring(0,2)));
        

        startDate = Calendar.getInstance();
        endDate = Calendar.getInstance();
        
        startDate.clear();
        endDate.clear();

        startDate.set(pStartDate.get(Calendar.YEAR), pStartDate.get(Calendar.MONTH), pStartDate.get(Calendar.DATE));        
        endDate.set(pEndDate.get(Calendar.YEAR), pEndDate.get(Calendar.MONTH), pEndDate.get(Calendar.DATE));        
    }

    public void calculateDifference()
    {


        if( startDate == null || endDate == null || startDate.after(endDate) )
            return;

        dayOnly = (int) ((endDate.getTimeInMillis() - startDate.getTimeInMillis()) / DAY);

        yearDiff = endDate.get(Calendar.YEAR) - startDate.get(Calendar.YEAR);
            
        boolean bYearAdjusted = false;
        startDate.add(Calendar.YEAR, yearDiff);
        if( startDate.after(endDate) )
        {
            bYearAdjusted = true;
            startDate.add(Calendar.YEAR, -1 );
            yearDiff--;
        }

        monthDiff = endDate.get(Calendar.MONTH) - startDate.get(Calendar.MONTH);
        if( bYearAdjusted && monthDiff <= 0 )
            monthDiff = 12 + monthDiff;

        startDate.add(Calendar.MONTH, monthDiff);
        if( startDate.after(endDate) )
        {
            startDate.add(Calendar.MONTH, -1 );
            monthDiff--;
        }
            
        dayDiff = endDate.get(Calendar.DAY_OF_YEAR) - startDate.get(Calendar.DAY_OF_YEAR);
        if( dayDiff < 0 )
            dayDiff = 365 + dayDiff;

        startDate.add(Calendar.DAY_OF_YEAR, dayDiff);
    }

    public int getYear()
    {
        return yearDiff;
    }

    public int getMonth()
    {
        return monthDiff;
    }

    public int getDay()
    {
        return dayDiff;
    }

    public int getDayOnly()
    {
        return dayOnly;
    }


}
