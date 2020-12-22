ScoreState = Class{__includes = BaseState}

function ScoreState:enter(params)
    self.score = params.score
    self.goldMedal = love.graphics.newImage('graphics/Gold Medal.png')
    self.silverMedal = love.graphics.newImage('graphics/Silver Medal.png')
    self.bronzeMedal = love.graphics.newImage('graphics/Bronze Medal.png')
    self.emptyMedal = love.graphics.newImage('graphics/Empty Medal.png')
end

function ScoreState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Game Over!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    local receivedMedal = nil
    local medalType = nil
    if self.score > 15 then
        receivedMedal = self.goldMedal
        medalType = 'gold'
    elseif self.score > 5 and self.score <= 15 then
        receivedMedal = self.silverMedal
        medalType = 'silver'
    elseif self.score > 1 and self.score <= 5 then 
        receivedMedal = self.bronzeMedal
        medalType = 'bronze'
    end

    if receivedMedal ~= nil then
        love.graphics.printf('Congratulations! You received a ' .. medalType .. ' medal ', 0, 120, VIRTUAL_WIDTH, 'center')
    else
        receivedMedal = self.emptyMedal
    end
        
    love.graphics.draw(receivedMedal, VIRTUAL_WIDTH / 2 - receivedMedal:getWidth() / 2, 140, 0 , 2, 2)

    love.graphics.printf('Press Enter to Play Again!', 0, 175, VIRTUAL_WIDTH, 'center')
end