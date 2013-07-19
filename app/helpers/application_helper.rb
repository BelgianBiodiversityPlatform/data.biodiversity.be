# Require our custom application helpers

require './lib/custom_application_helper'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def stylesheet_link_tag_with_custom(name)
    stylesheet_link_tag(name) + stylesheet_link_tag('custom/' + name)
  end

  def partial_name_localized(name)
    "#{name}.#{I18n.locale.to_s}"
  end

  def back_to_top
    '<p class="btt">' + link_to(t('back_to_top'), :anchor => 'container') + '</p>'
  end

  def ajax_spinner(html_id)
    image_tag 'ajax-loader.gif', :id => html_id, :style => 'display: inline-block; display: none; float: right;', :alt => 'AJAX Loader'
  end

  # Generics links_to

  def link_to_col2010(name = 'Catalogue of Life - 2010 Annual Checklist', options = {:class => 'external'})
    link_to name, 'http://www.catalogueoflife.org/annual-checklist/2010/info/ac', options
  end

  def link_to_gbif(name = 'GBIF', options = {:class => 'external'})
    link_to name, 'http://www.gbif.org', options
  end

  def link_to_gbif_occurrence(key, name=nil, options = {})
    name = key.to_s unless name
    link_to name, "http://data.gbif.org/occurrences/#{key.to_s}", options
  end

  def link_to_gbif_provider(name, key, options = {})
    link_to name , "http://data.gbif.org/datasets/provider/#{key}", options
  end

  def link_to_gbif_resource(name, key, options = {})
    link_to name, "http://data.gbif.org/datasets/resource/#{key}", options
  end

end
