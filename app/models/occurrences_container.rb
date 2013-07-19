# Needs RESULTS_PER_PAGE

class OccurrencesContainer
  attr_reader   :occurrences, # Array of the occurences
                :total_results,
                :total_georef_results,
                :page_num


  def initialize(collection, number_total_results, number_georef_results, page_num)
    @occurrences = collection
    @total_results = number_total_results
    @total_georef_results = number_georef_results
    @page_num = page_num
  end

  def empty?
    total_results == 0
  end

  def first_on_page
    start_index
  end

  def last_on_page
    unless last_page?
      start_index + RESULTS_PER_PAGE
    else
      total_results - 1
    end
  end

  def start_index
    (page_num-1)*RESULTS_PER_PAGE
  end

  # return the number of pages
  def total_pages
    f = total_results.to_f / RESULTS_PER_PAGE
    f.ceil
  end

  def last_page?
    page_num >= total_pages
  end

  def first_page?
    page_num <= 1
  end

  def last_page_num
    total_pages
  end

  # Used externally by Paginated model
  def self.calculate_offset(page_num)
    ((page_num.to_i)-1)*RESULTS_PER_PAGE
  end

end
