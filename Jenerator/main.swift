//
//  main.swift
//  Jenerator
//
//  Created by Romain Menke on 01/06/16.
//  Copyright © 2016 menke-dev. All rights reserved.
//

import Foundation


// Swift CLI's don't have a main, so let's intruduce some scope.
do {
    // Parse the arguments
    parseArguments()
    // Exit if something is wrong
    earlyEscapes()
    // Do the works
    parseJSON()
    // Save the result
    writeToFile()
}



