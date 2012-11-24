require 'java'
require File.expand_path(File.join(__FILE__, '../../swt/swt_wrapper'))

class Test
  def initialize(args)    
    display = Swt::Widgets::Display.get_current    
    #@shell = Swt::Widgets::Shell.new    
    #layout = Swt::Layout::FillLayout.new
    #@shell.setLayout(layout)
    p display.getSystemColor(Swt::SWT::COLOR_WIDGET_BACKGROUND)
    p display.getSystemColor(Swt::SWT::COLOR_WIDGET_BACKGROUND).getRGBs()
  end
end
