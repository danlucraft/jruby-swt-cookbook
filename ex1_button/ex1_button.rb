
require 'java'
require 'swt/swt_wrapper'

class ButtonExample

  def initialize
    # A Display is the connection between SWT and the native GUI. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Display.html)
    display = Swt::Widgets::Display.get_current
  
    # A Shell is a window in SWT parlance. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Shell.html)
    @shell = Swt::Widgets::Shell.new
    
    # A Shell must have a layout. FillLayout is the simplest.
    layout = Swt::Layout::FillLayout.new
    @shell.setLayout(layout)

    # Create a button widget (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Button.html)
    button = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH)
    button.setText("Click Me")
    
    # Add a button click listener
    button.add_selection_listener do
      puts "You clicked the button."
    end
    
    # This lays out the widgets in the Shell
    @shell.pack
    
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

Swt::Widgets::Display.set_app_name "Button Example"
 
app = ButtonExample.new
app.start

 