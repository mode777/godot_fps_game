@tool
extends TrenchBroomGameConfig
class_name TrenchBroomGameConfigEx

func do_export_file():
	if OS.get_name() == "Windows":
		trenchbroom_games_folder = "%s/TrenchBroom/games"%OS.get_environment("APPDATA")
	if OS.get_name() == "macOS":
		trenchbroom_games_folder = "%s/Library/Application Support/TrenchBroom/games"%OS.get_environment("HOME")	
	print("Setting Trenchbroom games folder: %s"%trenchbroom_games_folder)
	super()
