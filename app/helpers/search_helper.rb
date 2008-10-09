module SearchHelper
  
  def truncate_for_search(text, term, offset=200)
    search = /#{term}/im
    occurance = search.match text
    if occurance
      from = (occurance.pre_match.length < offset) ? 0 : occurance.pre_match.length - offset
      preceeding = occurance.pre_match.slice(from, occurance.pre_match.length)
      to = (occurance.post_match.length < offset) ? occurance.post_match.length : offset
      following = occurance.post_match.slice(0, to)
      displaystring = "#{preceeding} #{occurance[0]} #{following}"
      highlight(displaystring, term.split(/\s/))
    else
      truncate(text, offset)
    end
  end
  
end
