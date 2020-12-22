
PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
    -- uses math.random() to make pipe intervals slightly random
    self.pipeInterval = math.random(3) == 2 and 3 or 2
end

function PlayState:update(dt)
    if scrolling then
        self.timer = self.timer + dt
    
        if self.timer > self.pipeInterval then
          self.pipeInterval =  math.random(3) == 2 and 3 or 2
          local y = math.max(-PIPE_HEIGHT + 10, 
              math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            self.lastY = y
            self.timer = 0

            table.insert(self.pipePairs, PipePair(y))
        end

        for k, pair in pairs(self.pipePairs) do
            if not pair.scored then
                if pair.x + PIPE_WIDTH < self.bird.x  then 
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end
            pair:update(dt)
        end

        for k, pair in pairs(self.pipePairs) do
            if pair.remove then
                table.remove(self.pipePairs, k)
            end
        end

        for k, pair in pairs(self.pipePairs) do
            for l, pipe in pairs(pair.pipes) do
                if self.bird:collides(pipe) then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end

        self.bird:update(dt)

        if self.bird.y > VIRTUAL_HEIGHT - 15 then
            sounds['explosion']:play()
            sounds['hurt']:play()

            gStateMachine:change('score', {
                score = self.score
            })
        end
    
            
    end
    if love.keyboard.wasPressed('p') then
        if scrolling then 
            scrolling = false
            sounds['music']:pause()
        else
            scrolling = true
            sounds['music']:play()
        end
    end 
end


function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
    if scrolling == false then
        love.graphics.setFont(hugeFont)
        love.graphics.printf('PAUSED', 0, 100, VIRTUAL_WIDTH, 'center')
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Press P to resume', 0, 160, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setFont(mediumFont)
        love.graphics.print('Press P to pause', 8, 250)
    end
end

function PlayState:enter()
    scrolling = true
end

function PlayState:exit()
    scrolling = false
end