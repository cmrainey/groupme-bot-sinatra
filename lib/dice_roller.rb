class DiceRoller

  def self.roll(dice_string)
    if /\d+d\d+/.match(dice_string)
      dice_arr = dice_string.split("d")
      number = dice_arr[0].to_i
      die = dice_arr[1].to_i
      rolls = []
      roll_total = 0
      number.times do
        roll = rand(1..die)
        roll_total += roll
        rolls << roll
      end
      return "You rolled #{roll_total} #{rolls}"
    else
      return "Invalid dice roll request."
    end
  end

end