require 'rbconfig'

module Swt
  def self.jar_path
    case Config::CONFIG["host_os"]
    when /darwin/i
      if Config::CONFIG["host_cpu"] == "x86_64"
        'swt/swt_osx64'
      else
        'swt/swt_osx'
      end
    when /linux/i
      if %w(amd64 x84_64).include? Config::CONFIG["host_cpu"]
        'swt/swt_linux64'
      else
        'swt/swt_linux'
      end
    when /windows|mswin/i
      'swt/swt_win32'
    end
  end

  path = File.expand_path(File.dirname(__FILE__) + "/../" + Swt.jar_path)
  if File.exist?(path + ".jar")
    puts "loading #{Swt.jar_path}"
    require path
  else
    puts "SWT jar file required: #{path}.jar"
    exit
  end

  import org.eclipse.swt.SWT
  
  module Widgets
    import org.eclipse.swt.widgets.Button
    import org.eclipse.swt.widgets.Caret
    import org.eclipse.swt.widgets.Combo
    import org.eclipse.swt.widgets.Composite
    import org.eclipse.swt.widgets.Display
    import org.eclipse.swt.widgets.Event
    import org.eclipse.swt.widgets.DirectoryDialog
    import org.eclipse.swt.widgets.FileDialog
    import org.eclipse.swt.widgets.Label
    import org.eclipse.swt.widgets.List
    import org.eclipse.swt.widgets.Menu
    import org.eclipse.swt.widgets.MenuItem
    import org.eclipse.swt.widgets.MessageBox
    import org.eclipse.swt.widgets.Shell
    import org.eclipse.swt.widgets.TabFolder
    import org.eclipse.swt.widgets.TabItem
    import org.eclipse.swt.widgets.Text
    import org.eclipse.swt.widgets.ToolTip
  end
  
  def self.display
    if defined?(SWT_APP_NAME)
      Swt::Widgets::Display.app_name = SWT_APP_NAME
    end
    @display ||= (Swt::Widgets::Display.getCurrent || Swt::Widgets::Display.new)
  end

  display # must be created before we import the Clipboard class.

  module Custom
    import org.eclipse.swt.custom.CTabFolder
    import org.eclipse.swt.custom.CTabItem
    import org.eclipse.swt.custom.SashForm
    import org.eclipse.swt.custom.StackLayout
    import org.eclipse.swt.custom.ST
  end
  
  module DND
    import org.eclipse.swt.dnd.Clipboard
    import org.eclipse.swt.dnd.Transfer
    import org.eclipse.swt.dnd.TextTransfer

    import org.eclipse.swt.dnd.DropTarget
    import org.eclipse.swt.dnd.DropTargetEvent
    import org.eclipse.swt.dnd.DropTargetListener
    
    import org.eclipse.swt.dnd.DragSource
    import org.eclipse.swt.dnd.DragSourceEvent
    import org.eclipse.swt.dnd.DragSourceListener
    import org.eclipse.swt.dnd.DND
    
    import org.eclipse.swt.dnd.ByteArrayTransfer
  end
  
  module Layout
    import org.eclipse.swt.layout.FillLayout
    import org.eclipse.swt.layout.FormAttachment
    import org.eclipse.swt.layout.FormLayout
    import org.eclipse.swt.layout.FormData
    import org.eclipse.swt.layout.GridLayout
    import org.eclipse.swt.layout.GridData
    import org.eclipse.swt.layout.RowLayout
    import org.eclipse.swt.layout.RowData
    import org.eclipse.swt.custom.StackLayout
  end
  
  module Graphics
    import org.eclipse.swt.graphics.Color
    import org.eclipse.swt.graphics.Font
    import org.eclipse.swt.graphics.FontMetrics
    import org.eclipse.swt.graphics.GC
    import org.eclipse.swt.graphics.Image
    import org.eclipse.swt.graphics.ImageData
    import org.eclipse.swt.graphics.Pattern
    import org.eclipse.swt.graphics.Point
    import org.eclipse.swt.graphics.Rectangle
    import org.eclipse.swt.graphics.ImageLoader
  end
  
  module Events
    import org.eclipse.swt.events.KeyEvent
    import org.eclipse.swt.events.MouseListener
  end
  
  import org.eclipse.swt.browser.Browser
  class Browser
    import org.eclipse.swt.browser.BrowserFunction
  end
  
  class RRunnable
    include java.lang.Runnable

    def initialize(&block)
      @block = block
    end

    def run
      @block.call
    end
  end
end
