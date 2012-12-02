
require 'java'
require 'swt/swt_wrapper'

class CircleExample

  def initialize
    # A Display is the connection between SWT and the native GUI. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Display.html)
    display = Swt::Widgets::Display.get_current
  
    # A Shell is a window in SWT parlance. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Shell.html)
    @shell = Swt::Widgets::Shell.new

    @shell.add_paint_listener do |event|
      rect = @shell.client_area
      event.gc.draw_oval(0, 0, rect.width - 1, rect.height - 1)
    end
    
    client_area = @shell.client_area
    
    @shell.set_bounds(client_area.x + 10, client_area.y + 10, 200, 200)
    
    # And this displays the Shell
    @shell.open
  end
  
  # This is the main gui event loop
  def start
    display = Swt::Widgets::Display.get_current
    
    # until the window (the Shell) has been closed
    while !@shell.isDisposed
    
      # check for and dispatch new gui events
      display.sleep unless display.read_and_dispatch
    end

    display.dispose
  end
end

Swt::Widgets::Display.set_app_name "Circle Example"
 
app = CircleExample.new
app.start

