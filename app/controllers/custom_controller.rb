class CustomController < ApplicationController
  layout 'minimal' # Because this controller is used for overlay legends (copied in app/views/custom), and we don't know in advance the action's names. So do not remove this, but add exceptions to this layout if necessary.


end
