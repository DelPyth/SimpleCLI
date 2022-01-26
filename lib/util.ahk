/*
	name ------ : util.ahk
	description : Simple tools for AHK scripts. Constants, functions, etc.
	author ---- : TopHatCat
	version --- : v1.0.0
	date ------ : 21-01-2022  [DD-MM-YYYY]
*/

; =================================================================================================================
; CONSTANTS

; int EXIT_SUCCESS = 0    // Indicate a success when closing the current program.
global EXIT_SUCCESS := 0
; int EXIT_FAILURE = 1    // Indicate a failure when closing the current program.
global EXIT_FAILURE := 1

; char NULL = 0           // Create a null character for readabilty in AHK.
global NULL := Chr(0)

; string DIR_BINARY       // The directory where any included binary files can be located for a global installation.
global DIR_BINARY := A_MyDocuments . "/AutoHotkey/lib/bin"


; =================================================================================================================
; FUNCTIONS

/*
	@name get_flags
	@brief Get flags from a string similar to how a URL's flags are parsed.
	@param {string} flags_str        - The string containing the flags.
	@param {char}   flag_delim = "&" - The delimiter used to separate the flags.
	@return {object} The flags.
*/
get_flags(flags, flag_delim := "&")
{
	result := {}

	for i, flag in StrSplit(flags, flag_delim)
	{
		if (InStr(flag, "="))
		{
			split := StrSplit(flag, "=")

			switch (split[2])
			{
				case "true", "yes":   result[split[1]] := true
				case "false", "no":   result[split[1]] := false
				case "null", "none":  result[split[1]] := NULL
				default:              result[split[1]] := split[2]
			}
			continue
		}

		result[flag] := true
	}
	return result
}

/*
	@name json_date
	@brief Get a date in JSON format.
	@param {boolean} local_time - Whether to get the date in local time or UTC.
	@return {string} The date in JSON format.
*/
json_date(local_time := false)
{
	FormatTime, frmt_time,, HH:mm:ss
	FormatTime, frmt_date,, yyyy-MM-dd

	VarSetCapacity(SYSTEMTIME, 16, 0)

	; GetLocalTime - Get local time.
	; GetSystemTime - Get UTC time.
	DllCall("kernel32\" . (local_time ? "GetLocalTime" : "GetSystemTime"), "Ptr", &SYSTEMTIME)

	msec := NumGet(&SYSTEMTIME, 14, "UShort")  ; wMilliseconds

	return Format("{1}T{2}.{3}Z", frmt_date, frmt_time, msec)
}

/*
	@name join_array
	@brief Join an array into a human readable string.
	@param {array} arr - The array to combine.
	@param {string} delim = ", " - The delimiter to use.
	@return {string} The combined string.
*/
join_array(arr, delim := " ")
{
	; If not an array, just return it.
	if (!IsObject(arr))
	{
		return arr
	}

	result := ""

	for i, item in arr
	{
		result .= item . (i < arr.Count() ? delim : "")
	}
	return result
}
