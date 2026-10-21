
-- Project 2: Distorted Spiral Staircase
-- Bradley Lowe

require("L5")

-- Colors used for the staircase
colors = {
    {0, 100, 255},
    {255, 70, 160}
}

-- Store the staircase steps
steps = {}

-- Time between changes
changeInterval = 1.5
lastChange = 0

-- Save controls
saveMessage = ""
saveMessageUntil = 0
saveKeyWasDown = false

-- Arrange the staircase steps
function createStaircase()
    steps = {}

    local centerX = 300
    local centerY = 300
    local totalSteps = 48

    local angle = -2.5
    local radius = 245

    -- Place the steps along the spiral
    for stepNumber = 1, totalSteps do
        local progress = (stepNumber - 1) / (totalSteps - 1)

        -- Steps become smaller toward the center
        local baseWidth = 75 - progress * 55
        local baseHeight = 30 - progress * 17

        -- Randomly change the step sizes
        local stepWidth = baseWidth * random(0.85, 1.15)
        local stepHeight = baseHeight * random(0.85, 1.15)

        -- Randomly change the angles and spacing
        local angleChange = random(0.23, 0.29)
        local gapChange = random(4.2, 5.3)

        angle = angle + angleChange
        radius = radius - gapChange

        -- Find the position of each step
        local stepX = centerX + cos(angle) * radius
        local stepY = centerY + sin(angle) * radius

        -- Choose blue or pink
        local colorIndex = math.random(1, #colors)

        steps[stepNumber] = {
            x = stepX,
            y = stepY,
            width = stepWidth,
            height = stepHeight,
            angle = angle,
            colorIndex = colorIndex
        }
    end
end

-- Set up the canvas
function setup()
    size(600, 600)
    rectMode(CENTER)
    noStroke()

    createStaircase()
    lastChange = love.timer.getTime()
end

-- Display the staircase
function draw()
    background(255)

    -- Draw each step
    for stepNumber = 1, #steps do
        local step = steps[stepNumber]
        local stepColor = colors[step.colorIndex]

        push()
        translate(step.x, step.y)
        rotate(step.angle)

        fill(stepColor[1], stepColor[2], stepColor[3])
        rect(0, 0, step.width, step.height)

        pop()
    end

    local currentTime = love.timer.getTime()

    -- Check if the S key is pressed
    local saveKeyIsDown = love.keyboard.isDown("s")

    if saveKeyIsDown and not saveKeyWasDown then
        local fileName = "SpiralStaircase.png"

        -- Save the current staircase
        local saveWorked, saveError = pcall(function()
            save(fileName)
        end)

        -- Check whether the file exists
        local fileInfo = love.filesystem.getInfo(fileName)

        if saveWorked and fileInfo then
            saveMessage = "Saved: " .. fileName
        else
            saveMessage = "Save failed!"
            print("Save error:", saveError)
        end

        saveMessageUntil = currentTime + 3
    end

    saveKeyWasDown = saveKeyIsDown

    -- Show the save message
    if currentTime < saveMessageUntil then
        fill(0)
        text(saveMessage, 20, 575)
    end

    -- Change the staircase every 1.5 seconds
    if currentTime - lastChange >= changeInterval then
        createStaircase()
        lastChange = currentTime
    end
end