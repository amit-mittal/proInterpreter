factorial(compound([
			assign(n, 7),
			assign(fact, 1),
			while(n > 1,
				compound([
					assign(fact, fact*n),
					assign(n, n-1)
				])
			),
			print(fact)
		])
).