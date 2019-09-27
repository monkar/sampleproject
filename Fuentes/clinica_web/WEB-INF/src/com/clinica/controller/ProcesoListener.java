package com.clinica.controller;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSession;

public class ProcesoListener implements javax.servlet.http.HttpSessionListener 
{
  private HttpSession session = null;

  public void sessionCreated(HttpSessionEvent event)
  {
    session = event.getSession();    
  }

  public void sessionDestroyed(HttpSessionEvent event)
  {
    session = event.getSession();
  }
}