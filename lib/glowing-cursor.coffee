
{CompositeDisposable} = require 'atom'
{Disposable} = require 'atom'

style = null
disposables = null
module.exports =
    apply = ->
      Promise.resolve(atom.packages.isPackageLoaded('cursor-blink-interval') and atom.packages.activatePackage('cursor-blink-interval')).then(->
        disposables = new CompositeDisposable(
          setupStylesheet(),
          atom.config.observe('glowing-cursor', updateCursorStyles)
        )
        return
      ).catch (error) ->
        console.error error.message
        return

      dispose = ->
        disposables.dispose()
        disposables = null

      toRGBAString = (color) ->
        if typeof color == 'string'
          return color
        if typeof color.toRGBAString == 'function'
          return color.toRGBAString()
        "rgba(#{color.red}, #{color.green}, #{color.blue}, #{color.alpha})"


      setupStylesheet = ->
        style = document.createElement('style')
        style.type = 'text/css'
        document.querySelector('head atom-styles').appendChild style
        new Disposable(->
          style.parentNode.removeChild style
          style = null
          return
        )

      updateCursorStyles = ->
        style.innerHTML = ''
        glowColor = toRGBAString(atom.config.get('glowing-cursor.glowColor'))
        innerColor = toRGBAString(atom.config.get('glowing-cursor.innerColor'))
        cursorWidth = atom.config.get('glowing-cursor.cursorWidth')
        transitionDuration = atom.config.get('glowing-cursor.transitionDuration')
        glowDistance = atom.config.get('glowing-cursor.glowDistance')
        pulseOnRule = createCSSOption(
          "atom-text-editor .cursors .cursor"
          {
            transition: "opacity ease-in-out"
        	   "transition-duration": "#{transitionDuration}ms";
            opacity: 1
            "background-color": "#{innerColor}"
          })
        pulseOffRule = createCSSOption(
          "atom-text-editor .cursors.blink-off .cursor"
          {
            opacity: 0
            visibility: "visible !important"
          })
        cursorRule = createCSSOption(
          "atom-text-editor .cursors .cursor"
          {
            width: "#{cursorWidth}px !important"
            "box-shadow": "0px 0px #{glowDistance}px 0px #{glowColor}"
          })
        style.innerHTML = pulseOnRule + '\n' + pulseOffRule + '\n' + cursorRule

      createCSSOption = (selector, properties) ->
        output = "#{selector} {\n"
        for key of properties
          output += "\t#{key}: #{properties[key]};\n"
        output += "}"
        output
