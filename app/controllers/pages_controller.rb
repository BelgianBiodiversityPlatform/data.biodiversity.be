class PagesController < ApplicationController
  protect_from_forgery :except => [ :autocomplete_sn,
                                    :provider_select_after_country_change,
                                    :resource_select_after_country_change,
                                    :country_select_after_provider_change,
                                    :resource_select_after_provider_change,
                                    :provider_select_after_self_change,
                                    :resource_select_after_self_change,
                                    :provider_select_after_resource_change,
                                    :country_select_after_resource_change ]


  def occurrence_details
    @occurrence = Occurrence.find(params[:id])
    render :layout => 'minimal'
  end

  # To autocomplete scientific name on search (index page)
  def autocomplete_sn
    render :partial => 'autocomplete', :object => Scientificname.find(:all, :conditions => ['name ILIKE ?', params[:sn] + '%' ])
  end

  def index
    @selected_menu = :home

    @counter_all = Stat.count_all
    @counter_georef = Stat.count_georef
    @last_update = Stat.last_updated
    
    render 'index2'
  end
  
  def oldindex
    @selected_menu = :home

    @counter_all = Stat.count_all
    @counter_georef = Stat.count_georef
    @last_update = Stat.last_updated
    
    render 'index'
  end

  def search
    @selected_menu = :search
  end

  def contact
    @selected_menu = :contact

    if request.post?
      if valid_contact_params?(params)
        flash[:success] = t('contact.msg_ok')
        ContactMailer.deliver_contact_email(params)
        redirect_to :action => 'index'
      else
        flash.now[:error] = t('contact.msg_error')
        @spamcode = session[:spamcode]
      end
    else # GET, we generate a captcha and store in the session
      @spamcode = (rand*1000).to_i
      session[:spamcode] = @spamcode
    end
  end

  def about
    @selected_menu = :about
    render :template => 'custom/pages/about'
  end

  # AJAX requests for search page.
  def provider_select_after_country_change
    collec = params[:country_id] == 'ALL' ? Provider.for_search_select : Provider.from_country_id(params[:country_id].to_i).for_search_select
    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => 'ALL'
                    }
  end

  def resource_select_after_country_change
    collec = params[:country_id] == 'ALL' ? Resource.for_search_select : Resource.from_country_id(params[:country_id]).for_search_select #Country.find(params[:country_id]).resources
    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => 'ALL'
                    }
  end

  def country_select_after_provider_change
    # We show all the countries
    #  -if provider has parent, select the provider's parent
    #  -else, select ALL
    prov = Provider.find(params[:provider_id])
    sel = prov.country ? prov.country.id : 'ALL'

    render :json => {
                      :results => (Country.for_search_select.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => sel
                    }

  end

  def resource_select_after_provider_change
    collec = Resource.from_provider_id(params[:provider_id].to_i).for_search_select #Provider.find(params[:provider_id]).resources
    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => 'ALL'
                    }
  end

  def provider_select_after_self_change
    selected = Provider.find(params[:provider_id])

    # If provider has a parent, show all siblings
    # else, show everything

    if selected.country
      collec = Provider.from_country_id(selected.country_id).for_search_select
    else
      collec = Provider.for_search_select
    end


    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => selected.id
                    }

  end

  def resource_select_after_self_change
    selected = Resource.find(params[:resource_id])

    collec = Resource.from_provider_id(selected.provider_id).for_search_select

    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => selected.id
                    }
  end

  def provider_select_after_resource_change
    # Select the resource's provider in
    # - If the provide has a country : show all providers from the same country as the selected resource
    # - Else show all providers
    res = Resource.find(params[:resource_id])

    collec = if res.provider.country
               #res.provider.country.providers
               Provider.from_country_id(res.provider.country_id).for_search_select
             else
               Provider.for_search_select
             end

    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => res.provider.id
                    }
  end

  def country_select_after_resource_change
    res = Resource.find(params[:resource_id])

    selected = if res.provider.country
                  res.provider.country.id
               else
                 'ALL'
               end

    collec = Country.for_search_select
    render :json => {
                      :results =>(collec.map{|e| {:name => e.name, :value => e.id}}) << {:name => '-- ALL --', :value => 'ALL'},
                      :selected_id => selected
                    }
  end

 
  private
  # return true if params are valid, false if invalid
  def valid_contact_params?(params)
    r = false
    if !params[:sender_name].blank? and !params[:sender_address].blank? and !params[:message_title].blank? and !params[:message_content].blank? and ((params[:spamcode]).to_i==session[:spamcode])
      r = true
    end
    r
  end

  
end
