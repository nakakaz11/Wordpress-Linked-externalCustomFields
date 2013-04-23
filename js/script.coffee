(($, win, doc) ->
  $win = $(win)
  $doc = $(doc)

  $ ->
    $(".todoList").sortable
      axis       : "y" # 垂直方向のみの動きは許され
      containment: "#main" # Constrained by the window
      update     : -> # odos 再配置された後に関数が呼び出されます
        # toArrayメソッドはtodo のIDを配列で返します
        arr = $(".todoList").sortable("toArray")
        arr = $.map(arr, (val, key) -> # idsのthetodo-prefixをストライピング
          val.replace "todo-", ""
        )
        setTimeout ->       # sw timeoutで遅延評価
          $.get "ajax.php",
            action   : "rearrange"
            positions: arr
          , 11     #遅延
      stop       : (e, ui) -> #Opera fix:
        ui.item.css
          top : "0"
          left: "0"

    # currentTodo項目を含むjQueryオブジェクトを保持するグローバル変数
    currentTODO = undefined

    # 削除確認ダイアログの設定
    $("#dialog-confirm").dialog
      resizable: false
      height   : 130
      modal    : true
      autoOpen : false
      buttons  :
        "Delete item": ->
          $.get "ajax.php",
            action: "delete"
            id    : currentTODO.data("id")
          , (msg) ->
            currentTODO.fadeOut "fast"

          $(this).dialog "close"

        Cancel: ->
          $(this).dialog "close"


    # ダブルクリックが発生したときに、ちょうど edit ボタンのクリックをシミュレート:
    $(".todo").on "dblclick", ->
      $(this).find("a.edit").click()

    # Todo内のどのリンクがクリックされた場合は、割り当てる
    # 後で使用するためにcurrentTODO変数へ
    $(".todo a").on "click", (e) ->
      currentTODO = $(this).closest(".todo")
      currentTODO.data "id", currentTODO.attr("id").replace("todo-", "")
      e.preventDefault()

    # Listening for a click on a delete button:
    $(".todo a.delete").on "click", ->
      $("#dialog-confirm").dialog "open"

    # [edit]ボタンをクリックしてのリスニング // currentTODOを分岐 (セル追加時は、 ajax.phpの引数追加)
    $(".todo a.edit").on "click", ->
      containerText = currentTODO.find(".text")
      # currentTODOを分岐でin
      containerMisc = currentTODO.find(".misc")
      # misc追加
      if not currentTODO.data("origText") or
      not currentTODO.data("origMisc")
        # theToDoの現在の値を保存する ユーザーは変更を破棄した場合、後でそれを復元します。
        currentTODO.data "origText", containerText.text()
        currentTODO.data "origMisc", containerMisc.text() # misc追加
      else # 編集ボックスがすでに開いている場合、これは、[edit]ボタンをブロックします。
        return false

      # inputをセル分　appendToする
      $("<input type='text' class='iText'>")
        .val(containerText.text()).appendTo containerText.empty()
      $("<input type='text' class='iMisc'>")
        .val(containerMisc.text()).appendTo containerMisc.empty()
      # misc追加
      # 保存してリンクを解除を付加
      containerMisc.append """
          <div class='editTodo'>
          <a class='saveChanges' href='#'>Save</a> or
          <a class='discardChanges' href='#'>Cancel</a>
          </div>
          """

    # The cancel edit link:
    $doc.on "click", "a.discardChanges", ->   # sw fix live()
      currentTODO.find(".text").text currentTODO.data("origText")
      # misc追加
      currentTODO.find(".misc").text currentTODO.data("origMisc")
      currentTODO.removeData "origText origMisc"
      false

    # The save changes link:
    $doc.on "click", "a.saveChanges", ->
      text = currentTODO.find("input[class=iText]").val()
      misc = currentTODO.find("input[class=iMisc]").val()
      false

      setTimeout ->       # sw timeoutで遅延評価
        $.get "ajax.php",
          action: "edit"
          id    : currentTODO.data("id")
          text  : text
          misc  : misc
        , 11     #遅延

      currentTODO.find(".text").text text
      # misc追加
      currentTODO.find(".misc").text misc
      currentTODO.removeData "origText origMisc"


    # The Add NewToDo button:
    timestamp = 0
    $("#addButton").click (e) ->

      # Only oneTodo per 3 seconds is allowed:
      return false  if (new Date()).getTime() - timestamp < 1000
      $.get "ajax.php",
        action: "new"
        text  : "リストを追加（Doubleclick to Edit.）"
        misc  : "calを追加"
        rand  : Math.random()
      , (msg) ->

        # new Todoを付加し、ビューにそれをフェード。
        $(msg).hide().appendTo(".todoList").fadeIn()

      timestamp = (new Date()).getTime()
      # Updating the timestamp:
      e.preventDefault()

) jQuery, @, @document
