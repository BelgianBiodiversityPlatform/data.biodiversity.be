module PagesHelper
  
  # params: :name, :db_field, :html_id
  def rt_sortable_header(prm = {})
    # TODO: Access to global Cdp.search... BAD BAD !!
    txt = link_to_function prm[:name], "sortByField(Cdp.search, '#{prm[:db_field]}')", :id => prm[:html_id]
    
    line = "if (Cdp.search.results_configuration.sort == '#{prm[:db_field]}') {$('#{prm[:html_id]}').addClassName('current')}"
    
    txt += content_tag(:script, line,  :type =>'text/javascript')    

    txt
  end

  def select_for_datasource(html_id, collection, selected)

    if selected == 'ALL'
      options = '<option value="ALL" selected="selected">-- ALL --</option>' + options_from_collection_for_select(collection, :id, :name)
    else
      options = '<option value="ALL">-- ALL --</option>' + options_from_collection_for_select(collection, :id, :name, selected)
    end

    select_tag  html_id,
                options,
                :onchange => "updateProvFilters(this);"
  end
end
