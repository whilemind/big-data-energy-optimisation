from Tkinter import *

WINDOW_HEIGHT = 700
WINDOW_WIDTH = 800


def fileNewCmd():
  print("File New Command")


def exitAppCmd():
	print("Application Exit Command")
	window.destroy()

window = Tk()
window.title("AP Energy Optimisation")
window.geometry("600x400")

''' Menu part
'''
menu = Menu(window)
window.config(menu=menu)

fileMenuItem = Menu(menu)
menu.add_cascade(label="File", menu=fileMenuItem)
fileMenuItem.add_command(label="New", command=fileNewCmd)
fileMenuItem.add_separator()
fileMenuItem.add_command(label="Exit", command=exitAppCmd)

''' Canvas part
'''
canvas = Canvas(window, height=WINDOW_HEIGHT, width=WINDOW_WIDTH)
canvas.pack()

# button = Button(canvas, text="Hello World", bg="grey")
# button.pack()

window.mainloop()
