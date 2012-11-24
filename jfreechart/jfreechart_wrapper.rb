require 'java'
require 'swt/swt_wrapper'

module Jfree
  
  def self.jars
    [
      'jcommon-1.0.16',
      'swtgraphics2d',
      'jfreechart-1.0.13',
      'jfreechart-1.0.13-swt',
      'jfreechart-1.0.13-experimental',
      'iText-2.1.5'
    ]
  end

  Jfree.jars.each do |jar|
    path = File.expand_path(File.dirname(__FILE__) + "/../jfreechart/" + jar)
    if File.exist?(path + ".jar")
      puts "loading #{jar}"
      require path
    else
      raise "jar file required: #{path}.jar"
    end
  end
  
  module Chart
    import org.jfree.chart.ChartFactory
    import org.jfree.chart.JFreeChart
    module Axis
      import org.jfree.chart.axis.DateAxis
    end
    module Plot
      import org.jfree.chart.plot.XYPlot
    end
    module Renderer
      module Xy
        import org.jfree.chart.renderer.xy.XYItemRenderer
        import org.jfree.chart.renderer.xy.XYLineAndShapeRenderer
      end
    end
  end
  
  module Data
    module Time
      import org.jfree.data.time.Month
      import org.jfree.data.time.TimeSeries
      import org.jfree.data.time.TimeSeriesCollection
    end
    module Xy
      import org.jfree.data.xy.XYDataset
    end
  end
  
  module Experimental
    module Chart
      module Swt
        import org.jfree.experimental.chart.swt.ChartComposite
      end
    end
  end
  
  module Ui
    import org.jfree.ui.RectangleInsets
  end
end