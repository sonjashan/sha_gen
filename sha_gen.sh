#!/opt/homebrew/bin/bash


rm -f ./genOut/*.*
rm -f ../Result/pp*_*_checkS*.*
rm -f ../Result/cubeplusfree_S*.*
rm -f ../Result/S*.*
rm -f ../Result/sha*.*
rm -f waitforjava.txt
rm -f ochem_gen_failed.txt

recordIdx=()
counter=0

coproc java Main.Prover 

for b in {2..10}
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
			echo "eval pp${a}_${b}_checkS${i} \"An (S${i}[n]=S${i}[n+${a}]|S${i}[n]=S${i}[n+${b}])\":\r" >&"${COPROC[1]}"

			1>>waitforjava.txt 2>&1 cat "../Result/pp${a}_${b}_checkS${i}.txt" 
			while [ $? -eq 1 ]
			do
				1>>waitforjava.txt 2>&1 cat "../Result/pp${a}_${b}_checkS${i}.txt" 
			done

			ppCheck=$(<"../Result/pp${a}_${b}_checkS${i}.txt")

			if [ "${ppCheck}" == "true" ]
			then
				echo "see pp${a}_${b}_checkS${i}.txt in Results"
				found=1
				break
			fi			
		done
		
		if (( found == 0 ))
		then
			echo "running a=${a}, b=${b}" >> ./genOut/genlog.txt
			./og_gen "${a}" "${b}" 3 1 1 ${counter} >> ./genOut/genlog.txt
			chmod -R 755 ./genOut

			less ./genOut/"${a}"_"${b}"_311_S${counter}.txt << EOF >&"${COPROC[1]}"
EOF

			1>>waitforjava.txt 2>&1 cat "../Result/cubeplusfree_S${counter}.txt"
			while [ $? -eq 1 ]
			do
				1>>waitforjava.txt 2>&1 cat "../Result/cubeplusfree_S${counter}.txt" 
			done

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
echo 'exit;' >&"${COPROC[1]}"


