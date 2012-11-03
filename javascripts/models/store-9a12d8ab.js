(function(){var e={}.hasOwnProperty,t=function(t,n){function i(){this.constructor=t}for(var r in n)e.call(n,r)&&(t[r]=n[r]);return i.prototype=n.prototype,t.prototype=new i,t.__super__=n.prototype,t};ph.Store=function(e){function n(){return n.__super__.constructor.apply(this,arguments)}return t(n,e),n.prototype.defaults={highScore:0,gamesPlayed:0,autoPlayMusic:!0,playSoundEffects:!0},n.prototype.initialize=function(){return this.on("change",this.persist,this)},n.prototype.persist=function(e){return amplify.store("pushing-hands",this.toJSON())},n.prototype.toggleAutoPlay=function(){return this.set({autoPlayMusic:!this.get("autoPlayMusic")})},n.prototype.toggleSoundEffects=function(){return this.set({playSoundEffects:!this.get("playSoundEffects")})},n.prototype.resetStats=function(){if(confirm("Are you sure you want to permanently reset your stats?"))return this.set({highScore:0,gamesPlayed:0})},n}(Backbone.Model)}).call(this);