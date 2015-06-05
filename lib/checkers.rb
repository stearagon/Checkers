require 'byebug'

class Game

  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def play
    Game.new(Board.new)

    board.fill_board

    instructions

    current_player = :red

    until over?(current_player)

      begin
        turn(current_player)
      rescue
       puts "Not valid move."
       retry
      end

      board.display


      current_player = toggle_player(current_player)

    end

    puts "Team #{toggle_player(current_player).to_s.capitalize} wins"

  end

  def over?(current_player)
    return true if !board.board.flatten.compact.any? { |piece| piece.color == current_player }

    current_player_pieces = board.board.flatten.compact.select do |pieces|
      pieces.color == current_player
    end

    return true if current_player_pieces.all? { |piece| piece.jump_moves.empty? &&
                                                    piece.slide_moves.empty? }

    return false
  end

  def toggle_player(player)
    player == :red ? :black : :red
  end

  def instructions

    puts "Welcome to checkers"
    puts "\n\n\n"
    puts "To select a piece to move type in the row and col."
    puts "e.g. '11' will select piece at (1,1)"
    puts "\n\n\n"
    puts "To move a piece enter move similar to selecting a piece."
    puts "You can enter multiple moves. Just separate by a space."
    puts "e.g. '33' will move piece to (3,3) \n and '33 55'will jump to (3,3) then (5,5)"
    puts "\n\n\n"


    board.display
  end

  def turn(color)

    puts "What piece would you like to move?"

    inputs = gets.chomp

    start = board[[inputs[0].to_i,inputs[1].to_i]]

    raise "Not your piece" if start.color != color

    puts "Where would you like to move? (Can enter multiple locations)"

    inputs = gets.chomp

    new_moves = move_convert(inputs)

    start.perform_moves(new_moves)

  end

  def move_convert(inputs)
    return [[inputs[0].to_i,inputs[1].to_i]] if inputs.length < 3
    move = []
    inputs.split(" ").each do |move|
      move << [move[0].to_i,move[1].to_i]
    end
    move
  end

end


class Board
  attr_accessor :board

  BOARD_SIZE = 8
  FAR_ROW = {
    red: 1,
    black: 8
  }

  def initialize(board = nil)
    board ||= Array.new(BOARD_SIZE) {Array.new(BOARD_SIZE) { nil }}
    @board = board
  end

  def display

    display_board = board.map do |row|
      row.map do |tile|
        if tile.nil?
          "_"
        elsif tile.king == false
          (tile.color == :red) ? "r" : "b" #add functionality to show unicode
        else
          (tile.color == :red) ? "R" : "B"
        end
      end.join(" ")
    end

    display_board.unshift((1..BOARD_SIZE).to_a.join(" "))

    row_start = " "
    row_count = 0

    display_board.each do |row|
      puts row_start.to_s + " " + row
      row_count += 1
      row_start = row_count.to_s
    end
    nil
  end

  def fill_board
   fill_team(:black)
   fill_team(:red)
   nil
  end

  def fill_team(team)
    row_start = (team == :black) ? 1 : 6
    row_end =  (team == :black) ? 3 : 8

      (row_start..row_end).each do |row|
        (1..BOARD_SIZE).each do |tile|
          if row.odd?
            self[[row,tile]] = Piece.new(self,[row,tile],team) if tile.odd?
          else
            self[[row,tile]] = Piece.new(self,[row,tile],team) if tile.even?
          end
        end
      end

  end

  def [](pos)
    board[pos[0]-1][pos[1]-1]
  end

  def []=(pos, checker_piece)
      board[pos[0]-1][pos[1]-1] = checker_piece
  end

  def is_empty?(pos)
    board[pos[0]-1][pos[1]-1] == nil
  end

  def on_board?(pos)
    pos.all? { |el| el.between?(1,8) }
  end

  def board_dup
    duped_board = Board.new

    # Flattens 2D grid, throws away nils, iterates through pieces.
    self.board.flatten.compact.each do |piece|
      duped_board[piece.pos] = Piece.new(duped_board,piece.pos.dup, piece.color)
    end

    duped_board

  end

end


class Piece
  DELTAS = [
      [1,1], [1,-1]
    ]

  attr_accessor :symbol, :color, :king, :pos, :board

  def initialize(board, pos, color, king = false)
    @board, @pos, @color, @king = board, pos, color, king
    nil
  end

  def perform_slide(end_pos)

    return false if !self.slide_moves.include?(end_pos)

    start_pos = pos.dup

    pos[0] = end_pos[0]
    pos[1] = end_pos[1]
    board[pos] = board[start_pos]
    board[start_pos] = nil
    board[pos].king = true if board[pos].maybe_promote

    return true
  end

  def perform_jump(end_pos)
    return false if !self.jump_moves.include?(end_pos)

    start = pos.dup
    pos[0] = end_pos[0]
    pos[1] = end_pos[1]

    board[end_pos] = board[start]
    board[start] = nil

    diff_x = (start[0] > end_pos[0]) ? -1 : 1
    diff_y = (start[1] > end_pos[1]) ? -1 : 1
    board[[(start[0] + diff_x),(start[1] + diff_y)]] = nil
    board[end_pos].king = true if board[end_pos].maybe_promote


    return true
  end

  def move_diffs
    if color == :black && !king
      DELTAS
    elsif color == :red && !king
      DELTAS.map { |delta| delta.map { |el| el * -1 }}
    elsif king
      DELTAS.concat(DELTAS.map { |delta| delta.map { |el| el * -1 }})
    end
  end

  def slide_moves
    possible_moves = []
    self.move_diffs.each do |new_pos|
      end_pos_x = pos[0] + new_pos[0]
      end_pos_y = pos[1] + new_pos[1]
      end_pos = [end_pos_x,end_pos_y]
      if board.on_board?(end_pos)
        possible_moves << end_pos if board.is_empty?(end_pos)
      end
    end

    possible_moves
  end

  def jump_moves
    possible_moves = []
    self.move_diffs.each do |new_pos|
      end_pos = [pos[0] + (2 * new_pos[0]), pos[1] + (2 * new_pos[1])]
      end_pos_mid = [pos[0] + new_pos[0], pos[1] + new_pos[1]]

      if self.board.on_board?(end_pos)
        possible_moves << end_pos if board.is_empty?(end_pos) &&
                                     !board.is_empty?(end_pos_mid) &&
                                     board[end_pos_mid].color != self.color
      end
    end
    possible_moves
  end


  def perform_moves!(list_of_moves)
    return true if list_of_moves.count == 1 && perform_slide(list_of_moves.first)

    list_of_moves.each do |move|
      if self.perform_jump(move)

      else
        raise InvalidMoveError
      end
    end

    return true

  end

  def valid_move_seq?(moves)
    duped_board = board.board_dup
    new_pos = [self.pos[0],self.pos[1]]

    return true if duped_board[[new_pos[0],new_pos[1]]].perform_moves!(moves)

    rescue
    return false
  end

  def perform_moves(moves)

    if valid_move_seq?(moves)
      perform_moves!(moves)
    else
      raise InvalidMoveError
    end
  end

  def maybe_promote
    return true if Board::FAR_ROW[color] == pos[0]
    return false
  end

end
