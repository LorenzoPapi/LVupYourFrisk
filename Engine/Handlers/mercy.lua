--[[
	Credit to ally for the layout of the library (inspired by her gb library)
	I'm not super gud in lua so I get inspiration from great minds
]]

return (function()
	local self = {}
	self.choice = 1
	self.texts = {}

	function self.Start()
		State("MERCYMENU")
		BattleDialog("")
		self.texts[1] = CreateChoice("Spare", 1)
		if (Encounter.flee) then
			self.texts[2] = CreateChoice("Flee", 3)
		end
		self.choice = 1
		SelectChoice(self.choice)
	end

	local function flee()
		Encounter.HandleFlee()
		BattleDialog(Encounter.fleetexts[math.random(1, #Encounter.fleetexts)])
		State("DONE")
	end

	function self.keypressed(key)
		if (key == "up") then
			self.choice = 1
		elseif (key == "down" and Encounter.flee) then
			self.choice = 3
		end
		SelectChoice(self.choice)
		if (Input.equals(key, "Confirm")) then
			self.resetPage()
			if (self.choice == 1) then
				Encounter.HandleSpare()
			elseif (Encounter.fleesuccess == false) then
				--ADD failFleeTexts
				BattleDialog("You tried to flee the battle...\n[w:30]You failed.")
			else
				if (Encounter.fleesuccess) then
					flee()
				elseif (Encounter.fleesuccess == nil) then
					--TODO: formula
					if (math.random(0, 1) % 2 == 0) then
						flee()
					else
						BattleDialog("You tried to flee the battle...\n[w:30]You failed.")
					end
				end
			end
		end
	end

	function self.resetPage()
		self.texts[1].Remove()
		if (Encounter.flee) then
			self.texts[2].Remove()
		end
	end

	return self
end)()