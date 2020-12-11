-- Author: Colton Ogden
-- Sprites: https://github.com/cs50/gd50/tree/master/flappy-bird and owned medals

push = require 'push'
Class = require 'class'

WINDOW_WIDTH = 800
WINDOW_HEIGHT = 500

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('Assets/background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('Assets/ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30 
local GROUND_SCROLL_SPEED = 60 
 
local BACKGROUND_LOOPING_POINT = 413

scrolling = true

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Fifty Bird')

    smallFont = love.graphics.newFont('Assets/font.ttf', 8)
    mediumFont = love.graphics.newFont('Assets/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('Assets/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('Assets/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('Assets/Jump8.wav', 'static'),
        ['explosion'] = love.audio.newSource('Assets/Explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('Assets/Hit_Hurt6.wav', 'static'),
        ['score'] = love.audio.newSource('Assets/Pickup_Coin7.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('Assets/marios_way.mp3', 'static')
    }

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true, 
        vsync = true
    })
end

function love.resize(w, h)
    push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end 

function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    -- or return love.keyboard.keysPressed[key]  
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false 
    end
end  

function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end

function love.update(dt)
    if scrolling then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt)
            % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt)
            % VIRTUAL_WIDTH
    end

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end  