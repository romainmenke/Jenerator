<p align="center">
	<br>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-2.3-orange.svg?style=flat" alt="Swift" /></a>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift" /></a>
    <a href="https://travis-ci.org/romainmenke/Jenerator"><img src="https://travis-ci.org/romainmenke/Jenerator.svg?branch=master" alt="Travis CI" /></a>
    <a href="https://codecov.io/gh/romainmenke/Jenerator"><img src="https://codecov.io/gh/romainmenke/Jenerator/branch/master/graph/badge.svg" alt="CodeCov" /></a>
    <a href="http://romainmenke.github.io/Jenerator/"><img src="https://img.shields.io/badge/Documented-97%25-blue.svg" alt="Jazzy" /></a>
</p>

# Jenerator

### Why?

There are many great libraries out there to make JSON responses from API's easier to use in Swift. What none of them do is write the code for you. Insteads of reading for hours about the response structure of various API calls and then mapping those with your favorite JSON lib you can also just pass the API call to Jenerator and let it generate a model.

### How?

Jenerator comes in two forms : a Swift Framework and a Command Line Tool. 

- The Framework can be imported into your Xcode project where you would pass it a JSON response
from an API call. Using the debug console you print out the generated code and copy/paste that into a new .swift file. Then you can passs the same JSON response to your newly generated model and start using the data.

- The CLI has two modes : Local .json file and remote API call

 - The local mode takes a path to .json file, a save file name and a class prefix. It will parse the .json file, build a model, generate the Swift code and save to a file with the specified name in the same directory as the .json file.

 - The remote mode takes a url, a save directory, a save file name and a class prefix. It will then parse it and save it in the specified directory.

The commands will look like this:

`$ jenerator "myJSONRemoteSource" "saveDirectory" filename classPrefix`

`$ jenerator "myJSONLocalSource" filename classPrefix`

An example can be found here:

[Example](github.com/romainmenke/Jenerator/examples/sample "Example")

The top level Type will have a `fromSource()` method that can be used to fetch the data to goes with the model. Obviously you can and should modify this to create other queries.


Note :

Swift CLI's don't like urls as arguments, will see if I can fix it in an update.
