
-- Project 2: Distorted Spiral Staircase
-- Bradley Lowe

require("L5")

-- Blue and pink colors
colors = {
    {0, 100, 255},
    {255, 70, 160}
}

steps = {}

changeInterval = 1.5
lastChange = 0

saveMessage = ""
saveMessageUntil = 0
sWasDown = false

function createStaircase()
    steps = {}

    local centerX = 300
    local centerY = 300
    local totalSteps = 48

    local angle = -2.5
    local radius = 245

    -- Arrange the steps in a spiral
    for i = 1, totalSteps do
        local progress = (i - 1) / (totalSteps - 1)

        -- Larger steps outside, smaller steps inside
        local baseWidth = 75 - progress * 55
        local baseHeight = 30 - progress * 17

        -- Change the size of each step
        local stepWidth = baseWidth * random(0.85, 1.15)
        local stepHeight = baseHeight * random(0.85, 1.15)

        -- Change the angles and spacing
        local angleChange = random(0.23, 0.29)
        local gapChange = random(4.2, 5.3)

        angle = angle + angleChange
        radius = radius - gapChange

        local x = centerX + cos(angle) * radius
        local y = centerY + sin(angle) * radius

        local colorIndex = math.random(1, #colors)

        steps[i] = {
            x = x,
            y = y,
            w = stepWidth,
            h = stepHeight,
            angle = angle,
            color = colorIndex
        }
    end
end

function setup()
    size(600, 600)
    rectMode(CENTER)
    noStroke()

    createStaircase()
    lastChange = love.timer.getTime()
end

function draw()
    background(255)

    -- Show the staircase
    for i = 1, #steps do
        local step = steps[i]
        local c = colors[step.color]

        push()
        translate(step.x, step.y)
        rotate(step.angle)

        fill(c[1], c[2], c[3])
        rect(0, 0, step.w, step.h)

        pop()
    end

    local now = love.timer.getTime()

    -- Check for the S key
    local sIsDown = love.keyboard.isDown("s")

    if sIsDown and not sWasDown then
        -- Save the current frame
        local filename = "SpiralStaircase.png"

        local success, err = pcall(function()
            save(filename)
        end)

        local fileInfo = love.filesystem.getInfo(filename)

        if success and fileInfo then
            saveMessage = "Saved: " .. filename
        else
            saveMessage = "Save failed!"
            print("Save error:", err)
        end

        saveMessageUntil = now + 3
    end

    sWasDown = sIsDown

    -- Show the save result
    if now < saveMessageUntil then
        fill(0)
        text(saveMessage, 20, 575)
    end

    -- Change the staircase every 1.5 seconds
    if now - lastChange >= changeInterval then
        createStaircase()
        lastChange = now
    end
end