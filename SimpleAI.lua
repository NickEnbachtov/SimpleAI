-----------------------------------------------------------------------------------------
--
-- SimpleAI class
--
-----------------------------------------------------------------------------------------
-- Creates an object with specific behavior, which can contact (fire, visual contact, collision) with the object having type "player" (and other objects if needed)
--[[
	syntax: newAI({group, img, x, y[, ai_type][,spriteObj]})
	usage: 
	local newAI = require('classes.SimpleAI').newAI
	local enemy = newAI({group = self.parent, img = "img.png", x = x, y = y, ai_type = "patrol"})
--]]  
-- ai_types: "patrol"(default), "guard", "boss"
-- params: group, img, x, y, ai_type, spriteObj

local physics = require( "physics" )

local _M = {}

function _M.newAI(params)
	local img = params.img
	local group = params.group	
	local x = params.x
	local y = params.y
	local limitLeft = 20
	local limitRight = 20
	local aiType = params.ai_type or "patrol"
	local spriteObj = params.spriteObj
	local obj = nil
	local direction = 0
	local extraAction = 0
	local runActionActivity = 0
	local stalker = false
	local lastPlayerNoticedPosition = x
	local fireEnabled = false
	local stopFireOnInit = true
	local visionScanner = nil

	
	if(spriteObj ~= nil) then
		obj = spriteObj;
		obj.x = x
		obj.y = y
		group:insert(spriteObj)
		obj:setSequence( "normalRun" )
		obj:play()
	else
		obj = display.newImage(group, img, x, y);
	end
	
	physics.addBody( obj, { density=1.0, friction=0.3, bounce=0.2 } )
	obj.type = "enemy"
	obj.limitLeft = limitLeft
	obj.limitRight = limitRight
	-- obj.isFixedRotation = true
	obj.switchDirectionTime = 5000
	obj.allowShoot = false
	obj.shootVelocity = 2000
	obj.fireImg = nil
	obj.visionLength = 500
	
	-- Scanner for limited vision
	visionScanner = display.newRect(group, obj.x, obj.y, 1, obj.height);
	physics.addBody( visionScanner, "dynamic" )
	visionScanner.type = "visionScanner"
	visionScanner.isSensor = true
	visionScanner.gravityScale = 0
	visionScanner.alpha = 0

	---------------------
	-- Methods
	---------------------
	-- ai detection
	function obj:defaultActionOnVisualContactWithPlayer(event)
		if(obj.type == "enemy") then
			timer.performWithDelay( 10, getPlayerPosition(event.other) )				
		end		
	end
	
	function obj:defaultActionOnVisualContactWithPlayerEnd(event)
		
	end
	
	function obj:customActionOnVisualContactWithPlayer(event)
		
	end
	
	function obj:customActionOnVisualContactWithPlayerEnd(event)
		
	end
	
	
	function obj:defaultActionOnVisualContactWithObjects(event)
			
	end
	
	function obj:defaultActionOnVisualContactWithObjectsEnd(event)
		
	end
	
	function obj:customActionOnVisualContactWithObjects(event)
		
	end
	
	function obj:customActionOnVisualContactWithObjectsEnd(event)
		
	end	
	
	-- ai collision
	function obj:defaultActionOnAiCollisionWithPlayer(event)
		
	end
	
	function obj:defaultActionOnAiCollisionWithPlayerEnd(event)
		
	end
	
	function obj:customActionOnAiCollisionWithPlayer(event)
		
	end
	
	function obj:customActionOnAiCollisionWithPlayerEnd(event)
		
	end

	function obj:defaultActionOnAiCollisionWithObjects(event)
		
	end
	
	function obj:defaultActionOnAiCollisionWithObjectsEnd(event)
		
	end
	
	function obj:customActionOnAiCollisionWithObjects(event)
		
	end
	
	function obj:customActionOnAiCollisionWithObjectsEnd(event)
		
	end
	-- fire collision
	function obj:customActionOnAiFireToPlayer(event)
		
	end
	
	function obj:customActionOnAiFireToPlayerEnd(event)
		
	end
	
	function obj:customActionOnAiFireToObjects(event)
		
	end
	
	function obj:customActionOnAiFireToObjectsEnd(event)
		
	end
	
	function obj:addExtraAction()
		
	end

	function obj:remove()
		Runtime:removeEventListener( "enterFrame", actionAI )
		display.remove( obj )
	end
	
	---------------------
	-- Collisions
	---------------------
	
	function onObjCollision( self, event )
		if(event.other.type == "player") then
			if ( event.phase == "began" ) then
				print( self.type .. ": collision began with " .. event.other.type )
				obj:defaultActionOnAiCollisionWithPlayer(event)
			elseif ( event.phase == "ended" ) then
				print( self.type .. ": collision ended with " .. event.other.type )
				obj:defaultActionOnAiCollisionWithPlayerEnd(event)
			end
		else
			if ( event.phase == "began" ) then
				-- print( self.type .. ": collision began with " )
				obj:customActionOnAiCollisionWithObjects(event)
			elseif ( event.phase == "ended" ) then
				-- print( self.type .. ": collision ended with " )
				obj:customActionOnAiCollisionWithObjectsEnd(event)
			end
		end
		if(runActionActivity == 0) then
			runActionActivity = 1
		end
	end

	obj.collision = onObjCollision
	obj:addEventListener( "collision", obj )
	
	-- End of Collisions


	
	---------------------
	-- Functions
	---------------------
	function MoveAIRigth()
		obj.x = obj.x + 1
		obj.xScale = -1
	end

	function MoveAILeft()			
		obj.x = obj.x - 1
		obj.xScale = 1
	end

	function TurnAIRigth()		
		obj.xScale = -1
	end

	function TurnAILeft()		
		obj.xScale = 1
	end

	function SwitchDirection()		
		if(direction == 2) then
			direction = 1
		elseif(direction == 3) then
			direction = 0
		end		
	end

	function getPlayerPosition(player)		
		lastPlayerNoticedPosition = player.x
		obj.isFixedRotation = false
		stalker = true
	end

	function moveObjToPlayerPosition()
		if(stalker) then
			transition.moveTo( obj, {x = lastPlayerNoticedPosition, time = 2000} )
			obj.isFixedRotation = true
			stalker = false			
		end
	end

	-- function defaultActionOnVisualContact(event)
	-- 	timer.performWithDelay( 10, getPlayerPosition(event.other) )
	-- end
	

	function lookAIAhead( direction )
		local scanBeam = display.newCircle(group,obj.x,obj.y,5)
		physics.addBody( scanBeam, "dynamic" )
		scanBeam.type = "scanBeam"
		scanBeam.gravityScale = 0
		scanBeam.alpha = 0

		--Make the object a "bullet" type object
		-- scanBeam.isBullet = true

		--Make the object a sensor
		scanBeam.isSensor = true

		if(direction == 0 or direction == 2) then
			scanBeam:setLinearVelocity( -700,0 )
		elseif(direction == 1 or direction == 3) then
			scanBeam:setLinearVelocity( 700,0 )
		end
		
		---------------------
		-- Collisions scanBeam
		---------------------
		
		local function onScanCollision( self, event )
			if(event.other.type == "player") then
				if ( event.phase == "began" ) then
					-- print( self.type .. ": detection began with " .. event.other.type )					
					obj:defaultActionOnVisualContactWithPlayer(event)
					obj:customActionOnVisualContactWithPlayer(event)					
				elseif ( event.phase == "ended" ) then
					-- print( self.type .. ": detection ended with " .. event.other.type )
					obj:defaultActionOnVisualContactWithPlayerEnd(event)
					obj:customActionOnVisualContactWithPlayerEnd(event)
				end
			else
				if ( event.phase == "began" ) then
					-- print( self.type .. ": detection began with " .. event.other.type )					
					obj:defaultActionOnVisualContactWithObjects(event)										
					obj:customActionOnVisualContactWithObjects(event)					
				elseif ( event.phase == "ended" ) then
					-- print( self.type .. ": detection ended with " .. event.other.type )
					obj:defaultActionOnVisualContactWithObjectsEnd(event)
					obj:customActionOnVisualContactWithObjectsEnd(event)
				end
			end
			if(event.other ~= obj and event.other.type ~= "fireBall") then
				self:removeSelf( )
				self = nil
			end
			
		end

		scanBeam.collision = onScanCollision
		scanBeam:addEventListener( "collision", scanBeam )
		
	end

	function fireAIAhead( direction )
		local fireBall = nil
		if(obj.fireImg ~= nil) then	
			fireBall = display.newImage(group,obj.fireImg,obj.x,obj.y)
			local fireBallSize = (fireBall.height*0.5) - (obj.height*0.5)
			if(fireBallSize >= 0) then
				fireBall.y = obj.y - fireBallSize - 1
			end		
		else
			fireBall = display.newCircle(group,obj.x,obj.y,5)
		end		
		
		physics.addBody( fireBall, "dynamic" )
		fireBall.type = "fireBall"
		fireBall.gravityScale = 0		

		-- Make the object a "bullet" type object
		fireBall.isBullet = true

		--Make the object a sensor
		fireBall.isSensor = true

		if(direction == 0 or direction == 2) then
			fireBall:setLinearVelocity( -700,0 )
		elseif(direction == 1 or direction == 3) then
			fireBall:setLinearVelocity( 700,0 )
		end

		
		timer.performWithDelay( obj.shootVelocity, function ()
			fireEnabled = true
		end )
		
		---------------------
		-- Collisions fireBall
		---------------------
		
		local function onFireBallCollision( self, event )
			if(event.other.type == "player") then
				if ( event.phase == "began" ) then
					-- print( self.type .. ": fire collision began with " .. event.other.type )	
					obj:customActionOnAiFireToPlayer(event)					
				elseif ( event.phase == "ended" ) then
					-- print( self.type .. ": fire collision ended with " .. event.other.type )
					obj:customActionOnAiFireToPlayerEnd(event)
				end
			else
				if ( event.phase == "began" ) then
					-- print( self.type .. ": fire collision began with " .. event.other.type )
					obj:customActionOnAiFireToObjects(event)
				elseif ( event.phase == "ended" ) then
					-- print( self.type .. ": fire collision ended with " .. event.other.type )
					obj:customActionOnAiFireToObjectsEnd(event)
				end
			end
			if(event.other ~= obj and event.other.type ~= "scanBeam" and event.other.type ~="visionScanner") then				
				self:removeSelf( )
				self = nil
			end
			
		end

		fireBall.collision = onFireBallCollision
		fireBall:addEventListener( "collision", fireBall )
		
	end
	
	function activateExtraAction()
		extraAction = 0		
	end
	
	function bossAction()
		if(extraAction == 0 and runActionActivity == 1) then					
			obj:applyForce( 0, -101, obj.x, obj.y )
			extraAction = 1
			timer.performWithDelay( 128, activateExtraAction )
		end	
		
	end
	

	
	---------------------
	-- Render
	---------------------
	function actionAI( event )	

		lookAIAhead(direction) -- AI scan area ahead		
		if(direction == 0) then				
			visionScanner.x = obj.x - obj.visionLength -- left		
		elseif(direction == 1) then			
			visionScanner.x = obj.x + obj.visionLength -- right	
		end		
		visionScanner.y = obj.y

		

		if(stopFireOnInit) then
			stopFireOnInit = false
			timer.performWithDelay( obj.shootVelocity, function ()
			fireEnabled = true
		end )

		end

		if(fireEnabled and obj.allowShoot) then
			fireEnabled = false
			fireAIAhead(direction)		
		end

		if(aiType == "patrol") then				
			if(obj.x >= (x-obj.limitLeft) and direction == 0) then								
				MoveAILeft()				
			elseif(obj.x <= (x+obj.limitRight) and direction == 1) then					
				MoveAIRigth()							
			end			

			if(obj.type == "enemy") then 
				moveObjToPlayerPosition()
				if( obj.x == lastPlayerNoticedPosition ) then
					obj.isFixedRotation = false
				end
			end	

		-- if obj follow the the player
		if(obj.isFixedRotation == false) then 
			if(obj.x <= (x-obj.limitLeft)) then 			
				direction = 1
			elseif(obj.x >= (x+obj.limitRight)) then 			
				direction = 0	
			end
		end
			
		elseif(aiType == "guard") then
			if(direction == 0) then
				TurnAILeft()
				direction = 2
				timer.performWithDelay( obj.switchDirectionTime, SwitchDirection )
			elseif(direction == 1) then
				TurnAIRigth()
				direction = 3
				timer.performWithDelay( obj.switchDirectionTime, SwitchDirection )
			end					
			
		elseif(aiType == "boss") then			
			bossAction()			
		end
		obj:addExtraAction()
	end
	
	
	Runtime:addEventListener( "enterFrame", actionAI )
	-- End of Functions
	
	return obj
end

return _M




