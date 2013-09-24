module(..., package.seeall)

function yeniHarfDugmesi(harf)
	print("dugme icin harf:"..harf)
 local sheetInfo = require("sprites2")
 local myImageSheet = graphics.newImageSheet( "sprites2.png", sheetInfo:getSheet() )
 local harfGrafigi = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex(harf)}} )

--	local harfGrafigi = display.newImage("images/letters/lc/"..harf..".png")

	local letterButton = {}
	letterButton.graphics = display.newGroup()
	letterButton.graphics:insert(harfGrafigi)
	letterButton.letter = harf
	return letterButton	
end

function getRandomOrder(amount)
	local order ={}
	local i
	local temp
	local temp1
	for n = 1,amount do
		order[n] = n
	end
	for i=0,9 do
		for temp = 1,amount do
			n = math.random(1, amount)
			temp1 = order[temp]
			order[temp] = order[n]
			order[n] = temp1
		end
	end
	return order
end 

function getRandomLetters(numLetters, excludeLetter)
	local alphabet = {"a","b","c","ç","d","e","f","g","h","ı","i","j","k","l","m","n","o","ö","p","r","s","ş","t","u","ü","v","y","z"}
	-- remove excluded letter
	local excludeIndex
	for i=1,#alphabet do
		if alphabet[i] == excludeLetter then
			excludeIndex = i
			alphabet[i] = nil
		end
	end
	table.remove(alphabet, excludeIndex)

	-- shuffle alphabet
	local randomLetterOrder = getRandomOrder(#alphabet)

	-- put selected letters into array
	local letters = {}
	for i=0,numLetters do
		letters[i] = alphabet[randomLetterOrder[i]]
	end

	return letters
end
