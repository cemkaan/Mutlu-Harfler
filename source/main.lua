-- versiyon 2.2
Runtime:addEventListener("enterFrame", function(event) pcall(onUpdate, event) end)

-- Vars
local ayarGenisligi = 800
local ayarYuksekligi = 600
local ekranGenisligi = display.viewableContentWidth
local ekranYuksekligi = display.viewableContentHeight
local yKenarlik = 10
local ortaX = ayarGenisligi/2;
local ortaY = ayarYuksekligi/2;
local xDuzeltme = (ayarGenisligi - display.viewableContentWidth)/2
local yDuzeltme = (ayarYuksekligi - display.viewableContentHeight)/2
local zorluk = 2  --varsayılan zorluk
local zorlukSlider
local zorlukSlotlari
local zorlukDugmesi
local oynaDugmesi
local harfDugmeleri
local correctButton
local wrongGraphic
local playOrder
local currQuestion = 0
local eskiEkran
local yeniEkran
local kelimeGrafigi
local transitionDuration = 10
local kelimeler = require("kelimeler")
local easing = require("easing")
local ekler = require("ekler")
local geriAktif = true
local oynaAktif = true
local oyunMuzigi = audio.loadStream("audio/oyun.mp3")
local baslamaMuzigi = audio.loadStream("audio/giris.mp3")


------------------------------------------------------------
-- Game Play


function basla()
	display.setStatusBar(display.HiddenStatusBar)
	
	-- create launch screen
	baslamaEkraniEkle()
	
	yeniEkran = ekranAc
	
	-- assign random order for words
	playOrder = ekler.getRandomOrder(#kelimeler)
end

function baslamaEkraniEkle()

	ekranAc = display.newGroup()
	ekranAc.x = ortaX
	ekranAc.y = ortaY
	
  -- music
  baslamaMuzigiCal()
  
	-- add background
	local background = display.newImageRect("images/graphics/bg.jpg", ayarGenisligi, ayarYuksekligi, true)
	ekranAc:insert(background)
	
	-- add title
	local title = display.newImageRect("images/graphics/title.png", 400, 180, true)
	ekranAc:insert(title)
	title.y = -ekranYuksekligi/2 + title.height/2 + yKenarlik
	
	-- add copyright
	local copyright = display.newImageRect("images/graphics/copyright.png", 106, 60, true)
	copyright.y = ekranYuksekligi/2 - copyright.height/2
	ekranAc:insert(copyright)
	
	-- add the play button
	oynaDugmesi = display.newImageRect("images/buttons/play.png", 111, 111)
	oynaDugmesi.y = copyright.y - oynaDugmesi.height/4 - copyright.height
	oynaDugmesi:addEventListener("touch", onPlayTouch)
	ekranAc:insert(oynaDugmesi)
	
	-- add difficulty slider
	zorlukAyariEkle()
  



	-- adjust spacing
	if yDuzeltme == 0 then
		title.y = title.y + yKenarlik*2
		oynaDugmesi.y = oynaDugmesi.y - yKenarlik
	elseif yDuzeltme > 50 then
		title.xScale = .8
		title.yScale = .8
		oynaDugmesi.xScale = .7
		oynaDugmesi.yScale = .7
		title.y = title.y - yKenarlik
		oynaDugmesi.y = oynaDugmesi.y + yKenarlik
		zorlukSlider.y = zorlukSlider.y - yKenarlik
		zorlukDugmesi.y = zorlukDugmesi.y - yKenarlik
	end
end

function zorlukAyariEkle()

  --
	zorlukSlider = display.newImageRect("images/graphics/difficulty.png", 730, 100)
	zorlukSlider.x = ortaX
	zorlukSlider.y = ortaY + zorlukSlider.height/3
	zorlukSlider:addEventListener("touch", zorlugaDokunuldugunda)
	
	-- add difficulty button
	zorlukDugmesi = display.newImageRect("images/buttons/zorlukAyarDug.png", 69, 69)
	zorlukDugmesi:addEventListener("touch", zorlukSuruklendiginde)
	
	-- define slots for difficulty slider
	zorlukSlotlari = {ortaX - zorlukSlider.width/2 + zorlukDugmesi.width*1.5, 
					   ortaX - zorlukSlider.width/3 + zorlukDugmesi.width*2, 
					   ortaX + zorlukDugmesi.width/2, 
					   ortaX + (zorlukSlider.width/10)*2.5, 
					   ortaX + (zorlukSlider.width/10)*4.5 }
	
	-- set position
	zorlukDugmesi.x = zorlukSlotlari[zorluk]
	zorlukDugmesi.y = zorlukSlider.y-20
end

function setDifficulty(xPosition)
	zorluk = #zorlukSlotlari
	for i=#zorlukSlotlari, 2, -1 do
	   local middleX = (zorlukSlotlari[i] + zorlukSlotlari[i-1])/2
	   if xPosition < middleX then
	   		zorluk = i-1
	   end
	end
	transition.to(zorlukDugmesi, {time=500, x=zorlukSlotlari[zorluk], transition = easing.outExpo})
end

function anaMenuDonusEkle()
	geriAktif = true
	evDugmesi = display.newImage("images/buttons/home.png")
	evDugmesi.alpha = .9
	evDugmesi.y = yDuzeltme + evDugmesi.height/2
	evDugmesi:addEventListener("touch", onHomeTouch)
end

function kelimeGoster()
      
	-- Geri düğmesini kaldır
	geriAktif = false
  
	--  kelimeler den kelime al
	local kelime = kelimeler[playOrder[currQuestion]].word
	
	-- kelime grafiği yap
	kelimeGrafigi = display.newGroup()
	local harfgostermeAnimasyonGecikmesi = 500
	for i=1,string.len(kelime) do
		local harf = kelime:sub(i,i)
		if harf == " " then
			-- space
		else
			local karakter = ekler.yeniHarfDugmesi(harf).graphics
			kelimeGrafigi:insert(karakter)
			karakter.x = ekranGenisligi/string.len(kelime)* (i-1)+40
			local charDelay = (i-1) * harfgostermeAnimasyonGecikmesi
			timer.performWithDelay(charDelay, playLetterSound)
		  transition.from(karakter, {time = 400, delay = charDelay, y=ortaY+karakter.height, transition=easing.easeOutElastic})



		end
	end
	kelimeGrafigi.x = ortaX - kelimeGrafigi.width/2
	kelimeGrafigi.y = ortaY - kelimeGrafigi.height/2
	timer.performWithDelay(kelimeGrafigi.numChildren * harfgostermeAnimasyonGecikmesi + 1000, kelimeTamamlandiginda)


end

function sonrakiSoru()

    -- music
oyunMuzigiCal()
audio.resume(2)
	-- update screen var
	eskiEkran = yeniEkran
	
	-- update question number index
	currQuestion = currQuestion+1
	if currQuestion > #playOrder then
		currQuestion = 1
	end
	local questionNumber = playOrder[currQuestion]
  print("SoruNo "..currQuestion)
  print("id "..kelimeler[questionNumber].id)
  print("word "..kelimeler[questionNumber].word)
	
	-- add new image
	yeniEkran = display.newImageRect("images/pics/"..kelimeler[questionNumber].id..".jpg",ayarGenisligi, ayarYuksekligi, true)
	yeniEkran.x = ortaX
	yeniEkran.y = ortaY
	
	-- do transitions
	transitionIn(yeniEkran)
	transitionOut(eskiEkran)
	
	-- bring home button to front
	evDugmesi:toFront()
	
	-- make buttons
	harfDugmeleri = {}



	
	-- make letter button for correct letter
	local harf = kelimeler[questionNumber].word:sub(1,1)
	table.insert(harfDugmeleri, ekler.yeniHarfDugmesi(harf))
	correctButton = harfDugmeleri[1].graphics
	local buttonWidth = correctButton.width
	
	-- make other letter buttons
	local letters = ekler.getRandomLetters(zorluk-1, harf)
	for i=1, zorluk-1 do
    print("Diger Harfler:"..letters[i])
		table.insert(harfDugmeleri, ekler.yeniHarfDugmesi(letters[i]))
	end
	
	-- position letter buttons and add touch event listener
	local randomLetterOrder = ekler.getRandomOrder(#harfDugmeleri)
	local buttonSpacing = buttonWidth * 1.25
	local buttonsWidth = (#harfDugmeleri * buttonWidth) + ((#harfDugmeleri-1) * (buttonSpacing/4))
	local buttonsX = ortaX - (buttonsWidth/2) + 10
	for i=1, #harfDugmeleri do
		local button = harfDugmeleri[i].graphics
		button.y = ayarYuksekligi - button.height - yDuzeltme
		button.x = buttonsX + (buttonSpacing * (randomLetterOrder[i]-1))
		button:addEventListener("touch", onLetterTouch)
		local randomDelay = transitionDuration + (math.random(1,10) * 10)
		transition.from(button, {time = 500, delay = randomDelay, y = ayarYuksekligi + button.height, transition=easing.easeOutElastic})
	end
	
	-- play bubbles sound when letters animate in
	timer.performWithDelay(transitionDuration, playBubbles)
	
	-- enable home button
	geriAktif = true
end

function clearQuestion()
	-- remove wrongGraphic if present
	if wrongGraphic then
		wrongGraphic:removeSelf()
		wrongGraphic = nil
	end
	
	-- remove all letter buttons
	for i=1,#harfDugmeleri do
		harfDugmeleri[i].graphics:removeSelf()
		harfDugmeleri[i].graphics = nil
	end
end

function goHome()
	-- update screen var
	eskiEkran = yeniEkran
	
	baslamaEkraniEkle()
	yeniEkran = ekranAc
	
	-- do transitions
	transitionIn(yeniEkran)
	transitionIn(zorlukSlider)
	transitionIn(zorlukDugmesi)
	transitionOut(eskiEkran)
	transitionOut(evDugmesi)
	
	for i=1,#harfDugmeleri do
		transitionOut(harfDugmeleri[i].graphics)
	end
	
	-- enable play button
	oynaAktif = true
end

------------------------------------------------------------
-- SOUNDS
alkisSesleri = {}
alkisSesleri[1] = audio.loadSound("audio/dogru/dogru1.mp3")
alkisSesleri[2] = audio.loadSound("audio/dogru/dogru2.mp3")
alkisSesleri[3] = audio.loadSound("audio/dogru/dogru3.mp3")
alkisSesleri[4] = audio.loadSound("audio/dogru/dogru4.mp3")
alkisSesleri[5] = audio.loadSound("audio/dogru/dogru5.mp3")
 
function alkisla()
      local buAlkis = math.random(#alkisSesleri)
 
      audio.play(alkisSesleri[buAlkis])
      print(buAlkis)
end
 

local sesler = {

    harfSesi = audio.loadSound( "audio/letter.mp3" ),
    balonSesi = audio.loadSound( "audio/bubbles.mp3" ),
    hataSesi = audio.loadSound("audio/hata.mp3")

}
function playHataSesi()

	audio.play(sesler["hataSesi"])
end
function playLetterSound()

	audio.play(sesler["harfSesi"])
end

function playBubbles()

	audio.play(sesler["balonSesi"])
end

function playWord()
	local kelimelerinSesi = audio.loadSound( "audio/words/"..kelimeler[playOrder[currQuestion]].id..".mp3" )
	audio.play(kelimelerinSesi, {onComplete=alkisla} )
  print("kelime ses dosyasi:"..kelimeler[playOrder[currQuestion]].id)
end

function oyunMuzigiCal()
  audio.stop()
  audio.play(oyunMuzigi, { channel=2, loops=-1, fadein=2000 })
 end
 
 function baslamaMuzigiCal()
  audio.stop()
  audio.play(baslamaMuzigi,{ channel=1})
 end
------------------------------------------------------------
-- TRANSITIONS

function transitionIn(target)
	transition.from(target, {time = transitionDuration, x = ayarGenisligi + ortaX, transition=easing.inOutExpo})

end

function transitionOut(target)
	transition.to(target, {time = transitionDuration, x = -ortaX, transition=easing.inOutExpo, onComplete = onTransitionOutComplete})

end

function onTransitionOutComplete(target)

	target:removeSelf()
	target = nil
end


------------------------------------------------------------
-- EVENTS

function zorlukSuruklendiginde(event)
	local t = event.target

	local phase = event.phase
	if "began" == phase then
		-- Spurious events can be sent to the target, e.g. the user presses 
		-- elsewhere on the screen and then moves the finger over the target.
		-- To prevent this, we add this flag. Only when it's true will "move"
		-- events be sent to the target.
		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			local newX = event.x - t.x0
			if newX > zorlukSlotlari[1] and newX < zorlukSlotlari[#zorlukSlotlari] then
				t.x = newX
			elseif newX < zorlukSlotlari[1] then
				t.x = zorlukSlotlari[1]
			elseif newX > zorlukSlotlari[#zorlukSlotlari] then
				t.x = zorlukSlotlari[#zorlukSlotlari]
			end
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
			setDifficulty(t.x)
		end
	end

	-- Important to return true. This tells the system that the event
	-- should not be propagated to listeners of any objects underneath.
	return true
end

function zorlugaDokunuldugunda(event)
	if "ended" == event.phase then
		setDifficulty(event.x)
	end
end

function onPlayTouch(event)
	if "ended" == event.phase and oynaAktif == true then
		-- disable play button touches
		oynaAktif = false
		
		-- add home button
		anaMenuDonusEkle()
		
		-- do transitions
		transitionIn(evDugmesi)
		transitionOut(oynaDugmesi)
		transitionOut(zorlukSlider)
		transitionOut(zorlukDugmesi)
		sonrakiSoru()
	end
end

function onLetterTouch(event)
	local t = event.target
	if "ended" == event.phase then
		if t == correctButton then
			onCorrect()
		else
			onIncorrect(t)
		end
		
	end
end

function onIncorrect(incorrectButton)
	playHataSesi()
	wrongGraphic = display.newImageRect("images/graphics/wrong.png", 55, 55)
	wrongGraphic.x = incorrectButton.x 
	wrongGraphic.y = incorrectButton.y 
	transition.to(incorrectButton, {time=100, delay=500, alpha=0})
	transition.to(wrongGraphic, {time=200, delay=500, alpha=0, onComplete=wrongCompleteListener})
	local wrongCompleteListener = function(obj)
       obj:removeSelf()
       obj = nil
       incorrectButton:removeSelf()
       incorrectButton = nil
	end
end

function onCorrect()
	-- play correct sound then display word
	--alkisla()
	playWord()
 kelimeGoster()
 
	-- remove the letter buttons
	clearQuestion()
	
	-- disable the home button until new screen is shown
	geriAktif = false
end

function kelimeTamamlandiginda(event)
	transition.to(kelimeGrafigi, {time = transitionDuration, x = -ayarGenisligi, transition=easing.inOutExpo, onComplete = onTransitionOutComplete})

	sonrakiSoru()end

function onHomeTouch(event)
	if "ended" == event.phase and geriAktif == true then
		-- disable home button to prevent double touches
		geriAktif = false
		goHome()
	end
end


------------------------------------------------------------
-- Start app

basla()
