## Part 1
# Question 2


I've gone ahead and added a bunch of comments to some_controller.rb, noting issues, and possible solutions

The primary concern is the sheer amount of logic located in the controller
Secondary is trying to break out the nested structure of the logic into something more manigible 
Hopefully there are existing tests for this controller, if not some would need to be created before attempting a refactor

Rather than an in depth discussion of the controller, I've spent most of my effort refactoring it
improved_controller.rb is a refactored version of some_controller.rb
Model specific logic has been moved into models
Presentation logic has been moved into a Presentor
The render partial has been moved into a regular .html.erb file


