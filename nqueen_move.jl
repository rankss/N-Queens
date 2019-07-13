#=
# Author: Ben Yang
# Date: 12/3/2016
# Description: Solves Fixing N-Queen Problem
# For educational purposes only
=#

# Creates a board of all 0
function board_size(n::Int64)
    board = zeros(Int64,n,n)
    return board
end

# Sets a position to 1 indicating queen
function pos(board::Array{Int64,2}, row::Int64, col::Int64)
    board[row, col] = 1
    return board
end

# Resets a position to 0 indicating no queen
function reset(board::Array{Int64,2}, row::Int64, col::Int64)
    board[row,col] = 0
    return board
end

# Prints the N x N board
function printBoard(board::Array{Int64,2})
    n = Int64(sqrt(length(board)))
    for row in 1:n
        for col in 1:n
            print(board[row, col])
            print(' ')
        end
        print("\n")
    end
end

# Predefined values of the y = -x diagonal
#= 4 x 4 example
4 3 2 1
5 4 3 2
6 5 4 3
7 6 5 4
=#
function diag1(board::Array{Int64,2}, row::Int64, col::Int64)
    n = Int64(sqrt(length(board)))
    return row - col + n
end

# Predefined values of the y = x diagonal
#= 4 x 4 example
1 2 3 4
2 3 4 5
3 4 5 6
4 5 6 7
=#
function diag2(board::Array{Int64,2}, row::Int64, col::Int64)
    n = Int64(sqrt(length(board)))
    return row + col - 1
end

# Determines whether a queen is present at a location, true if so, false if not
function queen(board::Array{Int64,2}, row::Int64, col::Int64)
    n = Int64(sqrt(length(board)))
    if (row > 0 && row < n+1) && (col > 0 && col < n+1) && board[row, col] == 1
        return true
    else
        return false
    end
end

# Function set QBR and rowMove determines whether given source coordinate and target coordinate,
# it is a row move, true if so, false if not
function QBR(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    if cs < cd
        for i in (cs+1):cd
            if queen(board,rs,i)
                return true
            end
        end
    else
        for i in cd:(cs-1)
            if queen(board,rs,i)
                return true
            end
        end
    end
    return false
end

function rowMove(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    n = Int64(sqrt(length(board)))
    if rs == rd && cs != cd && !(QBR(board,rs,cs,rd,cd)) && (rd > 0 && rd < n+1) && (cd > 0 && cd < n+1)
        return true
    else
        return false
    end
end

# Function set QBR and colMove determines whether given source coordinate and target coordinate,
# it is a column move, true if so, false if not
function QBC(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    if rs < rd
        for i in (rs+1):rd
            if queen(board,i,cs)
                return true
            end
        end
    else
        for i in rd:(rs-1)
            if queen(board,i,cs)
                return true
            end
        end
    end
    return false
end

function colMove(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    n = Int64(sqrt(length(board)))
    if cs == cd && rs != rd && !(QBC(board,rs,cs,rd,cd)) && (rd > 0 && rd < n+1) && (cd > 0 && cd < n+1)
        return true
    else
        return false
    end
end

# Function set QBR and diag1Move determines whether given source coordinate and target coordinate,
# it is a move along diag1 defined previously, true if so, false if not
function QBD1(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    i = 1
    if rs < rd && cs < cd
        while rs+i <= rd && cs+i <= cd
            if queen(board,rs+i,cs+i)
                return true
            end
            i+=1
        end
    else
        while rs-i >= rd && cs-i >= cd
            if queen(board,rs-i,cs-i)
                return true
            end
            i+=1
        end
    end
    return false
end

function diag1Move(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    n = Int64(sqrt(length(board)))
    if rs != rd && cs != cd && diag1(board,rs,cs) == diag1(board,rd,cd) && !(QBD1(board,rs,cs,rd,cd)) && (rd > 0 && rd < n+1) && (cd > 0 && cd < n+1)
        return true
    else
        return false
    end
end

# Function set QBR and diag2Move determines whether given source coordinate and target coordinate,
# it is a move along diag2 defined previously, true if so, false if not
function QBD2(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    i = 1
    if rs < rd && cs < cd
        while rs-i <= rd && cs+i <= cd
            if queen(board,rs-i,cs+i)
                return true
            end
            i+=1
        end
    else
        while rs+i <= rd && cs-i <= cd
            if queen(board,rs+i,cs-i)
                return true
            end
            i+=1
        end
    end
    return false
end

function diag2Move(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    n = Int64(sqrt(length(board)))
    if rs != rd && cs != cd && diag2(board,rs,cs) == diag2(board,rd,cd) && !(QBD2(board,rs,cs,rd,cd)) && (rd > 0 && rd < n+1) && (cd > 0 && cd < n+1)
        return true
    else
        return false
    end
end

# Combines all row move, column move, diag1 move, diag2 move together to simulate a legal move
function legalMove(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    if queen(board,rs,cs) && (rowMove(board,rs,cs,rd,cd) || colMove(board,rs,cs,rd,cd) || diag1Move(board,rs,cs,rd,cd) || diag2Move(board,rs,cs,rd,cd))
        return true
    else
        return false
    end
end

# Generates all possible moves for a particular queen
function moveGeneration(board::Array{Int64,2}, rs::Int64, cs::Int64)
    location = Array{Tuple{Int64,Int64}}(0)
    n = Int64(sqrt(length(board)))
    if queen(board,rs,cs)
        for r in 1:n
            for c in 1:n
                if legalMove(board,rs,cs,r,c)
                    push!(location,(r,c))
                end
            end
        end
    end
    return location
end

# Checks if a queen is in a safe position or not
function safePiece(board::Array{Int64,2},r::Int64,c::Int64)
    n = Int64(sqrt(length(board)))
    counter = 0
    for i in 1:n
        if queen(board,r,i)
            counter+=1
            if counter >= 2
                return false
            end
        end
    end
    counter = 0
    for i in 1:n
        if queen(board,i,c)
            counter+=1
            if counter >= 2
                return false
            end
        end
    end
    counter = 0
    for row in 1:n
        for col in 1:n
            if diag1(board,r,c) == diag1(board,row,col)
                if queen(board,row,col)
                    counter+=1
                    if counter >= 2
                        return false
                    end
                end
            end
        end
    end
    counter = 0
    for row in 1:n
        for col in 1:n
            if diag2(board,r,c) == diag2(board,row,col)
                if queen(board,row,col)
                    counter+=1
                    if counter >= 2
                        return false
                    end
                end
            end
        end
    end
    return true
end

# Checks all queens to determine whether or not it is a safe board state
function safeBoard(board::Array{Int64,2})
    n = Int64(sqrt(length(board)))
    counter = 0
    for row in 1:n
        for col in 1:n
            if queen(board,row,col)
                if safePiece(board,row,col)
                    counter+=1
                end
            end
        end
    end
    if counter == n
        return true
    else
        return false
    end
end

# Simulates a move on the board, without destroying the previous board
function sim(board::Array{Int64,2}, rs::Int64, cs::Int64, rd::Int64, cd::Int64)
    n = Int64(sqrt(length(board)))
    nextboard = zeros(Int64,n,n)
    for row in 1:n
        for col in 1:n
            nextboard[row,col] = board[row,col]
        end
    end
    nextboard = reset(nextboard,rs,cs)
    nextboard = pos(nextboard,rd,cd)
    return nextboard
end


######################################################################################
# Insert Solver Function Here!
function solver(board::Array{Int64,2}, depth::Int64, limit::Int64)
    if safeBoard(board)
        return depth
    end
    if depth >= limit
        return limit
    end
    for row in 1:n
        for col in 1:n
            if queen(board,row,col)
                location = moveGeneration(board,row,col) # Location is a tuple (rowdest, coldest)
                for i in 1:length(location)
                    nextboard = sim(board,row,col,location[i][1],location[i][2]) # Simulates the next board state
                    limit = solver(nextboard,depth+1,limit) # Increases depth
                end
            end
        end
    end
    return limit
end

#########= TEST =#########
n = 7
row = [7,2,3,4,5,6,7]
col = [3,6,2,5,1,4,7]
board = board_size(n)
for i in 1:n
    board = pos(board,row[i],col[i])
end
printBoard(board)
@fastmath m = Int64(round(n*1.5))
@time move = solver(board,0,m)
println("move($move)")
#########= TEST =#########