CodeMirror.defineMode("logs", function() {

	var TOKEN_NAMES = {
		'SEVERE' : 'severe',
		'WARNING' : 'warning',
		'CONFIG' : 'config',
		'INFO' : 'info'
	};

	return {
		token : function(stream) {

			var next = stream.next();
			var tokenName = null;
			
			// look for any of the specified tokens
			for (var i in TOKEN_NAMES) {
				var ch = i.charAt(0);
				// search for the first letter
				if (next === ch) {
					// try to match the rest of the word
					var match = stream.match(new RegExp(i.substring(1)));
					match && (tokenName = TOKEN_NAMES[i] || null);
					break;
				}
			}

			return tokenName;
		}
	};
});

CodeMirror.defineMIME("text/plain", "logs");
