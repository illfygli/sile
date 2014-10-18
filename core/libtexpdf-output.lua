local pdf = require("justenoughlibtexpdf");
if (not SILE.outputters) then SILE.outputters = {} end
local cursorX = 0
local cursorY = 0
local font = 0
local lastW = 0
SILE.outputters.libtexpdf = {
  init = function()
    pdf.init(SILE.outputFilename, SILE.documentState.paperSize[1],SILE.documentState.paperSize[2])
    pdf.beginpage()
  end,
  newPage = function()
    pdf.endpage()
    pdf.beginpage()
  end,
  finish = function()
    pdf.endpage()
    pdf.finish()
  end,
  setColor = function (self, color)
    -- XXX
  end,
  outputHbox = function (value,w)
    if not value.glyphString then return end
    local buf = {}
    for i=1,#(value.glyphString) do
      glyph = value.glyphString[i]
      buf[#buf+1] = string.char(math.floor(glyph % 2^32 / 2^8))
      buf[#buf+1] = string.char(glyph % 0xff)
    end
    buf = table.concat(buf, "")
    pdf.setstring(cursorX, cursorY, buf, string.len(buf), font, w)
    lastW = w
  end,
  setFont = function (options)
    if SILE.font._key(options) == lastkey then return end
    lastkey = SILE.font._key(options)
    f = pdf.loadfont({filename=SILE.font.cache(options).filename,pointsize=options.size})
    font = f
  end,
  drawPNG = function (src, x,y,w,h)
    -- XXX
  end,
  moveTo = function (x,y)
    cursorX = x
    cursorY = SILE.documentState.paperSize[2] - y
  end,
  rule = function (x,y,w,d)
    pdf.setrule(x,SILE.documentState.paperSize[2] -y,w,d)
  end,
  debugFrame = function (self,f)
  end,
  debugHbox = function(typesetter, hbox, scaledWidth)
  end
}

SILE.outputter = SILE.outputters.libtexpdf