class ProjectsController < ApplicationController
  
  before_filter :set_main_menu,
                :set_prefix_title,
                :add_my_custom_path,
                :set_projects_css

  def sub_layout
    'projects'
  end

  private

  def set_prefix_title
    @controller_title_prefix = t('page_titles.projects_prefix')
  end

  def set_projects_css
    @css_to_load = 'projects'
  end

  def set_main_menu
    @selected_menu = :projects
  end

  # This adds our custom view path to find our custom views
  def add_my_custom_path
    prepend_view_path("app/views/custom/")
  end
end


