// Generated by CoffeeScript 1.6.2
/*
coffee -wcb *.coffee
*/

/* beta version -------------------------------------------------------
*/

/*
callbacks = $.Callbacks()
callbacks.add( fn1 )
*/

var swAct;

swAct = function(oya) {
  var TheGet, makeDom;

  TheGet = {
    defs: function(url) {
      var dfr;

      dfr = $.Deferred();
      $.ajax({
        url: url,
        cache: false,
        success: dfr.resolve
      });
      return dfr.promise();
    }
  };
  TheGet.defs("./register.php").then(function(data) {
    return makeDom(data);
  });
  return makeDom = function(data) {
    var divList, getObj, i, inLen, j, res, setList, that, val, _i, _len;

    setList = $();
    res = [];
    that = $(oya + " .sw_slides_control");
    getObj = $(data).find("ul.todoList li");
    setList.push(getObj.text(function(k, tx) {}));
    inLen = getObj.length;
    $("#smpSlideDiv2").append("<div><br>スライド数：" + inLen + "</div>");
    divList = setList.get(0);
    for (i = _i = 0, _len = divList.length; _i < _len; i = ++_i) {
      val = divList[i];
      that.append("<div class=\"sw_slides_containerCld innerSMP carousel-item\">\n\n<div class=\"phSMP\"><img src=\"img/photo_s" + (i + 1) + ".png\" alt=\"photo(test)\"></div>\n<div class=\"txtSMP\">" + val.innerHTML + "</div>\n</div>");
      j = i + 1;
      $("#res").append(j + '：' + val.innerHTML + '<br>');
    }
    $('#sw_slides').slides({
      preload: true,
      preloadImage: 'img/loading.gif',
      play: 2500,
      pause: 1500,
      hoverPause: true
    });
    $("#res").swLink();
  };
};

$.fn.extend({
  swLink: function() {
    var $_that, bkfire, fire, i, nodes, supports3DTransforms, val, _i, _len;

    $_that = $("#res a,#res2 a");
    supports3DTransforms = document.body.style['webkitPerspective'] !== void 0 || document.body.style['MozPerspective'] !== void 0;
    if (supports3DTransforms) {
      nodes = $($_that);
      for (i = _i = 0, _len = nodes.length; _i < _len; i = ++_i) {
        val = nodes[i];
        $(nodes[i]).addClass("roll").wrapInner("<span data-title='" + $(val).text() + "'/>");
        /*if( !node.className or !node.className.match( /roll/g ) )
          node.className += ' roll'
        */

      }
      return;
    }
    fire = function(ev) {
      return $($_that).addClass("hover");
    };
    bkfire = function(ev) {
      return $($_that).removeClass("hover");
    };
    return $($_that).on('touchstart', fire).off('touchend', bkfire);
  }
});

$(function() {
  return swAct("#pSC");
});
