/*
	name ------ : oop.ahk
	description : Allow for an object oriented programming style in AutoHotkey scripts.
	author ---- : TopHatCat
	version --- : v1.0.0
	date ------ : 21-01-2022  [DD-MM-YYYY]
	notes ----- : - Runs in the global scope. If there's a way to run the if statement without creating a new function, without creating new variables,
	----------- :   and without requiring this include to be at the bottom of an include list, then be my guest.
	----------- : - This file MUST be included last if other files execute code as this will run a command and close the program.
	----------- : - The reason we can't just throw this in a function and use static to initialize it before everything else is because static is called before everything else,
	----------- :   and we need to be able to have other includes use their constants/variables before this file is run.
	----------- :   Technically we could modify the other files to have a function in each that initializes all of the variables, but that would be a pain.
	----------- :   So for now, we're just gonna have to enforce that this runs last.
*/

; Entry point.
; If the class PROGRAM exists, we check if the INIT method exists and if it does, we run it as the entry point to the program.
if (IsObject(Program) && (Program.__Class != NULL))
{
	if (ObjBindMethod(Program, "init"))
	{
		ExitApp, % Program.init(A_Args*)
	}
}

/*
	@name get_str
	@brief Retrieves a string of the given parameter.
	@param {any} obj - The variable to retrieve the string from.
	@return {string} Returns the string representation of the given variable if it is an object that has the __STR "meta" function.
	@notes This function is here instead of @file{util.ahk} because it fits within the Object Oriented model of AutoHotkey we're wanting.
*/
get_str(obj)
{
	; If it's not an object, we just return the string.
	if (!IsObject(obj))
	{
		return obj
	}

	; If it is an object, make sure it has the __str method.
	if (ObjBindMethod(obj, "__str"))
	{
		return obj.__str()
	}

	; Shouldn't happen.
	return NULL
}
