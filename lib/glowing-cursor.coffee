module.exports =
    config:
        cusrorWidth:
            title: "Cursor Width"
            description: "The width of your cursor"
            type: "integer"
            default: 1
        # glowColor:
        #     title: "Glow Color"
        #     description: "Change the glow color of the selector."
        #     type: "string"
        #     default: "rgba(75,213,255,1.0)"
        # 
        # innerColor:
        #     title: "Selector Inner Color"
        #     description: "The color of the inner of the selector."
        #     type: "string"
        #     default: "rgba(97,210,255,1.0)"

    activate: (state) ->
        console.log "glowing-cursor active"
        atom.config.onDidChange "glowing-cursor.cursorWidth", @setCursorWidth
        # atom.config.onDidChange "glowing-cursor.glowColor", @setGlowColor
        # atom.config.onDidChange "glowing-cursor.innerColor", @setInnerColor

    setCursorWidth: (event) ->
        console.log "width: #{event.newValue}"

    # setGlowColor: (event) ->
    #     console.log "color: #{event.newValue};"
    #     # newValue = "color: #{event.newValue};"
    #     # oldValue = "color: #{event.oldValue};"
    #     # for textEditor in atom.workspace.getTextEditors()
    #     #   glowingCursor.setEditor textEditor, event.newValue, event.oldValue
    # 
    # setInnerColor: (event) ->
    #     console.log "color: #{event.newValue};"
    #     # newValue = "color: #{event.newValue};"
    #     # oldValue = "color: #{event.oldValue};"
    #     # for textEditor in atom.workspace.getTextEditors()
    #     #   glowingCursor.setEditor textEditor, event.newValue, event.oldValue
    # 
    # # init: (textEditor) ->
    # #     animationType = atom.config.get "glowing-cursor.animationType"
    # #     glowingCursor.setEditor textEditor, animationType
    # #     cursorType = atom.config.get "glowing-cursor.cursorType"
    # #     glowingCursor.setEditor textEditor, cursorType
    # 
    # setEditor: (textEditor, newValue, oldValue) ->
    #     textEditorView = atom.views.getView textEditor
    # 
    #     if textEditorView.shadowRoot
    #         classList = textEditorView.shadowRoot.querySelector(".editor--private").classList
    #     else
    #         classList = textEditorView.classList
    # 
    #     classList.add "glowing-cursor" unless classList.contains "glowing-cursor"
    #     classList.remove "glowing-cursor-" + oldValue if oldValue
    #     classList.add "glowing-cursor-" + newValue
