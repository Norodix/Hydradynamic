extends Node


func trigger_level_reset():
	resetnode(self)


func resetnode(node):
	for N in node.get_children():
		if N.get_child_count() > 0:
			if N.has_method("reset_level"):
				N.reset_level()
			resetnode(N)
		else:
			if N.has_method("reset_level"):
				N.reset_level()
