#!/bin/bash
wget https://ilps.science.uva.nl/ilps/wp-content/uploads/sites/6/files/compound-splitter-nl.tar.gz || exit 2
tar -xvzf compound-splitter-nl.tar.gz || exit 2
cd compound-splitter-nl
ln -sf ../compoundwords.edited.out
rm compound_server.conf
ln -s ../compound_server.conf
cd ..
