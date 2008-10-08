class Document < ActiveRecord::Base
  
  belongs_to :component
  
  has_attachment    :max_size => 4.megabytes,
                    :content_type => ['application/pdf', 
                                      'application/msword', 
                                      'application/msexcel', 
                                      'application/vnd.ms-excel',
                                      'application/mspowerpoint',
                                      'application/octet-stream',
                                      'text/rtf',
                                      'text/plain'],
                    :storage => :file_system
                    
  validates_as_attachment
  validates_presence_of :name
end


