FROM proycon/lamachine:piccl
MAINTAINER Iris Hendrickx <i.hendrickx@let.ru.nl>
LABEL description="Lexicon enrichment pipeline"
USER lamachine
WORKDIR /home/lamachine
RUN git clone https://github.com/LanguageMachines/lexiconenrichment
WORKDIR lexiconenrichment
RUN ./install_deps.sh
CMD /bin/bash -l
