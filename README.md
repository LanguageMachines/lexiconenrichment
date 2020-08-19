# lexiconenrichment

Pipeline script to clean and enrich a word list.

- clean the word list to remove most junk, numbers and non-Dutch words

- run spelling checker Ticcl to get spelling corrections
- run lemmatizer form Frog to get lemmas for the corrected words
- split the lemmas in their coumpound parts

## Installation

1. Clone this repository: ``$ git clone https://github.com/LanguageMachines/lexiconenrichment``
2. Build the image: ``$ docker build -t lexiconenrichment lexiconenrichment``

## Usage

1. Start an interactive shell in a new container: ``$ docker run -t -i lexiconenrichment``.
2. Invoke ``clean_run.sh`` with two parameters:
    - TODO


