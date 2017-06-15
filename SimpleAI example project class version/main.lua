-- 
-- Abstract: SimpleAI Library Plugin Test Project
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2015 Corona Labs Inc. All Rights Reserved.
--
------------------------------------------------------------

-- Load SimpleAI class library
local newAI = require('classes.SimpleAI').newAI -- because we put file "SimpleAI.lua" to the directory "classes"

-------------------------------------------------------------------------------
-- BEGIN (Insert your sample test starting here)
-------------------------------------------------------------------------------
-- physics init
local physics = require( "physics" )
physics.start()

-- Groups
local sceneGroup = display.newGroup( );
local mainGroup = display.newGroup( );
local buttonGroup = display.newGroup( );
local playerGroup = display.newGroup( );
-- Multitoch activate for buttons
system.activate( "multitouch" )

-- If you need to debug ancommit line below 
-- physics.setDrawMode( 'hybrid' )

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

-- create a color rectangle as the backdrop
local background = display.newRect(mainGroup, 0, 0, screenW, screenH )
background.anchorX = 0
background.anchorY = 0
background:setFillColor( 0.816, 0.957, 0.969 )

-- create a ground rectangle as the ground base
local ground = display.newImage( mainGroup, "ground.png", halfW, screenH )
ground.type = "ground"
physics.addBody( ground, "static", { friction=0.3 } )
local ground = display.newImage( mainGroup, "ground.png", halfW-300, screenH )
ground.type = "ground"
physics.addBody( ground, "static", { friction=0.3 } )

-- create a platform rectangle
local platform = display.newImage( mainGroup, "platform.png", halfW-50, screenH-250 )
platform.type = "platform"
physics.addBody( platform, "static", { friction=0.3 } )

local platform1 = display.newImage( mainGroup, "platform.png", halfW-200, screenH-250 )
platform1.type = "platform"
physics.addBody( platform1, "static", { friction=0.3 } )

local platform1 = display.newImage( mainGroup, "platform.png", halfW-350, screenH-250 )
platform1.type = "platform"
physics.addBody( platform1, "static", { friction=0.3 } )

-- player instance
local player = display.newImage(playerGroup, "wingMan1.png", halfW, display.contentHeight-100);
-- add type "player" to allow the user to interact with the Artificial Intelligence and Artificial Intelligence will understand that this is user
player.type = "player" 
player.width = player.width/2
player.height = player.height/2
physics.addBody( player, { density=1.0, friction=0.3, bounce=0.2 } )
player.isFixedRotation = true

-- forward declarations and other locals
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5, display.contentHeight*0.5

---------------------
-- Sprite Animation
---------------------
local sheetOptions =
{
    width = 43,
    height = 56,
    numFrames = 4
}

local sheet_spriteObj = graphics.newImageSheet( "naruto_sasuke.png", sheetOptions )

-- sequences table
local sequences_spriteObj = {
    -- first sequence (consecutive frames)
    {
        name = "normalRun",
        start = 1,
        count = 4,
        time = 400,
        loopCount = 0
    },
    -- next sequence (non-consecutive frames)
    {
        name = "fastRun",
        start = 1,
        count = 4,
        time = 200,
        loopCount = 0
    },
}

local sprite = {sheet_spriteObj, sequences_spriteObj}


-- enemy instance with animation example
local enemy = newAI({group = mainGroup, img = "snailWalk1.png", x = halfW-50, y = display.contentHeight-300, ai_type = "patrol", sprite = sprite})
function enemy:defaultActionOnAiCollisionWithPlayer(event)
	 	enemy:remove( )
end


-- now "enemy" will contact with "player"

-- another enemy instance with animation example
local enemy1 = newAI({group = mainGroup, img = "snailWalk1.png", x = halfW-140, y = display.contentHeight-500, ai_type = "patrol", sprite = sprite})
function enemy1:defaultActionOnAiCollisionWithPlayer(event)
	 	enemy1:remove( )
end
enemy1.fireImg = "bullet.png" -- add bullet image
enemy1.allowShoot = true
enemy1.changeDirection = true
function enemy1:customActionOnAiCollisionWithObjects(event)
	if(event.other.type == 'enemy') then
		enemy1:SwitchDirection()
	end	 		

end

-- enemy instanc static image
local enemy2 = newAI({group = mainGroup, img = "snailWalk1.png", x = halfW-300, y = display.contentHeight-300, ai_type = "patrol"})
function enemy2:defaultActionOnAiCollisionWithPlayer(event)
	 	enemy2:remove( )
end

physics.setDrawMode( "hybrid" )

-- Controllers
-- action buttons	
-- Jump button
local jumpButton = display.newImage( buttonGroup, "jumpButton.png",screenW-45, display.contentHeight-150 )
function jump( event )				
	player:applyForce( 0, -1000, player.x, player.y )		
	return true
end
jumpButton:addEventListener("tap", jump)

-- Right button
local rightButton = display.newImage( buttonGroup, "rightButton.png", 45, display.contentHeight-150 )
function moveRight( event )
	-- print("tappy right")
	if(event.phase == "began") then
		player.action = "right"	
	else
		player.action = "stop"	
	end
		
	return true
end
rightButton:addEventListener("touch", moveRight)

-- Left button
local leftButton = display.newImage( buttonGroup, "leftButton.png", 45, display.contentHeight-150-85 )
function moveLeft( event )
	-- print("tappy left")
	if(event.phase == "began") then
		player.action = "left"	
	else
		player.action = "stop"	
	end		
	return true
end
leftButton:addEventListener("touch", moveLeft)

-- runtime listener
function actionList( event )
	if(player.action == "right") then
		player.x = player.x + 5
	elseif(player.action == "left") then
		player.x = player.x - 5
	end			
	return true
end
Runtime:addEventListener( "enterFrame", actionList )



sceneGroup:insert( mainGroup )		
sceneGroup:insert( playerGroup )
-------------------------------------------------------------------------------
-- END
-------------------------------------------------------------------------------