module.exports =
  # public API
  config:
    cursorWidth:
      title: 'Cursor Width'
      description: 'The width of your cursor'
      type: 'integer'
      default: 1
    glowColor:
      title: 'Glow Color'
      description: 'Change the glow color of the selector.'
      type: 'color'
      default: 'rgba(75,213,255,1.0)'
    innerColor:
      title: 'Selector Inner Color'
      description: 'The color of the inner of the selector.'
      type: 'color'
      default: 'rgba(97,210,255,1.0)'
    transitionDuration:
      title: 'Transition duration'
      description: 'The duration of the phase transition animation'
      type: 'integer'
      default: 500
    glowDistance:
      title: 'Glow Width'
      description: 'The distance the cursor\'s glow should extend on either side'
      type: 'integer'
      default: 6


  activate: (state) ->
    glowingCursor = require './glowing-cursor'
    glowingCursor.apply()
