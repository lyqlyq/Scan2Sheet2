# https://stackoverflow.com/questions/3207219/how-do-i-list-all-files-of-a-directory
import os
from os import walk
from os import path

swift_files = []
# extract all .swift file
for (dirpath, dirnames, filenames) in walk(os.getcwd()):
	for file in filenames:
		if path.splitext(file)[1] == ".swift":
			swift_files.append(path.join(dirpath, file))

# remove all empty line in end of swif file
for file in swift_files:
	fo = open(file, encoding='utf-8', mode="r+")

	# read lines
	lines = fo.readlines()
	# remove empty line
	while True:
		if len(lines) == 0:
			break
		l = lines.pop()		
		if l != '\n':
			lines.append(l)
			break		

	# empty file			
	fo.seek(0)
	fo.truncate()
	# write to file
	fo.writelines(lines)
	fo.flush()
	fo.close()