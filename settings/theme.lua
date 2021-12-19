return {
	levelEditor = {
		detailsWorldDivisionStyle = {
			divisionRatio = 0.3,
			dividerColor = {1,1,1},
			dividerWidth = 1,
		},
		colors = {
			worldBackground = {0,0.5,1, 1},
			resizeCircles = {0.5,0.5,0.5, 0.5},
			selectingArea = {1,1,1, 1},
			handHighlight = {1,1,1, 0.5},
			hoverHighlight = {1,1,1, 0.5},
			
			foregroundObject = {
				shape = {0,1,0, 0.4},
				outline = {0,1,0, 1},
				text = {0,0,0, 1},
				selected = {1,1,1 ,1},
			},
			backgroundObject = {
				shape = {1,0,0, 0.4},
				outline = {1,0,0, 1},
				text = {0,0,0, 1},
				selected = {1,1,1 ,1},
			},
			pathNode = {
				shape = {0,0,1, 0.4},
				outline = {0,0,1, 1},
				connection = {0,0,1, 1},
				selected = {1,1,1 ,1},
			},
		},
	},
	tabs = {
		activeDividerColor = {0,0,0, 0},
		buttonHeight = 30,
		tabButtonStyle = {
			padding = 0,
			border = true,
			normal = {
				backgroundColor = {0,0,0},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
			hover = {
				backgroundColor = {0.5,0.5,0.5},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
		},
		activeTabButtonStyle = {
			padding = 0,
			border = true,
			normal = {
				backgroundColor = {0.3,0.3,0.3},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
			hover = {
				backgroundColor = {0.4,0.4,0.4},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
		},
	},
	treeViewer = {
		listStyle = {
			textIndentSize = 0,--unused, weird values that can help detect errors unfortunately can't be saved
			entryMargin = 0,
			
			indentCharacters = 2,
			
			buttonStyle = {
				padding = 6,
				border = false,
				normal = {
					backgroundColor = {0,0,0},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
				hover = {
					backgroundColor = {0.5,0.5,0.5},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
			},
			actionButtonStyle = {
				padding = 6,
				border = true,
				normal = {
					backgroundColor = {0,0,0},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
				hover = {
					backgroundColor = {0.5,0.5,0.5},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
			},
		},
		listDetailsDivisionStyle = {
			divisionRatio = 0.25,
			dividerColor = {1,1,1},
			dividerWidth = 1,
		},
	},
	details = {
		listStyle = {
			textIndentSize = 15,
			entryMargin = 6,
			
			buttonStyle = {
				padding = 6,
				border = true,
				normal = {
					backgroundColor = {0,0,0},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
				hover = {
					backgroundColor = {0.5,0.5,0.5},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "left",
						verAlign = "center",
						color = {1,1,1},
					},
				},
			},
		},
		insetSize = 10,
	},
	modal = {
		boxStyle = {
			padding = 10,
			backgroundColor = {0,0,0},
			borderColor = {1,1,1},
		},
		listStyle = {
			textIndentSize = 12,
			entryMargin = 8,
			textStyle = {
				horAlign = "left",
				verAlign = "center",
				color = {1,1,1},
			},
			buttonStyle = {
				padding = 5,
				border = true,
				normal = {
					backgroundColor = {0,0,0},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "center",
						verAlign = "center",
						color = {1,1,1},
					},
				},
				hover = {
					backgroundColor = {0.5,0.5,0.5},
					borderColor = {1,1,1},
					textStyle = {
						horAlign = "center",
						verAlign = "center",
						color = {1,1,1},
					},
				},
			},
		},
		blockStyle = {
			overlayColor = {0,0,0, 0.5},
		},
		widthFactor = 0.57,
	},
	scrollbar = {
		buttonStyle = {
			padding = 0,
			border = true,
			normal = {
				backgroundColor = {0,0,0},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
			hover = {
				backgroundColor = {0.5,0.5,0.5},
				borderColor = {1,1,1},
				textStyle = {
					horAlign = "center",
					verAlign = "center",
					color = {1,1,1},
				},
			},
		},
		width = 25,
		--not the center button:
		buttonHeight = 35,
	},
}
