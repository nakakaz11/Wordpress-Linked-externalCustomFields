###
coffee -wcb *.coffee
###
#print = (@) -> console?.log @
#print = (@) -> document.write(@+"\n")
### beta version ------------------------------------------------------- ###
#$ ->
###
callbacks = $.Callbacks()
callbacks.add( fn1 )
###
swAct = (oya) ->
  TheGet = {
      defs: (url) ->
           dfr = $.Deferred();
           $.ajax(
               url:url
               #dataType:'html'
               cache    : false
               success:dfr.resolve  #reject is failed
           )
           return dfr.promise();
  }

  TheGet.defs("./register.php").then (data) ->
    makeDom(data)   # 全部終わったらコールバック実行するわ $.when()
                    # 終わったらハイこれやってね then()、done()、fail()、pipe()
  makeDom = (data) ->
      setList = $()  # domObj?
      res = [] # 表示用配列
      that = $(oya+" .sw_slides_control")
      getObj  = $(data).find("ul.todoList li")
      #getObjMsc  = $(data).find("ul.todoList li div.misc")

      setList.push( getObj.text(       # objに格納
        (k,tx)->
          return
      ))
      inLen = getObj.length
      $("#smpSlideDiv2").append("<div><br>スライド数："+inLen+"</div>")
      divList = setList.get(0)
      for val, i in divList  # len分dom生成
        that.append(    # ヒアドキュメント生成
          """
          <div class="sw_slides_containerCld innerSMP carousel-item">

          <div class="phSMP"><img src="img/photo_s#{i+1}.png" alt="photo(test)"></div>
          <div class="txtSMP">#{val.innerHTML}</div>
          </div>
          """
        )
        # <a href="http://www.samuraiworks.org/_jsFiddle_/jDataBases/jQDBtodo/Interface.php">  </a>
        # console.log val

        j=i+1
        $("#res").append(j+'：'+val.innerHTML+'<br>') # .get(0) 素のHTMLエレメント
      # res.push('<div>変数展開arr：'+j+'： '+val.innerHTML+'</div>')
      # 配列をpush
      #$("#smpSlideDiv2").append(res.join()) # 配列をjoin

      $('#sw_slides').slides({
                preload     :true,
                preloadImage:'img/loading.gif',
                play        :2500,
                pause       :1500,
                #generateNextPrev: true,
                hoverPause  :true
                })
      $("#res").swLink()  # リンクのトランスフォームぶちこみ  if( supports3DTransforms )
      return

$.fn.extend  # 初の拡張ベース。aに対して、データ属性spanを追加など。
  swLink : () ->
    $_that = $("#res a,#res2 a")
    supports3DTransforms =  document.body.style['webkitPerspective'] isnt undefined or
                            document.body.style['MozPerspective'] isnt undefined #サポート判定
    if( supports3DTransforms )
          nodes = $($_that)#.find("a" )
          #console.log nodes[1]
          for val,i in nodes
            #console.log val.innerHTML
            $(nodes[i]).addClass("roll")
                       .wrapInner( "<span data-title='"+$(val).text()+"'/>" )
                       #.wrapInner( "<span data-title='"+val.innerHTML+"'/>" )
                       # $(val).text() は中にタグあってもtext取れる！

            ###if( !node.className or !node.className.match( /roll/g ) )
              node.className += ' roll'###
          return
    # http://minipaca.net/blog/jquery/jquery-de-hover/
    # $(elements).on(events [, selector] [, data], handler); event

    fire = (ev) ->
      $($_that).addClass("hover")
    bkfire = (ev) ->
      $($_that).removeClass("hover")
    $($_that).on('touchstart',fire)
             .off('touchend', bkfire)

$ ->
  swAct("#pSC")
