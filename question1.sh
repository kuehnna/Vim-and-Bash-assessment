#selects all files ending in _scores.out
for file in *_scores.out
  #outputs name of file
  do echo "$file"
  #outputs linecount of file (-2 because first 2 lines are header, not models)
  sed -e '1,2d' < "$file" | wc -l
done
