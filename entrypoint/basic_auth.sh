SOLR_USER=$(cat $BASIC_AUTH | cut -d ":" -f 1)
export SOLR_USER=$SOLR_USER
SOLR_PASSWORD=$(cat $BASIC_AUTH | cut -d ":" -f 2 | tr -d '[[:space:]]')
export SOLR_PASSWORD=$SOLR_PASSWORD
