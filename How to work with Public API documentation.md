

	This repository only contains the documentation source code ( docs.sources ) .

	To edit documentation just edit *.md files in sources folder. 

	To see the changes run 'bundle exec middleman server' in Terminal. (and then open http://0.0.0.0:4567 in browser)

	To push the changes to the github just use: git push.

	To publish these changes to https://idexx.github.io/docs-sfs/ do next:

		1) go to the docs.sources folder in the Terminal
		2) run 'bundle exec middleman build --clean' in the Terminal
			-> this will build html files and put them in /build folder
		
		3) Copy /build folder contents to the 'docs.veterinarium.io' project ( https://github.com/IDEXX/docs-sfs.git )
		4) Push changes to github for 'docs.veterinarium.io'
			-> changes should immediatelly appear on https://idexx.github.io/docs-sfs/
