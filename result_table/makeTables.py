import pandas as pd

gen_out = open("genlog.txt", "r")

seq_num = 0
entry_dict = {}
key_int = ()
value_lst = []
zero_line = False
one_line = False

for line in gen_out:
    if line[:3] == "run":
        lst_line = line.split()
        # key_tuple = (seq_num, lst_line[1][2:-1], lst_line[2][2:])
        key_int = seq_num
        seq_num += 1

    elif line[:2] == "OK":
        zero_line = True

    elif zero_line:
        value_lst.append(line.split()[0])
        zero_line = False
        one_line = True

    elif one_line:
        value_lst.append(line.split()[0])
        entry_dict[key_int] = value_lst
        one_line = False
        key_int = ()
        value_lst = []

print(entry_dict)


# df_pp_s = pd.read_csv("all_seq.csv")
df_pp_s = pd.read_csv("complete.csv")

print("pseudoperiodicity pairs of (a,b), a goes from 1 to b-1, up to a=20, b=55")

num_seq = df_pp_s.nunique(axis=0)['seq']
print("A total of {} sequences/morphisms".format(num_seq))

pairs = []
for b in range(2, 56):
    for a in range(1, b):
        if (2 * a != b) and (b != 55 or a < 21):
            pairs.append((a, b))

file = open("result_table.txt", "w")
count = 0
total = 0
for x in df_pp_s.iterrows():
    a = x[1][0]
    b = x[1][1]
    seq = x[1][2]

    pairs.remove((a, b))

    # file.write("{}\t{}\t{:30}{:30}\n".format(a, b, entry_dict[seq][0], entry_dict[seq][1]))
    file.write(f'{a:n}\t{b:n}\t{entry_dict[seq][0]:30}{entry_dict[seq][1]:30}\n')

    total += 1

print("has {} pairs".format(total))
print("skipped {} pairs: {}".format(len(pairs), pairs))
file.close()

