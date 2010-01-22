
require 'java'
require 'swt/swt_wrapper'

class ButtonExample

  def initialize
    @shell = Swt::Widgets::Shell.new(Swt::Widgets::Display.get_current)
    @shell.setSize(450, 200)
    layout = Swt::Layout::FillLayout.new
    @shell.setLayout layout

    button = Swt::Widgets::Button.new(@shell, Swt::SWT::PUSH)
    button.setText("Click Me")
  		
    @shell.pack
    @shell.open
  end
  
  def start
    display = Swt::Widgets::Display.get_current
    while !@shell.isDisposed
      display.sleep unless display.readAndDispatch
    end

    display.dispose
  end
end

Swt::Widgets::Display.set_app_name "Button Example"
 
app = ButtonExample.new
app.start

 