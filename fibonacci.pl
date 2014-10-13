fibonacci(compound([
			assign(n, 5),
			assign(fib1, 0),
			assign(fib2, 1),
			while(n > 1,
				compound([
					assign(fib, fib1+fib2),
					assign(fib1, fib2),
					assign(fib2, fib),
					assign(n, n-1)
				])
			),
			print(fib)
		])
).