--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:861759f82de3fbdbed1eecec0b3c39aa:1/1$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- a
            x=254,
            y=254,
            width=82,
            height=82,

        },
        {
            -- b
            x=422,
            y=170,
            width=82,
            height=82,

        },
        {
            -- c
            x=338,
            y=170,
            width=82,
            height=82,

        },
        {
            -- d
            x=254,
            y=170,
            width=82,
            height=82,

        },
        {
            -- e
            x=170,
            y=422,
            width=82,
            height=82,

        },
        {
            -- f
            x=170,
            y=338,
            width=82,
            height=82,

        },
        {
            -- g
            x=170,
            y=254,
            width=82,
            height=82,

        },
        {
            -- h
            x=170,
            y=170,
            width=82,
            height=82,

        },
        {
            -- i
            x=422,
            y=86,
            width=82,
            height=82,

        },
        {
            -- j
            x=338,
            y=86,
            width=82,
            height=82,

        },
        {
            -- k
            x=254,
            y=86,
            width=82,
            height=82,

        },
        {
            -- l
            x=170,
            y=86,
            width=82,
            height=82,

        },
        {
            -- m
            x=86,
            y=422,
            width=82,
            height=82,

        },
        {
            -- n
            x=86,
            y=338,
            width=82,
            height=82,

        },
        {
            -- o
            x=86,
            y=254,
            width=82,
            height=82,

        },
        {
            -- p
            x=86,
            y=170,
            width=82,
            height=82,

        },
        {
            -- r
            x=86,
            y=86,
            width=82,
            height=82,

        },
        {
            -- s
            x=422,
            y=2,
            width=82,
            height=82,

        },
        {
            -- t
            x=338,
            y=2,
            width=82,
            height=82,

        },
        {
            -- u
            x=254,
            y=2,
            width=82,
            height=82,

        },
        {
            -- v
            x=170,
            y=2,
            width=82,
            height=82,

        },
        {
            -- y
            x=86,
            y=2,
            width=82,
            height=82,

        },
        {
            -- z
            x=2,
            y=422,
            width=82,
            height=82,

        },
        {
            --ç
            x=2,
            y=338,
            width=82,
            height=82,

        },
        {
            --ö
            x=2,
            y=254,
            width=82,
            height=82,

        },
        {
            --ü
            x=2,
            y=170,
            width=82,
            height=82,

        },
        {
            --ı
            x=2,
            y=86,
            width=82,
            height=82,

        },
        {
            --ş
            x=2,
            y=2,
            width=82,
            height=82,

        },
    },
    
    sheetContentWidth = 512,
    sheetContentHeight = 512
}

SheetInfo.frameIndex =
{

    ["a"] = 1,
    ["b"] = 2,
    ["c"] = 3,
    ["d"] = 4,
    ["e"] = 5,
    ["f"] = 6,
    ["g"] = 7,
    ["h"] = 8,
    ["i"] = 9,
    ["j"] = 10,
    ["k"] = 11,
    ["l"] = 12,
    ["m"] = 13,
    ["n"] = 14,
    ["o"] = 15,
    ["p"] = 16,
    ["r"] = 17,
    ["s"] = 18,
    ["t"] = 19,
    ["u"] = 20,
    ["v"] = 21,
    ["y"] = 22,
    ["z"] = 23,
    ["ç"] = 24,
    ["ö"] = 25,
    ["ü"] = 26,
    ["ı"] = 27,
    ["ş"] = 28,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
