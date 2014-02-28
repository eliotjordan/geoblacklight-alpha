module BlacklightHelper
  include Blacklight::BlacklightHelperBehavior

  def application_name
    "GeoBlacklight"
  end

  def render_document_partial(doc, action_name, locals = {})
    # return action_name.to_s + doc.to_s

    format = document_partial_name(doc)

    # puts doc["LayerDisplayName"]
    # # puts action_name
    # # puts render_document_partial
    # # puts document_partial_path_templates
    # puts action_name
    if action_name.to_s == 'index_header'
      document_partial_path_templates.each do |str|
        # XXX rather than handling this logic through exceptions, maybe there's a Rails internals method
        # for determining if a partial template exists..
        begin
          # puts format
          return render :partial => (str % { :action_name => action_name, :format => format, :index_view_type => document_index_view_type }), :locals=>locals.merge({:document=>doc})
        rescue ActionView::MissingTemplate
          nil
        end
      end
    else
      if action_name.to_s == 'index'
        return render :partial => 'listview', :locals => locals.merge({:document => doc})
        # return render :partial => 'themename_tags', :locals => {:keywords => doc['ThemeKeywords']}

      end
      if action_name.to_s == 'show'
        return render :partial => 'mapview', :locals => {:document => doc}
      end
    end


    return ''
  end


  def place_tag_labels
    return "Hello"
  end



end