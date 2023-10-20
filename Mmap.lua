
comm.mmfSetFilename("pokemon-bot-screenshot")
comm.mmfWrite("pokemon-bot-screenshot", string.rep("\x00", 24576))

function writeScreenshotToMmap() 
    comm.mmfScreenshot()
end


writeScreenshotToMmap()
--[[
while true do
    framecount = emu.framecount()
    fps = client.get_approx_framerate()
    if framecount % fps == 0 then
        -- print(framecount, fps)
        writeScreenshotToMmap()
    end

    emu.frameadvance()
end
--]]