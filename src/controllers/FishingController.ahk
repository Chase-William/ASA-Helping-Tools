#Requires AutoHotkey v2.0

#include "../Config.ahk"
#include "../Util.ahk"

FISHING_SECTION := "fishing"

FISHING_LETTER_Q_CONFIG_KEY := "q"
FISHING_LETTER_W_CONFIG_KEY := "w"
FISHING_LETTER_A_CONFIG_KEY := "a"
FISHING_LETTER_S_CONFIG_KEY := "s"
FISHING_LETTER_Z_CONFIG_KEY := "z"
FISHING_LETTER_E_CONFIG_KEY := "e"
FISHING_LETTER_D_CONFIG_KEY := "d"
FISHING_LETTER_C_CONFIG_KEY := "c"
FISHING_LETTER_X_CONFIG_KEY := "x"

; Near white text is expected of fishing text commands
FISHING_PROMPT_TEXT_COLOR_THRESHOLD := 240

; Houses all the necessary logic/local data for automatic fishing
; This was done because automatic fishing is too complicated to implemented
; within the general controller.
class FishingController {
  __New(cfg, user) {
    this.cfg := cfg
    this.user := user
    
    this.m_q := ParseFishingArray(FISHING_LETTER_Q_CONFIG_KEY)
    this.m_w := ParseFishingArray(FISHING_LETTER_W_CONFIG_KEY)
    this.m_a := ParseFishingArray(FISHING_LETTER_A_CONFIG_KEY)
    this.m_s := ParseFishingArray(FISHING_LETTER_S_CONFIG_KEY)
    this.m_z := ParseFishingArray(FISHING_LETTER_Z_CONFIG_KEY)
    this.m_e := ParseFishingArray(FISHING_LETTER_E_CONFIG_KEY)
    this.m_d := ParseFishingArray(FISHING_LETTER_D_CONFIG_KEY)
    this.m_c := ParseFishingArray(FISHING_LETTER_C_CONFIG_KEY)
    this.m_x := ParseFishingArray(FISHING_LETTER_X_CONFIG_KEY)

    this.m_isAutoFishOn := false

    this.autofishCallback := this.AutoFish.bind(this)
  }

  IsAutoFishOn {
    get => this.m_isAutoFishOn
    set => this.m_isAutoFishOn := value
  }

  AutoFishToggle() {
    if this.IsAutoFishOn := !this.IsAutoFishOn {
      WinActivate(this.cfg.process.windowTitle)
      SetTimer(this.autoFishCallback, this.cfg.delay.lw)
    } else {
      Settimer(this.autoFishCallback, 0)
    }
  }

  AutoFish() {
    static centerX := 0
    static centerY := 0

    if (centerX == 0) {
      WinGetPos(,, &centerX, &centerY, this.cfg.process.windowTitle)
      centerX := centerX / 2
      centerY := centerY / 2
    }

    ; Test each character in a specific order
    if (this.TestPixelColor(this.m_q)) {
      ;MsgBox "q", "q" 
      ControlSend("q",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_w)) {
      ;MsgBox "w", "w" 
      ControlSend("w",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_a)) {
      ;MsgBox "a", "a" 
      ControlSend("a",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_s)) {
      ;MsgBox "s", "s" 
      ControlSend("s",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_z)) {
      ;MsgBox "z", "z" 
      ControlSend("z",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_e)) {
      ;MsgBox "E", "E" 
      ControlSend("e",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_d)) {
      ;MsgBox "D", "D"      
      ControlSend("d",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_c)) {
      ;MsgBox "c", "c" 
      ControlSend("c",, this.cfg.process.windowTitle)
    } else if (this.TestPixelColor(this.m_x)) {
      ;MsgBox "x", "x" 
      ControlSend("x",, this.cfg.process.windowTitle)
    } else {
      return ; No letter found
    }    
  }

  ; Test a character's positions for valid color value
  ; positions - positions array to test
  ; return - true for all matches, false for failure of one or more matches
  TestPixelColor(positions) {
    rgb := Array()
    ; Loop over all positions for this character
    for position in positions {
      rgb := HexToDecArray(PixelGetColor(position.x, position.y))
      if (rgb[RED_INDEX] < FISHING_PROMPT_TEXT_COLOR_THRESHOLD) {
        return false
      }
      if (rgb[GREEN_INDEX] < FISHING_PROMPT_TEXT_COLOR_THRESHOLD) {
        return false
      }
      if (rgb[BLUE_INDEX] < FISHING_PROMPT_TEXT_COLOR_THRESHOLD) {
        return false
      }
    }
    ; Success only occurs if all previous steps succeed
    return true
  }
}

; Returns an array of points as a result of parsing 
; the [fishing] section's | deliminated points
ParseFishingArray(key) {
  pointsStr := Config.Get(key, FISHING_SECTION)
  ; pointStrings := StrSplit(Config.Get(key, FISHING_SECTION), "|")
  points := Array()
  Loop Parse, pointsStr, "|" {
    ; Parse and push points onto array
    points.Push(Point.From(A_LoopField))
  }
  return points
}