(function(){var e=function(e,t){return function(){return e.apply(t,arguments)}},t={}.hasOwnProperty,n=function(e,n){function i(){this.constructor=e}for(var r in n)t.call(n,r)&&(e[r]=n[r]);return i.prototype=n.prototype,e.prototype=new i,e.__super__=n.prototype,e};ph.CellRowsView=function(t){function r(){return this.render=e(this.render,this),r.__super__.constructor.apply(this,arguments)}return n(r,t),r.prototype.initialize=function(){var e;return e=this.options,this.rows=e.rows,this.sfx=e.sfx,this.grid=e.grid,this.setElement($("#grid")),this.grid.on("change:locked",this.toggleLock,this)},r.prototype.render=function(){var e=this;return _.each(this.rows,function(t){var n;return n=new ph.CellRowView({collection:t,sfx:e.sfx,grid:e.grid}),e.$el.append(n.render().el)}),this},r.prototype.toggleLock=function(e,t){return t?this.$el.addClass("locked"):this.$el.removeClass("locked")},r}(Backbone.View)}).call(this);