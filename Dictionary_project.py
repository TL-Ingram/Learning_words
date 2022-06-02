


import pandas as pd
import os
import glob
words = pd.read_csv("C:/R_projects/dict/words_from_apple_notes.csv", encoding='cp1252')
import string

punct = '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{}~'''   # `|` is not present here
transtab = str.maketrans(dict.fromkeys(punct, ''))

words['Word'] = '|'.join(words['Word'].tolist()).translate(transtab).split('|')

###
path = r'C:/R_projects/dict/Dictionary-in-csv/*.csv'                     # use your path
all_files = glob.glob(os.path.join(path, "*.csv"))     # advisable to use os.path.join as this makes concatenation OS independent


filepaths = [f for f in os.listdir("C:/R_projects/dict/Dictionary-in-csv/") if f.endswith('.csv')]
df = pd.concat(map(pd.read_csv, filepaths))
def f(i):
    return pd.read_csv(i, header=None)

df = pd.concat(map(f, filepaths))



df_from_each_file = (pd.read_csv(f) for f in all_files)
concatenated_df   = pd.concat(df_from_each_file, ignore_index=True)
# doesn't create a list, nor does it append to one


import pandas as pd
import glob
import functools

df = pd.concat(map(functools.partial(pd.read_csv, compression=None), 
                    glob.glob("C:/R_projects/dict/Dictionary-in-csv/*.csv")))



all_rec = glob(path, recursive=True)     
dataframes = (pd.read_csv(f) for f in all_rec)
big_dataframe = pd.concat(dataframes, ignore_index=True)