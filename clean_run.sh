#!/bin/bash

if [ $# -ne 2 ]; then
    #script wants 2 arguments: input-word list, name of cleaned word-list(ends on .txt!)
    echo "usage: clean_run.sh input_word_list output_word_list"
    exit 2
fi

echo "inputfile $1"


#cleaning data
# alleen woorden met 0 of 10 als code
#opschonen door het wegfilteren van
#-woorden korter dan 3 letters
#-woorden die beginnen met een cijfer
#- alle woorden met spaties, kommas, dubbele punten, underscores
#- woorden die bestaan uit minimaal letter-cijfer-letter
#- woorden met niet-nl characters

DIR=inputdata
grep -ve  "[\"\'\‘\’\ʺ\ʻ\ʼ\ʽ\ˆ\ˮ̧́̂̇̈]"  -e '[­\.:_ /\\]'  -e '^[0123456789]'  -e '[ÖßàáâãäåæçìíîðñòóôõøùúûýþāăąćĉċČčēĕėęěğģħĩīįĳķļľłńņňőœřśşšţťūůűųźŻżžƒǎșțɪ̶ίαβδικλμνοπςστφχωόύабвгдежзийклмнопрстфхцшъяёєᵉό‑‒ₓℎ≥ﬁﬂגּ]' -e '[\bp-z]ö' -e '\bö' -e '[a-n]ö' $1 |egrep -v '[a-z]+[0-9]+[a-z]+'  |grep  -e ",10"  -e ",0" | grep -e '[a-zA-Z][a-zA-Z][a-zA-Z]' | cut -f1 -d',' > $1.clean.txt


if [ -d $DIR ]; then
    #delete old input directory if it exists
    rm -Rf "$DIR"
fi

#and create it anew
mkdir $DIR

#copy file to dir for spelling correcton
cp $1.clean.txt $DIR

echo " ticcl.nf --inputdir $DIR --inputtype text --lexicon $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict --alphabet $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict.lc.chars --charconfus $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict.c20.d2.confusion --outputdir $DIR/ticcle-output --nofoliacorrect "

#run ticcl
ticcl.nf --inputdir $DIR --inputtype text --lexicon $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict --alphabet $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict.lc.chars --charconfus $LM_PREFIX/opt/PICCL/data/int/nld/nld.aspell.dict.c20.d2.confusion --outputdir $DIR/ticcle-output --nofoliacorrect || exit 1

 # actual output is called: $DIR/ticcle-output/corpus.wordfreqlist.tsv.clean.ldcalc.ranked

 #we merge this with the uncorrected forms
python3 rewriteTiccl.v3.py  $DIR/ticcle-output/corpus.wordfreqlist.tsv.clean.ldcalc.ranked $1.clean.txt > $1.clean.txt.ticclcorr || exit 1

 #run the lemmatizer with a wordlist as input
mblem --wordlist $1.clean.txt.ticclcorr > $1.clean.txt.mblem  || exit 1
cut -f 2 -d ',' $1.clean.txt.mblem > $1.clean.txt.lemma || exit 1

if [ ! -d compound-splitter-nl ]; then
    #install compound splitter if it is not installed yet
    ./install_deps.sh || exit 1
fi

#run splitter -we need to add current dir to perl-path for the script to work
perlpath=`pwd`/compound-splitter-nl
echo "$perlpath"
export PERL5LIB=$perlpath
perl compound-splitter-nl/compound_splitter.pl compound_server.conf $1.clean.txt.lemma  > $1.clean.txt.lemma_compounds || exit 1


#clean compounds
perl -pe 's/ tus / tussen /g; s/ bin / binnen /g;' < $1.clean.txt.lemma_compounds |awk '{print $2,$3,$4,$5,$6;}' > $1.clean.txt.compounds || exit 1

#final step: concatenate all results into one file
#with one word per line,
#per line: original word, spelchecked word, lemma, compound
paste -d',' $1.clean.txt $1.clean.txt.ticclcorr $1.clean.txt.lemma $1.clean.txt.compounds > $2.processed.csv || exit 1

echo "ready: output is witten to  $2.processed.csv"
