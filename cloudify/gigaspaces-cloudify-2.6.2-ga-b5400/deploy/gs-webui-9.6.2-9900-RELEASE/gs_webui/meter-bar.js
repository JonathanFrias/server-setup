/**
 * @author Eliran Malka
 * @since 8.0.4
 */

(function(){
	
	MeterBar = function(container, width, height, cornerRadius, tickInterval, fgColor) {
		
		this.w = width;
		this.h = height;
		this.rad = cornerRadius;
		this.interval = tickInterval;
		this.fg = fgColor;

		this.r = Raphael(container, this.w, this.h);
		this.ticks = this.r.set();
		this.val = 0;
		
		var rect = this.r.rect(0, 0, this.w, this.h, this.rad).attr({
				fill : '90-#eeeeee:0-#bbbbbb:100'
			,	stroke : 'none'
			,	opacity : .8
			});
		
		var currInterval = this.interval;
		while (currInterval < 100) {
			var tickPos = this.w / 100 * currInterval;
			var tick = this.r.path('M0,0L0,' + this.h).translate(tickPos ,0);
			this.ticks.push(tick);
			currInterval += this.interval;
		}
		this.ticks.attr({
			'stroke' : '#b6b6b6'
		,	'stroke-width' : this.w / 110
		,	'stroke-opacity' : .8
		});
		
		this.overlay = rect.clone().attr({
				fill : this.fg
			,	'clip-rect' : '0 0 0 ' + this.h
			,	opacity : .3
			});
		this.overlay.node.style.opacity = 0.3;
		
		return this;
	}
	
	MeterBar.prototype = {
		
		animate : function(val) {
			this.val = val;
			var clip = (this.w * this.val).toFixed(3);
/*			this.overlay.attr({
				'clip-rect' : '0 0 ' + clip + ' ' + this.h
			});
*/			
			this.overlay.animate(
					{ 'clip-rect' : '0 0 ' + clip + ' ' + this.h }, 200
			);
		}

	}
	
})();
