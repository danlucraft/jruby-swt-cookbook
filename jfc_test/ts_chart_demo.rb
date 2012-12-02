require 'java'
require 'swt/swt_wrapper'
require 'jfreechart/jfreechart_wrapper'

puts "Starting demo!"

class TimeSeriesExample
  
  def initialize
    # A Display is the connection between SWT and the native GUI. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Display.html)
    display = Swt::Widgets::Display.get_current
  
    # A Shell is a window in SWT parlance. (jruby-swt-cookbook/apidocs/org/eclipse/swt/widgets/Shell.html)
    @shell = Swt::Widgets::Shell.new
    
    # A Shell must have a layout. FillLayout is the simplest.
    layout = Swt::Layout::FillLayout.new
    @shell.setLayout(layout)

    # create a jfreechart!
    chart = create_chart(create_dataset)
    frame = Jfree::Experimental::Chart::Swt::ChartComposite.new(@shell, Swt::SWT::NONE, chart, true);
    frame.setDisplayToolTips(true);
    frame.setHorizontalAxisTrace(false);
    frame.setVerticalAxisTrace(false);
    
    @shell.setSize(1000, 500);
    @shell.setText("Time series demo for jfreechart running with SWT");
    
    # This lays out the widgets in the Shell
    #@shell.pack

    # And this displays the Shell
    @shell.open
  end
  
  def create_chart(dataset)
    chart = Jfree::Chart::ChartFactory.createTimeSeriesChart(
        "Legal & General Unit Trust Prices",  # title
        "Date",             # x-axis label
        "Price Per Unit",   # y-axis label
        dataset,            # data
        true,               # create legend?
        true,               # generate tooltips?
        false               # generate URLs?
    );

    chart.setBackgroundPaint(java.awt.Color.white);

    plot = chart.getPlot();
    plot.setBackgroundPaint(java.awt.Color.lightGray);
    plot.setDomainGridlinePaint(java.awt.Color.white);
    plot.setRangeGridlinePaint(java.awt.Color.white);
    plot.setAxisOffset(Jfree::Ui::RectangleInsets.new(5.0, 5.0, 5.0, 5.0));
    plot.setDomainCrosshairVisible(true);
    plot.setRangeCrosshairVisible(true);
    
    renderer = plot.getRenderer();
    renderer.setBaseShapesVisible(true);
    renderer.setBaseShapesFilled(true);
    
    axis = plot.getDomainAxis();
    axis.setDateFormatOverride(java.text.SimpleDateFormat.new("MMM-yyyy"));
    
    chart
  end
  
  def create_dataset
    s1 = Jfree::Data::Time::TimeSeries.new("L&G European Index Trust")
    s1.add(Jfree::Data::Time::Month.new(2, 2001), 181.8)
    s1.add(Jfree::Data::Time::Month.new(3, 2001), 167.3)
    s1.add(Jfree::Data::Time::Month.new(4, 2001), 153.8)
    s1.add(Jfree::Data::Time::Month.new(5, 2001), 167.6)
    s1.add(Jfree::Data::Time::Month.new(6, 2001), 158.8)
    s1.add(Jfree::Data::Time::Month.new(7, 2001), 148.3)
    s1.add(Jfree::Data::Time::Month.new(8, 2001), 153.9)
    s1.add(Jfree::Data::Time::Month.new(9, 2001), 142.7)
    s1.add(Jfree::Data::Time::Month.new(10, 2001), 123.2)
    s1.add(Jfree::Data::Time::Month.new(11, 2001), 131.8)
    s1.add(Jfree::Data::Time::Month.new(12, 2001), 139.6)
    s1.add(Jfree::Data::Time::Month.new(1, 2002), 142.9)
    s1.add(Jfree::Data::Time::Month.new(2, 2002), 138.7)
    s1.add(Jfree::Data::Time::Month.new(3, 2002), 137.3)
    s1.add(Jfree::Data::Time::Month.new(4, 2002), 143.9)
    s1.add(Jfree::Data::Time::Month.new(5, 2002), 139.8)
    s1.add(Jfree::Data::Time::Month.new(6, 2002), 137.0)
    s1.add(Jfree::Data::Time::Month.new(7, 2002), 132.8)

    s2 = Jfree::Data::Time::TimeSeries.new("L&G UK Index Trust")
    s2.add(Jfree::Data::Time::Month.new(2, 2001), 129.6)
    s2.add(Jfree::Data::Time::Month.new(3, 2001), 123.2)
    s2.add(Jfree::Data::Time::Month.new(4, 2001), 117.2)
    s2.add(Jfree::Data::Time::Month.new(5, 2001), 124.1)
    s2.add(Jfree::Data::Time::Month.new(6, 2001), 122.6)
    s2.add(Jfree::Data::Time::Month.new(7, 2001), 119.2)
    s2.add(Jfree::Data::Time::Month.new(8, 2001), 116.5)
    s2.add(Jfree::Data::Time::Month.new(9, 2001), 112.7)
    s2.add(Jfree::Data::Time::Month.new(10, 2001), 101.5)
    s2.add(Jfree::Data::Time::Month.new(11, 2001), 106.1)
    s2.add(Jfree::Data::Time::Month.new(12, 2001), 110.3)
    s2.add(Jfree::Data::Time::Month.new(1, 2002), 111.7)
    s2.add(Jfree::Data::Time::Month.new(2, 2002), 111.0)
    s2.add(Jfree::Data::Time::Month.new(3, 2002), 109.6)
    s2.add(Jfree::Data::Time::Month.new(4, 2002), 113.2)
    s2.add(Jfree::Data::Time::Month.new(5, 2002), 111.6)
    s2.add(Jfree::Data::Time::Month.new(6, 2002), 108.8)
    s2.add(Jfree::Data::Time::Month.new(7, 2002), 101.6)
    
    dataset = Jfree::Data::Time::TimeSeriesCollection.new
    dataset.addSeries(s1)
    dataset.addSeries(s2)
    
    dataset
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

Swt::Widgets::Display.set_app_name "Timeseries Example"
 
app = TimeSeriesExample.new
app.start
exit