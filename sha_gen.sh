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
n=0				

for b in {2..600}
do 
	for (( a=1; a<b; a++ ))
	do
		if (( a * 2 == b )); then
			continue
		fi
		
		echo "a,b = $a, $b"
		
		found=0		
		for i in ${recordIdx[@]}; 
		do
			echo "eval pp${a}_${b}_checkS${i} \"An (S${i}[n]=S${i}[n+${a}]|S${i}[n]=S${i}[n+${b}])\":\r" >&${COPROC[1]}
# 			cat <&${COPROC[0]} 

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
			./og_gen ${a} ${b} 3 1 1 ${counter} >> ./genOut/genlog.txt
			chmod -R 755 ./genOut

			less ./genOut/${a}_${b}_311_S${counter}.txt << EOF >&${COPROC[1]}
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
			let counter++
		fi
		
		echo "n = ${n}"
		let n++
		if (( n > 10 )); then 
			kill $COPROC_PID
			coproc java Main.Prover
			n=0
		fi
	done
done
echo 'exit;' >&${COPROC[1]}










# 				let n++
# 				if (( n > 150))
# 				then
# 					kill $COPROC_PID
# 					coproc java Main.Prover
# 					break
# 				fi


# 			sleep .8
# 			ppNewSeqCheck=$(<../Result/"pp${a}_${b}_checkS${counter}.txt")
# 			cfNewSeqCheck=$(<../Result/"cubeplusfree_S${counter}.txt")
# 
# 			while [ "${ppNewSeqCheck}" == "" ] || [ "${cfNewSeqCheck}" == "" ]
# 			do
# 				ppNewSeqCheck=$(<../Result/"pp${a}_${b}_checkS${counter}.txt")
# 				cfNewSeqCheck=$(<../Result/"cubeplusfree_S${counter}.txt")
# 			done			



# 			ppCheck=$(<"../Result/pp${a}_${b}_checkS${i}.txt")
# 			while [ "${ppCheck}" == "" ]
# 			do
# 				ppCheck=$(<../Result/"pp${a}_${b}_checkS${i}.txt")
# 			done			


# 		if (( found == 0 && !(a * 2 == b) ))


# 			echo 'exit;' >&${COPROC[1]}
# 			wait $COPROC_PID


# # at the end made it slow so
# wait $COPROC_PID


# chmod -R 555 ./genOut
# 
# coproc java Main.Prover 
# 
# echo "eval test \"Ei,n (n >=1) & Aj (j<=n) => T[i+j] = T[i+j+n]\";\r" >&${COPROC[1]}
# 
# less ./genOut/3_4_311.txt << EOF >&${COPROC[1]}
# EOF
# 
# echo 'exit;' >&${COPROC[1]}
# 





# NAME="checkTMP"
# value=$(<../Result/${NAME}a.txt)
# 
# if [ ${value} == "true" ]
# then
# echo Hey that\'s a large number.
# echo "$value"  
# fi

# 			if (( b == 4 && a == 2 ))
# 			then
# 				 break
# 			fi
			




# X=3
# X=2
# ary=()
# ary+=(4)
# ary+=($X)
# echo ${ary[0]}
# echo ${ary[1]}




# coproc java Main.Prover 
# # Alfred's stdin is now referred to with ${COPROC[1]}
# 
# echo 'eval tmp "Ei,n (n >=1) & Aj (j<=n) => T[i+j] = T[i+j+n]";\r' >&${COPROC[1]}
# 
# echo 'reg power2 msd_2 "0*10*":\r' >&${COPROC[1]}
# 
# echo 'eval prop1 "Aa,x,i (a>=1 & $power2(x)) => (T[i]=T[i+a] | T[i]=T[i+a+x] | T[i]=T[i+a+2*x])":\r' >&${COPROC[1]}
# 
# echo 'exit;' >&${COPROC[1]}
# 
# # Alfred's stdout is found with ${COPROC[0]}
# cat <&${COPROC[0]} > out.txt
# echo wow




# for i in {1..5}
# do
#    echo "Welcome $i times"
# done


# for b in {2..5}
# do 
# 	for (( a=1; a<b; a++ ))
# 	do
# 		echo am a $a
# 	done
# 	echo am b $b
# done
