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


			float grain = abs(sin(rand(vec2(vertTexCoord.x,vertTexCoord.y),seed)));
			grain = clamp(grain,0.7,1.0);

			vec2 p2 = vertTexCoord.st;
			p2.x = sin(rand(vec2(vertTexCoord.y,0.1),seed))*0.002+0.002;
			p2.y = 0.002;


			vec2 p3 = vertTexCoord.st;
			p3.x = sin(rand(vec2(vertTexCoord.y,0.2),seed))*0.002-0.002;
			p3.y = -0.002;

			
			float x1 = abs(sin(rand(vec2(s,0.0),seed)));
			float x2 = abs(sin(rand(vec2(s+1.0,0.0),seed)));
			
			
			vec4 c;
			
			
			if(sin(rand(vec2(s+100.0,0.0),seed))>0.8){
				if((vertTexCoord.y>x1)&&(vertTexCoord.y<x2)){
				
					p.x+=0.1*sign(sin(s));
					p2.x+=0.11*sign(sin(s));
					p3.x+=0.12*sign(sin(s));

				
				}
			}

			
			
			
			
			
			//c = texture2D(texture, vertTexCoord.st+p)*vertColor;
			
			c = vec4(texture2D(texture, vertTexCoord.st+p2).x,texture2D(texture, vertTexCoord.st+p).y,texture2D(texture, vertTexCoord.st+p3).z,1.0)*vertColor*grain;
			
			//vec4 c = texture2D(texture, vertTexCoord.st)*vertColor;
	   
        
            gl_FragColor = c;
        }