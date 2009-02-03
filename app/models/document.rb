class Document < ActiveRecord::Base
  
  belongs_to :component
  belongs_to :article
  
  has_attachment    :max_size => 9.megabytes,
                    :content_type => ['application/pdf', 
                                      'application/msword', 
                                      'application/msexcel', 
                                      'application/vnd.ms-excel',
                                      'application/vnd.ms-powerpoint',
                                      'application/octet-stream',
                                      'text/rtf',
                                      'text/plain',
                                      'audio/mpeg'],
                    :storage => :file_system
                    
  validates_as_attachment
  validates_presence_of :name
  
  ORDER_OPTIONS = [
    [ 'Created Descending', 'created_at DESC' ],
    [ 'Created Ascending', 'created_at ASC' ],
    [ 'Name Descending', 'name DESC' ],
    [ 'Name Ascending', 'name ASC' ]
  ]
  
end


