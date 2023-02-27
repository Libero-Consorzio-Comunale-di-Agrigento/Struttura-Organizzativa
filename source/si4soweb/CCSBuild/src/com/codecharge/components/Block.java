//Block component @0-CEEDD8D8
package com.codecharge.components;

/**
A Block is provided to be able to hide some html and other components enclosed in it, by setting its visible property.
 **/
public class Block {

  private String name;
  private boolean visible;

  public Block(String name) {
    this.name = name;
    visible = true;
  }
  /**  Whether this control should be shown. */
  public boolean isVisible() {return visible;}
  /**  Specify whether this control or component should be shown. */
  public void setVisible(boolean f) {visible = f;}
  public String getName() {return name;}
  public void setName(String name) {this.name = name;}
}
//End Block component

