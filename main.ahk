/*
	name ------ : main.ahk
	description : A quick CLI example to demonstrate the use of the AHK library
	----------- : as well as some common ideas used in other CLI tools.
	author ---- : TopHatCat
	version --- : v0.1.0
	date ------ : 24-01-2022  [DD-MM-YYYY]
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
		; Control the console.
		con := new CMD()

		; Change the title.
		con.title := A_ScriptName . " v" . A_AhkVersion

		; Display our welcome message.
		con.writeln("Simple CLI example. v1.0.0")
		con.writeln("This is to show off my CONSOLE class and how you can use it to create a console application in AHK.")

		if (args.Count() > 0)
		{
			con.writeln("You ran this demo using the following arguments:")
			for index, value in args
			{
				con.write_with_color("  [", {"text": index, "color": con.Color.FG_CYAN}, "] = ", {"text": value, "color": con.Color.FG_BLUE}, "`n")
			}
		}
		else
		{
			con.writeln("You can run this demo with command line arguments passed to it.")
			con.writeln("It doesn't seem like you gave any arguments.")
		}
		con.write("`n")

		; Check for what example the user would like to do:
		con.write_with_color("What example would you like to run? Use '"
			, {"text": "help", "color": con.Color.FG_CYAN}
			, "' to see the commands you can run.`n")

		; Get list of examples.
		this.list_examples(con)

		has_cursed := false

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

				case "reload":
					con.writeln("Reloading...")
					Reload
					return EXIT_SUCCESS

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

				case "you're cute", "you are cute", "cutie":
					con.writeln("No, you're cute.")

				; Empty input.
				case NULL:
					continue

				default:
					; If we don't have an example with this name, say we don't and then ask again.
					if (!this.Examples.HasKey("example_" . choice))
					{
						con.writeln("Sorry, but I don't know that example.")
						continue
					}

					; Run the example.
					result := ObjBindMethod(this.Examples, choice, con).Call()
					if (result != true)
					{
						con.write_with_color({"text": result . "`n", "color": con.Color.FG_RED})
					}

					con.title := A_ScriptName . " v" . A_AhkVersion
			}
		}

		; Just in case we forget to reset the text color, we change it back to default.
		con.fgcolor := con.Color.FG_GRAY

		; Exit the program successfully.
		return EXIT_SUCCESS
	}

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
		#include %A_ScriptDir%\lib\examples.ahk
	}
}
