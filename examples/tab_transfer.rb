require 'java'
require File.expand_path(File.join(__FILE__, '../../swt/swt_wrapper'))

class TabTransfer < Swt::DND::ByteArrayTransfer
  
  class TabType
    # Empty class for now
  end
	
	TAB_TYPE = "TabType"
	TAB_TYPE_ID = register_type(TAB_TYPE)
  @@instance = nil
 
  def self.get_instance
    @@instance || TabTransfer.new
  end
  
  def java_to_native(types, transfer_data)
    return if (types == null || types.empty? || (types.first.class != TabType))
 	
   	if (is_supported_type(transfer_data))
      super(TAB_TYPE.to_java_bytes, transfer_data)
    end
  end
  
  def native_to_java(transfer_data)
   	if (is_supported_type(transfer_data))
      buffer = super(transferData)
      return nil unless buffer
 		
      if String.from_java_bytes buffer == TAB_TYPE
        return [TabType.new]
      end
    end
    return nil
  end
  
  def get_type_names
    [TAB_TYPE].to_java(:string)
  end
  
  def get_type_ids
    [TAB_TYPE_ID].to_java(:int)
  end
  
  def getTypeIds
    get_type_ids
  end
  
  def getTypeNames
    get_type_names
  end
end
