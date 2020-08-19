
import collections
import os
import sys



ticcloutput = sys.argv[1]  #nlfiscaal: "TICCLv2.OUT.clean.ldcalc.ranked
inputwords  = sys.argv[2]  # nlfiscaal: nlf_wordlist.v2


#inlezen van spelling correcties
#file format
#Word variant # frequency word variant # Correction # frequency correction # Anagram Value Difference # Levenstein Distance # Confidence Score
#pprocureur#1#procureur#100002624#20113571875#1#0.865979
#pereel#1#perceel#100002620#24883200000#1#0.999284
#erceel#1#perceel#100002620#20113571875#1#0.995794
#uitbreding#1#uitbreiding#100002620#14693280768#1#0.989803
#tegmoet#1#tegemoet#100002620#11592740743#1#0.982571
#tegenmoet#6#tegemoet#100002620#12166529024#1#0.941964

### checks if spellingsuggestion should be kept- based on simple heuristic rules
#longer words that occ twice or more do not need a spelling Correction
#i also checked length of 12 but that is too short
# this entails:
#if longword has higher freq than spellingsuggestion -> not a candidate and validlongword
# only if correction occurs more otften than word -it is a validlongword
#    if len(word)>14 and int(freqw)>1  and int(freqcorr ) > int(freqw):
# nope niet nuttig - word is meestal gewoon goed
def validlongword(word, freqw,correct,freqcorr,anadiff,ldiff,conf_score):
    if len(word)>14 and int(freqw)>1:
        return True
    else:
        return False



ticcl_corrections={}
with open(ticcloutput,'r',encoding='utf-8') as ticcl:
    for line in ticcl:
        (word, freqw,correct,freqcorr,anadiff,ldiff,conf_score) = line.split('#')
        if(validlongword(word, freqw,correct,freqcorr,anadiff,ldiff,conf_score)):
            print("valid word " ,word,file=sys.stderr)
        else:
            ticcl_corrections[word] = correct

#inlezen van lexicon in een dictionary waarbij ieder woord aan zijn correctie is gekoppeld
#tel hoeveel woorden geen correctie krijgen
new_lexicon = {}
correct_counter = 0
with open(inputwords,'r',encoding='utf-8') as lexicon:
    for w in lexicon.readlines():
        w = w.strip()
        if( w in ticcl_corrections):
            new_lexicon[w] = ticcl_corrections[w]
        else:
            new_lexicon[w] =  w     #"-"
            correct_counter += 1








newlexlength = len(new_lexicon)
print("new lexicon has ",newlexlength, " items and ", correct_counter, " words that were not corrected by ticcl \n", file=sys.stderr)


sorted_new_lexicon = collections.OrderedDict(sorted(new_lexicon.items()))
#for k, v in sorted_new_lexicon.items(): print(k + "\t" + str(v))
for k, v in sorted_new_lexicon.items(): print(str(v))

#     z.isupper() or z.islower()
