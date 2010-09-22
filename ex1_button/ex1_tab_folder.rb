
require 'java'
require File.expand_path(File.join(__FILE__, '../../swt/swt_wrapper'))
require File.expand_path(File.join(__FILE__, '../../swt/graphics_utils'))
require File.expand_path(File.join(__FILE__, '../ex_drag_listener'))
require File.expand_path(File.join(__FILE__, '../tab_transfer'))

class VerticalTabLabel
  attr_reader :active, :title
  
  include Swt::Events::MouseListener
  
  Font = Swt::Graphics::Font.new(Swt::Widgets::Display.current, "Arial", 12, 0)
  
  def initialize(tab, parent, style)
    @label = Swt::Widgets::Label.new(parent, style)
    @tab = tab
    @active = false
    @tab = tab
    @parent = parent
    @title = ""
    
    @label.image = label_image
    @label.add_paint_listener { |event| event.gc.draw_image(label_image, 0, 0) }
    @label.add_mouse_listener(self)
  end
  
  def label_image
    display = Swt::Widgets::Display.current
    GraphicsUtils.create_rotated_text(@title, Font, @parent.foreground, @parent.background, Swt::SWT::UP) do |gc, extent|
      fg, bg = gc.foreground, gc.background
      if @active
        options = @tab.selection_color_options
        options[:percents].each_with_index do |p, idx|
          gc.foreground = options[:colors][idx]
          gc.background = options[:colors][idx + 1]
          if options[:vertical]
            h = idx > 0 ? extent.height * options[:percents][idx - 1] : 0
            gc.fill_gradient_rectangle(0, h, extent.width, extent.height * p, true)
          else
            h = idx > 0 ? extent.width * options[:percents][idx - 1] : 0
            gc.fill_gradient_rectangle(w, 0, extent.width * p, extent.height, false)
          end
        end
      else
        gc.fill_rectangle(0, 0, extent.width, extent.height)
      end
      gc.foreground = display.get_system_color(Swt::SWT::COLOR_WIDGET_NORMAL_SHADOW)
      gc.draw_rectangle(0, 0, extent.width - 1, extent.height - 1)
      gc.foreground, gc.background = fg, bg
    end
  end
  
  def activate
    @tab.activate
  end
  
  def active!
    @active = true
    @label.image = label_image
  end
  
  def inactive!
    @active = false
    @label.image = label_image
  end
  
  def title= (str)
    @title = str
    @label.image = label_image
  end
  
  def mouseUp(e)
    activate
  end
  
  # Unused
  def mouseDown(e); end
  def mouseDoubleClick(e); end
  
  # Delegate to SWT Label
  def method_missing(method, *args, &block)
    return @label.send(method, *args, &block) if @label.respond_to? method
    super
  end
end

class VerticalTabItem
  attr_accessor :text, :control
  
  def initialize(parent, style)
    @parent = parent
    @parent.add_item(self)
  end
  
  def text= title
    @text = title
    @label.title = title
  end
  
  def control= control
    @control = control
    @control.visible = active?
    @control.layout_data = Swt::Layout::GridData.new.tap do |l|
      l.horizontalAlignment = Swt::Layout::GridData::FILL
      l.verticalAlignment = Swt::Layout::GridData::FILL
      l.grabExcessHorizontalSpace = true
      l.exclude = active?
    end
  end
  
  def draw_label(tab_area)
    @label = VerticalTabLabel.new(self, tab_area, Swt::SWT::NONE)
  end
  
  # This way up to the parent
  def activate
    @parent.selection = self
  end
  
  # This way down to the label
  def active!
    @label.active!
    if @control
      @control.visible = true
      @control.layout_data.exclude = false
    end
  end
  
  # This way down to the label
  def inactive!
    @label.inactive!
    if @control
      @control.visible = false
      @control.layout_data.exclude = true
    end
  end

  def active?
    @label.active
  end

  def selection_color_options
    @parent.selection_color_options
  end

  # Delegate to label
  def method_missing(method, *args, &block)
    return @label.send(method, *args, &block) if @label.respond_to? method
    super
  end
end

class VerticalTabFolder < Swt::Widgets::Composite
  attr_accessor :tab_area, :content_area
  attr_reader :selection_color_options
  
  def initialize(parent, style)
    super(parent, style)
    self.layout = Swt::Layout::GridLayout.new(2, false).tap do |l|
      l.horizontalSpacing = -1
    end
    
    @items = []
    
    @tab_area = Swt::Widgets::Composite.new(self, Swt::SWT::NONE).tap do |t|
      t.layout_data = Swt::Layout::GridData.new(Swt::Layout::GridData::FILL_VERTICAL | Swt::Layout::GridData::GRAB_VERTICAL)
      t.layout = Swt::Layout::RowLayout.new.tap do |l|
        l.type         = Swt::SWT::VERTICAL
        l.spacing      = -1
        l.wrap         = false
        l.marginLeft   = 0
        l.marginRight  = 0
        l.marginTop    = 0
        l.marginBottom = 0
      end
    end
  end
  
  def set_selection_background(colors, percents, vertical = true)
    @selection_color_options = { :colors => colors,
      :percents => percents.collect {|i| i / 100.0},
      :vertical => vertical }
  end

  def add_item(tab)
    @items << tab
    tab.draw_label(@tab_area)
    tab.active! if @items.size == 1
    layout
  end
  
  def get_item(idx)
    return @items[idx] if idx.respond_to? :to_int
    raise NotImplementedError, "Getting via Point not implemented"
  end
  
  def item_count
    @items.size
  end
  
  def selection
    @items.detect { |x| x.active }
  end
  
  def selection=(tab)
    selection.inactive!
    if tab.respond_to? :to_int
      @items[tab].active!
    else
      tab.active!
    end
    layout
  end
  
  def selection_index
    index_of(selection)
  end
  
  def index_of(tab)
    @items.index(tab)
  end
  
  def show_item(tab)
    selection = tab
  end
end

class ButtonExample
  
  def initialize
    @insertMark = -1
    @tab_folder = nil
    
    # A Display is the connection between SWT and the native GUI. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Display.html)
    display = Swt::Widgets::Display.get_current
    
    # A Shell is a window in SWT parlance. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Shell.html)
    @shell = Swt::Widgets::Shell.new
    
    # A Shell must have a layout. FillLayout is the simplest.
    layout = Swt::Layout::FillLayout.new
    @shell.setLayout(layout)
    
    # Create composite
    composite = Swt::Widgets::Composite.new(@shell, Swt::SWT::NONE)
    composite.setLayoutData(Swt::Layout::GridData.new(Swt::Layout::GridData::FILL_HORIZONTAL))
    composite.setLayout(Swt::Layout::GridLayout.new)
    composite.set_size(600,500)
    
    # btn = VerticalTab.new(composite, "oh boy")
    
    # Create a tabfolder
    @tab_folder = VerticalTabFolder.new(composite, Swt::SWT::TOP)
    @tab_folder.setLayoutData(Swt::Layout::GridData.new(Swt::Layout::GridData::FILL_BOTH));
    @tab_folder.set_size(500,400)
    colors = [ Swt::Graphics::Color.new(display, 230, 240, 255),
      Swt::Graphics::Color.new(display, 170, 199, 246),
      Swt::Graphics::Color.new(display, 135, 178, 247) ]
    percents = [60, 85]
    @tab_folder.set_selection_background(colors, percents, true)
    items = 4.times.collect do |idx|
      i = VerticalTabItem.new(@tab_folder, Swt::SWT::NULL)
      i.text = "Item #{idx}"
      i.control = (Swt::Widgets::Text.new(@tab_folder, (Swt::SWT::BORDER | Swt::SWT::MULTI)).tap do |t|
        t.set_text("Text for Item #{idx}")
      end)
    end
    
    
    
    # And this displays the Shell
    @shell.open
  end
  
  def resetInsertMark
    @tabFolder.setInsertMark(@insertMark, true)
    # Workaround for bug #32846
    if (@insertMark == -1)
      @tabFolder.redraw()
    end
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

