class Image < ActiveRecord::Base
  belongs_to :article
  
  named_scope :originals, :conditions => ["parent_id IS NULL"]
  
  has_attachment   :article_type => :image,
                   :path_prefix  => 'public/imageupload',
                   :processor => 'rmagick',
                   :storage => :file_system, 
                   :max_size => 1024.kilobytes, # 1MB
                   :resize_to => '500x500>',
                   :thumbnails => { :thumb100 => '100x100>', 
                                    :thumb200 => '200x200>', 
                                    :thumb300 => '300x300>',
                                    :thumb400 => '400x400>' }

  validates_as_attachment
  
  #def before_destroy
  #  if article 
  #    raise "Can't delete images that are being used in an article"
  #  end
  #end
end
