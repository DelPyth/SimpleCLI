/*
	name ------ : main.ahk
	description : A quick CLI example to demonstrate the use of the AHK library
	----------- : as well as some common ideas used in other CLI tools.
	author ---- : TopHatCat
	version --- : v1.1.0
	date ------ : 27-01-2022  [DD-MM-YYYY]
*/

; Note that OOP is at the bottom, read why in lib/oop.ahk.
; MISC can be below since it's just functions, no need to execute anything since AHK parses functions before running.
#include <util>
#include <console>
#include <oop>

#NoEnv
#KeyHistory 0
#SingleInstance Force
#Persistent

class Program
{
	init(args*)
	{
		; Set tray icon to our project icon.
		; This will not change the icon of the console window.
		; this requires the AHK executable, or the compiled script's icon to change..
		if (!A_IsCompiled)
		{
			Menu, Tray, Icon, % A_ScriptDir . "/program.ico"
		}

		; Control the console.
		; The reason we aren't using a class property is because we want to show why OOP would work in many scenarios.
		con := new CMD()

		; Change the title. main.ahk v1.1.33.10
		con.title := A_ScriptName . " v" . A_AhkVersion

		; Display our welcome message.
		con.writeln("Simple CLI example. v1.1.0")
		con.writeln("This is to show off my CONSOLE class and how you can use it to create a console application in AHK.")

		; If the user provided any command line arguments, display them.
		if (args.Count() > 0)
		{
			con.writeln("You ran this demo using the following arguments:")
			for index, value in args
			{
				;  [1] = some_argument
				;  [2] = -o
				;  [2] = file.exe
				con.write_with_color("  [", {"text": index, "color": con.Color.FG_CYAN}, "] = ", {"text": value, "color": con.Color.FG_BLUE}, "`n")
			}
		}
		else
		{
			; Otherwise, just say that the user can give arguments.
			con.writeln("You can run this demo with command line arguments passed to it.")
			con.writeln("It doesn't seem like you gave any arguments.")
		}

		; Add a new line for clarity.
		con.write("`n")

		; Check for what example the user would like to do:
		con.write_with_color("What example would you like to run? Use '"
			, {"text": "help", "color": con.Color.FG_CYAN}
			, "' to see the commands you can run.`n")

		; Get list of examples.
		this.list_examples(con)

		; Just for an easter egg.
		has_cursed := false

		; Since we want the user to continuiously be able to type commands, we need to loop.
		loop
		{
			; Preppend a little space to help distinguish user input.
			; Since the user input will end with a line break, we don't have to append a new line but we're going to anyway to help readability.
			con.write("> ")

			; Change the input color to be something recognizable for when the user inputs something.
			con.fgcolor := con.Color.FG_YELLOW

			; Get input.
			choice := con.input()

			; Reset text color
			con.fgcolor := con.Color.FG_GRAY

			; Check if the user typed a valid command, an easter egg, or an example.
			switch (choice)
			{
				case "list":
					this.list_examples(con)

				; ALWAYS have an exit clause.
				case "exit", "quit":
					con.writeln("Exiting...")
					return EXIT_SUCCESS

				case "clear", "cls":
					con.clear()
					con.write_with_color("What example would you like to run? Use '"
						, {"text": "help", "color": con.Color.FG_CYAN}
						, "' to see the commands you can run.`n")

				case "help", "idk":
					this.say_help(con)

				; Most of the time the user is running the script on its own instead of inside an already existing console,
				; so we'll just say that we're reloading just so the user knows what happened.
				case "reload":
					con.writeln("Reloading...")
					Reload
					return EXIT_SUCCESS

				; Easter egg :)
				case "fuck", "shit", "fuck you", "go fuck yourself":
					con.writeln("You kiss your mother with that mouth?")
					has_cursed := true
				case "yes":
					if (has_cursed)
					{
						con.writeln("You're a nice person.")
						has_cursed := false
					}
					else
					{
						con.writeln("Sorry, but I don't know that example.")
					}
				case "no":
					if (has_cursed)
					{
						con.writeln("Lucky woman.")
						has_cursed := false
					}
					else
					{
						con.writeln("Sorry, but I don't know that example.")
					}

				; Another easter egg :)
				case "you're cute", "you are cute", "cutie":
					con.writeln("No, you're cute.")

				; Empty input.
				; We can just ignore the empty input and continue to ask for more input.
				; This is how normal consoles work anyways.
				case NULL:
					continue

				; Example check.
				default:
					; If we don't have an example with this name, say we don't and then ask again.
					; To know how to set up a custom example, read lib/examples.ahk
					if (!this.Examples.HasKey("example_" . choice))
					{
						con.writeln("Sorry, but I don't know that example.")
						continue
					}

					; Run the example.
					result := ObjBindMethod(this.Examples, choice, con).Call()
					if (result != true)
					{
						; If the example returned amything but true, we can assume it was an error and print it to the console.
						con.write_with_color({"text": result . "`n", "color": con.Color.FG_RED})
					}

					; Reset the console title.
					con.title := A_ScriptName . " v" . A_AhkVersion
			}
		}

		; Just in case we forget to reset the text color in one of the examples,
		; we change it back to default so when the script closes, it's as if nothing changed.
		con.fgcolor := con.Color.FG_GRAY

		; Exit the program successfully. EXIT_SUCCESS = 0.
		return EXIT_SUCCESS
	}

	; Display the help message showing the list of valid commands.
	say_help(con)
	{
		;  cmd1[, cmd2]  -  description
		con.write_with_color("These are the commands you can use.`n"
			, {"text": "  help, idk", "color": con.Color.FG_GREEN}
			,          "    - Show this message.`n"
			, {"text": "  list", "color": con.Color.FG_GREEN}
			,          "         - Show a list of examples.`n"
			, {"text": "  clear, cls", "color": con.Color.FG_GREEN}
			,          "   - Clear the console.`n"
			, {"text": "  reload", "color": con.Color.FG_GREEN}
			,          "       - Reload the program.`n"
			, {"text": "  exit, quit", "color": con.Color.FG_GREEN}
			,          "   - Exit the program.`n")
		return NULL
	}

	; Display a list of all the valid examples. Read lib/examples.ahk for more info.
	list_examples(con)
	{
		for key, description in this.Examples
		{
			if (InStr(key, "example_"))
			{
				key := StrReplace(key, "example_")

				padding := ""
				loop, % 18 - StrLen(key)
				{
					padding .= " "
				}

				; [key] = [description]
				con.write_with_color("  ["
					, {"text": key, "color": con.Color.FG_GREEN}
					, "]"
					, padding
					, {"text": description . "`n", "color": con.Color.FG_GRAY})
			}
		}
		return NULL
	}

	class Examples
	{
		; To keep the examples organized and keep main.ahk shorter, we'll put them in our lib folder.
		#include %A_ScriptDir%\lib\examples.ahk
	}
}
