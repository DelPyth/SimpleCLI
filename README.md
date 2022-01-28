# SimpleCLI
A super comfortable CLI demo to showcase how to create CLI programs in AutoHotkey.

## Do I need anything to run this?
An AutoHotkey installation of 1.1.33.10+. Nothing much else.

## How to I run this demo?
Run `main.ahk` with AutoHotkey (recommended unicode) and you should be good to go.

## How do I make my own?
There's a two ways (I can think of) to do so:
- Create a new script file and include `console.ahk` in it and look over the examples I've given in `lib/examples.ahk`.
- Take my code and strip everything down you don't like... You monster.

## Does this have any practical use over a GUI?
Hell no! A GUI is much more powerful and allows for much more control over user input.
This whole demo is purely to show the use of a console as your interface as merely to be fancy and look cool to all your friends :)

## What's `oop.ahk`?
That is my way of doing Object Oriented Programming in AHK. It's a little.. tempermental and requires the include to be last or something close to last, read more about why in that file.

## What can this console class do?
First you have to initalize it:
```
con := new CMD()
```
Then you can do so many things:
- Print to it (of course).
```
con.writeln("Hello world!")
con.write("I am the start of a line... ")
con.writeln("And I'm at the end of the same line!")
```
- Get user input (prompt for answer).
```
con.write("Enter your name:  ")
username := con.input()
con.writeln("Hello, {1}!", username)
```
- Change text color and background and print to the console.
```
con.fgcolor := con.Color.FG_CYAN
con.bgcolor := con.Color.BG_RED
con.writeln("This is probably really hard to see. Sorry!")
con.writeln("Let's clean this up...")
con.set_color()  ; Reset console colors back to default (grey text, black background).
```

## What can the console class not do?
It does not have built-in user interfaces like a progress bar, selection list, or statusbar. Those you have to make yourself. I've provided the progress bar as an example for you already.


### Note...
- Testing is needed on other versions of windows and bit sizes of AHK.
- *Method names are due to change and cleanup, so keep an eye on the changelog for name changes!*
- Documentation for `lib/console.ahk` is to be done, I'm just pushing this demo to github before I lose it to something dumb.

### What I want to add next:
- A new write method that allows for changing the color without passing an map as a parameter.
- Clean up method names.
- Add new properties.
