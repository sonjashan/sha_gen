#!/opt/homebrew/bin/bash

#!/bin/bash

rm -fr ./genOut
rm -f ../Result/pp*_*_checkS*.*
rm -f ../Result/cubeplusfree_S*.*
rm -f ../Result/S*.*
rm -f ../Result/sha*.*
rm -f ochem_gen_failed.txt
rm -f og_gen
rm -f pseudoCheckFailedRecord.txt

gcc -O3 -o og_gen og_gen.c
mkdir genOut

recordIdx=()
counter=0


for b in {2..500}
do
	for (( a=1; a<b; a++ ))
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

		if (( found == 0 ))
		then
			echo "running a=${a}, b=${b}" >> ./genOut/genlog.txt
			./og_gen "${a}" "${b}" 3 1 1 ${counter} >> ./genOut/genlog.txt
			chmod -R 755 ./genOut

      coproc java Main.Prover ../bin/genOut/"${a}"_"${b}"_311_S${counter}.txt
      echo 'exit;' >&"${COPROC[1]}"
      wait "$COPROC_PID"

			ppNewSeqCheck=$(<"../Result/pp${a}_${b}_checkS${counter}.txt")
			cfNewSeqCheck=$(<"../Result/cubeplusfree_S${counter}.txt")

			if [ "${ppNewSeqCheck}" != "true" ] || [ "${cfNewSeqCheck}" != "false" ]
			then
				echo "see ochem_gen_failed.txt"
				echo "${a}_${b}_311_S${counter}.txt by Ochem program does not work!!!" >> ochem_gen_failed.txt
			else
				echo "see ${a}_${b}_311_S${counter}.txt in genOut"
			fi
			recordIdx+=("$counter")
			(( counter++ ))
		fi
	done
done


