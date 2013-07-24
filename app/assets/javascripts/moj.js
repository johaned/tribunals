(function(){
  var moj = {

    Modules: {},

    Utilities: {},

    Events: $({}),

    init: function(){
      var x;

      for( x in moj.Modules ) {
        moj.Modules[x].init();
      }
    }

  };

  window.moj = moj;
})();
