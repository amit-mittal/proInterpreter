oddeven(compound([
			assign(n, 12),
			while(n > 1,
				compound([
					assign(n, n-2)
				])
			),
			ifthenelse(
				n == 0,
				compound([
					print(\even)
				]),
				compound([
					print(\odd)
				])
			)
		])
).