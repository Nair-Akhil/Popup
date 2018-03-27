#ifdef GL_ES
precision mediump float;
precision mediump int;
#endif

        
        //These uniforms need to be set up in your management code
		
		uniform sampler2D texture;
		
		varying vec4 vertColor;
		varying vec4 vertTexCoord;
		
        //uniform vec2 resolution;
        //uniform vec2 mouse;
        uniform float s;
        
        float rand(vec2 co,vec2 seed){
            return fract(sin(dot(co.xy ,seed)) * 43758.5453);
        }
        
        
        // This is the main loop
        void main(void)
        {
			
			vec2 seed = vec2(s,s);
			
			vec2 p = gl_FragCoord.xy+rand(gl_FragCoord.xy,seed);
			p.x += rand(vec2(gl_FragCoord.y,0.0),seed)*5.0;
        
			
			vec4 c = texture2D(texture, vertTexCoord.st+p)*vertColor;
			
       
        
            gl_FragColor = c;
        }