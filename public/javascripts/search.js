var Cdp = {
    search: {
        filters: new Object,
        type: 'occurrences',
        results_configuration: {
            map_on_page: false,
            page: 1,
            sort: 'occurrences.key'
        }
    }

};

// Called when a datasource select (provider country, provider or resource) is changed
function updateProvFilters(elem_changed) {
    //formstatus[elem_changed.id] = $F(elem_changed);
    if (elem_changed.id == 'occ_providercountry_id') {
        // No parent, we just have to refresh the children
        // AJAX request to update the providers for this country only
        myUpdater('occ_provider_id', 'provider_select_after_country_change' , {
            country_id: $F(elem_changed)
            })
        // A second one to display only resources of the selected country
        myUpdater('occ_resource_id', 'resource_select_after_country_change', {
            country_id: $F(elem_changed)
            })
    }

    // We changed the provider
    if (elem_changed.id == 'occ_provider_id') {

        // Only if specific choice, we have to update the three levels
        if ($F(elem_changed) != 'ALL') {
            myUpdater('occ_providercountry_id', 'country_select_after_provider_change', {
                provider_id: $F(elem_changed)
                });
            myUpdater('occ_provider_id', 'provider_select_after_self_change',{
                provider_id: $F(elem_changed)
                });
            myUpdater('occ_resource_id', 'resource_select_after_provider_change', {
                provider_id: $F(elem_changed)
                });
        // Specific actions when provider has no parent, managed on the server side
        }
        else // If all, we have to display all resources of the country
        {
            myUpdater('occ_resource_id', 'resource_select_after_country_change', {
                country_id: $F('occ_providercountry_id')
                })
        }
    }
    // If we changed resource
    if (elem_changed.id == 'occ_resource_id') {
        if ($F(elem_changed) != 'ALL') {
            // We sets the parents, starting at provider and then country
            // Resource must also be set on self, with siblings displayed
            myUpdater('occ_resource_id', 'resource_select_after_self_change', {
                resource_id: $F(elem_changed)
                })
            myUpdater('occ_provider_id', 'provider_select_after_resource_change', {
                resource_id: $F(elem_changed)
                });
            myUpdater('occ_providercountry_id', 'country_select_after_resource_change', {
                resource_id: $F(elem_changed)
                });
        }
    /*else {
            // Don't have to update the datasource form, but we have to update the results, so we call directly updateResults
            updateResults();
        }*/
    }
}

// execute the AJAX request and update the HTML element
function myUpdater(element_to_update, action, parameters) {
    spinner_id = element_to_update + '_spinner'
    Element.show(spinner_id);
    new Ajax.Request(action, {
        parameters: parameters,
        onSuccess: function(transport) {
            json = transport.responseText.evalJSON();
            
            // Need this to prevent stupid IE bug
            sorted_results = sortResults(json.results);

            var i=0;
            $(element_to_update).options.length = 0;
            sorted_results.each(function(res) {
                $(element_to_update).options[i] = new Option(res.name, res.value);
                i++;
            });


            $(element_to_update).value = json.selected_id;
            //form_status[element_to_update] = json.selected_id;
            
            Element.hide(element_to_update + '_spinner');
        }

    });

    function sortResults(results) {
        return results.sort(mysort);

        function mysort(a,b) {
            if (a.name < b.name)
                return -1;
            else
                return 1
        }
    }

}

function start_search() {
    // For when we're, for example, on the last page of a large resultset, and the switch to a smaller resultset
    Cdp.search.results_configuration.page = 1;

    // Collect different values in the form and populate the filters object.
    Cdp.search.filters.sn = formtext_to_filters('sn');
    Cdp.search.filters.locality = formtext_to_filters('locality');

    // For the 3 datasources select
    Cdp.search.filters.providercountry_id = formselect_to_filters('occ_providercountry_id');
    Cdp.search.filters.provider_id = formselect_to_filters('occ_provider_id');
    Cdp.search.filters.resource_id = formselect_to_filters('occ_resource_id');

    // from collected / observed
    Cdp.search.filters.collected_before = formtext_to_filters('collec_date_before');
    Cdp.search.filters.collected_after = formtext_to_filters('collec_date_after');

    Cdp.search.filters.min_lat = formtext_to_filters('minimum_lat');
    Cdp.search.filters.max_lat = formtext_to_filters('maximum_lat');
    Cdp.search.filters.min_lon = formtext_to_filters('minimum_lon');
    Cdp.search.filters.max_lon = formtext_to_filters('maximum_lon');

    // And execute the query
    loadMyResults(Cdp.search);

    // Small helper to help mapping <select's> (datasource) to "filters" object.
    function formselect_to_filters(elem_id) {
        if ($F(elem_id) != 'ALL')
            return $F(elem_id);
        else 
            return undefined;
    }

    function formtext_to_filters(elem_id) {
       if ($F(elem_id) != '')
            return $F(elem_id);
        else
            return undefined;
    }


}


