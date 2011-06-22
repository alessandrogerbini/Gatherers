#!/bin/sh

# Launches development environment stuff
  
  osascript <<-eof
    set app_directory to "~/typeish_clients/granola/"
    
	tell application "iTerm"

		set staticterm to (make new terminal)
		tell staticterm

			launch session "Default session"
			tell the last session
				set name to "staples server"
				write text "cd " & app_directory
				write text "staples runserver"
			end tell

			launch session "Default session"
			tell the last session
				set name to "staples watcher"
				write text "cd " & app_directory
				write text "workon aym"
				write text "staples watch"
			end tell

			launch session "Default session"
			tell the last session
				set name to "Compass"
				write text "cd " & app_directory
				write text "compass watch --sass-dir content/sass/ --css-dir content/media_includes/ -s compact"
			end tell

			launch session "Default session"
			tell the last session
				set name to "CoffeeScript"
				write text "cd " & app_directory
				write text "coffee -o content/media_includes/ -w -c content/coffee/*.coffee"
			end tell

			launch session "Default session"
			tell the last session
				set name to "Livereload"
				write text "cd " & app_directory
				write text "livereload"
			end tell

		end tell
	end tell

eof
