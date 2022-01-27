/*
	name ------ : examples.ahk
	description : A handful of examples for the CLI program. I put them here to keep things clean and to clear space in the main file.
	----------- : as well as some common ideas used in other CLI tools.
	author ---- : TopHatCat
	version --- : v0.1.0
	date ------ : 27-01-2022  [DD-MM-YYYY]
*/

/*
	To create your own example:
	1. Create a new function with the parameter:
		con : The console object to control... the console.
	2. Change the title of the console to match the other examples below:
		con.title := "my_test - " . A_ScriptName
	3. Add a property above the function with the name of the example and the description of the example:
		static example_my_test := "A quick test to print some stuff to the console."
	4. Return either TRUE for success, or a string telling what went wrong with the example:
		if (x > 5)
		{
			return TRUE
		}
		else
		{
			return "x cannot be greater than 5"
		}
	That's it.
*/

static example_hello_world := "Write ""Hello World!"" to the console and wait for the user to press ENTER."
hello_world(con)
{
	; Set the title.
	con.title := "hello_world - " . A_ScriptName

	; Say hello while showing an example of the format tool of the function.
	con.writeln("Hello {1}!", "World")

	; Wait for user input.
	con.write("Press enter to continue...")
	con.input()
	return true
}

static example_input_info := "Ask the user for some input and then greet them :)"
input_info(con)
{
	; Set the title.
	con.title := "input_info - " . A_ScriptName

	; Ask for the user's name.
	con.write("What's your name?  ")
	con.fgcolor := con.Color.FG_YELLOW
	user_name := con.input()
	con.fgcolor := con.Color.FG_GRAY

	; Ask for the user's age.
	con.write("What's your age?   ")
	con.fgcolor := con.Color.FG_YELLOW
	user_age := con.input()
	con.fgcolor := con.Color.FG_GRAY

	; Greet the user.
	con.writeln("Hello {1}!  You are {2} years old.", user_name, user_age)
	return true
}

static example_useless_calc := "A useless calculator and number comparison thingie."
useless_calc(con)
{
	; Set the title.
	con.title := "useless_calculator - " . A_ScriptName

	; Give a little heads up.
	con.writeln("This calculator is useless.")
	con.writeln("It just does a simple calculation along with some comparison operators.")
	con.writeln("Also note that the bit size is 32-bit.")

	; Ask for the first number.
	con.write("What's the first number?   ")
	con.fgcolor := con.Color.FG_YELLOW
	first_number := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (first_number == NULL)
	{
		return "You didn't enter a number."
	}

	; Ask for the operation.
	con.write("What's the operation?      ")
	con.fgcolor := con.Color.FG_YELLOW
	operation := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (operation == NULL)
	{
		return "You didn't enter an operation."
	}

	; Ask for the second number.
	con.write("What's the second number?  ")
	con.fgcolor := con.Color.FG_YELLOW
	second_number := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (second_number == NULL)
	{
		return "You didn't enter a number."
	}

	; Calculate the result.
	result := 0
	switch (operation)
	{
		case "+":   result := first_number + second_number
		case "-":   result := first_number - second_number
		case "*":   result := first_number * second_number
		case "/":
			if (second_number == 0)
			{
				return "Division by zero is not allowed!"
			}
			result := InStr(first_number, ".") || InStr(second_number, ".")
				? first_number / second_number
				: Round(first_number / second_number)
		case "%":
			if (second_number == 0)
			{
				return "Division by zero is not allowed!"
			}
			result := Mod(first_number, second_number)

		; AHK doesn't print True or False as strings, just as ints, so we'll print them ourselves.
		case "^":   result := first_number ** second_number
		case ">":   result := first_number > second_number ? "True" : "False"
		case "<":   result := first_number < second_number ? "True" : "False"
		case "=":   result := first_number == second_number ? "True" : "False"
		case "!=":  result := first_number != second_number ? "True" : "False"
		case ">=":  result := first_number >= second_number ? "True" : "False"
		case "<=":  result := first_number <= second_number ? "True" : "False"
		default:    return "Unknown operation!"
	}
	con.writeln("{1} {2} {3} = {4}", first_number, operation, second_number, result)
	return true
}

static example_random_num_gen := "Generate a random number your two choices."
random_num_gen(con)
{
	; Set the title.
	con.title := "random_num_gen - " . A_ScriptName

	; Ask for the first number.
	con.write("What's the first number?   ")
	con.fgcolor := con.Color.FG_YELLOW
	first_number := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (first_number == NULL)
	{
		return "You didn't enter a number."
	}

	; Ask for the second number.
	con.write("What's the second number?  ")
	con.fgcolor := con.Color.FG_YELLOW
	second_number := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (second_number == NULL)
	{
		return "You didn't enter a number."
	}

	; Generate a random number between X and Y.
	Random, secret_result, 1, 2
	Random, random_result, % first_number, % second_number
	secrete_msg := secret_result == 2 ? "Your lucky lottery number is: {1}" : "Random number: {1}"
	con.writeln(secrete_msg, random_result)
	return true
}

static example_progress_bar := "A simple progress bar showing off cursor positioning and color."
progress_bar(con)
{
	; Set the title.
	con.title := "progress_test - " . A_ScriptName

	con.writeln("This is a simple example of using cursor positioning to overwrite where the progress bar is.")
	con.writeln("It is recommended that you use the width of around 16 to 50 characters.")
	con.writeln("Depending on how long you set the width, the amount of time it takes to finish will vary.")
	con.write_with_color("Enter '", {"text": "exit", "color": con.Color.FG_CYAN}, "' to quit the example.`n")

	; This is the width of the progress bar, it is recommended to use between 10 and 50.
	width := 0
	allowed_width := false

	; This could probably be done better but I don't care at the moment.
	while (!allowed_width)
	{
		con.write("Enter a width for the progress bar:  ")
		con.fgcolor := con.Color.FG_YELLOW
		width := con.input()
		con.fgcolor := con.Color.FG_GRAY
		if (width == NULL)
		{
			con.fgcolor := con.Color.FG_RED
			con.writeln("You didn't enter a number!")
			con.fgcolor := con.Color.FG_GRAY
		}
		else if (width = "exit")
		{
			return true
		}
		else if width not between 16 and 50
		{
			con.fgcolor := con.Color.FG_RED
			con.writeln("The width must be between 16 and 50!")
			con.fgcolor := con.Color.FG_GRAY
		}
		else
		{
			allowed_width := true
		}
	}

	; Ask for the progress bar character, if the given input is longer than a single character, just use default.
	con.write("Progress bar character, default is the equals sign (=):  ")
	con.fgcolor := con.Color.FG_YELLOW
	progress_bar_char := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if ((StrLen(progress_bar_char) > 1) || (progress_bar_char == NULL))
	{
		progress_bar_char := "="
	}

	; This is the amount of time it takes to finish the progress bar.
	elasped_time := A_TickCount

	con.write("Progress: ")
	con.fgcolor := con.Color.FG_YELLOW
	con.writeln("{1:s}", 0)
	loop % width
	{
		empty_space .= " "
	}
	con.fgcolor := con.Color.FG_GRAY
	con.writeln("[{1}]", empty_space)

	cursor := con.cursor
	xpos := cursor.x + 1
	ypos := cursor.y - 1

	loop % width
	{
		; Sleep for a second.
		Sleep, 100

		; Set the percent color.
		percent_clr := con.Color.FG_GRAY

		; Calculate the percentage.
		percent := (A_Index / width) * 100

		if (percent <= 25)
		{
			percent_clr := con.Color.FG_RED
		}
		else if (percent <= 50 && percent > 25)
		{
			; I don't like the default yellow, but I can't really complain since
			; DARKYELLOW is just gold and any other ways of doing yellow will lead us back to the original.
			percent_clr := con.Color.FG_YELLOW
		}
		else if (percent >= 50)
		{
			percent_clr := con.Color.FG_GREEN
		}

		; Show the progress as a number.
		con.set_text_color(percent_clr)
		con.write_to_pos(Round(percent) . "%", 10, ypos - 1)

		; Reset the color...
		con.set_text_color(con.Color.FG_GRAY)

		; Append our progress bar.
		con.write_to_pos(progress_bar_char, xpos, ypos)

		xpos += 1
	}

	; Reset the cursor position back to normal.
	con.cursor := {"x": 0, "y": ypos + 1}

	; Say we're done.
	con.writeln("Finished in {1}s!", Round((A_TickCount - elasped_time) / 1000))
	return true
}

static example_open_file := "Open a file and read it's contents."
open_file(con)
{
	; Set the title.
	con.title := "open_file - " . A_ScriptName

	con.writeln("You can use environment variables surrounded with percent signs (%) as well as using a tilda (~) for the home directory.")
	con.write_with_color("Enter '", {"text": "exit", "color": con.Color.FG_CYAN}, "' to quit the example.`n")
	con.write("The file path:  ")
	con.fgcolor := con.Color.FG_YELLOW
	file_path := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (file_path == NULL)
	{
		return "You didn't enter a file."
	}

	if (file_path = "exit")
	{
		return true
	}

	; Replace starting Tilda with the home directory.
	EnvGet, env_home, USERPROFILE
	file_path := RegExReplace(file_path, "^\~", env_home)

	; Replace environment variables.
	while (RegExMatch(file_path, "iOS)%([a-z0-9_]+)%", match_obj))
	{
		EnvGet, env_var, % match_obj[1]
		file_path := StrReplace(file_path, Format("%{1}%", match_obj.Value(1)), env_new)
	}

	if (!FileExist(file_path))
	{
		return "The file you've entered doesn't exist."
	}

	if (InStr(FileExist(file_path), "D"))
	{
		return "The file you've entered is a directory."
	}

	FileGetSize, file_size, % file_path, K
	if (file_size > 4)
	{
		return "The file you've entered is larger than 4 kb. For the sake of this example, we want to keep it under 4 kb."
	}

	con.writeln("The contents of the file are:")
	con.writeln("--------------------------------")

	; Open file.
	file_obj := FileOpen(file_path, "r")

	; Read and print to console.
	con.writeln(file_obj.Read())
	con.writeln("--------------------------------")

	; Close file.
	file_obj.Close()
	return true
}

static example_save_console := "Save the current console's contents to a file."
save_console(con)
{
	; Set the title.
	con.title := "save_console - " . A_ScriptName

	con.writeln("You can use environment variables surrounded with percent signs (%) as well as using a tilda (~) for the home directory.")
	con.write_with_color("Enter '", {"text": "exit", "color": con.Color.FG_CYAN}, "' to quit the example.`n")
	con.write("The file path:  ")
	con.fgcolor := con.Color.FG_YELLOW
	file_path := con.input()
	con.fgcolor := con.Color.FG_GRAY
	if (file_path == NULL)
	{
		return "You didn't enter a file."
	}

	if (file_path = "exit")
	{
		return true
	}

	; Replace starting Tilda with the home directory.
	EnvGet, env_home, USERPROFILE
	file_path := RegExReplace(file_path, "^\~", env_home)

	; Replace environment variables.
	while (RegExMatch(file_path, "iOS)%([a-z0-9_]+)%", match_obj))
	{
		EnvGet, env_var, % match_obj[1]
		file_path := StrReplace(file_path, Format("%{1}%", match_obj.Value(1)), env_new)
	}

	if (FileExist(file_path))
	{
		return "The file you've entered already exists."
	}

	file_path := StrReplace(file_path, "/", "\")

	con.writeln("Appending console text to:  {1}", file_path)

	; Save the console contents to the file.
	try
	{
		FileAppend, % con.get_console_text(), % file_path
	}
	catch err
	{
		return IsObject(err) ? err.message : err
	}
	return true
}

static example_multi_line_input := "Allow the user to enter multiple lines of text."
multi_line_input(con)
{
	; Set the title.
	con.title := "multi_line_input - " . A_ScriptName

	con.writeln("Type some multi-line text.")
	con.writeln("Enter a blank line to quit the example.`n")

	txt := ""

	; Keep looping until the user enters a blank line.
	loop
	{
		con.write(">>> ")
		con.fgcolor := con.Color.FG_YELLOW
		line := con.input()
		con.fgcolor := con.Color.FG_GRAY

		if (line == NULL)
		{
			break
		}

		txt .= line . "`n"
	}

	txt := RTrim(txt, "`n")

	if (txt != NULL)
	{
		con.writeln("You entered: ")
		con.writeln("--------------------------------")
		con.writeln(txt)
		con.writeln("--------------------------------")
	}
	return true
}
