module EventsHelper
  
  def seed_calendar(events)
    calendar(:year => @year, :month => @month, :previous_month_text => previous_month_link, :next_month_text => next_month_link) do |d|
      if events.collect {|e| [e.range]}.flatten.include?(d)
        [d.mday, {:class => "specialDay"}]
      else 
        [d.mday, {:class => "day"}]
      end 
    end
  end
  
  def calendar_date(from, to)
    todate = "- #{to.strftime("%b %d")}" unless to.blank? || to == from
    fromdate = from.strftime("%b %d") 
    "#{fromdate} #{todate}"
  end
  
  def calendar_time(date, all_day)
    ampm = date.strftime("%p").downcase
    date.strftime("%l:%M" + ampm) unless all_day
  end
  
  def previous_month_link
    link_to('&laquo;', browse_path(@page, previous_month(@month), previous_year(@year)))
  end
  
  def next_month_link
    link_to('&raquo;', browse_path(@page, next_month(@month), next_year(@year)))
  end
  
  def next_year(year)
    if @month == 12
      year = year + 1
    else
      year = year
    end
  end
  
  def previous_year(year)
    if @month == 1
      year = year - 1
    else
      year = year
    end
  end

  def previous_month(current)
    if current != 1
      previous = current - 1
    else
      previous = 12
    end
  end
  
  def next_month(current)
    if current != 12
      next_month = current + 1
    else
      next_month = 1
    end
  end
  
end
