# ActsAsIndexed
# Copyright (c) 2007 Douglas F Shearer.
# http://douglasfshearer.com
# Distributed under the MIT license as included with this plugin.

require 'active_record'

require 'search_index'
require 'search_atom'

module Foo #:nodoc:
  module Acts #:nodoc:
    module Indexed #:nodoc:

      def self.included(mod)
        mod.extend(ClassMethods)
      end

      module ClassMethods

        # Declares a class as searchable.
        #
        # ====options:
        # fields:: Names of fields to include in the index. Symbols pointing to
        #          instance methods of your model may also be given here.
        # index_file_depth:: Tuning value for the index partitioning. Larger
        #                    values result in quicker searches, but slower
        #                    indexing. Default is 3.
        # min_word_size:: Sets the minimum length for a word in a query. Words
        #                 shorter than this value are ignored in searches
        #                 unless preceded by the '+' operator. Default is 3.

        def acts_as_indexed(options = {})
          class_eval do
            extend Foo::Acts::Indexed::SingletonMethods
          end
          include Foo::Acts::Indexed::InstanceMethods

          after_create  :add_to_index
          before_update  :update_index
          after_destroy :remove_from_index

          cattr_accessor :aai_config

          # default config
          self.aai_config = { 
            :index_file => [RAILS_ROOT,'index',RAILS_ENV,name],
            :index_file_depth => 3,
            :min_word_size => 3,
            :fields => []
          }

          # set fields
          aai_config[:fields] = options[:fields] if options.include?(:fields)

          # set minimum word size if available.
          aai_config[:min_word_size] = options[:min_word_size] if options.include?(:min_word_size)

          # set index file depth if available.
          # Min size of 1.
          aai_config[:index_file_depth] = options[:index_file_depth].to_i if options.include?(:index_file_depth) && options[:index_file_depth].to_i > 0

          # Set file location for plugin testing.
          # TODO: Find more portable (ruby) way of doing the up-one-level.
          aai_config[:index_file] = [File.dirname(__FILE__),'../test/index',RAILS_ENV,name] if options.include?(:self_test)

        end

        # Adds the passed +record+ to the index. Index is built if it does not already exist. Clears the query cache.

        def index_add(record)
          build_index if !File.exists?(File.join(aai_config[:index_file]))
          index = SearchIndex.new(aai_config[:index_file], aai_config[:index_file_depth], aai_config[:fields], aai_config[:min_word_size])
          index.add_record(record)
          index.save
          @query_cache = {}
          true
        end

        # Removes the passed +record+ from the index. Clears the query cache.

        def index_remove(record)
          index = SearchIndex.new(aai_config[:index_file], aai_config[:index_file_depth], aai_config[:fields], aai_config[:min_word_size])
          # record won't be in index if it doesn't exist. Just return true.
          return true if !index.exists?
          index.remove_record(record)
          index.save
          @query_cache = {}
          true
        end
        
        # Updates the index.
        # 1. Removes the previous version of the record from the index
        # 2. Adds the new version to the index.
        
        def index_update(record)
          build_index if !File.exists?(File.join(aai_config[:index_file]))
          index = SearchIndex.new(aai_config[:index_file], aai_config[:index_file_depth], aai_config[:fields], aai_config[:min_word_size])
          #index.remove_record(find(record.id))
          #index.add_record(record)
          index.update_record(record,find(record.id))
          index.save
          @query_cache = {}
          true
        end

        # Finds instances matching the terms passed in +query+. Terms are ANDed by
        # default. Returns an array of model instances or, if +ids_only+ is
        # true, an array of integer IDs.
        #
        # Keeps a cache of matched IDs for the current session to speed up
        # multiple identical searches.
        #
        # ====find_options
        # A hash passed on to active_record's find when retrieving the data from db, useful for pagination.
        #
        # ====options
        # ids_only:: Method returns an array of integer IDs when set to true.
        # no_query_cache:: Turns off the query cache when set to true. Useful for testing.

        def search_index(query, find_options={}, options={})
          # Clear the query cache off  if the key is set.
          @query_cache = {}  if (options.has_key?('no_query_cache') || options[:no_query_cache])
          if !@query_cache || !@query_cache[query]
            logger.debug('Query not in cache, running search.')
            build_index if !File.exists?(File.join(aai_config[:index_file]))
            index = SearchIndex.new(aai_config[:index_file], aai_config[:index_file_depth], aai_config[:fields], aai_config[:min_word_size])
            @query_cache = {} if !@query_cache
            @query_cache[query] = index.search(query)
          else
            logger.debug('Query held in cache.')
          end
          return @query_cache[query].sort{|a,b| b <=> a }.collect{|a| a.first} if (options.has_key?(:ids_only) && options[:ids_only]) || @query_cache[query].empty?
          
          # slice up the results by offset and limit
          offset = find_options[:offset] || 0
          limit = find_options.include?(:limit) ? find_options[:limit] : @query_cache[query].size
          part_query = @query_cache[query].sort{|a,b| b <=> a }.slice(offset,limit).collect{|a| a.first}
          
          # Set these to nil as we are dealing with the pagination by setting
          # exactly what records we want.
          find_options[:offset] = nil
          find_options[:limit] = nil
          
          with_scope :find => find_options do
            # Doing the find like this eliminates the possibility of errors occuring
            # on either missing records (out-of-sync) or an empty results array.
            records = find(:all, :conditions => [ "#{class_name.tableize}.id IN (?)", part_query])
            
            # Results come back in random order from SQL, so order again.
            ranked_records = {}
            records.each do |r|
              ranked_records[r] = @query_cache[query][r.id]
            end

            ranked_records.to_a.sort{|a,b| b.last <=> a.last }.collect{|a| a.first}
          end
          
        end

        private

        # Builds an index from scratch for the current model class.
        def build_index
          increment = 500
          offset = 0
          while (records = find(:all, :limit => increment, :offset => offset)).size > 0
            #p "offset is #{offset}, increment is #{increment}"
            index = SearchIndex.new(aai_config[:index_file], aai_config[:index_file_depth], aai_config[:fields], aai_config[:min_word_size])
            offset += increment
            index.add_records(records)
            index.save
          end
        end

      end

      # Adds model class singleton methods.
      module SingletonMethods

        # Finds instances matching the terms passed in +query+.
        #
        # See Foo::Acts::Indexed::ClassMethods#search_index.
        def find_with_index(query='', find_options = {}, options = {})
          search_index(query, find_options, options)
        end

      end

      # Adds model class instance methods.
      # Methods are called automatically by ActiveRecord on +save+, +destroy+,
      # and +update+ of model instances.
      module InstanceMethods

        # Adds the current model instance to index.
        # Called by ActiveRecord on +save+.
        def add_to_index
          self.class.index_add(self)
        end

        # Removes the current model instance to index.
        # Called by ActiveRecord on +destroy+.
        def remove_from_index
          self.class.index_remove(self)
        end

        # Updates current model instance index.
        # Called by ActiveRecord on +update+.
        def update_index
          self.class.index_update(self)
        end
      end

    end
  end
end

# reopen ActiveRecord and include all the above to make
# them available to all our models if they want it

ActiveRecord::Base.class_eval do
  include Foo::Acts::Indexed
end