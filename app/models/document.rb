class Document < ActiveRecord::Base
  
  belongs_to :component
  
  has_attachment    :max_size => 4.megabytes,
                    :content_type => ['application/pdf', 
                                      'application/ms-word', 
                                      'application/ms-excel', 
                                      'application/ms-powerpoint', 
                                      'text/plain'],
                    :storage => :file_system
                    
  validates_as_attachment
  validates_presence_of :name
end


