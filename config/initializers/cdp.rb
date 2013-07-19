# encoding: utf-8

# The application name
# Used :
# - In the <title> tags on the generated web pages.
# - In the message sent when a visitor contact you via form on the contact page
APP_NAME = 'Belgian Data Portal' 
AVAILABLE_LOCALES = ['fr', 'nl', 'en']

COUNTRY_BOUNDS = [2.5, 49.5, 6.5, 51.5]

# Must be present even if empty !
OVERLAYS = [
  { :name => {  'en' => 'Natura 2000 zones',
                'fr' => 'Zones Natura 2000',
                'nl' => 'Natura 2000 gebieden'},
    :url => 'http://gis.bebif.be/geoserver2/wms',
    :layer => 'bdp:n2000',
    :srs => 'EPSG:900913' },
  
  { :name => {  'en' => 'CORINE Land Cover (CLC2000)',
                'fr' => 'CORINE Land Cover (CLC2000)',
                'nl' => 'CORINE Land Cover (CLC2000)'},
    :url => 'http://gis.bebif.be/geoserver2/wms',
    :layer => 'eea:mergedandclipped',
    :srs => 'EPSG:900913',
    :legend => {:url => { :action => 'legend_corine'}, # View file should be placed at the in 'views/XXX.html.erb' (will be copied  in app/views/custom/XXX.html.erb)
                :js_params => 'width=800,height=600,scrollbars=yes'
               }
  }
]
GMAP_KEYS = {
	      "development" => "ABQIAAAA_H2Y7BVEZdYUnncdaLmvrxQX9SAbnTELfdk5apeKxOHp_bh8pRTuVbZRACgDBNq8P7A9H9o4YTcoJA", # http://home.bebif.be/...
	      #{}"development" => "ABQIAAAA_H2Y7BVEZdYUnncdaLmvrxTGv8pFig_qdcIeIanIjQzecSm0lRRbfvxEBv0lIg7eYhsaWHMMM2YlJA", #dev
	      "production" => "ABQIAAAA_H2Y7BVEZdYUnncdaLmvrxRrYsWrnXYxzPj6sqpxi3MLWtrLuBTbS_cvpDIuAVr26JlbjnLnk9mcVA" # http://biodiversity.be
            }

CONTACT_EMAIL_RECIPENTS = ['niconoe@ulb.ac.be']

# Used in stats box on the index page
COUNTRY_NAME = {
		  'fr' => 'Belgique', 
		  'en' => 'Belgium', 
		  'nl' => 'België' }

# Is the app protected by an HTTP basic authentication (useful for testing on a public URL before official release)
PASSWORD_PROTECTED = false
# The following two lines are only useful if PASSWORD_PROTECTED = true
#APP_LOGIN = 'cdp'
#APP_PASSWORD = 'cdp_pass'

# When a ruby exception occurs (in production only), an email is sent to the following address(es)
ExceptionNotifier.exception_recipients = %w(niconoe@ulb.ac.be)
