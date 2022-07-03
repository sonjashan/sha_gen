#!/opt/homebrew/bin/bash

#!/bin/bash

recordIdx=()
for n in {0..69}
do
	recordIdx+=("$n")
done

for b in {40..54}
do
	for (( a=22; a<24; a++ ))
	do
		if (( a * 2 == b )); then
			continue
		fi

		echo "a,b = $a, $b"

		found=0
		for i in "${recordIdx[@]}";
		do
      coproc java Main.Prover
			echo "eval pp${a}_${b}_checkS${i} \"An (S${i}[n]=S${i}[n+${a}]|S${i}[n]=S${i}[n+${b}])\":\r" >&"${COPROC[1]}"
      echo 'exit;' >&"${COPROC[1]}"
      wait "$COPROC_PID"

			ppCheck=$(<"../Result/pp${a}_${b}_checkS${i}.txt")

			if [ "${ppCheck}" == "true" ]
			then
				echo "see pp${a}_${b}_checkS${i}.txt in Results"
				found=1
				break
			else
			  rm ../Result/pp${a}_${b}_checkS${i}*
				echo "pp${a}_${b}_checkS${i} returned false - files deleted" >> pseudoCheckFailedRecord.txt
			fi
		done
	done
done

# use files like 9_40_311_S57.txt from genOut folder to let Walnut know about all these sequences
#for filename in ../Command\ Files/tmp/*.txt
#do
#  echo "$filename"
#done