<p align="center">
	<br>
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-2.2-orange.svg?style=flat" alt="Swift" /></a>
		<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat" alt="Swift" /></a>
		<img src="https://img.shields.io/badge/Platform-OSX-grey.svg?style=flat" alt="Platform" />
    <a href="https://travis-ci.org/romainmenke/Jenerator"><img src="https://travis-ci.org/romainmenke/Jenerator.svg?branch=master" alt="Travis CI" /></a>
    <a href="https://codecov.io/gh/romainmenke/Jenerator"><img src="https://codecov.io/gh/romainmenke/Jenerator/branch/master/graph/badge.svg" alt="CodeCov" /></a>
    <a href="http://romainmenke.github.io/Jenerator/"><img src="https://img.shields.io/badge/Documented-86%25-blue.svg" alt="Jazzy" /></a>
</p>

# Jenerator


### Why?

There are many great libraries out there to make JSON responses from API's easier to use in Swift. What none of them do is write the code for you. Insteads of reading for hours about the response structure of various API calls and then mapping those with your favorite JSON lib you can also just pass the API call to Jenerator and let it generate a model.


### How?

Jenerator comes in two forms : a Swift Framework and a Command Line Tool.

- The Framework can be imported into your Xcode project where you would pass it a JSON response
from an API call. Using the debug console you print out the generated code and copy/paste that into a new .swift file. Then you can pass the same JSON response to your newly generated model and start using the data. Before moving to production, you can remove Jenerator as it has no place there.

```swift
import JeneratorSDK
```

```swift
guard let apiQueryUrl = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20item.condition%20from%20weather.forecast%20where%20woeid%20%3D%202487889&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys") else {
  print("not a valid url")
  return
}

guard let builder = ModelBuilder.fromSource(apiQueryUrl, classPrefix: "YW")?.findAliasses() else {
  print("invalid JSON, or no data")
  return
}

print(SwiftGenerator.generate(model: builder))
```

- The CLI has two modes : local .json file or remote API call

 - The local mode takes a path to .json file, a save file name and a class prefix. It will parse the .json file, build a model, generate the Swift code and save to a file with the specified name in the same directory as the .json file.

 - The remote mode takes a url, a save directory, a save file name and a class prefix. It will then parse it and save it in the specified directory.

cmd options :

```
-s, --source:
		Path to .json file or Url to remote JSON, use double quotes
-d, --dir:
		Path to save directory
-f, --file:
		Name for generated .swift file
-c, --classprefix:
		Class Prefix for generated Types
```

cmd :

`$ jenerator -s "myJSONRemoteSource"  -d "saveDirectory" -f filename  -c classPrefix`

`$ jenerator -s "myJSONLocalSource" -f filename -c classPrefix`


### Install

[Download](https://github.com/romainmenke/Jenerator/releases "Download")

- Drop the CLI somewhere in your `PATH`, for example in `usr/local/bin/`

- Copy the Framework into your OSX project. (iOS Compiled Framework is Coming Soon)


### See More


Examples can be found here:

[Example](https://github.com/romainmenke/Jenerator/tree/master/examples/sample "Example")

The generated Swift code will have template documentation making it easy for you to add some extra info about each Type.

If the code was generated from a remote API call it will include a method to repeat the query. The method can be modified easily to have parameters. In seconds you can have an awesome dynamic SDK for any API.

### License

Use as you like.

### Note

Swift CLI's don't like urls as arguments, that is why they need the double quotes, I will see if I can fix it in an update.
