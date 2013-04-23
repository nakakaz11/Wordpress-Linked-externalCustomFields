###
Slides, A Slideshow Plugin for jQuery
Intructions: http://slidesjs.com
By: Nathan Searles, http://nathansearles.com
Version: 1.1.9
sw Fix By SamuraiWorks 121031~130421
###
(($, win, doc) ->
  $win = $(win)
  $doc = $(doc)

  $.fn.slides = (option) ->
    option = $.extend({}, $.fn.slides.option, option)

    return this.each ->
      elem = $(this)
      control = $(".sw_slides_control")
      total = control.children().size()
      width = control.children().outerWidth()
      #850
      height = control.children().outerHeight()
      #60
      start = option.start - 1
      effect = if option.effect.indexOf(',') <
      0 then option.effect else option.effect
        .replace(' ', '').split(',')[0]
      paginationEffect = if option.effect.indexOf(',') <
      0 then effect else option.effect
        .replace(' ', '').split(',')[1]
      next = 0
      prev = 0
      number = 0
      current = 0

      loaded = null
      active = null
      clicked = null
      position = null
      direction = null
      imageParent = undefined
      pauseTimeout = null
      playInterval = undefined

      # 唯一つのスライドがあるのでしょうか？
      if (total < 2)
        $('.' + option.container, $(this))
          .fadeIn(option.fadeSpeed, option.fadeEasing, ->
            loaded = true
            option.slidesLoaded()
          )
        $('.' + option.next + ', .' + option.prev).fadeOut(0)
        return false

      # animate slides
      animate = (direction, effect, clicked) ->
        if (!active && loaded)
          active = true
          # start of animation
          option.animationStart(current + 1)
          switch direction
            when 'next'
            # 以前に現在のスライドを変更
              prev = current
              # get next from current + 1
              next = current + 1
              # 最後のスライドの場合、最初のスライドの横に設定
              next = if total is next then 0 else next
              # 前の右側に次のスライドの位置を設定
              position = width * 2
              # スライドする距離は、スライドの幅に基づいて、
              direction = -width * 2
              # store new current slide
              current = next
            when 'prev'
              prev = current
              # get next from current - 1
              next = current - 1
              next = if next is -1 then total - 1 else next
              position = 0
              direction = 0
              # store new current slide
              current = next
            when 'pagination'
            # ページネーションの項目をクリックから次の取得、
            # 数値に変換
              next = parseInt(clicked, 10)
              # currentのクラスと改ページ項目から前の取得
              prev = $('.' + option.paginationClass + ' li.' +
              option.currentClass + ' a', elem)
                .attr('href').match('[^#/]+$')
              # nextは、前の右側に次に次のスライドのprevの
              # セット位置も大きい場合
              if (next > prev)
                position = width * 2
                direction = -width * 2
              else
                # 次は前の左側に少ないし、次のスライドの前の
                # セットポジションである場合
                position = 0
                direction = 0
              current = next
            else
              null

          # fade animation
          if (effect is 'fade')
            if (option.crossfade)
              # put hidden next above current
              control.children(":eq(#{next})", elem).css({
                zIndex: 10
              }).fadeIn(option.fadeSpeed, option.fadeEasing, ->
                if (option.autoHeight)
                  # animate container to height of next
                  control.animate({
                    height: control.children(":eq(#{next})", elem).outerHeight()
                  }
                  , option.autoHeightSpeed, ->
                    # hide previous
                    control.children(":eq(#{prev})", elem).css({
                      display: 'none',
                      zIndex : 0
                    })
                    # reset z index
                    control.children(":eq(#{next})", elem).css({
                      zIndex: 0
                    })
                    # end of animation
                    option.animationComplete(next + 1)
                    active = false
                  )
                else
                  # hide previous
                  control.children(":eq(#{prev})", elem).css({
                    display: 'none'
                    zIndex : 0
                  })
                  # reset zindex
                  control.children(":eq(#{next})", elem).css({
                    zIndex: 0
                  })
                  # end of animation
                  option.animationComplete(next + 1)
                  active = false
              )
            else
              # fade animation with no crossfade
              control.children(":eq(#{prev})", elem)
                .fadeOut(option.fadeSpeed, option.fadeEasing, ->
                  # animate to new height
                  if (option.autoHeight)
                    control.animate({
                    # animate container to height of next
                      height: control.children(":eq(#{next})", elem)
                        .outerHeight()}
                    , option.autoHeightSpeed, -> # fade in next slide
                      control.children(":eq(#{next})", elem)
                        .fadeIn(option.fadeSpeed, option.fadeEasing))
                  else
                    # if fixed height
                    control.children(":eq(#{next})", elem)
                      .fadeIn(option.fadeSpeed, option.fadeEasing, ->
                        # fix font rendering in ie, lame
                        if ($.browser.msie)
                          $(this).get(0).style.removeAttribute('filter'))
                  # end of animation
                  option.animationComplete(next + 1)
                  active = false
                )
          else
            # move next slide to right of previous
            control.children(":eq(#{next})").css({
              left   : position,
              display: 'block'
            }).addClass('current').siblings().removeClass('current')
            ###------------------currentクラスを挿入siblings-----###
            # animate to new height
            if (option.autoHeight)
              control.animate({
                left  : direction,
                height: control.children(":eq(#{next})").outerHeight()
              }, option.slideSpeed, option.slideEasing, ->
                control.css({
                  left: -width
                })
                control.children(":eq(#{next})").css({
                  left  : width,
                  zIndex: 5
                })
                # reset previous slide
                control.children(":eq(#{prev})").css({
                  left   : width,
                  display: 'none',
                  zIndex : 0
                })
                # end of animation
                option.animationComplete(next + 1)
                active = false
              )
              # if fixed height
            else
              # animate control
              control.animate({
                left: direction
              }, option.slideSpeed, option.slideEasing, ->
                # after animation reset control position
                control.css({
                  left: -width
                })
                # reset and show next
                control.children(":eq(#{next})").css({
                  left  : width,
                  zIndex: 5
                })
                # reset previous slide
                control.children(":eq(#{prev})").css({
                  left   : width,
                  display: 'none',
                  zIndex : 0
                })
                # end of animation
                option.animationComplete(next + 1)
                active = false
              )
          # ページネーションのための現在の状態を設定する
          if (option.pagination)
            # remove current class from all
            $('.' + option.paginationClass + ' li.' + option.currentClass, elem)
              .removeClass(option.currentClass)
            # add current class to next
            $('.' + option.paginationClass + " li:eq( #{next})", elem)
              .addClass(option.currentClass)

      # end animate function
      stop = () ->
        # clear interval from stored id
        clearInterval(elem.data('interval'))
      pause = () ->
        if (option.pause)
          # clear timeout and interval
          clearTimeout (elem.data('pause'))
          clearInterval(elem.data('interval'))
          # option.pause量の一時停止スライドショー
          pauseTimeout = setTimeout(->
            # clear pause timeout
            clearTimeout(elem.data('pause'))
            # start play interval after pause
            playInterval = setInterval(->
              animate("next", effect)
            , option.play)
            # store play interval
            elem.data('interval', playInterval)
          , option.pause)
          # store pause interval
          elem.data('pause', pauseTimeout)
        else
          # if no pause, just stop
          stop()
      # 2 or more slides required
      if total < 2 then return
      # error corection for start slide
      if start < 0 then start = 0
      if (start > total)
        start = total - 1
      # change current based on start option number
      if (option.start)
        current = start
      # randomizes slide order
      if (option.randomize)
        control.randomize()
      # オーバーフローが隠されていることを確認し、幅が設定されています
      $('.' + option.container, elem).css({
        overflow: 'hidden',
      # fix for ie
        position: 'relative'
      })

      # set css for slides
      control.children().css({
        position: 'absolute',
        top     : 0,
        left    : control.children().outerWidth(),
        zIndex  : 0,
        display : 'none'
      })

      # set css for control div
      control.css({
        position: 'relative',
      # size of control 3 x slide width
      #width    :$(win).width()-60
      #width    :width+'px'
      #width   :(width * 3),
      # set height to slide height
        height  : height,
      # center control to slide
        left    : -width
      })
      ###----------------------------------- リサイズイベントつっこみ ------###
      timer = false
      $(win).resize(->
        if (timer isnt false)
          clearTimeout(timer)
        timer = setTimeout(->
          control.css('width', $(win).width() - 62)
        , 200)
      )
      ###----------------------------------- リサイズイベントつっこみ ------###
      # show slides
      $('.' + option.container, elem).css({
        display: 'block'
      })

      # if autoHeight true, get and set height of first slide
      if (option.autoHeight)
        control.children().css({
          height: 'auto'
        })
        control.animate({
          height: control.children(':eq(' + start + ')').outerHeight()
        }, option.autoHeightSpeed)
      # checks if image is loaded
      if (option.preload && control.find('img:eq(' + start + ')').length)
        # adds preload image
        $('.' + option.container, elem).css({
          background: 'url(' + option.preloadImage + ') no-repeat 50% 50%'
        })
        # gets image src, with cache buster
        img = control.find('img:eq(' + start + ')').attr('src') + '?' + (new Date()).getTime()
        # check if the image has a parent
        if ($('img', elem).parent().attr('class') != 'sw_slides_control')
          # If image has parent, get tag name
          imageParent = control.children(':eq(0)')[0].tagName.toLowerCase()
        else
          # Image doesn't have parent, use image tag name
          imageParent = control.find('img:eq(' + start + ')')

        # checks if image is loaded
        control.find('img:eq(' + start + ')').attr('src', img).load(->
          # once image is fully loaded, fade in
          control.find(imageParent + ':eq(' + start + ')')
            .fadeIn(option.fadeSpeed, option.fadeEasing, ->
              $(this).css({
                zIndex: 5
              })
              # removes preload image
              $('.' + option.container, elem).css({
                background: ''
              })
              # let the script know everything is loaded
              loaded = true
              # call the loaded funciton
              option.slidesLoaded()
            )
        )
      else
        # if no preloader fade in start slide
        control.children(':eq(' + start + ')')
          .fadeIn(option.fadeSpeed, option.fadeEasing, ->
            # let the script know everything is loaded
            loaded = true
            # call the loaded funciton
            option.slidesLoaded()
          )

      # click slide for next
      if (option.bigTarget)
        # set cursor to pointer
        control.children().css({
          cursor: 'pointer'
        })
        # click handler
        control.children().click(->
          # animate to next on slide click
          animate('next', effect)
          return false
        )

      # pause on mouseover
      if (option.hoverPause and option.play)
        control.on 'mouseover', ->
          # on mouse over stop
          stop()
        control.on 'mouseleave', ->
          # on mouse leave start pause timeout
          pause()

      # generate next/prev buttons
      if (option.generatesNextPrev)
        $('.' + option.container, elem)
          .after('<a href="#" class="' + option.prev + '">Prev</a>')
        $('.' + option.prev, elem)
          .after('<a href="#" class="' + option.next + '">Next</a>')

      ###----------タッチイベント挿入--------------###
      getTouchHandler = ->
        startX = 0
        diffX = 0
        return (e) ->
          e.preventDefault()
          touch = e.touches[0]
          if (e.type is "touchstart")
            startX = touch.pageX
            sTime = (new Date()).getTime()
            #開始時間
            return
          else if (e.type is "touchmove")
            diffX = touch.pageX - startX
            return
          else if (e.type is "touchend")
            t = (new Date()).getTime() - sTime
            #時間差分
            # 160以上移動したか、300ミリ秒以内に80以上移動したらフリックと判定
            if (diffX > 111 || (t < 300 && diffX > 80))
              animate('prev', effect)
              # fncfireL
              return
            else if (diffX < -111 || (t < 300 && diffX < -80))
              animate('next', effect)
              # fncfireR
              return
            else if (0 >= diffX < 30 or e.type is "click")
              href = $(".sw_slides_control .current a").attr("href")
              win.open(href, '_self')
              #touch link fire
              return

      $ ->
        # sw IE8以下は無視
        userAgent = window.navigator.userAgent.toLowerCase()
        appVersion = window.navigator.appVersion.toLowerCase()
        unless userAgent.indexOf("msie") is -1
          false
          unless appVersion.indexOf("msie 6.") is -1
            false
          else unless appVersion.indexOf("msie 7.") is -1
            false
          else unless appVersion.indexOf("msie 8.") is -1
            false
          ###else unless appVersion.indexOf("msie 9.") is -1
            false
          else unless appVersion.indexOf("msie 10.") is -1
            false###
        else
          box = $(".sw_slides_container")[0]
          touchHandler = getTouchHandler()
          box.addEventListener("touchstart", touchHandler, false)
          box.addEventListener("touchmove", touchHandler, false)
          box.addEventListener("touchend", touchHandler, false)
          return

      ###----------タッチイベント挿入--------------###
      # next button
      $('.next').on "click", (e)->
        e.preventDefault()
        if (option.play)
          pause()
        animate('next', effect)
      # previous button
      $('.prev').on "click", (e)->
        e.preventDefault()
        if (option.play)
          pause()
        animate('prev', effect)

      # generate pagination
      if (option.generatePagination)
        # create unordered list
        if (option.prependPagination)
          elem.prepend('<div class="sw_pagenate1 clearfix"><ul class=' +
          option.paginationClass + '></ul></div>')
        else
          elem.append('<div class="sw_pagenate1 clearfix"><ul class=' +
          option.paginationClass + '></ul></div>')
        # for each slide create a list item and link
        control.children().each(->
          $('.' + option.paginationClass, elem)
            .append('<li><a href="#' + number + '">' + (number + 1) + '</a></li>')
          number++
        )
      else
        # 改ページが存在する場合は、href w/アイテム数の値をリンクに追加する
        $('.' + option.paginationClass + ' li a', elem).each(->
          $(this).attr('href', '#' + number)
          number++
        )
      # add current class to start slide pagination
      $('.' + option.paginationClass + ' li:eq(' + start + ')', elem)
        .addClass(option.currentClass)
      # click handling
      $('.' + option.paginationClass + ' li a', elem).click(->
        # pause slideshow
        if (option.play)
          pause()
        # get clicked, pass to animate function
        clicked = $(this).attr('href').match('[^#/]+$')
        # if current slide equals clicked, don't do anything
        if (current != clicked)
          animate('pagination', paginationEffect, clicked)
        return false
      )
      # click handling
      $('a.link', elem).click(->
        # pause slideshow
        if (option.play)
          pause()
        # get clicked, pass to animate function
        clicked = $(this).attr('href').match('[^#/]+$') - 1
        # if current slide equals clicked, don't do anything
        if (current != clicked)
          animate('pagination', paginationEffect, clicked)
        return false
      )
      if (option.play)
        # set interval
        playInterval = setInterval(->
          animate('next', effect)
        , option.play)
        # store interval id
        elem.data('interval', playInterval)

  ### default options ###
  $.fn.slides.option =
    preload           : false  # boolean, 画像ベースのスライドショーにプリロード画像にtrueを設定
    preloadImage      : '/img/loading.gif' # string, Name and location of loading image for preloader. Default is "/img/loading.gif"
    container         : 'sw_slides_container' # string, Class name for slides container. Default is "slides_container"
    generateNextPrev  : false  # boolean, Auto generate next/prev buttons
    next              : 'next' # string, Class name for next button
    prev              : 'prev' # string, Class name for previous button
    pagination        : true   # boolean, If you're not using pagination you can set to false, but don't have to
    generatePagination: true   # boolean, Auto generate pagination
    prependPagination : false  # boolean, prepend pagination
    paginationClass   : 'sw_pagination' # string, Class name for pagination
    currentClass      : 'sw_current' # string, Class name for current class
    fadeSpeed         : 700    # number, Set the speed of the fading animation in milliseconds
    fadeEasing        : ''     # string, must load jQuery's easing plugin before http://gsgd.co.uk/sandbox/jquery/easing/
    slideSpeed        : 350    # number, Set the speed of the sliding animation in milliseconds
    slideEasing       : ''     # string, must load jQuery's easing plugin before http://gsgd.co.uk/sandbox/jquery/easing/
    start             : 1      # number, Set the speed of the sliding animation in milliseconds
    effect            : 'slide'# string, '[next/prev], [pagination]', e.g. 'slide, fade' or simply 'fade' for both
    crossfade         : false  # boolean, Crossfade images in a image based slideshow
    randomize         : false  # boolean, Set to true to randomize slides
    play              : 0 # number, Autoplay slideshow, a positive number will set to true and be the time between slide animation in milliseconds
    pause             : 0 # number, Pause slideshow on click of next/prev or pagination. A positive number will set to true and be the time of pause in milliseconds
    hoverPause        : false  # boolean, Set to true and hovering over slideshow will pause it
    autoHeight        : false  # boolean, Set to true to auto adjust height
    autoHeightSpeed   : 350    # number, Set auto height animation time in milliseconds
    bigTarget         : false  # boolean, Set to true and the whole slide will link to next slide on click
    animationStart    : ->     # Function called at the start of animation
    animationComplete : ->     # Function called at the completion of animation
    slidesLoaded      : ->  #swAct("#pSC")   # Function is called when slides is fully loaded


      # Randomize slide order on load
  $.fn.randomize = (callback) ->
    randomizeOrder = () ->
      return(Math.round(Math.random()) - 0.5)
    return $(this).each ->
      $this = $(this)
      $children = $this.children()
      childCount = $children.length
      if (childCount > 1)
        $children.hide()
        indices = []
        for val ,i in $children
          indices[indices.length] = i
        indices = indices.sort(randomizeOrder)
        $.each(indices, (j, k) ->
          $child = $children.eq(k)
          $clone = $child.clone(true)
          $clone.show().appendTo($this)
          if (callback isnt undefined) then callback($child, $clone)
          $child.remove()
        )


) jQuery, @, @document
