# Q1
import math
import time
import os

def make_queen_sat(N):

	def exactly_one(arr):
		cnf = ""
		count = 0
		literals = 0
		
		result = at_most_one(arr)
		cnf += result[0]
		count += result[1]
		literals += result[2]

		for i in arr:
			cnf += str(i) + " "
			literals += 1
		cnf += "0\n"
		count += 1
		return (cnf, count, literals)

	def at_most_one(arr):
		cnf = ""
		count = 0
		literals = 0
		for i in range(len(arr)):
			for j in range(i+1, len(arr)):
				cnf += str(-arr[i]) + " " + str(-arr[j]) + " 0\n"
				literals += 2
				count += 1
		return (cnf, count, literals)

	cnf = ""
	count = 0
	literals = 0

	cnfvar = [ [i*N + j + 1 for j in range(N)] for i in range(N) ]

	# Row Constraints
	for arr in cnfvar:
		result = exactly_one(arr)
		cnf += result[0]
		count += result[1]
		literals += result[2]

	# Column Constraints
	for i in range(N):
		arr = [ a[i] for a in cnfvar ]
		result = exactly_one(arr)
		cnf += result[0]
		count += result[1]
		literals += result[2]

	# Diagonal Constraints
	diagLR = cnfvar[0][:N-1]
	diagRL = cnfvar[0][1:]
	for i in range(1, N-1):
		diagLR.append(cnfvar[i][0])
		diagRL.append(cnfvar[i][N-1])

	for i in range((N-1) + (N-2)):
		# Left to Right
		arr = []
		x = int((diagLR[i]-1)/N)
		y = int((diagLR[i]-1)%N)

		while x < N and y < N:
			arr.append(cnfvar[x][y])
			x += 1
			y += 1

		result = at_most_one(arr)
		cnf += result[0]
		count += result[1]
		literals += result[2]

		# Right to Left
		arr = []
		x = int((diagRL[i]-1)/N)
		y = int((diagRL[i]-1)%N)

		while x < N and y >= 0:
			arr.append(cnfvar[x][y])
			x += 1
			y -= 1

		result = at_most_one(arr)
		cnf += result[0]
		count += result[1]
		literals += result[2]

	# Prepend prefix
	cnf = "p cnf " + str(N*N) + " " + str(count) + "\n" + cnf
	return (cnf, N*N, count, literals)

def draw_queen_sat_sol(sol):
	sol = sol.splitlines()
	if sol[0] == "UNSAT":
		print("No solution.\n")
		return "UNSATISFIABLE"

	sol[1] = sol[1].split()
	solution = sol[1][0:len(sol[1])-1]

	N = int(math.sqrt(len(solution)))
	if N > 40:
		print("Too big: N must be less than 40.\n")
		return "SATISFIABLE"

	board = ""
	for i in range(N):
		for j in range(N):
			if int(solution[i*N + j]) < 0:
				board += ". "
			else:
				board += "Q "
		board += "\n"
	print(board)
	return "SATISFIABLE"

def test(N):

	def write(name, mode, content):
		filein = open(name, mode)
		filein.truncate(0)
		filein.write(content[0])
		filein.close()
		return content[1], content[2], content[3]

	def read(name, mode):
		fileout = open(name, mode)
		sol = fileout.read()
		return sol

	print(f'\nN = {N}\n')
	var, clause, literals = write("cnf", "w", make_queen_sat(N))
	start = time.time()
	os.system("minisat cnf cnfout")
	elapsed = time.time() - start
	sol = read("cnfout", "r")
	solution = draw_queen_sat_sol(sol)

	return elapsed, var, clause, literals, solution

start = time.time()
N = 2
t = 0
arr = []
while t < 10:
	t, var, clause, lit, sol = test(N)
	arr.append({"N":N, "Time":t, "Variable Count":var, "Clause Count": clause, "Literals":lit, "Solution":sol})
	N += 1

elapsed = time.time() - start
print(f'Total Runtime: {elapsed}')

# Total time: 491.33526039123535
# N = 153