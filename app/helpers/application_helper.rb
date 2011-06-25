module ApplicationHelper
  
  # TIME FORMATTING
  ############################################################################
  
  def local_time(dtime)
    dtime.localtime.strftime("%l:%M %P")
  end
  
  def local_date(dtime)
    dtime.localtime.strftime("%m/%d/%y")
  end
  
end
