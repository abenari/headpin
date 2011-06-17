module DashboardHelper
  def consumed_percentage
    if (@org.subscriptions_summary[:available] == 0)
      0
    else
      @org.subscriptions_summary[:percent_consumed]=(@org.subscriptions_summary[:used]/@org.subscriptions_summary[:available])*100
    end    
  end  
end