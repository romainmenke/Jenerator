# Jenerator
Create Swift Models from JSON files or API calls


Build it -> Drop somewhere in your PATH -> Profit

cmd : `jenerator "myJSONSource" "saveDirectory" "filename"`

Try it:

cmd : `Jenerator "https://finance.yahoo.com/webservice/v1/symbols/YHOO/quote?format=json" "$HOME/Desktop" YahooResponse`

Note :

Swift CLI's don't like urls as arguments, will see if I can fix it in an update.
