require 'java'
require 'swt/swt_wrapper'

display = Swt::Widgets::Display.get_current
font = Swt::Graphics::Font.new(display,"Comic Sans MS", 24, Swt::SWT::BOLD)
image = Swt::Graphics::Image.new(display,87,48)
gc = Swt::Graphics::GC.new(image)

gc.set_background(display.get_system_color(Swt::SWT::COLOR_WHITE))
gc.fill_rectangle(image.get_bounds)
gc.set_font(font)
gc.set_foreground(display.get_system_color(Swt::SWT::COLOR_RED))
gc.draw_string("S", 3, 0)
gc.set_foreground(display.get_system_color(Swt::SWT::COLOR_GREEN))
gc.draw_string("W", 25, 0)
gc.set_foreground(display.get_system_color(Swt::SWT::COLOR_BLUE))
gc.draw_string("T", 62, 0)
gc.dispose

loader = Swt::Graphics::ImageLoader.new
loader.data = [image.get_image_data]
loader.save("swt.png", Swt::SWT::IMAGE_PNG);

image.dispose
font.dispose
display.dispose
