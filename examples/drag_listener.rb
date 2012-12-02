require 'java'
require File.expand_path(File.join(__FILE__, '../../swt/swt_wrapper'))

class ExDragListener
  include org.eclipse.swt.dnd.DragSourceListener
  include org.eclipse.swt.dnd.DropTargetListener
  
  class MPaintListener
    include org.eclipse.swt.events.PaintListener
    
    attr_accessor :selected_item
    
    def initialize(tabfolder)
      @folder = tabfolder
      @selected_item = nil
    end
    
    def paintControl(event)
      if @selected_item
        clientArea = @selected_item.bounds
        event.gc.drawRectangle(clientArea)
      end
    end
  end
  
  def initialize(tab_folder)
    @tab_folder = tab_folder
    @paint_listener = MPaintListener.new(@tab_folder)
  end
  
  def dragStart(dsEvent)
    @dragging = true
    @source_item = @tab_folder.get_selection
    @tab_folder.addPaintListener(@paint_listener) 
  end
  
  def dragFinished(dsEvent)
    @dragging = false
    @paint_listener.selected_item = nil
    @tab_folder.removePaintListener(@paint_listener)
    @tab_folder.redraw
  end
  
  def dropAccept(event)
    event.detail = Swt::DND::DND::DROP_NONE # Don't actually accept the drop
    if @dragging && @source_item
      target_tab_item = @tab_folder.get_item(@tab_folder.to_control(event.x, event.y))
      unless target_tab_item # drop happened behing the tabs
        target_tab_item = @tab_folder.get_items[@tab_folder.get_items.length - 1]
      end
      unless target_tab_item == @source_item # items need to be moved
        insert(@source_item, target_tab_item)
      end
    end
    dragFinished(event)
  end
  
  def insert(item1, item2)
    if @tab_folder.index_of(item1) < @tab_folder.index_of(item2)
      insert_after(item1, item2)
    else
      insert_before(item1, item2)
    end
    @tab_folder.set_selection(item2)
  end
  
  def insert_after(item1, item2)
    # Exclude the last item from the list of moving items -> the moved on will go there
    moving_items = @tab_folder.get_items[@tab_folder.index_of(item1)...@tab_folder.index_of(item2)]
    # Save the item's values, that is to be moved
    saved_values = [item1.get_control, item1.get_font, item1.get_tool_tip_text, item1.get_text]
    
    moving_items.each do |item| # move all tabs down from right to left
      next_item = @tab_folder.get_item(@tab_folder.index_of(item) + 1)
      item.set_control(next_item.get_control)
      item.set_font(next_item.get_font)
      item.set_tool_tip_text(next_item.get_tool_tip_text)
      item.set_text(next_item.get_text)
    end
    
    # finally, update the last item to make it the new position of the dropped item
    item2.set_control(saved_values[0])
    item2.set_font(saved_values[1])
    item2.set_tool_tip_text(saved_values[2])
    item2.set_text(saved_values[3])
  end
  
  def insert_before(item1, item2)
    # Exclude the first item from the list of moving items -> the moved on will go there
    moving_items_reverse = @tab_folder.get_items[(@tab_folder.index_of(item2) + 1)..@tab_folder.index_of(item1)]
    # Save the item's values, that is to be moved to the front
    saved_values = [item1.get_control, item1.get_font, item1.get_tool_tip_text, item1.get_text]
    
    moving_items = moving_items_reverse.to_a
    #moving_items_reverse.each {|i| moving_items << i}
    moving_items.reverse.each do |item| # move all tabs up from left to right
      next_item = @tab_folder.get_item(@tab_folder.index_of(item) - 1)
      item.set_control(next_item.get_control)
      item.set_font(next_item.get_font)
      item.set_tool_tip_text(next_item.get_tool_tip_text)
      item.set_text(next_item.get_text)
    end
    
    # finally, update the last item to make it the new position of the dropped item
    item2.set_control(saved_values[0])
    item2.set_font(saved_values[1])
    item2.set_tool_tip_text(saved_values[2])
    item2.set_text(saved_values[3])
  end
  
  # Must implement the java interface
  def dragSetData(dsEvent); end
  def dragEnter(event); end
  def dragLeave(event); end
  def dragOperationChanged(event); end
  def dragOver(event)
    target_tab_item = @tab_folder.get_item(@tab_folder.to_control(event.x, event.y))
    unless target_tab_item # drop happened behing the tabs
      target_tab_item = @tab_folder.get_items[@tab_folder.get_items.length - 1]
    end
    @paint_listener.selected_item = target_tab_item
    @tab_folder.redraw
  end
  def drop(event); end
end