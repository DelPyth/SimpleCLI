/*
	name ------ : console.ahk
	description : Command line tools for AutoHotkey.
	author ---- : TopHatCat
	version --- : v0.2.0
	date ------ : 27-01-2022  [DD-MM-YYYY]
	notes ----- : Might need to work on the functions and add more properties.
	----------- : Otherwise, this is how it is for now.
	----------- : Colors constants will NOT change as these are built-in to the console's colors.
	example --- :
		; Initialize the console.
		con := new CMD()

		; Set the console's title.
		con.title = "New Console Title - " . A_ScriptName

		; Set the console's text color of any new text added.
		con.SetWritingColor(con.Colors.GREEN)

		; Write to the console.
		con.writeln("Hello World!")

		; Set a "Custom" text color.
		con.SetWritingColor(con.Colors.FOREGROUND_RED | con.Colors.FOREGROUND_GREEN | con.Colors.FOREGROUND_INTENSITY)

		; Write to the console again.
		con.writeln("Some more text!")

		; Reset the console's text color.
		con.SetWritingColor()
*/

class CMD
{
	class Color
	{
		static FG_BLACK                := 0
		static FG_DARKBLUE             := 1
		static FG_DARKGREEN            := 2
		static FG_DARKCYAN             := 3
		static FG_DARKRED              := 4
		static FG_DARKMAGENTA          := 5
		static FG_DARKYELLOW           := 6
		static FG_GRAY                 := 7
		static FG_DARKGRAY             := 8
		static FG_BLUE                 := 9
		static FG_GREEN                := 10
		static FG_CYAN                 := 11
		static FG_RED                  := 12
		static FG_MAGENTA              := 13
		static FG_YELLOW               := 14
		static FG_WHITE                := 15

		static BG_NAVYBLUE             := 16
		static BG_GREEN                := 32
		static BG_TEAL                 := 48
		static BG_MAROON               := 64
		static BG_PURPLE               := 80
		static BG_OLIVE                := 96
		static BG_SILVER               := 112
		static BG_GRAY                 := 128
		static BG_BLUE                 := 144
		static BG_LIME                 := 160
		static BG_CYAN                 := 176
		static BG_RED                  := 192
		static BG_MAGENTA              := 208
		static BG_YELLOW               := 224
		static BG_WHITE                := 240

		static FOREGROUND_BLUE      := 0x0001  ; text color contains blue.
		static FOREGROUND_GREEN     := 0x0002  ; text color contains green.
		static FOREGROUND_RED       := 0x0004  ; text color contains red.
		static FOREGROUND_INTENSITY := 0x0008  ; text color is intensified.
		static BACKGROUND_BLUE      := 0x0010  ; background color contains blue.
		static BACKGROUND_GREEN     := 0x0020  ; background color contains green.
		static BACKGROUND_RED       := 0x0040  ; background color contains red.
		static BACKGROUND_INTENSITY := 0x0080  ; background color is intensified.
	}

	static _ptr    := (A_PtrSize) ? "uptr" : "uint"
	static _suffix := (A_IsUnicode) ? "W" : "A"

	static _fgcolor := CMD.Color.GRAY
	static _bgcolor := CMD.Color.BLACK

	; Don't let foreground and background colors be the same.
	static color_protect := true

	__new(pid := -1)
	{
		DllCall("AttachConsole", "uint", pid)
		DllCall("AllocConsole")

		this.stdout := DllCall("GetStdHandle", "uint", -11, CMD._ptr)
		this.stdin  := DllCall("GetStdHandle", "uint", -10, CMD._ptr)

		if ((this.stdout + this.stdin) == 0)
		{
			throw Exception("Failed to get std handles", -1)
		}
		return this
	}

	__delete()
	{
		DllCall("FreeConsole")
	}

	fgcolor
	{
		set
		{
			this._fgcolor := value
			DllCall("SetConsoleTextAttribute", "uint", this.stdout, "uchar", value)
		}

		get
		{
			return this._fgcolor
		}
	}

	bgcolor
	{
		set
		{
			this._bgcolor := value
			DllCall("SetConsoleTextAttribute", "uint", this.stdout, "uchar", value)
		}

		get
		{
			return this._bgcolor
		}
	}

	title[original := false]
	{
		get
		{
			if (original == true)
			{
				VarSetCapacity(Title, 1024, 0)
				DllCall("GetConsoleOriginalTitle", "uint", &Title, "uint", 1024)
				return title
			}
			VarSetCapacity(Title, 1024)
			DllCall("GetConsoleTitle", "str", Title, "uint", 1024)
			return Title
		}
		set
		{
			DllCall("SetConsoleTitle" . CMD._suffix, "str", value)
		}
	}

	; This doesn't seem to work for me, but it might work for you?
	fullscreen
	{
		set
		{
			VarSetCapacity(CoordStruct, 32, 0)

			DllCall("SetConsoleDisplayMode" . CMD._suffix
				, "uint", this.stdout, "uint", value == true ? 1 : 2, "int", &CoordStruct)
		}
	}

	cursor
	{
		get
		{
			VarSetCapacity(CONSOLE_SCREEN_BUFFER_INFO, 44, 0)
			dummy := DllCall("GetConsoleScreenBufferInfo", "uint", this.stdout, "uint", &CONSOLE_SCREEN_BUFFER_INFO)
			X := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 4, "short")
			Y := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 6, "short")
			return {"x": X, "y": Y}
		}

		set
		{
			if (value.HasKey("X"))
			{
				X := value.X
			}
			else if (value.HasKey(1) && (value.Count() == 2))
			{
				X := value[1]
			}

			if (value.HasKey("Y"))
			{
				Y := value.Y
			}
			else if (value.HasKey(2) && (value.Count() == 2))
			{
				Y := value[2]
			}

			COORD := (Y << 16) + X
			DllCall("SetConsoleCursorPosition", CMD._ptr, this.stdout, "uint", COORD)
		}
	}

	set_color(textcolor := 7, backcolor := 0)
	{
		if (CMD.color_protect && textcolor == backcolor)
		{
			throw Exception("TextColor color cannot be the same as BackColor", -1, textcolor . ":" . backcolor)
		}

		this._fgcolor := textcolor
		this._bgcolor := backcolor
		wAttributes := (this._bgcolor << 4) | this._fgcolor
		return DllCall("SetConsoleTextAttribute", "uint", this.stdout, "uchar", wAttributes)
	}

	set_text_color(textcolor := 7)
	{
		if (CMD.color_protect && textcolor == this._bgcolor)
		{
			throw Exception("TextColor color cannot be the same as BackColor", -1, textcolor)
		}
		this._fgcolor := textcolor
		wAttributes := (this._bgcolor << 4) | this._fgcolor
		return DllCall("SetConsoleTextAttribute", "uint", this.stdout, "uchar", wAttributes)
	}

	set_back_color(backcolor := 0)
	{
		if (CMD.color_protect && this._fgcolor == backcolor)
		{
			throw Exception("TextColor color cannot be the same as BackColor", -1, backcolor)
		}
		this._bgcolor := backcolor
		wAttributes := (this._bgcolor << 4) | this._fgcolor
		return DllCall("SetConsoleTextAttribute", "uint", this.stdout, "uchar", wAttributes)
	}

	write(txt, args*)
	{
		Write := Format(txt, args*)
		return DllCall("WriteConsole" . CMD._suffix, "uint", this.stdout, "str", Write, "uint", strlen(Write), "uint*", Written, "uint", 0)
	}

	writeln(txt, args*)
	{
		return this.write(txt . "`n", args*)
	}

	write_with_color(blocks*)
	{
		for index, block in blocks
		{
			if (!IsObject(block))
			{
				this.write(block)
				continue
			}

			if (block.HasKey("text"))
			{
				if (block.HasKey("color"))
				{
					this.set_color(block.color)
				}
				this.write(block.text)
			}

			this.set_color()
		}
		return NULL
	}

	write_to_pos(txt, x := 0, y := 0)
	{
		cursor := this.cursor
		this.cursor := {"x": x, "y": y}
		this.write(txt)
		this.cursor := cursor
		return true
	}

	input()
	{
		VarSetCapacity(buffer, 1024)
		if ((!DllCall("ReadConsole" . CMD._suffix, CMD._ptr, this.stdin, CMD._ptr, &buffer, "uint", 1024, CMD._ptr . "*", numreaded, CMD._ptr, 0, "uint")) || (numreaded = 0))
		{
			return 0
		}

		loop, % numreaded
		{
			msg .= Chr(NumGet(buffer, (A_Index - 1) * ((A_IsUnicode) ? 2 : 1), (A_IsUnicode) ? "ushort" : "uchar"))
		}
		return StrSplit(msg, "`r`n")[1]
	}

	; Flush current console line and overwrite i?
	; I don't know if this works as I don't know what flush does :?
	flush()
	{
		return DllCall("FlushConsoleInputBuffer", "uint", this.stdin)
	}

	; This method feels slow, but that could just be me. If the first method works fine with no delay, please remove this.
	clear()
	{
		VarSetCapacity(CoordStruct, 4, 0)
		Numput(3, &CoordStruct, 0, "short")
		Numput(3, &CoordStruct, 2, "short")
		VarSetCapacity(CharsWritten, 1024)
		obj := this.get_buffer_size()
		w := obj.width
		h := obj.height

		if (!DllCall("FillConsoleOutputCharacter" . CMD._suffix, "uint", this.stdout, "Char", A_Space, "uint", w * h, "uint", CoordStruct, "uint", &CharsWritten))
		{
			return 0
		}

		if (!DllCall("FillConsoleOutputAttribute", "uint", this.stdout, "Short", 15, "uint", w * h, "uint", CoordStruct, "uint", &CharsWritten))
		{
			return 0
		}
		return DllCall("SetConsoleCursorPosition", "uint", this.stdout, "uint", CoordStruct)
	}

	get_shown_buffer()
	{
		VarSetCapacity(CONSOLE_SCREEN_BUFFER_INFO, 44, 0)
		dummy := DllCall("GetConsoleScreenBufferInfo", "uint", this.stdout, "uint", &CONSOLE_SCREEN_BUFFER_INFO)
		X_upper_left := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 10, "short")
		Y_upper_left := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 12, "short")
		X_lower_right := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 14, "short")
		Y_lower_right := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 16, "short")
		return {"x1": X_upper_left, "y1": Y_upper_left, "x2": X_lower_right, "y2": Y_lower_right}
	}

	get_buffer_size()
	{
		VarSetCapacity(CONSOLE_SCREEN_BUFFER_INFO, 44, 0)
		dummy := DllCall("GetConsoleScreenBufferInfo", "uint", this.stdout, "uint", &CONSOLE_SCREEN_BUFFER_INFO)
		Width := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 0, "short")
		Height := NumGet(&CONSOLE_SCREEN_BUFFER_INFO, 2, "short")
		return {"width": Width, "height": Height}
	}

	; Holy shit I hate this function.
	; It was such a headache to do because when you try to get the text, it doesn't add the newline character.
	; I don't know why, but I added a newline character to the end of each passable line as well as trimming any excess space at the end.
	; I'm not sure if this is the best way to do it, but it works and it's kinda quick too.

	; Get text of entire console.
	get_console_text()
	{
		obj := this.get_buffer_size()
		width  := obj.width
		height := obj.height

		VarSetCapacity(buffer, (width * height) * 2, 0)
		VarSetCapacity(CoordStruct, 4, 0)
		Numput(3, &CoordStruct, 0, "short")
		Numput(3, &CoordStruct, 2, "short")
		VarSetCapacity(CharsWritten, 1024)
		if (!DllCall("ReadConsoleOutputCharacter" . CMD._suffix, "uint", this.stdout, "char", &buffer, "uint", width * height, "uint", CoordStruct, "uint", &CharsWritten))
		{
			return 0
		}

		result := ""

		; Loop through the width of the console's size and add a new line to the result.
		loop, % height
		{
			result .= Chr(NumGet(&buffer, (A_Index - 1) * 2, "ushort"))
			if (Mod(A_Index, width) == 0)
			{
				result := RTrim(result) . "`n"
			}
		}

		; Remove any trailing newlines.
		return RegExReplace(result, "`n+$")
	}
}
