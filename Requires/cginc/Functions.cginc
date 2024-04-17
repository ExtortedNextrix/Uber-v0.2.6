            float random(float2 uv, float seed) {
				return fract(sin(dot(uv, float2(12.9898, 78.233)) + seed) * 43758.5453);
			} 

			float2 SplitRot(float2 uv, float rotation, float2 mid)
			{
				return float2(
				cos(rotation) * (uv.x - mid.x) + sin(rotation) * (uv.y - mid.y) + mid.x,
				cos(rotation) * (uv.y - mid.y) - sin(rotation) * (uv.x - mid.x) + mid.y
				);
			}
			
			// every fucking hash ON EARTH
            float hash11(float p)
			{
				p = frac(p * hashScale.x);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
			float hash11s(float p)
			{
				p = frac(p * hashScaleSmall.x);
				p *= p + 33.33;
				p *= p + p;
				return frac(p);
			}
			float hash12(float2 p)
			{
				float3 p3  = frac(float3(p.xyx) * hashScale.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float hash12s(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * hashScaleSmall.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float hash13(float3 p3)
			{
				p3  = frac(p3 * hashScale.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float hash13s(float3 p3)
			{
				p3 = frac(p3 * hashScaleSmall.x);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.x + p3.y) * p3.z);
			}
			float2 hash21(float p)
			{
				float3 p3 = frac(p * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);

			}
			float2 hash21s(float p)
			{
				float3 p3 = frac(p * hashScaleSmall.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);

			}
			float2 hash22(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * hashScale.xyz);
				p3 += dot(p3, p3.yzx+19.19);
				return frac((p3.xx+p3.yz)*p3.zy);
			}
			float2 hash22s(float2 p)
			{
				float3 p3 = frac(float3(p.xyx) * hashScaleSmall.xyz);
				p3 += dot(p3, p3.yzx + 19.19);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			float2 hash23(float3 p3)
			{
				p3 = frac(p3 * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xx + p3.yz) * p3.zy);
			}
			float3 hash31(float p)
			{
				float3 p3 = frac(p * hashScale.xyz);
				p3 += dot(p3, p3.yzx + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			float3 hash32(float2 p)
			{
				float3 p3 = frac(p.xyx * hashScale.xyz);
				p3 += dot(p3, p3.yxz + 33.33);
				return frac((p3.xxy + p3.yzz) * p3.zyx);
			}
			float3 hash33(float3 p3)
			{
				p3 = frac(p3 * hashScale.xyz);
				p3 += dot(p3, p3.yxz+19.19);
				return frac((p3.xxy + p3.yxx)*p3.zyx);
			}
			float4 hash41(float p)
			{
				float4 p4 = frac(p * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash42(float2 p)
			{
				float4 p4 = frac(p.xyxy * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash43(float3 p)
			{
				float4 p4 = frac(float4(p.xyzx)  * hashScale);
				p4 += dot(p4, p4.wzxy+19.19);
				return frac((p4.xxyz+p4.yzzw)*p4.zywx);
			}
			float4 hash44(float4 p4)
			{
				p4 = frac(p4 * hashScale);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
			float4 hash44s(float4 p4)
			{
				p4 = frac(p4 * hashScaleSmall);
				p4 += dot(p4, p4.wzxy + 33.33);
				return frac((p4.xxyz + p4.yzzw) * p4.zywx);
			}
            
            // unused shit lev put for some fuckin reason
            float3 sqr(float3 x)
			{
				return x * x;
			}

            uint lcg_rand(inout uint4 seed)
			{
				seed = seed * 1664525 + 1013904223UL;
				return seed;
			}

            uint rand_xorshift(inout uint rng_state)
			{
				// Xorshift algorithm from George Marsaglia's paper
				rng_state ^= (rng_state << 13);
				rng_state ^= (rng_state >> 17);
				rng_state ^= (rng_state << 5);
				return rng_state;
			}

			uint rng_xor128(inout uint4 state)
			{
				uint t = state.x ^ (state.x << 11);
				state.xyz = state.yzw;
				state.w = (state.w ^ (state.w >> 19)) ^ (t ^ (t >> 8));
				return state.w;
			}

            float mask1(float2 uv)
			{
				if(Mask_Texture)
				{
					float maskColor;
					if(Mask_Noise)
						maskColor = hash13(float3(uv, _Time.x));
					else
					{
						maskColor = tex2D(_MaskTex, TRANSFORM_TEX(uv, _MaskTex) + _Time.y*_MaskScroll.xy);
						if(Mask_Multisampling > 0)
							for(float a = 0.5; a >= 0.125; a /= 2)
							{
								float2 maskUV = TRANSFORM_TEX(uv, _MaskTex) + _Time.y*_MaskScroll.xy;
								maskColor = lerp(maskColor, tex2D(_MaskTex, maskUV / a), a);
							}
					}
					return lerp(maskColor, _MaskColor, _MaskAlpha);
				}
				else
					return 1.0;
			}

            float4 mask4(float2 uv)
			{
				if(Mask_Texture)
				{
					float4 maskColor;
					if(Mask_Noise)
						maskColor = hash43(float3(uv, _Time.y));
					else
					{
						maskColor = tex2D(_MaskTex, TRANSFORM_TEX(uv, _MaskTex) + _Time.y*_MaskScroll.xy);
						if(Mask_Multisampling)
							for(float a = 0.5; a >= 0.125; a /= 2)
							{
								float2 maskUV = TRANSFORM_TEX(uv, _MaskTex) + _Time.y*_MaskScroll.xy;
								maskColor = lerp(maskColor, tex2D(_MaskTex, maskUV / a), a);
							}
					}
					return lerp(maskColor, float4(_MaskColor, 1.0), _MaskAlpha);
				}
				else
					return 1.0;
			}

            inline float CheckGrabTextureBorder(float2 uv)
			{
			#ifdef UNITY_SINGLE_PASS_STEREO
				float4 scaleOffset = unity_StereoScaleOffset[unity_StereoEyeIndex];
				return step(scaleOffset.z, uv.x)*step(0, uv.y)*step(-scaleOffset.z - scaleOffset.x, -uv.x)*step(-1, -uv.y);
			#else
				return step(0, uv.x)*step(0, uv.y)*step(-1, -uv.x)*step(-1, -uv.y);
			#endif
			}

			//return color from red to blue
			float3 rainbowOld(float t)
			{
				float3 dist = 1.0 - 2.0*abs(t - float3(0.0, 0.5, 1.0));
				return max(0, dist*float3(4.0, 2.0, 4.0));
			}

			//https://www.shadertoy.com/view/ls2Bz1
			float3 rainbowJET(float x)
			{
				return float3(4.0*x - 2.0,
    						  4.0*x + min(0.0, 4.0 - 8.0*x),
							  1.0 + 4.0*(0.25-x));
			}

            // SO GAY OMG SLAYY QUEEN!!
            float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}

			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

            // useful shit

            // ACES Filmic Tone Mapping Curve
			//
			// Adapted from code by Krzysztof Narkowicz
			// https://knarkowicz.wordpress.com/2016/01/06/
			// aces-filmic-tone-mapping-curve/

			float3 ACESFilm( float3 color )
			{
				float a = 2.51f;
				float b = 0.03f;
				float c = 2.43f;
				float d = 0.59f;
				float e = 0.14f;
				return saturate((color*(a*color+b))/(color*(c*color+d)+e));
			}

            // --- Spectral Zucconi --------------------------------------------
			// By Alan Zucconi
			// Based on GPU Gems: https://developer.nvidia.com/sites/all/modules/custom/gpugems/books/GPUGems/gpugems_ch08.html
			// But with values optimised to match as close as possible the visible spectrum
			// Fits this: https://commons.wikimedia.org/wiki/File:Linear_visible_spectrum.svg
			// With weighter MSE (RGB weights: 0.3, 0.59, 0.11)
			float3 bump3y (float3 x, float3 yoffset)
			{
				float3 y = float3(1.,1.,1.) - x * x;
				y = saturate(y-yoffset);
				return y;
			}
			float3 rainbow (float x)  //spectral_zucconi
			{
				const float3 cs = float3(3.54541723, 2.86670055, 2.29421995);
				const float3 xs = float3(0.69548916, 0.49416934, 0.28269708);
				const float3 ys = float3(0.02320775, 0.15936245, 0.53520021);

				return bump3y (cs * (x - xs), ys) * float3(2.5, 2.5, 5);
			}
			// --- Spectral Zucconi 6 --------------------------------------------

			// Based on GPU Gems
			// Optimised by Alan Zucconi
			float3 rainbow2 (float x)  //spectral_zucconi6   (kinda useful)
			{
				const float3 c1 = float3(3.54585104, 2.93225262, 2.41593945);
				const float3 x1 = float3(0.69549072, 0.49228336, 0.27699880);
				const float3 y1 = float3(0.02312639, 0.15225084, 0.52607955);

				const float3 c2 = float3(3.90307140, 3.21182957, 3.96587128);
				const float3 x2 = float3(0.11748627, 0.86755042, 0.66077860);
				const float3 y2 = float3(0.84897130, 0.88445281, 0.73949448);

				float3 result = bump3y(c1 * (x - x1), y1) +
								bump3y(c2 * (x - x2), y2) ;
				return result * float3(2.6, 2.7, 4.6);
			}

            float2 DistorsionSample(float2 uv)
			{
				float2 distorsion = 0;
				if(Texture_Distorsion)
				{
					float2 disUV = uv;
					disUV.x *= _ScreenParams.x / _ScreenParams.y;
					disUV = TRANSFORM_TEX(disUV, _DistorsionTex) + _Time.x * _DistorsionScroll.xy;
					distorsion = UnpackNormal(tex2D(_DistorsionTex, disUV)) * float2(_DIntensity_X, _DIntensity_Y);
					distorsion.x *= _ScreenParams.y/_ScreenParams.x;
				}
				if(Wave_Distorsion)
				{
					float4 sc;
					sincos(_DistorsionWaveDensity.xy*(uv.xy - 0.5) + _Time.yy*_DistorsionWaveSpeed.xy, sc.yw, sc.xz);
					distorsion += _DistorsionWave.xy*(sc.xy + sc.zw);
					//distorsion += _DistorsionWave.xy*cos(length(_DistorsionWaveDensity.xy*(uv - 0.5)) + _Time.y*_DistorsionWaveSpeed.xy);
				}
				return distorsion;
			}
			float3 TriPlanarSample(in float3 position, in float3 normal)
			{
				normal *= normal;
				float3 distorsion = normal.x * UnpackNormal(tex2D(_DistorsionTex, TRANSFORM_TEX(position.zy, _DistorsionTex) + _Time.x * _DistorsionScroll.xy)) +
					normal.y * UnpackNormal(tex2D(_DistorsionTex, TRANSFORM_TEX(position.xz, _DistorsionTex) + _Time.x * _DistorsionScroll.xy)) +
					normal.z * UnpackNormal(tex2D(_DistorsionTex, TRANSFORM_TEX(position.xy, _DistorsionTex) + _Time.x * _DistorsionScroll.xy));
				return distorsion;
			}
			float3 DistorsionSampleDir(in float3 direction)
			{
				float3 distorsion = 0;
				if (Texture_Distorsion)
				{
					float3 position = direction;
					//disUV.x *= _ScreenParams.x / _ScreenParams.y;
					//position = TRANSFORM_TEX(position.xy, _DistorsionTex) + _Time.x * _DistorsionScroll.xy;
					distorsion = TriPlanarSample(position, direction) * float3(_DIntensity_X, _DIntensity_Y, _DIntensity_X);
					
				}
				if (Wave_Distorsion)
				{
					float3 s, c;
					sincos(_DistorsionWaveDensity.xyz * direction.xyz + _Time.yyy * _DistorsionWaveSpeed.xyz, s, c);
					distorsion += _DistorsionWave.xyz * (s + c);
					//distorsion += _DistorsionWave.xy*cos(length(_DistorsionWaveDensity.xy*(uv - 0.5)) + _Time.y*_DistorsionWaveSpeed.xy);
				}
				return distorsion;
			}

			float2 BlurDistorsion(float2 uv) 
			{
				return Blur_Distorsion ? DistorsionSample(uv) : 0;
			}

			//Cheap Cubemap
			//https://www.shadertoy.com/view/ltl3D8
			//returns 2D UV 
			float2 cubeUV(in float3 d)
			{
				// intersect cube
				float3 n = abs(d);
				float3 v = (n.x > n.y && n.x > n.z) ? d.xyz :
					(n.y > n.x && n.y > n.z) ? d.yzx :
					d.zxy;
				// project into face
				float2 q = v.yz / v.x;
				// undistort in the edges
				q *= 1.25 - 0.25 * q * q;

				return 0.5 + 0.5 * q;
			}


			// nextrix stuff

			float2x2 r2d(float a) {
				float ca = cos(radians(a));
				float sa = sin(radians(a));
				return float2x2(ca, -sa, sa, ca);
			}

			float2 translate(float2 uv, float2 t) {
				return uv - t;
			}


			float random2(float2 uv) {
				return fract(
					BARS_RAND_SEED
					* (sin(dot(uv, float2(21.12, 17.23)))
						+ cos(dot(uv, float2(12.2241, 22.433)))
					)
				);
			}


			float smoothRand(float x, float2 blur) {
				float i = floor(x);
				return mix(random2(float(i)), random2(float(i+1.)), smoothstep(blur[0], blur[1], fract(x)));
			}


			float valueNoise(float2 uv) {
				float2 i = floor(uv);
				float2 f = fract(uv);
				float a = random2(i);
				float b = random2(i + float2(1., 0));
				float c = random2(i + float2(0., 1.));
				float d = random2(i + float2(1., 1.));
				float2 u = smoothstep(0., 1., f);
				// Bilinear
				float ab = mix(a, b, u.x);
				float cd = mix(c, d, u.x);
				return mix(ab, cd, u.y);
			}


			float2 DSCircle(float2 uv, int type) {
				float CScale, COff, CSpeed, CPower;
				if (type == 0) { // bars
					CScale = _distortScale;
					COff = _distortDeformation;
					CSpeed = _distortSpeed;
					CPower = _distortPower;
				} else {
					CScale = _DSCircleAmnt;
					COff = _DSCircleOffset;
					CSpeed = _DSCircleSpeed;
					CPower = _DSCirclePower;
				}
			
				float distance = length(uv.xy - 0.5);
                float angle = atan2(uv.y,uv.x);
				float color = sin(angle + distance * CScale * 15.)*cos(angle + distance * COff * 25. - COff * 10. + iTime * CSpeed) * CPower;
				
				return color;
			}

			float2 DSNorm(float2 uv, int type) {
				float globalScale, deformation, velocity, amplitude;
				switch (type) { 
					case 0: // bars
						globalScale = _distortScale;
						deformation = _distortDeformation;
						amplitude = _distortSpeed;
						break;
				    case 1: // norm
						globalScale = _DSUVScale;
						deformation = _DSUVDeformation;
						amplitude = _DSUVAmp; 
						break;
					case 2: // tbguv
						globalScale = _TDSUVScale;
						deformation = _TDSUVDeformation;
						amplitude = _TDSUVAmp;
						break;
					case 3: // outline
						globalScale = _ODistIter;
						deformation = _ODistDef;
						amplitude = _ODistAmp;
						break;
				}
				uv = translate(uv, float2(0.5, 0.5));
				uv.x *= _ScreenParams.x/_ScreenParams.y;

				float2 scaleLayer = uv*globalScale;
				
				float noiseScale = 1.;
				float2 noiseLayer = translate(scaleLayer*noiseScale, float(iTime*amplitude));
				float vNoise = (2. * valueNoise(noiseLayer)) - 1.;

				float3 raintex = float(vNoise * deformation);

				uv.x /= _ScreenParams.x/_ScreenParams.y;
				uv = translate(uv, float2(-0.5,-0.5));
				return uv.xy - raintex.xy;
			}

			float2 DSCos(float2 uv) {
				float halfDistort = _distortScale / 0.5;
				float distortsc2 = _distortScale / _distortScale + halfDistort;
				
				for(float i = 1.0; i < _distortPower; i++){
					uv.x += _distortDeformation / i * cos(i * _distortScale * uv.y - iTime * _distortSpeed);
					uv.y += _distortDeformation / i * cos(i * distortsc2 * uv.x + iTime * _distortSpeed);
				}
				return uv;
			}

			float4 hueWave (float2 uv) {
				
				float4 col = float4(0.5 + 0.5*sin(iTime*_hueOutlineSpeed+_hueOutlineOffset+uv.yxy + float3(0,2,4)), 1.);
				return col * _hueOutlinePower;
			}

			float4 hueCircle (float2 uv) {
				float4 col = float4(1,1,1,1);
				col = .6 + .6 * cos(iTime* _hueOutlineSpeed+ _hueOutlineOffset *  length(uv+uv-col.xz)/col.y  + float4(0,23,21,1.));
				return col.rgba * _hueOutlinePower;
			}

			float map(float value, float low1, float high1, float low2, float high2) {
				return low2 + (value - low1) * (high2 - low2) / (high1 - low1);
			}

			float4 ScreenParticles ( float4 col, float2 uv) {

				float iTimeR = _Time.y;
            	float iTimeW = _Time.y * _PartSpeed + _PartTOFF;

				float2 vigUV = uv;

                uv = mul(r2d(_PartRot + _PartInfRot * iTimeR * _PartInfRot), uv);
                
                float2 st = float2 (atan2(uv.y, uv.x), length(uv) - _PartVig) ;
                uv = float2(st.x / 6.2831+.5 - sin(-iTimeW + st.y), st.y);

                col = float(1);

                st.x=fract(_PartWavePower*sin(_PartIter*(ceil(st.x*_PartAmount)/128.)));

                float t = iTimeW*2.*((st.x+.5)/2.);
                float b = pow(1.-fract(st.y+st.x+t),_PartLength);

                b=(b*.5)+step(1.-b,.05);
                col.rgb = (st.y * b);
                col.rgb = lerp(col.rgb, ((col.rgb * _PartColor.rgb) * 1.25), st.y * b * _PartLinePow);
                float vig = smoothstep(length(vigUV), 0, _PartVig);
                float bgvig = smoothstep(length(vigUV), 0, _PartBGVignette);

                return float4(min(clamp(col.rgb * col.rgb, 0, 1) * vig, 1.25), _PartBGAlpha) * bgvig * 1;

			}

			float2 ZoomLoop (float2 uv) {  // borrowed from temmie :)
                    _Screens2 = 8.;
					if(_FLOORSCREENLOOP) { // int
                        _Screens = floor(_Screens);
                    } else {  // float
                        _Screens = _Screens;
                    }

                    if (_Screens > 0.001) {
                        fixed4 repeatcol = 0;
                        float2 multiuv = uv;
                        float bo = 1.0, yo = 1.0 / _Screens;
                        float2 fiter =  0;
                        float2 uv_inverted = 0;
                        float2 riter = 0;
                        UNITY_LOOP for (int bw = 0.0; bw < _Screens2; bw++) {
                            float jo11 = 1.0, ko11 = 1.0 / _Screens2;
                            multiuv -= 0.5;
                            multiuv.y /= ratio;
                            multiuv = mul(multiuv, r2d(jo11 * ko11 * (iTime * (_RotateScreenLoopSpeed / 10.) + _RotateScreenLoop) * float(bw)));
                            multiuv.y *= ratio;
                            multiuv += 0.5;
                        }

                        uv_inverted = 1.0 - multiuv;

                        fiter = floor(multiuv * (_Screens) * 2.0);	
                                            
                        riter = floor(uv_inverted * (_Screens) * 2.0);
                                                float2 iter = min(fiter, riter);					
                        float offset_mul = min(iter.x, iter.y) * _ScreensOffset / 10.;		
                        float2 offset = ((float2(0.5, 0.5) ) / _Screens) * offset_mul;

                        float2 uv_mul = 1.0 / ((float2(1.0, 1.0)) - offset * 2.);

                        uv = (multiuv - offset) * uv_mul;
                    
                    } else if (_Screens < -0.001) {   
                        fixed4 repeatcol = 0;    
                        float2 multiuv = uv;
                        float bo = 1.0, yo = 1.0 / 8.;

                        UNITY_LOOP for (int bw = 0.0; bw < 8.; bw++) {   //   
                            multiuv = mul(multiuv, r2d(bo * yo * _RotateScreenLoop * float(bw) * cos(_Time.y * _RotateScreenLoopSpeed)));
                            multiuv.y *= ratio;
                            multiuv += 0.5;
                        }		 
                                            
                        multiuv *= -1;
                        multiuv += 1;
                        float2 uv_inverted = 1.0 - multiuv;

                        float2 fiter = floor(multiuv * _Screens * 2.0);			
                        float2 riter = floor(uv_inverted * _Screens * 2.0);
                        float2 iter = min(fiter, riter);					
                        float offset_mul = min(iter.x, iter.y) * _ScreensOffset / 10.;		
                        
                        float2 offset = (float2(0.5, 0.5) / _Screens) * offset_mul;

                        float2 uv_mul = 1.0 / (float2(1.0, 1.0) - offset * 2.);
                        

                        uv = (multiuv - offset) * uv_mul;
                    }
                    return uv;
                }

                float2 UVDupe (float2 uv) {
                    if(_FLOORUVDUPE) {   // round to lowest integer relative to the decimal value
                        _columns = floor(_columns) + 1;
                        _rows = floor(_rows) + 1;
                    } else {  // set back to float value
                        _columns = _columns;
                        _rows = _rows;
                    }

                    uv.y = (uv.y - 0.5) * _rows + 0.5; // multiscreen y
                    uv.x = (uv.x - 0.5) * _columns + 0.5; // multiscreen x
                    return uv;
                }

				float2 FractLines(float2 uv) {

                    if(_FLOORFRACTLINES) {   // round to lowest integer relative to the decimal value
                        _XAmntFractLines = floor(_XAmntFractLines);
                    } else {  // set back to float value
                        _XAmntFractLines = _XAmntFractLines;
                    }

                    float rX = _XAmntFractLines;
                    float2 uX = float2(fract(uv.x * rX) / rX + .35 + ceil(uv.x * rX) * _FractLinesDist, uv.y); // x axis
                    return uX;
                }

				float2 MirrorFX(float2 uv) {
                    float XAXIS = step(_mirrorXAmnt, uv.x);
                    float YAXIS = step(_mirrorYAmnt, uv.y);
                    uv.x = float2(abs(uv.x - XAXIS), uv.y);
                    uv.y = float2(abs(uv.y - YAXIS), uv.x);
                    return uv.xy;
                }
				
				inline float modFix(float a, float b){
					return a-(floor((a)/(b))*(b));
				}
				inline float2 modFix2(float2 a, float2 b){
					return a-(floor((a)/(b))*(b));
				}

				float3x3 rot3D(float x, float y, float z)
				{
					float sinx, cosx;sincos(x, sinx, cosx);
					float siny, cosy;sincos(y, siny, cosy);
					float sinz, cosz;sincos(z, sinz, cosz);
					return float3x3(cosy * cosz, -cosy * sinz, siny, cosx * sinz + cosz * sinx * siny, cosx * cosz - sinx * siny * sinz, -cosy * sinx, sinx * sinz - cosx * cosz * siny, cosz * sinx + sinx * siny * sinz, cosx * cosy);
				}

				float getEdgeGradient(float2 inputUVs,  		// "borrowed" from luka
					float inputTolerance, float inputWidth,
					float2 inputCoordinates, Texture2D inputPass) {
					// grabs a gradient of the desired edge's luma for sobel algorithm..
					float2 egUVs = inputUVs;
					egUVs.x += (inputCoordinates.x * inputWidth);
					egUVs.y += (inputCoordinates.y * inputWidth);
					egUVs /= _ScreenParams.xy;
					float3 egColor = SampleGrabTexture(egUVs).rgb;
					float3 egTolerance = lumaWeighting * inputTolerance;
					float egValue = egTolerance.r * egColor.r + egTolerance.g * egColor.g + egTolerance.b * egColor.b;
					return egValue;
				}

				float makeSobelEdge(float2 inputUVs,      		 // "borrowed" from luka
					float inputTolerance, float inputWidth,
					float2 inputOffset, Texture2D inputPass) {
					// creates an outline using the sobel weights..
					float2 scUVs = float2(inputUVs + inputOffset) * _ScreenParams.xy;
					float scWeights[2];
					// apply kernel in x direction
					scWeights[0] = 0.0;
					scWeights[0] -= getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(-1.0, -1.0), inputPass);
					scWeights[0] -= 2.0 * getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(-1.0, 0.0), inputPass);
					scWeights[0] -= getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(-1.0, 1.0), inputPass);
					scWeights[0] += getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(1.0, -1.0), inputPass);
					scWeights[0] += 2.0 * getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(1.0, 0.0), inputPass);
					scWeights[0] += getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(1.0, 1.0), inputPass);
					// applying kernel in y direction
					scWeights[1] = 0.0;
					scWeights[1] -= getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(-1.0, -1.0), inputPass);
					scWeights[1] -= 2.0 * getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(0.0, -1.0), inputPass);
					scWeights[1] -= getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(1.0, -1.0), inputPass);
					scWeights[1] += getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(-1.0, 1.0), inputPass);
					scWeights[1] += 2.0 * getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(0.0, 1.0), inputPass);
					scWeights[1] += getEdgeGradient(scUVs, inputTolerance, inputWidth, float2(1.0, 1.0), inputPass);
					//applying and returning color
					float sobelWeight = scWeights[0] * scWeights[0] + scWeights[1] * scWeights[1];
					//float3 sobelColor = inputColor.rgb * sobelWeight;
					return sobelWeight;
				}
			
				float2x2 TanTransitionMatrix (float2 uv) {
					float TanTime = iTime * _TanTransitionSpeed + _TanTransitionSpeedOffset;
					float t = TanTime * 1.1 + ((.25 + .05 * sin(TanTime * .1))/(length(uv.xy) + .27)) * 2.2;
					float si = tan(t);
					float co = cos(t);
					float2x2 ma;
					switch (_TanTransitionMatrixMode) {
						case 1:
							ma = float2x2(co, si, -si, co);
							break;
						case 2:
							ma = float2x2(co, -si, -si, co);
							break;
						case 3:
							ma = float2x2(co, si, si, -co);
							break;
						case 4:
							ma = float2x2(-co, si, si, -co);
							break;
						case 5:
							ma = float2x2(-co, -si, -si, -co);
							break;
						case 6:
							ma = float2x2(si, -co, co, si) * si;
							break;
						default:
							ma = float2x2(co, si, -si, co); // case 1
							break;
					}
					return ma;
					
				}


