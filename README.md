# Vim-and-Bash-assessment

### Use vim or  write simple bash script:

1. Count the number of models (each models = 1 line) for each scores.out files in the output directory
	Didn't wanna paste all the numbers, but question1.sh prints every filename ending in _scores.out and the corresponding line count (minus first two lines which are header)

2. What is the total_score of the model 45688_37289_water_0034?
	The answer is -1174.020.
	Method: found relevant line in relevant file using grep -r and -n; then used
	awk 'NR==2 || NR==36' Y4-models/37289_45688_scores.out | awk '{print $1 "\t" $2}'
	to print first two columns of header and relevant lines.

3. In the folder "promissing90models": Change the ligand entries from chain X to chain B in each pdb file. (vim/sed)
	Did just that. The command that did it (not very elegantly) was as follows:
	sed -r -i.original 's/([a-Z0-9]+[ ]+[a-Z0-9]+[ ]+[a-Z0-9]+[ ]+[a-Z0-9]+[ ]+)X/\1B/' *.pdb
	afterwards (after checking that the files looked the way they were supposed to), I simply used rm *.original
Just for fun : you should inspect the pdb files by running them on pymol to see how Y4 interacts with NAM.

4. output the column total score, interface_delta_x, and model name from the file scores.out, then sort the output based on the interface_delta_X scores and save the results into the sorted_models.txt
	This was achieved using the following:
	#putting a header for the intermediate scores.txt that contains the unsorted list
	echo -e "total_score\tinterface_delta_X\tdescription" > scores.txt
	#putting the three relevant columns (plus the filename for each line) in scores.txt
	for file in *scores.out; do awk '{if (NR > 2) print $2 "\t" $50 "\t" $62 "\t" ARGV[ARGIND]}' $file >> scores.txt; done
	#setting a header for sorted_scores.txt
	echo -e "total_score\tinterface_delta_X\tdescription\t file" > sorted_models.txt
	#sorting things by interface_delta_X and appending them to sorted_models.txt
	awk 'NR > 1' scores.txt | sort -k2 -n >> sorted_models.txt

5. make a new dir named "best_models", and move 10 best models with lowest sum of total_score and interface_delta_X to this dir. (awk, xargs))
	#First: finding 10 models with lowest sum of total_score and interface_delta_X:
	awk '{if (NR > 1) print $3 "\t" ($1 + $2) "\t" $4}' sorted_models.txt | sort -k2 -g | head -n 10
	This is used inside a short bash script to define the range for a loop variable named "model":
	for model in $(awk '{if (NR > 1) print $3 "\t" ($1 + $2) "\t" $4}' sorted_models.txt | sort -k2 -g | head -n 10 | awk '{print $1}'); do awk '/'$model'/' *_scores.out >> best_models/best_models.txt; done
