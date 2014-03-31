# -*- encoding : utf-8 -*-
require 'blacklight/catalog'

class CatalogController < ApplicationController 

  include Blacklight::Catalog

  configure_blacklight do |config|
    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = { 
      # :qt => 'query',
      :start => 0,
      :rows => 10,
      # :defType => 'dismax',
      # :df => 'text',
      # :q => 'text',
      # :fq => ['layer_bbox'],
      # :fq => ['layer_bbox:"IsWithin(-88 26 -79 36)"'],
      # :sort => 'score desc'
      # :qf => 'ThemeKeywordsExact',
      # :pf => 'LayerDisplayName^10',
      'q.alt' => '*:*'
    }

    ## Default parameters to send on single-document requests to Solr. These settings are the Blackligt defaults (see SolrHelper#solr_doc_params) or 
    ## parameters included in the Blacklight-jetty document requestHandler.
    #
    config.default_document_solr_params = {
     :qt => 'document',
     ## These are hard-coded in the blacklight 'document' requestHandler
     # :fl => '*',
     # :rows => 1
     :q => '{!raw f=layer_slug_s v=$id}' 
    }

    # solr field configuration for search results/index views
    # config.index.show_link = 'title_display'
    # config.index.record_display_type = 'format'

    config.index.title_field = 'dc_title_s'

    # solr field configuration for document/show views
    
    config.show.display_type_field = 'format'



    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    #
    # Setting a limit will trigger Blacklight's 'more' facet values link.
    # * If left unset, then all facet values returned by solr will be displayed.
    # * If set to an integer, then "f.somefield.facet.limit" will be added to
    # solr request, with actual solr request being +1 your configured limit --
    # you configure the number of items you actually want _displayed_ in a page.    
    # * If set to 'true', then no additional parameters will be sent to solr,
    # but any 'sniffed' request limit parameters will be used for paging, with
    # paging at requested limit -1. Can sniff from facet.limit or 
    # f.specific_field.facet.limit solr request params. This 'true' config
    # can be used if you set limits in :default_solr_params, or as defaults
    # on the solr side in the request handler itself. Request handler defaults
    # sniffing requires solr requests to be made with "echoParams=all", for
    # app code to actually have it echo'd back to see it.  
    #
    # :show may be set to false if you don't want the facet to be drawn in the 
    # facet bar
    # config.add_facet_field 'format', :label => 'Format'
    # config.add_facet_field 'pub_date', :label => 'Publication Year', :single => true
    # config.add_facet_field 'subject_topic_facet', :label => 'Topic', :limit => 20 
    # config.add_facet_field 'language_facet', :label => 'Language', :limit => true 
    # config.add_facet_field 'lc_1letter_facet', :label => 'Call Number' 
    # config.add_facet_field 'subject_geo_facet', :label => 'Region' 
    # config.add_facet_field 'layer_bbox', :fq => "layer_bbox:IsWithin(-88,26,-79,36)", :label => 'Spatial'  

    # config.add_facet_field 'example_pivot_field', :label => 'Pivot Field', :pivot => ['format', 'language_facet']

    # config.add_facet_field 'example_query_facet_field', :label => 'Publish Date', :query => {
    #    :years_5 => { :label => 'within 5 Years', :fq => "pub_date:[#{Time.now.year - 5 } TO *]" },
    #    :years_10 => { :label => 'within 10 Years', :fq => "pub_date:[#{Time.now.year - 10 } TO *]" },
    #    :years_25 => { :label => 'within 25 Years', :fq => "pub_date:[#{Time.now.year - 25 } TO *]" }
    # }

    config.add_facet_field 'dc_source_s', :label => 'Institution', :limit => 7
    config.add_facet_field 'dc_creator_sm', :label => 'Author', :limit => 6
    config.add_facet_field 'dc_publisher_s', :label => 'Publisher', :limit => 6
    config.add_facet_field 'layer_collection_s', :label => 'Collection', :limit => 6
    config.add_facet_field 'dc_subject_sm', :label => 'Subject', :limit => 6
    config.add_facet_field 'dc_coverage_spatial_sm', :label => 'Place', :limit => 6

    config.add_facet_field 'layer_year_i', :label => 'Year', :limit => 10, :range => {
      # :num_segments => 6,
      :assumed_boundaries => [1100, 2015]
      # :segments => true    
    }

    config.add_facet_field 'dc_format_s', :label => 'Format', :limit => 3
    config.add_facet_field 'layer_geom_type_s', :label => 'Data type', :limit => 5
    config.add_facet_field 'dc_rights_s', :label => 'Access', :limit => 3
    config.add_facet_field 'dc_language_s', :label => 'Language', :limit => 3
    config.add_facet_field 'layer_srs_s', :label => 'Projection', :limit => 6


    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display 
    # config.add_index_field 'title_display', :label => 'Title:' 
    # config.add_index_field 'title_vern_display', :label => 'Title:' 
    # config.add_index_field 'author_display', :label => 'Author:' 
    # config.add_index_field 'author_vern_display', :label => 'Author:' 
    # config.add_index_field 'format', :label => 'Format:' 
    # config.add_index_field 'language_facet', :label => 'Language:'
    # config.add_index_field 'published_display', :label => 'Published:'
    # config.add_index_field 'published_vern_display', :label => 'Published:'
    # config.add_index_field 'lc_callnum_display', :label => 'Call number:'

    # config.add_index_field 'dc_title_t', :label => 'Display Name:'
    # config.add_index_field 'dc_source_s', :label => 'Institution:'
    # config.add_index_field 'dc_rights_s', :label => 'Access:'
    # # config.add_index_field 'Area', :label => 'Area:'
    # config.add_index_field 'dc_subject_sm', :label => 'Keywords:'



    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display 
    # config.add_show_field 'dc_title_t', :label => 'Title:' 
    # config.add_show_field 'title_display', :label => 'Title:' 
    # config.add_show_field 'title_vern_display', :label => 'Title:' 
    # config.add_show_field 'subtitle_display', :label => 'Subtitle:' 
    # config.add_show_field 'subtitle_vern_display', :label => 'Subtitle:' 
    # config.add_show_field 'author_display', :label => 'Author:' 
    # config.add_show_field 'author_vern_display', :label => 'Author:' 
    # config.add_show_field 'format', :label => 'Format:' 
    # config.add_show_field 'url_fulltext_display', :label => 'URL:'
    # config.add_show_field 'url_suppl_display', :label => 'More Information:'
    # config.add_show_field 'language_facet', :label => 'Language:'
    # config.add_show_field 'published_display', :label => 'Published:'
    # config.add_show_field 'published_vern_display', :label => 'Published:'
    # config.add_show_field 'lc_callnum_display', :label => 'Call number:'
    # config.add_show_field 'isbn_t', :label => 'ISBN:'

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different. 

    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise. 

    # config.add_search_field 'text', :label => 'All Fields'
    # config.add_search_field 'dc_title_ti', :label => 'Title'
    # config.add_search_field 'dc_description_ti', :label => 'Description'    

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields. 
    
    # config.add_search_field('title') do |field|
    #   # solr_parameters hash are sent to Solr as ordinary url query params. 
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'title' }

    #   # :solr_local_parameters will be sent using Solr LocalParams
    #   # syntax, as eg {! qf=$title_qf }. This is neccesary to use
    #   # Solr parameter de-referencing like $title_qf.
    #   # See: http://wiki.apache.org/solr/LocalParams
    #   field.solr_local_parameters = { 
    #     :qf => '$title_qf',
    #     :pf => '$title_pf'
    #   }
    # end
    
    # config.add_search_field('author') do |field|
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'author' }
    #   field.solr_local_parameters = { 
    #     :qf => '$author_qf',
    #     :pf => '$author_pf'
    #   }
    # end
    
    # # Specifying a :qt only to show it's possible, and so our internal automated
    # # tests can test it. In this case it's the same as 
    # # config[:default_solr_parameters][:qt], so isn't actually neccesary. 
    # config.add_search_field('subject') do |field|
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'subject' }
    #   field.qt = 'search'
    #   field.solr_local_parameters = { 
    #     :qf => '$subject_qf',
    #     :pf => '$subject_pf'
    #   }
    # end

    #  config.add_search_field('Institution') do |field|
    #   field.solr_parameters = { :'spellcheck.dictionary' => 'Institution' }
    #   field.solr_local_parameters = { 
    #     :qf => '$Institution_qf',
    #     :pf => '$Institution_pf'
    #   }
    # end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    config.add_sort_field 'score desc, dc_title_sort asc', :label => 'relevance'
    config.add_sort_field 'layer_year_i desc, dc_title_sort asc', :label => 'year'
    # config.add_sort_field 'dc_creator_sort asc, dc_title_sort asc', :label => 'author'
    config.add_sort_field 'dc_publisher_sort asc, dc_title_sort asc', :label => 'publisher'
    config.add_sort_field 'dc_title_sort asc', :label => 'title'
    config.add_sort_field 'layer_collection_sort asc, dc_title_sort asc', :label => 'collection'

    # If there are more than this many search results, no spelling ("did you 
    # mean") suggestion is offered.
    config.spell_max = 5
  end



end 