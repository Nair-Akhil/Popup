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
			
			vec2 p = vertTexCoord.st;
			p.x = sin(rand(vec2(vertTexCoord.y,0.0),seed))*0.002;
			p.y = 0.0;
			
			float x1 = abs(sin(rand(vec2(s,0.0),seed)));
			float x2 = abs(sin(rand(vec2(s+1.0,0.0),seed)));
			
			
			vec4 c;
			
			
			if(sin(rand(vec2(s+100.0,0.0),seed))>0.8){
			if((vertTexCoord.y>x1)&&(vertTexCoord.y<x2)){
			
				p.x+=0.1;
				
			
			
			}
			}
			
			
			
			
			//c = texture2D(texture, vertTexCoord.st+p)*vertColor;
			
			c = vec4(texture2D(texture, vertTexCoord.st+vec2(0.1,0.0)+p).x,texture2D(texture, vertTexCoord.st+vec2(0.15,0.0)+p).y,texture2D(texture, vertTexCoord.st+vec2(0.2,0.0)+p).y,texture2D(texture, vertTexCoord.st+vec2(0.1,0.0)+p).w)*vertColor;
			//vec4 c = texture2D(texture, vertTexCoord.st)*vertColor;
	   
        
            gl_FragColor = c.xyzw;
        }