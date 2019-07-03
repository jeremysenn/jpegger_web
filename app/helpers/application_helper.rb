module ApplicationHelper
  
  def camera_classes
    [['Article Image', 'A'], ['Customer image', 'C'], ['Customer ID image', 'I'], ['Customer thumbprint image', 'T'], ['Customer signature', 'S'], ['Vehicle image', 'V'], ['Do not send image', 'N'], ['Document', 'D']]
  end
  
  def camera_positions
    [['Directly above', 'A'], ['From behind', 'B'], ['From left/driver side', 'D'], ['From front', 'F'], ['Not supplied or not applicable', 'N'], ['Right/passenger side', 'P'], ['Unspecified side', 'S']]
  end
  
  def camera_class_string(camera_class)
    camera_class_hash = {'A' => 'Article Image', 'C' => 'Customer image', 'I' => 'Customer ID image', 'T' => 'Customer thumbprint image', 'S' => 'Customer signature', 'V' => 'Vehicle image', 'N' => 'Do not send image', 'D' => 'Document'}
    return camera_class_hash[camera_class]
  end
  
  def camera_position_string(camera_position)
    camera_position_hash = {'A' => 'Directly above', 'B' => 'From behind', 'D' => 'From left/driver side', 'F' => 'From front', 'N' => 'Not supplied or not applicable', 'P' => 'Right/passenger side', 'S' => 'Unspecified side'}
    return camera_position_hash[camera_position]
  end
  
end
