" The stock rule starts a string at any ', so an apostrophe in prose
" ("libevent's") swallows the rest of the file. Only treat ' as a quote
" when it does not follow a word character.
syn clear configstring
syn region configstring start=+\z(["`]\)+ skip=+\\\z1+ end=+\z1+ contains=@Spell
syn region configstring start=+\(\w\)\@<!'+ skip=+\\'+ end=+'+ contains=@Spell
