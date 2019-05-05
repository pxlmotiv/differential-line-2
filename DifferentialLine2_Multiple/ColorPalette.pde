class ColorPaletteManager
{
  // strokeColor, fillColor, bgColor 
  color[][] palettes = new color[][]
    {
    new color[]{ #FF2400, #F0E130, #242124 }, 
    new color[]{ #13505B, #0C768A, #000000 }, 
    new color[]{ #456990, #EDC487, #241623 }, 
    new color[]{ #DB2941, #5C4263, #241623 }, 
    new color[]{ #F5F5F5, #D1C6AD, #3C3C3C }, 
    new color[]{ #FF5A5F, #D1C6AD, #087E8B }, 
    new color[]{ #6B94A8, #EFBEC7, #C54F32 }, 
    new color[]{ #FF9900, #FFCC33, #44001E }, 
    new color[]{ #5B8266, #E4FDE1, #212922 }, 
    new color[]{ #E4FDE1, #BE7C4D, #1D5F66 }, 
  };

  color[] getRandomColorPalette()
  {
    return palettes[floor(random(palettes.length))];
  }
  
  color[] getRandomAdjustedColorPalette()
  {
    color[] colors = getRandomColorPalette();

    color c1 = lerpColor(colors[0], colors[1], random(0.15, 0.85));
    color c2 = lerpColor(colors[1], colors[2], random(0.15, 0.85));
    color c3 = lerpColor(colors[2], colors[0], random(0.15, 0.85));

    int order = round(random(2));

    if (order == 0) {
      return new color[]{c1, c2, c3};
    } else if (order == 1) {
      return new color[]{c2, c3, c1};
    } else if (order == 2) {
      return new color[]{c3, c1, c2};
    }

    return new color[]{c1, c2, c3};
  }

  color[] getAdjustedColorPalette(int index)
  {
    color[] colors = palettes[index];

    color c1 = lerpColor(colors[0], colors[1], random(0.15, 0.85));
    color c2 = lerpColor(colors[1], colors[2], random(0.15, 0.85));
    color c3 = lerpColor(colors[2], colors[0], random(0.15, 0.85));

    int order = round(random(2));

    if (order == 0) {
      return new color[]{c1, c2, c3};
    } else if (order == 1) {
      return new color[]{c2, c3, c1};
    } else if (order == 2) {
      return new color[]{c3, c1, c2};
    }

    return new color[]{c1, c2, c3};
  }
}
