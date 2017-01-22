# Simple AI for Corona SDK
Simple artificial intelligence for Corona SDK
* easy connect to the project
* light, fast and easy in use
* flexible
* extensiable

# Overview
Creates an object with specific behavior, which can contact (fire, visual contact, collision) with the object having type "player" (and other objects if needed).

# Usage
1. Download the latest version of file "SimpleAI.lua"
2. Put it in your project root directory (for example root/classes/SimpleAI.lua)
3. Connect file SimpleAI.lua to your level file
`local newAI = require('classes.SimpleAI').newAI -- because we put file "SimpleAI.lua" to the directory "classes"`

4. Create enemy object
`local enemy = newAI({group = yourGroup, img = "img.png", x = 100, y = 50, ai_type = "patrol"})`

5. Enjoy

###### Under MIT license

### Sample Code

You can access sample code [here (SimpleAI example project class version)](SimpleAI example project class version).

Documentation and code examples at http://simple-ai.blogspot.com
