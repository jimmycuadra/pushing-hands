(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};ph.StatsView=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return t(n,e),n.prototype.className="well",n.prototype.template=JST.stats,n.prototype.initialize=function(){return this.store=this.options.store,this.store.on("change",this.render,this)},n.prototype.render=function(){return this.$el.html(this.template(this.store.toJSON())),this},n}(Backbone.View)}).call(this);