/**
 * <p>
 * Extends the Dracula Graph by modifying the original object model (extending
 * original methods, adding properties etc.).
 * </p>
 * 
 * <p>
 * This implementation is version-specific (see Dracula version) and should be updated 
 * when necessary according to changes in the Dracula resources.
 * </p>
 * 
 * <dl>
 * <dt>Dracula version</dt>
 * <dd>0.0.3alpha</dd>
 * </dl>
 */

function graphPostInit(graph, renderer, container) {

    // flag for one time attachment of tool de-activation handler
    var toolDeActivationHandlerSet = false;
    var toolIsActive = false;

    /**
     * Adapt renderer for use with rectangular nodes in layout
     */
    renderer.semiMajorRadius = 90; // max X-axis radius of node's enclosing ellipse
    renderer.semiMinorRadius = 40; // max Y-axis radius of node's enclosing ellipse

    /**
     * Override layout position calculation for rectangular nodes
     */
    Graph.Renderer.Raphael.prototype.translate = function(point) {
	return [
		(point[0] - this.graph.layoutMinX) * this.factorX
			+ this.semiMajorRadius,
		(point[1] - this.graph.layoutMinY) * this.factorY
			+ this.semiMinorRadius ];
    };

    Graph.Renderer.Raphael.prototype.draw = function() {
	this.factorX = (this.width - 2 * this.semiMajorRadius)
		/ (this.graph.layoutMaxX - this.graph.layoutMinX);
	this.factorY = (this.height - 2 * this.semiMinorRadius)
		/ (this.graph.layoutMaxY - this.graph.layoutMinY);
	for (i in this.graph.nodes) {
	    this.drawNode(this.graph.nodes[i]);
	}
	for (i = 0; i < this.graph.edges.length; i++) {
	    this.drawEdge(this.graph.edges[i]);
	}
    };

    /**
     * Adapt drag behavior to collaborate with clicker
     */
    renderer.hasDragged = false;

    container.onmousemove = function(r, m) {
	return function(e) {
	    m.call(this, e);
	    if (r.isDrag) {
		r.hasDragged = true;
	    }
	};
    }(renderer, container.onmousemove);

    container.onmouseup = function(r, u) {
	return function() {
	    u.call(this);
	    r.hasDragged = false;
	};
    }(renderer, container.onmouseup);

    /**
     * Extend draw node method to support custom mouse events
     */
    Graph.Renderer.Raphael.prototype.drawNode = function(dn) {
	return function(node) {

	    dn.call(this, node);

	    var shape = node.shape;
	    var connectors = node.edges;

	    if (node.clicker) {

		var clickHandler = function(n, s, selfRef) {
		    return function(e) {
			// if (selfRef.isDrag) {
			if (selfRef.hasDragged == false) {
			    n.clicker(n, s);
			}
		    };
		}(node, shape, this);

		// shape.mouseup(clickHandler);

		// attach event handlers excluding node tools
		shape.items.forEach(function(item) {
		    (item.node.id.indexOf('node-tool-') == -1)
			    && item.node.addEventListener('mouseup',
				    clickHandler, false);
		});
	    }

	    if (node.hoverer) {
		/*
		 * shape.mouseover(function() { node.hoverer(shape, true); });
		 * shape.mouseout(function() { node.hoverer(shape, false); });
		 */
		// attach event handlers excluding node tools
		shape.items.forEach(function(item) {
		    (item.node.id.indexOf('node-tool-') == -1)
			    && item.node.addEventListener('mouseover',
				    function() {
					node.hoverer(shape, true, connectors);
				    }, false);
		});
		shape.items.forEach(function(item) {
		    (item.node.id.indexOf('node-tool-') == -1)
			    && item.node.addEventListener('mouseout',
				    function() {
					node.hoverer(shape, false, connectors);
				    }, false);
		});
	    }

	    if (node.tools) {

		toolDeActivationHandlerSet || function() {

		    // send tool de-activation events back to java
		    container.addEventListener('mousedown', function() {
			if (toolIsActive) {
			    renderer.toolDeActivationHandler();
			    toolIsActive = false;
			}
		    }, false);

		    toolDeActivationHandlerSet = true;
		}();

		node.tools.eventHandlersAttached || function() {

		    node.tools.forEach(function(tool) {

			tool.icon.node.style.cursor = 'pointer';

			if (tool.toolHoverer) {
			    tool.icon.mouseover(function() {
				tool.toolHoverer(tool, true);
			    });
			    tool.icon.mouseout(function() {
				tool.toolHoverer(tool, false);
			    });
			}

			if (tool.toolClicker) {
			    tool.icon.mouseup(function(e) {
				if (e.button == 0) {
				    tool.toolClicker(tool);
				    toolIsActive = true;
				}
			    });
			}
		    });

		    node.tools.eventHandlersAttached = true;
		}();
	    }
	}
    }(renderer.drawNode);
}


/**
 *  Matrix layouter for the graph's nodes, based on the ordered layouter.
 *  
 *  @param graph The graph instance to be layed out.
 *  @param colNames Layout column names for the matrix object referencing.
 *  
 *  @author Eliran Malka
 *  @since 0.0.3 alpha (May 5'th, 2011).
 */
Graph.Layout.Matrix = function(graph, colNames) {
    this.graph = graph;
    this.colNames = colNames;
    this.matrix = {};
    this.clearMatrix();

    this.layout();
};

Graph.Layout.Matrix.prototype = {

    clearMatrix : function() {
	for ( var i in this.colNames) {
	    this.matrix[i] = {};
	}
    },

    parseTypeIndex : function(type) {
	for ( var i in this.colNames) {
	    if (this.colNames[i].indexOf(type) != -1) {
		return i;
	    }
	}
	return false;
    },

    layout : function() {
	this.layoutPrepare();
	this.layoutCalcBounds();
    },

    layoutPrepare : function() {

	this.clearMatrix();

	for ( var i in this.graph.nodes) {

	    var node = this.graph.nodes[i];
	    node.layoutPosX = 0;
	    node.layoutPosY = 0;

	    var type = node.puType;
	    if (type) {
		var index = this.parseTypeIndex(type)
		this.matrix[index][i] = node;
	    }
	}

	var counterX = 0;
	for ( var x in this.colNames) {
	    var counterY = 0;
	    for ( var y in this.matrix[x]) {
		var node = this.matrix[x][y];
		node.layoutPosX = counterX;
		node.layoutPosY = counterY;
		counterY++;
	    }
	    counterX++;
	}
    },

    layoutCalcBounds : function() {
	var minx = 0, maxx = this.colNames.length - 1, miny = Infinity, maxy = -Infinity;

	var nodes = this.graph.nodes;
	for (var i in nodes) {
	    var y = nodes[i].layoutPosY;

	    if (y > maxy) maxy = y;
	    if (y < miny) miny = y;
	}

	if (miny == maxy) maxy++;

	this.graph.layoutMinX = minx;
	this.graph.layoutMaxX = maxx;

	this.graph.layoutMinY = miny;
	this.graph.layoutMaxY = maxy;
    }

};


/**
 * Extension for Graph.Layout.Ordered. this is a pre-defined layouter that arranges the current nodes
 * in the graph with the topological_sort sorter before layout() executions.
 */
/*
Graph.Layout.OrderedTopologicalSort = function(graph) {
    Graph.Layout.Ordered.apply(this, arguments);
}
Graph.Layout.OrderedTopologicalSort.prototype = Object.create(Graph.Layout.Ordered.prototype);

Graph.Layout.OrderedTopologicalSort.prototype.layout = function() {
    this.order = topological_sort(this.graph);
    Graph.Layout.Ordered.prototype.layout.call(this);
}
*/

//
// TODO write a hub-and-spokes sorter for the ordered layouter (necessary?)
//


/**
 * Ported from dracula_graffle, overridden and modified to match the 
 * gs-graphs requirements. The original file is kept as legacy, 
 * since this is the only function in the file.
 * 
 * Original function from dracula_graffle is based on gRaphael.
 */
Raphael.fn.connection = function (obj1, obj2, style) {
    var selfRef = this;
    /* create and return new connection */
    var edge = {
        draw : function() {
            /* get bounding boxes of target and source */
        	// MOD: get contour shape (first shape in the set) instead of entire shape-set
            var bb1 = obj1[0].getBBox();
            var bb2 = obj2[0].getBBox();
            // MOD: adjust offset for connection point with target shape (distance from center)
            var off1 = 0;
            var off2 = 2;
            // MOD: adjust offset for connection point with target shape (shift from center)
            var off3 = 10;
            var off4 = 8;
            /* coordinates for potential connection coordinates from/to the objects */
            var p = [
                {x: (bb1.x + bb1.width / 2) - off3, y: bb1.y - off1},              /* NORTH 1 */
                {x: (bb1.x + bb1.width / 2) + off3, y: bb1.y + bb1.height + off1}, /* SOUTH 1 */
                {x: bb1.x - off1, y: (bb1.y + bb1.height / 2) + off4},             /* WEST  1 */
                {x: bb1.x + bb1.width + off1, y: (bb1.y + bb1.height / 2) - off4}, /* EAST  1 */
                {x: (bb2.x + bb2.width / 2) - off3, y: bb2.y - off2},              /* NORTH 2 */
                {x: (bb2.x + bb2.width / 2) + off3, y: bb2.y + bb2.height + off2}, /* SOUTH 2 */
                {x: bb2.x - off2, y: (bb2.y + bb2.height / 2) + off4},             /* WEST  2 */
                {x: bb2.x + bb2.width + off2, y: (bb2.y + bb2.height / 2) - off4}  /* EAST  2 */
            ];

            /* distances between objects and according coordinates connection */
            var d = {}, dis = [];

            /*
             * find out the best connection coordinates by trying all possible ways
             */
            /* loop the first object's connection coordinates */
            for (var i = 0; i < 4; i++) {
                /* loop the second object's connection coordinates */
                for (var j = 4; j < 8; j++) {
                    var dx = Math.abs(p[i].x - p[j].x),
                        dy = Math.abs(p[i].y - p[j].y);
                    if ((i == j - 4) || (((i != 3 && j != 6) || p[i].x < p[j].x) && ((i != 2 && j != 7) || p[i].x > p[j].x) && ((i != 0 && j != 5) || p[i].y > p[j].y) && ((i != 1 && j != 4) || p[i].y < p[j].y))) {
                        dis.push(dx + dy);
                        d[dis[dis.length - 1].toFixed(3)] = [i, j];
                    }
                }
            }
            var res = dis.length == 0 ? [0, 4] : d[Math.min.apply(Math, dis).toFixed(3)];


            // TODO: alter edge path to straight lines

            /* bezier path */
            var x1 = p[res[0]].x,
            y1 = p[res[0]].y,
            x4 = p[res[1]].x,
            y4 = p[res[1]].y,
            dx = Math.max(Math.abs(x1 - x4) / 2, 10),
            dy = Math.max(Math.abs(y1 - y4) / 2, 10),
            x2 = [x1, x1, x1 - dx, x1 + dx][res[0]].toFixed(3),
            y2 = [y1 - dy, y1 + dy, y1, y1][res[0]].toFixed(3),
            x3 = [0, 0, 0, 0, x4, x4, x4 - dx, x4 + dx][res[1]].toFixed(3),
            y3 = [0, 0, 0, 0, y1 + dy, y1 - dy, y4, y4][res[1]].toFixed(3);
            
            /* assemble path and arrow */
            var path = ["M", x1.toFixed(3), y1.toFixed(3), "C", x2, y2, x3, y3, x4.toFixed(3), y4.toFixed(3)].join(",");
//            var path = ["M", x1.toFixed(3), y1.toFixed(3), "L", x2, y2, "L", x3, y3, "L", x4.toFixed(3), y4.toFixed(3)].join(",");


            // TODO: alter arrow to narrow angle

            /* arrow */
            if(style && style.directed) {
                /* magnitude, length of the last path vector */
                var mag = Math.sqrt((y4 - y3) * (y4 - y3) + (x4 - x3) * (x4 - x3));
                /* vector normalization to specified length  */
                var norm = function(x,l){return (-x*(l||5)/mag);};
                /* calculate array coordinates (two lines orthogonal to the path vector) */
                var arr = [
                    {x:(norm(x4-x3)+norm(y4-y3)+x4).toFixed(3), y:(norm(y4-y3)+norm(x4-x3)+y4).toFixed(3)},
                    {x:(norm(x4-x3)-norm(y4-y3)+x4).toFixed(3), y:(norm(y4-y3)-norm(x4-x3)+y4).toFixed(3)}
                ];
                path = path + ",M"+arr[0].x+","+arr[0].y+",L"+x4+","+y4+",L"+arr[1].x+","+arr[1].y; 
				//	 MOD: arrow closure for triangular shape.
                path = path + ",Z" + arr[0].x + "," + arr[0].y;
            }
			
            /* function to be used for moving existent path(s), e.g. animate() or attr() */
            var move = "attr";
            /* applying path(s) */
            edge.fg && edge.fg[move]({path:path}) 
                || (edge.fg = selfRef.path(path).attr({stroke: style && style.stroke || "#000", fill: "none", opacity : .6, 'fill-opacity' : .6  }).toBack());
            edge.bg && edge.bg[move]({path:path})
                || style && style.fill && (edge.bg = style.fill.split && selfRef.path(path).attr({stroke: style.fill.split("|")[0], fill: "none", "stroke-width": style.fill.split("|")[1] || 3, opacity : .6, 'fill-opacity' : .6 }).toBack());
			/* setting label */
    		style && style.label
			//	 MOD: text label replaced with image, label position adapted.
	            && (edge.label && edge.label.attr({x:((x1+x4)/2) - 10, y:((y1+y4)/2) - 10}) 
                || (edge.label = selfRef.image(style.label,((x1+x4)/2)-10, ((y1+y4)/2)-10,20,20)));

            style && style.label && style["label-style"] && edge.label && edge.label.attr(style["label-style"]);
            style && style.callback && style.callback(edge);
        }
		
    }
    edge.draw();
    return edge;
};



/**
 * Some utilities
 */

function arrayFindByName(array, name) {
    array.forEach(function(o) {
	if (o.name && o.name == name) {
	    return o;
	}
    });
    return false;
}


