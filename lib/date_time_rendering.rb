module DateTimeRendering
  require 'parsedate'
  def standard_date(date)
    if date.is_a?(String)
      d = ParseDate.parsedate(date)
      begin
        date = Time.local(*d[0..2])
      rescue
        date = ''
      end
    end
    if date && date != ""
      "#{date.month}/#{date.day}/#{date.year.to_s[2..3]}" 
    else
      ""
    end
  end
  
  def standard_time(time)
    if time.is_a?(String)
      t = ParseDate.parsedate(date)
      time = Time.local(*t) if t[0]
    end
    if time
      time.asctime 
    else
      ""
    end
  end

  def standard_date_time(time)
    if time.is_a?(String)
      t = ParseDate.parsedate(time)
      t[0] ||= Time.now.year
      time = Time.local(*t[0..4]) if t[0]
    end
    if time
      "#{time.month}/#{time.day}/#{time.year.to_s[2..3]} #{time.hour}:#{time.min}:#{time.sec}" 
    else
      ""
    end
  end  
  
  def time_from_date(unit,beginning_date,end_date = nil)
    #This method calculates the time in seconds from the beginning date to the end date, if it is present.
    #If there is no end date, this method will calculate the time from the beginning date to the current date/time.
    return nil if beginning_date.blank?
    factors = {'day' => 86400 , 'week' => 604800 , 'month' => 2628000, 'year' => 31536000}
    factor = factors[unit]
    time_diff = 0
    if !end_date.blank?
      end_date = ParseDate.parsedate(end_date)[0..2]
      end_date = Time.local(*end_date) if end_date[0]
    end
    end_date = Time.now if end_date.blank?
    if beginning_date.is_a?(String)
      beginning_date = ParseDate.parsedate(beginning_date)[0..2]
      return nil unless beginning_date[0]
      beginning_date = Time.local(*beginning_date)
    end
    time_diff = ((end_date - beginning_date)/ factor ).truncate
    time_diff > 0 ? time_diff : nil
    time_diff ? time_diff : nil
  end
end