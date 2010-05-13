sol: membrane {
  substrate {
    
  }
  sol: matrice {
    breath: you_are <member>
  }
  sol: member {
    breath: who_am_i
  }
}


sol: mutual_credit {
  substrate {
    max_negative_balance:float
    min_negative_balance:float
  }
  breath: _first<mutual_credit>(min:float,max:float):ruby {
    receiver_transform:ruby {
      @max_negative_balance = min
      @min_negative_balance = max
    }
  }
  sol: admin {
    breath: set_credit_limit<member>(amount:float)
      receiver_transform:ruby {
        @credit_limit = @play.amount
      }
    breath: reverse(<_play>)
  }
  sol: member {
    substrate {
      balance:float
      volume:float
      credit_limit:float
    }
    breath: _first<member>:ruby {
      receiver_transform:ruby {
        @balance = 0
        @volume = 0
      }
    }
    breath: pay<member>(amount:float,memo:text) 
      sender_transform:ruby {
        return_value = true
        if (@balance - @play.amount) > @credit_limit
          @balance -= @play.amount
          @volume += @play.amount          
        else
          return_value = "Credit limit (#{@credit_limit}) exceeded."
        end
        return_value
      }
      receiver_transform:ruby {
        @balance += @play.amount
        @volume += @play.amount
      }
    }
  }
}
