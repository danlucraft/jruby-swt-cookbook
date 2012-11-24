
require 'java'
require 'swt/swt_wrapper'

# Application showing equivalents of various HTML form elements

class SimpleApplication
  def initialize
    # A Display is the connection between SWT and the native GUI. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Display.html)
    display = Swt::Widgets::Display.get_current
  
    # A Shell is a window in SWT parlance. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Shell.html)
    @shell = Swt::Widgets::Shell.new
    
    # A Shell must have a layout. FillLayout is the simplest.
    layout = Swt::Layout::FillLayout.new
    layout.type = Swt::SWT::VERTICAL
    @shell.setLayout(layout)

    build_app!
    
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

class FormApplication < SimpleApplication
  def build_app!
    label1 = Swt::Widgets::Label.new(@shell, Swt::SWT::CENTER)
    label1.set_text("Center Label")

    label2 = Swt::Widgets::Label.new(@shell, Swt::SWT::LEFT)
    label2.set_text("Left Label")
    
    combo = Swt::Widgets::Combo.new(@shell, 0)
    combo.add("First Choice")
    combo.add("Second Choice")
    combo.add("Third Choice")
    
    text = Swt::Widgets::Text.new(@shell, 0)
    text.set_text("Text box")
    text.set_message("Type some text here")

    button = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH)
    button.set_text("Click Me")
    button.add_selection_listener do
      puts "You clicked the button."
    end
  end
end

Swt::Widgets::Display.set_app_name "Form Example"
 
app = FormApplication.new
app.start
