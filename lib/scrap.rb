#perfrom two sliding moves
b = Board.new
b.fill_board
b.display
b[[6,2]].perform_slide([5,3])
b[[5,3]].perform_slide([4,2])
b.display

#performm jumping move over enemy
b = Board.new
b.fill_board
b.display
b[[3,5]].perform_slide([4,4])
b[[4,4]].perform_slide([5,3])
b[[6,2]].perform_jump([4,4])
b.display

#not valid move
b = Board.new
b.fill_board
b.display
b[[3,5]].perform_slide([3,4])
b.display

#not valid move
b = Board.new
b.fill_board
b.display
b[[6,2]].perform_jump([4,4])
b.display

#board dup
b = Board.new
b.fill_board
b.display
x = b.board_dup
q
x[[1,1]].object_id
b[[1,1]].object_id
x[[1,1]].pos.object_id
b[[1,1]].pos.object_id
x[[1,1]].class
b[[1,1]].class


#use perform moves!
b = Board.new
b.fill_board
b.display
moves = [[5,3],[4,4]]
b[[6,2]].perform_moves!(moves)

b = Board.new
b.display
b[[6,1]] = Piece.new(b,[6,1],:red)
b[[5,2]] = Piece.new(b,[5,2],:black)
q
b[[3,4]] = Piece.new(b,[3,4],:black)
q
b.display
moves = [[4,3], [2,5]]
b[[6,1]].perform_moves!(moves)
b.display

#use perform moves!
b = Board.new
b.fill_board
b.display
moves = [[5,3],[4,5]]
b[[6,2]].perform_moves!(moves)

#use valid moves to make double jump
load "checkers.rb"
b = Board.new
b.display
b[[6,1]] = Piece.new(b,[6,1],:red)

b[[5,2]] = Piece.new(b,[5,2],:black)
q
b[[3,4]] = Piece.new(b,[3,4],:black)
q
b.display
moves = [[4,3], [2,5]]
b[[6,1]].valid_move_seq?(moves)
b.display



#use valid moves to make invalid double jump
load "checkers.rb"
b = Board.new
b.display
b[[6,1]] = Piece.new(b,[6,1],:red)
  b[[5,2]] = Piece.new(b,[5,2],:black)
  q
b[[3,4]] = Piece.new(b,[3,2],:black)
q
b.display
moves = [[4,3], [2,6]]
b[[6,1]].valid_move_seq?(moves)
b.display


#test king display
b = Board.new
b.fill_board
b.display
b[[6,2]].king = true
b[[1,3]].king = true
b.display

#use perform moves!
b = Board.new
b.display
b[[6,1]] = Piece.new(b,[6,1],:red)
b[[5,2]] = Piece.new(b,[5,2],:black)
q
b[[3,4]] = Piece.new(b,[3,2],:black)
q
b.display
moves = [[4,3], [2,6]]
b[[6,1]].perform_moves(moves)

b = Board.new
b.display
b[[6,1]] = Piece.new(b,[6,1],:red)
b[[5,2]] = Piece.new(b,[5,2],:black)
q
b[[3,4]] = Piece.new(b,[3,4],:black)
q
b.display
moves = [[4,3], [2,5]]
b[[6,1]].perform_moves(moves)

b = Board.new
b.fill_board
b.display
moves = [[5,3]]
b[[6,2]].perform_moves(moves)

b = Board.new
b.fill_board
b.display
moves = [[5,3]]
b[[6,2]].valid_move_seq?(moves)

b = Board.new
b.fill_board
b.display
moves = [[5,3]]
b[[6,2]].perform_moves(moves)
moves = [[4,4]]
b[[3,5]].perform_moves(moves)
b.display
moves = [[3,5]]
b[[5,3]].perform_moves(moves)
b.display
moves = [[4,8]]
b[[3,7]].perform_moves(moves)
b.display
moves = [[5,3]]
b[[6,4]].perform_moves(moves)
b.display
moves = [[3,7]]
b[[2,6]].perform_moves(moves)
b.display
moves = [[4,4]]
b[[5,3]].perform_moves(moves)
b.display
moves = [[2,6]]
b[[1,7]].perform_moves(moves)
b.display
moves = [[1,7]]
b[[3,5]].perform_moves(moves)
b.display


b = Board.new
b.display
b[[1,8]] = Piece.new(b,[1,8],:black)
b.display
moves = [[2,7]]
b[[1,8]].perform_moves(moves)
b.display
moves = [[3,6]]
b[[2,7]].perform_moves(moves)
b.display
moves = [[4,5]]
b[[3,6]].perform_moves(moves)
b.display
moves = [[5,4]]
b[[4,5]].perform_moves(moves)
b.display
moves = [[6,3]]
b[[5,4]].perform_moves(moves)
b.display
moves = [[7,2]]
b[[6,3]].perform_moves(moves)
b.display
moves = [[8,1]]
b[[7,2]].perform_moves(moves)
b.display


62

53

35

44

71

62

26

35

82

71

17

26

68

57

35

46

53

35 17
