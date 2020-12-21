PipePair = Class{}

function PipePair:init(y)
    self.scored = false
    self.x = VIRTUAL_WIDTH + 32
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        --uses math.random() to make pipe gaps slightly random
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + math.random (90,110))
    }

    self.remove = false
    
end

function PipePair:update(dt)

    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for l, pipe in pairs(self.pipes) do
        pipe:render()
    end
end
