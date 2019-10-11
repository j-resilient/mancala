require 'byebug'
class Board
  attr_accessor :cups

  def initialize(name1, name2)
    @cups = place_stones
    @name1, @name2 = name1, name2
  end

  def place_stones
    # helper method to #initialize every non-store cup with four stones each
    cups = Array.new(14) { Array.new(4, :stone) }
    cups[6], cups[13] = [], []
    cups
  end

  def valid_move?(start_pos)
    raise "Invalid starting cup" unless start_pos.between?(0,13)
    raise "Starting cup is empty" if cups[start_pos].empty?
  end

  def make_move(start_pos, current_player_name)
    start_pos -=1 if start_pos.between?(1,6)
    @op_store = current_player_name == @name1 ? 13 : 6
    stones = cups[start_pos]
    current_idx = start_pos

    until stones.empty?
      current_idx = (current_idx + 1) <= 13 ? (current_idx + 1) : 0
      next if current_idx == @op_store
      cups[current_idx] << stones.pop
    end

    render
    return next_turn(current_idx)
  end

  def next_turn(ending_cup_idx)
    # helper method to determine whether #make_move returns :switch, :prompt, or ending_cup_idx
    return :prompt if (ending_cup_idx == 13 || ending_cup_idx == 6) && ending_cup_idx != @op_store
    return :switch if cups[ending_cup_idx].length == 1
    ending_cup_idx
  end

  def render
    print "      #{@cups[7..12].reverse.map { |cup| cup.count }}      \n"
    puts "#{@cups[13].count} -------------------------- #{@cups[6].count}"
    print "      #{@cups.take(6).map { |cup| cup.count }}      \n"
    puts ""
    puts ""
  end

  def one_side_empty?
    cups[0..5].all? { |cup| cup.empty? } || cups[7..12].all? { |cup| cup.empty? }
  end

  def winner
  end
end
