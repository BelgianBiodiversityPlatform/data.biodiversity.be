module ApplicationHelper
  
  def link_to_eea(name = 'European Environment Agency', options = {:class => 'external'})
    link_to name, 'http://www.eea.europa.eu/', options
  end
  
  def link_to_belspo(name = 'Belgian Science Policy', options = {:class => 'external'})
    link_to name, 'http://www.belspo.be', options
  end
  
   def link_to_bbpf(name = t('cus.bbpf'), options = {:class => 'external'})
    link_to name, 'http://www.biodiversity.be', options
  end
  
  def link_to_fada(name='FADA', options = {:class => 'external'})
    link_to name, 'http://fada.biodiversity.be/', options
  end

  def link_to_ias(name='IAS', options = {:class => 'external'} )
    link_to name, 'http://ias.biodiversity.be/', options
  end

  def link_to_forbio(name='Forest Biodiversity', options = {:class => 'external'} )
    link_to name, 'http://forbio.biodiversity.be/', options
  end

  def link_to_scarmarbin(name='SCAR-MarBIN', options = {:class => 'external'})
    link_to name, 'http://www.scarmarbin.be/', options
  end

  def link_to_be(name = 'Be Portal', options = {:class => 'external'})
    link_to name, 'http://www.fgov.be', options
  end
  
  def legend_entry(name, color)
    "<p><span style=\"background-color: ##{color}; border: 1px solid black; margin-right: 5px;\">&nbsp;&nbsp;&nbsp;&nbsp;</span>#{name}</p>"
  end
  
end
