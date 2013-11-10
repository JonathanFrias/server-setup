/**
 * Based on RaphaelJs demo.
 * 
 * @see {@link http://raphaeljs.com/spin-spin-spin.html}
 * 
 * @author Eliran Malka
 * @version 1.0
 * @since 8.0.4
 */
(function(){
	
	Spinner = function(count, colour, R1, R2, Rpad, strokeWidth) {

		this.sectorsCount = count;
		this.color = colour;
		this.pad = Rpad;
		this.width = strokeWidth;
		this.r1 = R1;
		this.r2 = R2;
		this.cx = this.r2 + this.width + this.pad;
		this.cy = cx;
		this.diameter = this.cx * 2;
		this.r = Raphael(0, 0, this.diameter, this.diameter);
		this.sectors = [];
		this.opacities = [];
		this.beta = 2 * Math.PI / this.sectorsCount;
		this.pathParams = {
				stroke: this.color,
				'stroke-width': this.width,
				'stroke-linecap': 'round'
		};

/*		this.shape = this.r.image(ICON_URL_EMPTY, 0, 0, 20, 20)
		.translate(this.cx - 10,this.cy - 10);
*/				

		// FIXME: alter fill color to use fill.
		// fill is implemented as a stroke as to avoid being affected by node hover behavior
		this.fill = this.r.circle(0,0,this.cx / 2)
			.attr({ stroke : '#fff', 'stroke-width' : this.cx, 'stroke-opacity' : .9 })
			.translate(this.cx,this.cy);
		this.shape = this.r.circle(0,0,this.cx)
			.attr({ stroke : '#dfdfdf', 'stroke-width' : 1.3 })
			.translate(this.cx,this.cy);

		this.shapes = this.r.set().push(this.fill, this.shape);

		Raphael.getColor.reset();
		for (var i = 0; i < this.sectorsCount; i++) {
			var alpha = this.beta * i - Math.PI / 2,
				cos = Math.cos(alpha),
				sin = Math.sin(alpha);
			this.opacities[i] = 1 / this.sectorsCount * i;
			this.sectors[i] = this.r.path([
			                     ['M', this.cx + this.r1 * cos, this.cy + this.r1 * sin],
			                     ['L', this.cx + this.r2 * cos, this.cy + this.r2 * sin]
			                     ]).attr(this.pathParams);
			if (this.color == 'rainbow') {
				this.sectors[i].attr('stroke', Raphael.getColor());
			}

	        this.shapes.push(this.sectors[i]);
		}

		this.intervalId = this.start();
	}

	Spinner.prototype = {

		start : function() {

			var selfRef = this;

			return setInterval(function() {
				selfRef.opacities.unshift(selfRef.opacities.pop());
				for ( var i = 0; i < selfRef.sectorsCount; i++) {
					selfRef.sectors[i].attr('opacity', selfRef.opacities[i]);
				}
				selfRef.r.safari();
			}, 1000 / selfRef.sectorsCount);
		},

		stop : function() {
			this.intervalId && clearInterval(this.intervalId);
		}
	}

})();